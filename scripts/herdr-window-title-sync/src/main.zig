const std = @import("std");
const Io = std.Io;
const Allocator = std.mem.Allocator;
const Value = std.json.Value;

const AgentKind = enum { codex, claude };
const MatchKind = enum { suffix, exact };

/// Bundles the handful of things every helper needs so call sites stay short.
const Ctx = struct {
    gpa: Allocator,
    io: Io,
    herdr_bin: []const u8,
    home: ?[]const u8,
    /// Set by `run`/`jsonRun` right before returning an error, so the
    /// top-level handler can print a message with real command context
    /// (mirrors the JS version's `Error` messages).
    err_msg: *?[]const u8,
};

pub fn main(init: std.process.Init) !void {
    const gpa = init.arena.allocator();
    const io = init.io;

    const herdr_bin = init.environ_map.get("HERDR_BIN_PATH") orelse "herdr";
    const state_dir = init.environ_map.get("HERDR_PLUGIN_STATE_DIR") orelse "/tmp";
    const state_path = try std.fs.path.join(gpa, &.{ state_dir, "last-title" });
    const home = init.environ_map.get("HOME");

    var err_msg: ?[]const u8 = null;
    const ctx = Ctx{
        .gpa = gpa,
        .io = io,
        .herdr_bin = herdr_bin,
        .home = home,
        .err_msg = &err_msg,
    };

    runMain(ctx, state_dir, state_path) catch |err| {
        var stderr_buffer: [4096]u8 = undefined;
        var stderr_writer: Io.File.Writer = .init(.stderr(), io, &stderr_buffer);
        const w = &stderr_writer.interface;
        if (err_msg) |m| {
            w.print("{s}\n", .{m}) catch {};
        } else {
            w.print("{s}\n", .{@errorName(err)}) catch {};
        }
        w.flush() catch {};
        std.process.exit(1);
    };
}

fn runMain(ctx: Ctx, state_dir: []const u8, state_path: []const u8) !void {
    const title = try buildTitle(ctx);
    const last = lastTitle(ctx.gpa, ctx.io, state_path);
    if (!std.mem.eql(u8, title, last)) {
        _ = try run(ctx, &.{ "terminal", "title", "set", title });
        try saveTitle(ctx.gpa, ctx.io, state_dir, state_path, title);
    }

    var stdout_buffer: [4096]u8 = undefined;
    var stdout_writer: Io.File.Writer = .init(.stdout(), ctx.io, &stdout_buffer);
    const w = &stdout_writer.interface;
    try w.print("{s}\n", .{title});
    try w.flush();
}

// ---------------------------------------------------------------------------
// herdr command execution + JSON parsing
// ---------------------------------------------------------------------------

fn run(ctx: Ctx, args: []const []const u8) ![]const u8 {
    var argv = std.ArrayList([]const u8).empty;
    try argv.append(ctx.gpa, ctx.herdr_bin);
    try argv.appendSlice(ctx.gpa, args);

    const result = std.process.run(ctx.gpa, ctx.io, .{ .argv = argv.items }) catch |err| {
        ctx.err_msg.* = try std.fmt.allocPrint(ctx.gpa, "{s} {s} failed: {s}", .{
            ctx.herdr_bin, try std.mem.join(ctx.gpa, " ", args), @errorName(err),
        });
        return err;
    };

    const ok = switch (result.term) {
        .exited => |code| code == 0,
        else => false,
    };
    if (!ok) {
        const detail = if (result.stderr.len > 0) result.stderr else result.stdout;
        ctx.err_msg.* = try std.fmt.allocPrint(ctx.gpa, "{s} {s} failed: {s}", .{
            ctx.herdr_bin, try std.mem.join(ctx.gpa, " ", args), detail,
        });
        return error.HerdrCommandFailed;
    }
    return std.mem.trim(u8, result.stdout, " \t\r\n");
}

fn jsonRun(ctx: Ctx, args: []const []const u8) !?Value {
    const out = try run(ctx, args);
    if (out.len == 0) return null;
    return std.json.parseFromSliceLeaky(Value, ctx.gpa, out, .{}) catch |err| {
        ctx.err_msg.* = try std.fmt.allocPrint(ctx.gpa, "failed to parse JSON output of {s} {s}: {s}", .{
            ctx.herdr_bin, try std.mem.join(ctx.gpa, " ", args), @errorName(err),
        });
        return err;
    };
}

// ---------------------------------------------------------------------------
// Dynamic JSON accessors
// ---------------------------------------------------------------------------

fn objGet(v: Value, key: []const u8) ?Value {
    if (v != .object) return null;
    return v.object.get(key);
}

fn getStr(v: ?Value) []const u8 {
    const val = v orelse return "";
    return switch (val) {
        .string => |s| s,
        else => "",
    };
}

fn getBool(v: ?Value) bool {
    const val = v orelse return false;
    return switch (val) {
        .bool => |b| b,
        else => false,
    };
}

// ---------------------------------------------------------------------------
// Text helpers
// ---------------------------------------------------------------------------

fn cleanPart(gpa: Allocator, value: []const u8) ![]const u8 {
    var out = std.ArrayList(u8).empty;
    var last_space = true;
    for (value) |raw| {
        const ch: u8 = if (raw <= 0x1f or raw == 0x7f) ' ' else raw;
        if (ch == ' ') {
            if (last_space) continue;
            try out.append(gpa, ' ');
            last_space = true;
        } else {
            try out.append(gpa, ch);
            last_space = false;
        }
    }
    while (out.items.len > 0 and out.items[out.items.len - 1] == ' ') _ = out.pop();
    return out.toOwnedSlice(gpa);
}

fn cleanLower(gpa: Allocator, value: []const u8) ![]const u8 {
    const cleaned = try cleanPart(gpa, value);
    const buf = try gpa.alloc(u8, cleaned.len);
    return std.ascii.lowerString(buf, cleaned);
}

fn stripCommandNameTag(s: []const u8) []const u8 {
    const open = "<command-name>";
    if (s.len < open.len or !std.ascii.startsWithIgnoreCase(s, open)) return s;
    const close = "</command-name>";
    if (std.ascii.findIgnoreCase(s[open.len..], close)) |idx| {
        var rest = s[open.len + idx + close.len ..];
        while (rest.len > 0 and std.ascii.isWhitespace(rest[0])) rest = rest[1..];
        return rest;
    }
    return s;
}

fn stripAllTags(gpa: Allocator, s: []const u8) ![]const u8 {
    var out = std.ArrayList(u8).empty;
    var i: usize = 0;
    while (i < s.len) {
        if (s[i] == '<') {
            if (std.mem.indexOfScalarPos(u8, s, i + 1, '>')) |j| {
                if (j > i + 1) {
                    try out.append(gpa, ' ');
                    i = j + 1;
                    continue;
                }
            }
            try out.append(gpa, '<');
            i += 1;
            continue;
        }
        try out.append(gpa, s[i]);
        i += 1;
    }
    return out.toOwnedSlice(gpa);
}

fn stripLeadingGt(s: []const u8) []const u8 {
    if (s.len == 0 or s[0] != '>') return s;
    var i: usize = 1;
    while (i < s.len and std.ascii.isWhitespace(s[i])) i += 1;
    return s[i..];
}

fn stripLeadingChevron(s: []const u8) []const u8 {
    const seq = "\xE2\x80\xBA"; // U+203A '›'
    if (!std.mem.startsWith(u8, s, seq)) return s;
    var i: usize = seq.len;
    while (i < s.len and std.ascii.isWhitespace(s[i])) i += 1;
    return s[i..];
}

fn compactTitle(gpa: Allocator, value: []const u8) ![]const u8 {
    const cleaned = try cleanPart(gpa, value);
    const after_cmd = stripCommandNameTag(cleaned);
    const after_tags = try stripAllTags(gpa, after_cmd);
    const after_gt = stripLeadingGt(after_tags);
    const after_chevron = stripLeadingChevron(after_gt);
    return std.mem.trim(u8, after_chevron, " ");
}

fn isAllDigits(s: []const u8) bool {
    if (s.len == 0) return false;
    for (s) |c| {
        if (!std.ascii.isDigit(c)) return false;
    }
    return true;
}

/// Clamp `s` to at most `max` bytes without splitting a UTF-8 sequence.
fn truncateBytes(s: []const u8, max: usize) []const u8 {
    if (s.len <= max) return s;
    var end = max;
    while (end > 0 and (s[end] & 0xC0) == 0x80) end -= 1;
    return s[0..end];
}

fn homePath(gpa: Allocator, home: ?[]const u8, parts: []const []const u8) ![]const u8 {
    const h = home orelse return "";
    var full = std.ArrayList([]const u8).empty;
    try full.append(gpa, h);
    try full.appendSlice(gpa, parts);
    return std.fs.path.join(gpa, full.items);
}

// ---------------------------------------------------------------------------
// Session file discovery (replaces shelling out to `find`)
// ---------------------------------------------------------------------------

fn findFirstMatch(gpa: Allocator, io: Io, root: []const u8, id: []const u8, kind: MatchKind) !?[]const u8 {
    if (root.len == 0) return null;
    var dir = std.Io.Dir.cwd().openDir(io, root, .{ .iterate = true }) catch return null;
    defer dir.close(io);

    var walker = try dir.walk(gpa);
    defer walker.deinit();

    const needle = try std.fmt.allocPrint(gpa, "{s}.jsonl", .{id});
    while (try walker.next(io)) |entry| {
        if (entry.kind != .file) continue;
        const matches = switch (kind) {
            .suffix => std.mem.endsWith(u8, entry.basename, needle),
            .exact => std.mem.eql(u8, entry.basename, needle),
        };
        if (matches) return try std.fs.path.join(gpa, &.{ root, entry.path });
    }
    return null;
}

fn extractCodexMessage(entry: Value) []const u8 {
    if (!std.mem.eql(u8, getStr(objGet(entry, "type")), "event_msg")) return "";
    const payload = objGet(entry, "payload") orelse return "";
    if (!std.mem.eql(u8, getStr(objGet(payload, "type")), "user_message")) return "";
    return getStr(objGet(payload, "message"));
}

fn extractClaudeMessage(gpa: Allocator, entry: Value) ![]const u8 {
    if (!std.mem.eql(u8, getStr(objGet(entry, "type")), "user")) return "";
    if (getBool(objGet(entry, "isMeta"))) return "";
    const message = objGet(entry, "message") orelse return "";
    const content = objGet(message, "content") orelse return "";

    if (content == .array) {
        var parts = std.ArrayList([]const u8).empty;
        for (content.array.items) |item| {
            const part: []const u8 = switch (item) {
                .string => |s| s,
                else => getStr(objGet(item, "text")),
            };
            if (part.len > 0) try parts.append(gpa, part);
        }
        return std.mem.join(gpa, " ", parts.items);
    }
    return switch (content) {
        .string => |s| s,
        else => "",
    };
}

fn extractLatestFromLines(gpa: Allocator, io: Io, path: []const u8, kind: AgentKind) !?[]const u8 {
    const data = std.Io.Dir.cwd().readFileAlloc(io, path, gpa, .unlimited) catch return null;
    var latest: ?[]const u8 = null;
    var lines = std.mem.splitScalar(u8, data, '\n');
    while (lines.next()) |line_raw| {
        const line = std.mem.trim(u8, line_raw, " \t\r");
        if (line.len == 0) continue;
        const parsed = std.json.parseFromSliceLeaky(Value, gpa, line, .{}) catch continue;
        const message = switch (kind) {
            .codex => extractCodexMessage(parsed),
            .claude => extractClaudeMessage(gpa, parsed) catch continue,
        };
        if (message.len == 0) continue;
        const title = try compactTitle(gpa, message);
        if (usableSessionTitle(title)) latest = title;
    }
    return latest;
}

fn usableSessionTitle(title: []const u8) bool {
    if (title.len < 2) return false;
    if (std.mem.startsWith(u8, title, "/clear")) return false;
    if (std.mem.startsWith(u8, title, "<local-command")) return false;
    return true;
}

fn codexSessionTitle(ctx: Ctx, id: []const u8) !?[]const u8 {
    const root = try homePath(ctx.gpa, ctx.home, &.{ ".codex", "sessions" });
    const path = try findFirstMatch(ctx.gpa, ctx.io, root, id, .suffix) orelse return null;
    return extractLatestFromLines(ctx.gpa, ctx.io, path, .codex);
}

fn claudeSessionTitle(ctx: Ctx, id: []const u8) !?[]const u8 {
    const root = try homePath(ctx.gpa, ctx.home, &.{ ".claude", "projects" });
    const path = try findFirstMatch(ctx.gpa, ctx.io, root, id, .exact) orelse return null;
    return extractLatestFromLines(ctx.gpa, ctx.io, path, .claude);
}

// ---------------------------------------------------------------------------
// Title assembly (mirrors sync-title.js function-for-function)
// ---------------------------------------------------------------------------

fn tabTitle(gpa: Allocator, tab: ?Value, order: ?usize) ![]const u8 {
    var number_buf: [20]u8 = undefined;
    const number: []const u8 = if (order) |o| try std.fmt.bufPrint(&number_buf, "{d}", .{o}) else "";

    const label_raw = if (tab) |t| getStr(objGet(t, "label")) else "";
    const label = try cleanPart(gpa, label_raw);

    if (label.len == 0 or isAllDigits(label)) {
        if (number.len > 0) return gpa.dupe(u8, number);
        return "tab";
    }
    if (number.len > 0) return std.fmt.allocPrint(gpa, "{s} / {s}", .{ number, label });
    return label;
}

fn jsonNumberToString(buf: []u8, v: ?Value) []const u8 {
    const val = v orelse return "";
    return switch (val) {
        .integer => |i| std.fmt.bufPrint(buf, "{d}", .{i}) catch "",
        .float => |f| std.fmt.bufPrint(buf, "{d}", .{@as(i64, @intFromFloat(f))}) catch "",
        else => "",
    };
}

fn workspaceName(gpa: Allocator, workspace: ?Value) ![]const u8 {
    var number_buf: [20]u8 = undefined;
    const number = if (workspace) |w| jsonNumberToString(&number_buf, objGet(w, "number")) else "";

    const label_raw = if (workspace) |w| getStr(objGet(w, "label")) else "";
    const label = try cleanPart(gpa, label_raw);

    if (label.len > 0 and !std.mem.eql(u8, label, number)) return label;
    return "";
}

fn fallbackTitle(gpa: Allocator, tab: ?Value, order: ?usize) ![]const u8 {
    const tab_part = try tabTitle(gpa, tab, order);
    if (std.mem.eql(u8, tab_part, "tab")) return "tab";
    return std.fmt.allocPrint(gpa, "tab {s}", .{tab_part});
}

fn withWorkspace(gpa: Allocator, title: []const u8, name: []const u8) ![]const u8 {
    const max: usize = 80;
    if (name.len == 0) return gpa.dupe(u8, truncateBytes(title, max));

    const suffix = try std.fmt.allocPrint(gpa, " ({s})", .{name});
    if (suffix.len >= max) return gpa.dupe(u8, truncateBytes(title, max));

    const room = max - suffix.len;
    const body = std.mem.trimEnd(u8, truncateBytes(title, room), " ");
    return std.fmt.allocPrint(gpa, "{s}{s}", .{ body, suffix });
}

fn agentTitle(gpa: Allocator, pane: Value) ![]const u8 {
    const display = getStr(objGet(pane, "display_agent"));
    const agent = getStr(objGet(pane, "agent"));
    const raw = if (display.len > 0) display else agent;
    return cleanLower(gpa, raw);
}

fn sessionFileTitle(ctx: Ctx, pane: Value) !?[]const u8 {
    const session = objGet(pane, "agent_session");
    const session_agent = if (session) |s| getStr(objGet(s, "agent")) else "";
    const pane_agent = getStr(objGet(pane, "agent"));
    const raw_agent = if (session_agent.len > 0) session_agent else pane_agent;
    const agent = try cleanLower(ctx.gpa, raw_agent);

    const id_raw = if (session) |s| getStr(objGet(s, "value")) else "";
    const id = try cleanPart(ctx.gpa, id_raw);

    if (agent.len == 0 or id.len == 0) return null;
    if (std.mem.eql(u8, agent, "codex")) return codexSessionTitle(ctx, id);
    if (std.mem.eql(u8, agent, "claude")) return claudeSessionTitle(ctx, id);
    return null;
}

fn appTitle(ctx: Ctx, pane: Value) ![]const u8 {
    const agent = try agentTitle(ctx.gpa, pane);

    const title = try cleanPart(ctx.gpa, getStr(objGet(pane, "title")));
    if (title.len > 0) {
        if (agent.len > 0) return std.fmt.allocPrint(ctx.gpa, "{s}: {s}", .{ agent, title });
        return title;
    }

    const status = try cleanPart(ctx.gpa, getStr(objGet(pane, "custom_status")));
    if (agent.len > 0 and status.len > 0) return std.fmt.allocPrint(ctx.gpa, "{s}: {s}", .{ agent, status });

    if (try sessionFileTitle(ctx, pane)) |session_title| {
        if (session_title.len > 0) {
            if (agent.len > 0) return std.fmt.allocPrint(ctx.gpa, "{s}: {s}", .{ agent, session_title });
            return session_title;
        }
    }

    if (agent.len > 0) return agent;
    return "";
}

fn buildTitle(ctx: Ctx) ![]const u8 {
    const pane_root = try jsonRun(ctx, &.{ "pane", "current" }) orelse return "herdr";
    const result_val = objGet(pane_root, "result") orelse return "herdr";
    const pane_val = objGet(result_val, "pane") orelse return "herdr";
    if (pane_val == .null) return "herdr";

    const workspace_id = getStr(objGet(pane_val, "workspace_id"));
    var workspace: ?Value = null;
    if (workspace_id.len > 0) {
        if (try jsonRun(ctx, &.{ "workspace", "get", workspace_id })) |ws_root| {
            if (objGet(ws_root, "result")) |res| workspace = objGet(res, "workspace");
        }
    }
    const name = try workspaceName(ctx.gpa, workspace);

    const title = try appTitle(ctx, pane_val);
    if (title.len > 0) return withWorkspace(ctx.gpa, title, name);

    var tabs: []Value = &.{};
    if (workspace_id.len > 0) {
        if (try jsonRun(ctx, &.{ "tab", "list", "--workspace", workspace_id })) |tabs_root| {
            if (objGet(tabs_root, "result")) |res| {
                if (objGet(res, "tabs")) |t| {
                    if (t == .array) tabs = t.array.items;
                }
            }
        }
    }

    const pane_tab_id = getStr(objGet(pane_val, "tab_id"));
    var index: ?usize = null;
    for (tabs, 0..) |t, i| {
        if (std.mem.eql(u8, getStr(objGet(t, "tab_id")), pane_tab_id)) {
            index = i;
            break;
        }
    }
    const tab: ?Value = if (index) |i| tabs[i] else null;
    const order: ?usize = if (index) |i| i + 1 else null;

    const fallback = try fallbackTitle(ctx.gpa, tab, order);
    return withWorkspace(ctx.gpa, fallback, name);
}

// ---------------------------------------------------------------------------
// Last-title state file
// ---------------------------------------------------------------------------

fn lastTitle(gpa: Allocator, io: Io, state_path: []const u8) []const u8 {
    const data = std.Io.Dir.cwd().readFileAlloc(io, state_path, gpa, .unlimited) catch return "";
    return std.mem.trim(u8, data, " \t\r\n");
}

fn saveTitle(gpa: Allocator, io: Io, state_dir: []const u8, state_path: []const u8, title: []const u8) !void {
    try std.Io.Dir.cwd().createDirPath(io, state_dir);
    const data = try std.fmt.allocPrint(gpa, "{s}\n", .{title});
    try std.Io.Dir.cwd().writeFile(io, .{ .sub_path = state_path, .data = data });
}
