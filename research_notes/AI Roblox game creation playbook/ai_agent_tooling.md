# AI Agent Tooling for Roblox (Claude Code, ChatGPT/Codex, Roblox Assistant) and Packaging It as Skills

Research date: 2026-10-07. Dates are given on every time-sensitive item. "Observed live" means the item was read directly from the tool schemas exposed by the Roblox Studio MCP server in a Claude Code desktop session on this machine on 2026-10-07. That is the most current evidence available, and it is newer than the public docs page.

---

## 1. The official Roblox Studio MCP server: tools, limits, gotchas, and how it compares with community servers and Rojo/file-based workflows

### Takeaway
Since spring 2026, Studio ships a built-in MCP server (stdio, toggled inside Assistant). It exposes about 25 tools covering scripts, the DataModel, Luau execution, playtesting with simulated input, and Roblox's generative models. It replaced the open-source `studio-rust-mcp-server`, which is no longer developed. It has three big weak spots: Team Create Drafts can't be managed programmatically, `multi_edit` works only in the Edit DataModel, and generation features have per-day caps. Script Sync (built in) or Rojo/Argon give you files and git, but they sync only script instances, so you still need MCP for everything else.

### Cited Findings
**Enabling and connecting**
- Enable it in Studio: **Assistant -> ... -> Manage MCP Servers -> toggle "Enable Studio as MCP server"**. A green indicator appears when a client connects. — [Roblox docs: Connect to the Studio MCP server](https://create.roblox.com/docs/en-us/studio/mcp.md)
- Quick-connect clients: Antigravity, Codex CLI, Claude Code, Claude Desktop, Cursor, Gemini CLI, VS Code. Any stdio MCP client works. — [Roblox docs](https://create.roblox.com/docs/en-us/studio/mcp.md)
- Windows config: `{"mcpServers":{"Roblox_Studio":{"command":"cmd.exe","args":["/c","%LOCALAPPDATA%\\Roblox\\mcp.bat"]}}}`. CLI form: `cmd.exe /c %LOCALAPPDATA%\Roblox\mcp.bat`. macOS binary: `/Applications/RobloxStudio.app/Contents/MacOS/StudioMCP`. Transport is stdio, running as a local process. — [Roblox docs](https://create.roblox.com/docs/en-us/studio/mcp.md)
- Every tool takes a `studio_id`. `list_roblox_studios` returns the name, instance ID and place ID of each connected Studio, so one agent can drive several open Studios. — [Roblox docs](https://create.roblox.com/docs/en-us/studio/mcp.md)
- Security warning in the docs: "MCP clients can read and modify content in your open Roblox places." — [Roblox docs](https://create.roblox.com/docs/en-us/studio/mcp.md)
- Troubleshooting: restart both Studio and the client, check the binary path, check JSON syntax. — [Roblox docs](https://create.roblox.com/docs/en-us/studio/mcp.md)
- Older coding-harness tutorial (WaveSurvival) wording: you "may need to approve MCP commands or add tools to an allowlist". The MCP can reach StarterGui and StarterPack, which Script Sync cannot. If the editor was installed after Studio opened, restart Studio. — [Roblox docs: Coding harness](https://create.roblox.com/docs/ai/coding-harness)
- An older doc page says to enable MCP via File -> Beta Features. The current MCP page has no beta step, so treat that wording as possibly outdated. — [Roblox docs: AI accelerated workflows](https://create.roblox.com/docs/ai/accelerated-workflows) vs [Roblox docs: MCP](https://create.roblox.com/docs/en-us/studio/mcp.md)

**Tool inventory as documented** ([Roblox docs](https://create.roblox.com/docs/en-us/studio/mcp.md))
- Scripts: `script_read` (dot-notation path, optional line range), `multi_edit` (several find/replace edits in one call; creates the script if the path doesn't exist), `script_search` (fuzzy name match, **max 10 results**), `script_grep` (pattern across all scripts, **max 50 matches**).
- Generation and assets: `generate_mesh`, `generate_material`, `generate_procedural_model`, `wait_job_finished`, `search_asset` (Creator Store and inventory), `insert_asset` (numeric asset ID), `upload_image` (batch upload from HTTP URLs), `store_image` (local file to a URI).
- DataModel: `subagent` (documented types: explore, playtest), `search_game_tree` (hierarchy as a flat JSON array), `inspect_instance` (properties and attributes).
- Execution: `execute_luau` with `datamodel_type` = Edit | Client | Server.
- Playtest: `get_studio_state`, `start_stop_play`, `get_console_output`, `screen_capture`.
- Input simulation: `character_navigation`, `user_keyboard_input`, `user_mouse_input`.
- Docs and skills: `http_get` (only allowed Roblox documentation URLs), `skill`.

**Observed live in this session (2026-10-07), more current than the docs page** (source: MCP tool schemas returned to Claude Code on this machine; no public URL)
- Extra tools beyond the docs list: `generate_texture`, `segment_mesh`.
- `subagent` types are now **explore, screen_capture, unit_test**. "playtest" is not listed in the schema enum. The docs page still says "explore and playtest", so the set has changed and should be re-checked before writing skills that depend on it.
- `skill` currently offers one Roblox-authored skill, **`rbx-debug`**: "Programmatically add breakpoints and inspect thread information to debug Roblox Studio games via MCP, plugins, or command scripts."
- `multi_edit`: `datamodel_type` enum is **Edit only**. Edits apply in sequence and atomically. `old_string` must match exactly, including whitespace. Use `className` plus an empty first `old_string` to create a new script. Path format is `game.ServerScriptService.MyScript`.
- `execute_luau`: Edit, Client or Server DataModel. Call `get_studio_state` first to see which are available, and use `start_stop_play` to switch modes.
- `generate_procedural_model`: produces a ProceduralModel driven by user-editable attributes and inserts it automatically. Accepts a reference image (`attachedImageUri` = `IMAGEID_<id>`). Segmentation auto/none/explicit, **max 8 parts**. The schema says to call it with `async: true` and poll `wait_job_finished` only when you need the result.
- `generate_mesh`: `maxTriangles` 12–20,000, optional bounding-box `size`, the same 8-part segmentation, and async support.
- `screen_capture`: "edit-time" viewport capture. You can pass `camera_position` and `look_at_position` to frame a shot.

**Assistant-side limits that also apply to MCP generation**
- Procedural models: **50 per rolling 24 h**. Segmentation is up to 8 parts. `/segment_mesh` takes up to 5 parts per command. Mesh default is 10,000 triangles. Mesh generation accepts text or an image, not both. — [Roblox docs: Assistant guide](https://create.roblox.com/docs/assistant/guide)
- Procedural models work with undo/redo, Team Create and replication. — [Roblox docs: Assistant guide](https://create.roblox.com/docs/assistant/guide)

**Team Create and Drafts gotcha (the main limit for a two-agent setup)**
- DevForum feature request, 2026-07-10: in Team Create places with Drafts Mode on, agents can modify scripts but **cannot list active drafts, diff them, detect conflicts, or commit/discard them**. A large agent-built feature leaves "dozens of uncommitted drafts" that a human has to finalize one by one. The workaround mentioned is the external Argon file sync, which has its own verification gap. The fetched content showed no staff reply. — [DevForum: Make DraftsService PluginSecurity](https://devforum.roblox.com/t/make-draftsservice-pluginsecurity/4730729)

**Predecessor and community servers**
- `Roblox/studio-rust-mcp-server` (open-sourced 2025) was a Rust axum web server long-polled by a Studio plugin plus an rmcp stdio server, with tools `run_code`, `insert_model`, `get_studio_mode`. It is **no longer actively developed**, and Roblox points to the built-in server. — [GitHub: Roblox/studio-rust-mcp-server](https://github.com/Roblox/studio-rust-mcp-server); [DevForum: Introducing the Open Source Studio MCP Server (2025)](https://devforum.roblox.com/t/introducing-the-open-source-studio-mcp-server/3649365)
- `boshyxd/robloxstudio-mcp` (TypeScript, plugin plus HTTP bridge, about 24 tools for bulk property and instance CRUD and mass operations). Install with `claude mcp add robloxstudio -- npx -y robloxstudio-mcp@latest`. Glama lists it as "Inactive". — [Glama README](https://glama.ai/mcp/servers/@boshyxd/robloxstudio-mcp/blob/df5439190b096cbb3066f2bc4687387382ff1677/README.md); [Glama forum-post](https://glama.ai/mcp/servers/@boshyxd/robloxstudio-mcp/blob/981a32b3a6c305df9ff8637c390000a55c9cc1be/docs/forum-post.md)
- Other community servers exist (Justice219's server for instance CRUD, kolvian/roblox-mcp-server, Meganugger/roblox-studio-mcp), but I found no evidence that any of them do more than the built-in one. — [search results: kolvian](https://github.com/kolvian/roblox-mcp-server), [Meganugger](https://glama.ai/mcp/servers/Meganugger/roblox-studio-mcp)

**Script Sync (built in) vs Rojo**
- Script Sync mirrors scripts to disk both ways. File names: `x.luau` = ModuleScript, `x.server.luau` = Script, `x.client.luau` = client Script, `x.local.luau` = LocalScript, `x.legacy.luau`, `x.plugin.luau`, and a folder name = Folder. — [Roblox docs: Script Sync](https://create.roblox.com/docs/scripting/sync)
- It syncs **only Script, LocalScript, ModuleScript and Folder**. It can't sync scripts that have attributes or tags. Limits are 10,000 scripts per top-level instance and 128 top-level synced instances. Studio's debugger can't be controlled from outside. On a mismatch it shows a "Keep Studio" / "Keep Disk" dialog. — [Roblox docs: Script Sync](https://create.roblox.com/docs/scripting/sync)
- It integrates with Team Create, but the docs warn **against two people editing the same synced script at once (overwrites)**. — [Roblox docs: Script Sync](https://create.roblox.com/docs/scripting/sync)
- Roblox's own guidance: for full version control, or when the file system is the source of truth, "third-party tools like Rojo are a better choice." — [Roblox docs: Script Sync](https://create.roblox.com/docs/scripting/sync)
- Roblox's official "coding harness" pattern is **Script Sync for code plus MCP for everything else**, committed to git. It syncs ServerScriptService, ReplicatedStorage and StarterPlayerScripts to folders and uses `game:GetService("InstanceFileSyncService"):GetStatus(instance)` to check sync state. — [Roblox docs: Coding harness](https://create.roblox.com/docs/ai/coding-harness)

**This team's own logged gotchas** (source: user memory file `C:\Users\rmcd9\.claude\projects\C--\memory\coal-mining-game.md`, 2026-09-28)
- The brothers chose MCP-only (no Rojo), so the game code lives only in Studio. Coordination runs through the CoalMiningGame git repo (CLAUDE.md, TASKS.md with lanes by Explorer path, STATUS.md log).
- `StarterPlayer.AvatarType` isn't readable through `execute_luau`, so detect the rig from `Humanoid.RigType` at runtime. KeyframeSequenceProvider-registered animations work only in Studio and must be published ("Save to Roblox") before live use.

### Inferences
- For two agents on one Team Create place, the riskiest part is **Drafts**. If Drafts Mode or collaborative script editing leaves agent edits as drafts, a human must commit them. The skill should include a "commit drafts / check Drafts window" step at session end, or the team should confirm how their place is configured (I did not verify whether current Team Create still uses Drafts by default; see Gaps).
- Pure-MCP (the current setup) keeps everything in one place but gives no git history for code. A cheap hedge is a periodic `execute_luau` export of all script sources into the docs repo, or turning on Script Sync for the code services. Script Sync doesn't fight MCP, because MCP still handles UI, models and attributes.
- Because `script_search` caps at 10 results and `script_grep` at 50, skills should tell agents to use narrow, path-scoped searches, or `execute_luau` with a custom traversal for big sweeps.
- The documented and live tool lists already differ (playtest vs unit_test/screen_capture subagents, plus new texture and segment tools). Skills should tell the agent to **read the live tool list rather than hard-code it**.

### Gaps
- No official numeric limits found for `execute_luau` (timeouts, output size) or `screen_capture` resolution. The user's memory mentions a "localhost trick for big Lua blocks", which suggests a practical payload-size limit, but I found no public documentation of it.
- No public changelog explains why the `playtest` subagent type is gone from the live schema or what `unit_test` does.
- I did not confirm whether Team Create places default to Drafts Mode or to live collaborative editing in late 2026. The "Live Scripting Beta" thread exists ([DevForum](https://devforum.roblox.com/t/live-scripting-beta/2640607)) but I did not read it.
- No feature-by-feature, side-by-side benchmark of community MCP servers against the built-in one was found.

---

## 2. Roblox Assistant and Roblox's own AI (Cube, mesh/procedural generation, code assist): what's production-ready vs experimental

### Takeaway
Roblox's AI stack (late 2026) is Assistant, with Planning, Build/Agent and Ask modes, running on Roblox's own Cube 3D foundation model plus BYO LLM keys. Planning Mode, mesh generation, Code Assist, the material generator and the built-in MCP server are shipped. Procedural models, the playtest/NPC agents and 4D behaviours are beta or newer and have caps, false positives and stalls. RDC 2026 (September) was mostly about Cube/3D, autonomous NPCs and "Roblox Reality" rather than coding agents.

### Cited Findings
- **2026-04-15 "Studio going agentic" announcement**: 44% of the top 1,000 creators use Assistant or third-party AI via MCP. Status at launch: Planning Mode GA, Mesh Generation GA, Procedural Models "coming soon", Playtesting Agent **beta**. Roadmap: parallel agent execution, long-form cloud workflows, NPC behaviour simulation, node-graph visualization. Planning Mode creates "structured task manifests for parallel agent execution". — [Roblox Newsroom 2026-04](https://about.roblox.com/newsroom/2026/04/roblox-studio-going-agentic)
- Mesh generation is built on the **Cube** foundation model, open-sourced March 2025. More than 160,000 objects were generated during early access. Roblox claims a 64% average play-time increase for "4D generation" users (company claim, not independently checked). TNW lists competitors Lemonade, SuperbulletAI and BloxBot. — [The Next Web, 2026-04-16](https://thenextweb.com/news/roblox-ai-assistant-agentic-tools-planning-procedural-models)
- **Assistant modes**: Planning Mode (`/plan`; plans are editable Markdown **stored in the cloud and kept across sessions**), Build/Agent mode (executes on the DataModel), Ask mode. Multiple chats per place, branching from any response, cloud-synced history. Docs advise "one chat at a time when Studio is open on multiple devices." A screen-capture subagent describes the viewport in Edit and Play. — [Roblox docs: Assistant guide](https://create.roblox.com/docs/assistant/guide)
- Assistant can **use your own API keys** for Anthropic, OpenAI or Google models. — [Roblox docs: AI accelerated workflows](https://create.roblox.com/docs/ai/accelerated-workflows); [DevForum Creator Roadmap 2026 Spring Update](https://devforum.roblox.com/t/creator-roadmap-2026-spring-update/4625473)
- Other Roblox AI tools: **Code Assist** (inline completions in the Script Editor), **Material Generator** (seamless tiling 2D), **Texture Generator** (geometry-aware), **Procedural Models**, **Interactive 3D Models** (vehicle, aircraft and weapon presets), **Avatar Auto-Setup**, TTS (`AudioTextToSpeech`), speech-to-text, and `TextGenerator` for NPC dialogue (output must go through `TextService:FilterStringAsync()`). — [Roblox docs: AI accelerated workflows](https://create.roblox.com/docs/ai/accelerated-workflows)
- **Creator Roadmap 2026 Spring Update**: shipped are the Assistant search subagent, Procedural Models (Studio Beta), Planning Mode, the built-in MCP server with BYO keys, "Agentic Gameplay Validation", and Speech-to-Text (full release). Planned for mid-2026 are Open Cloud APIs as Assistant/MCP tools ("callable from ... Claude Code, Cursor"), multiple chats and history, the Assistant NPC subagent (beta), **Assistant Skills + Documentation**, scripting workflow improvements (delayed), the Text Generation API (delayed), and 4D custom schema plus behaviour library. Late 2026: a translation glossary. — [DevForum Creator Roadmap 2026 Spring](https://devforum.roblox.com/t/creator-roadmap-2026-spring-update/4625473)
- **Playtest agent beta** (DevForum, 2026-04-09): enable under File > Beta Features. It spawns a test character and uses navigation, keyboard and mouse tools via MCP "without consuming user tokens". Limits: **false positives**, fails on vague instructions, low observability, **daily caps**, a **50-turn maximum**, loop detection that stops on repeated identical calls, and **no real-time reflexes (vehicles, combat fail)**. It is single-player only for now. — [DevForum: Studio Assistant & MCP Playtest Agent](https://devforum.roblox.com/t/studio-beta-studio-assistant-mcp-playtest-agent/4566767)
- Developer reports on that thread: stalls at "Generation is taking longer than expected" on chained tasks, and a sub-agent that never managed to start a playtest across three scenarios. — [DevForum thread p.2](https://devforum.roblox.com/t/studio-beta-studio-assistant-mcp-playtest-agent/4566767?page=2) (via search snippet)
- **RDC 2026 (press briefing 2026-09-11)**: AI pillars are coding tools, 3D objects, multiplayer NPCs, and video/realism. Demos covered Cube text-to-3D environment building inside the Roblox Player app on mobile, a self-trained 3D model for meshes and texturing, "Roblox Reality" (a video world model for photoreal effects), and autonomous NPCs at the scale of hundreds. The article did not mention MCP or coding agents. — [GamesBeat RDC briefing](https://gamesbeat.com/roblox-dives-into-the-details-on-its-rdc-engine-updates-roblox-wallet-and-offline-play-press-briefing/)
- Secondary-source assessment (RoWatcher, undated, no byline, so lower reliability): 70% of Luau Assist generations come from accounts under two years old. Material Generator is popular in horror, roleplay and tycoon games. Avatar Auto-Setup saves 60–70% of time for humanoids but degrades for non-humanoids. AI fails at architecture and performance and suggests deprecated APIs. "Tools raise the floor; they don't raise the roof." — [RoWatcher](https://rowatcher.com/news/roblox-ai-tools-in-2026-what-s-actually-changed-for-developers)

### Inferences
- **Production-ready for a small team**: Code Assist, Planning Mode, mesh generation (props and decor), Material Generator, the built-in MCP server, and `execute_luau`-driven building.
- **Use but verify**: procedural models (beta, 50/day cap), the playtest/NPC agents (false positives, so don't trust a "pass" without logs or screenshots), and segmentation.
- **Experimental or marketing-stage**: 4D behaviours, autonomous NPCs, Roblox Reality, and cloud parallel agents.
- Assistant's cloud-stored Markdown plans and "Skills + Documentation" roadmap item point toward Roblox-native skills. The live `skill` tool already serves `rbx-debug`. Team skills should live outside Roblox (in the repo) so Claude and Codex both get them.

### Gaps
- I couldn't confirm whether "Assistant Skills" shipped by October 2026 with a user-authorable format. Only the built-in `rbx-debug` skill is visible live.
- No published per-day caps were found for mesh generation, the playtest agent, or the material/texture generators (beyond the 50/day procedural-model cap).
- No RDC 2026 primary-source (Roblox newsroom) page was fetched. The GamesBeat briefing is the only RDC 2026 source.

---

## 3. Claude Code skills/plugins/CLAUDE.md/subagents vs the ChatGPT/Codex equivalents, and one source of truth for both

### Takeaway
As of 2026 both ecosystems use the **same open Agent Skills format** (agentskills.io): a folder containing `SKILL.md` with `name` and `description` YAML frontmatter, plus optional `scripts/`, `references/` and `assets/`. Claude Code reads `.claude/skills/`, and Codex/ChatGPT read `.agents/skills/`. For always-on rules, Claude reads `CLAUDE.md` and Codex reads `AGENTS.md`, and `CLAUDE.md` can simply import `@AGENTS.md`. So one repo can hold a single skill set and a single rules file that both agents use.

### Cited Findings
**Claude Code skills** ([Claude Code docs: Skills](https://code.claude.com/docs/en/skills))
- Locations: personal `~/.claude/skills/<name>/SKILL.md`, project `.claude/skills/<name>/SKILL.md`, nested `<subdir>/.claude/skills/`, plugin `<plugin>/skills/<name>/SKILL.md` (invoked as `/plugin-name:skill-name`), and claude.ai-synced skills. Legacy `.claude/commands/<name>.md` still works.
- Frontmatter: `name`, `description` (max **1,536 chars** including `when_to_use`), `when_to_use`, `disable-model-invocation`, `user-invocable`, `allowed-tools` (e.g. `Bash(git *) Read Grep`; this pre-approves tools), `disallowed-tools`, `argument-hint`, `arguments`, `context: fork` plus `agent` (run in an isolated subagent), `background`, `model`, `effort`, `paths` (glob-gated auto-activation), `shell` (`bash` or `powershell`), `hooks`, `metadata`, `license`, `compatibility`.
- Portable subset: **only `name`, `description`, `license`, `compatibility`, `metadata`, `allowed-tools`** are accepted for claude.ai upload and the Skills API. The Claude Code-only fields "will fail upload if included". claude.ai doesn't support `` !`cmd` `` injection, `@` file refs, or `${CLAUDE_*}` substitution.
- Substitutions: `$ARGUMENTS`, `$0..$N`, named args, `${CLAUDE_SKILL_DIR}`, `${CLAUDE_PROJECT_DIR}`. Dynamic context injection uses `` !`command` `` or a fenced ` ```! ` block.
- Sizing: keep **SKILL.md under 500 lines** and put detail in linked files that load only when needed. Descriptions are always in context; the body loads on invoke. After auto-compaction, the first **5,000 tokens per skill / 25,000 combined** are kept. If Claude "stops following" a skill, move the rule into hooks.
- Testing: `claude plugin validate .claude/skills` (v2.1.233+). The `skill-creator` plugin (`claude plugin install skill-creator@claude-plugins-official`) runs evals stored in `evals/evals.json` and compares with-skill against without-skill.
- Live reload: editing SKILL.md takes effect during the session. A new top-level skills directory needs `/reload-skills`.

**Claude Code subagents** ([Claude Code docs: Subagents](https://code.claude.com/docs/en/sub-agents))
- Files go in `.claude/agents/*.md` (project, version-controlled) or `~/.claude/agents/`. Frontmatter: `name`, `description` (required), `tools`, `disallowedTools` (e.g. `mcp__*`), `model`, `permissionMode`, `memory` (`user|project|local` -> `.claude/agent-memory/<name>/`, first 200 lines/25 KB of its MEMORY.md), `skills` (preloaded), `mcpServers` (inline or by name; inline servers are scoped to that subagent only), `hooks`, `maxTurns`, `isolation: worktree`, `omitClaudeMd`, `effort`, `background`, `color`.
- Subagents load the full CLAUDE.md hierarchy. The exceptions are the built-in Explore and Plan agents and `omitClaudeMd: true`. Nesting goes up to 3 levels by default (`CLAUDE_CODE_MAX_SUBAGENT_SPAWN_DEPTH`), with 20 concurrent (`CLAUDE_CODE_MAX_CONCURRENT_SUBAGENTS`). Background subagents keep their MCP tools.

**CLAUDE.md and AGENTS.md interop**
- Claude Code reads CLAUDE.md, not AGENTS.md. Put `@AGENTS.md` at the top of CLAUDE.md to import it, then add Claude-only notes below. Imports are recursive up to 5 levels. On Windows, use the import rather than a symlink (symlinks need admin or Developer Mode). — [travis.media](https://travis.media/blog/claude-md-import-agents-md); [Claude Code docs: memory](https://code.claude.com/docs/en/memory)

**Codex AGENTS.md** ([OpenAI docs: AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md))
- Discovery: global `~/.codex/AGENTS.override.md` or else `~/.codex/AGENTS.md`, then every directory from the git root down to the cwd (`AGENTS.override.md` -> `AGENTS.md` -> fallbacks). Files are **concatenated root-down, and closer files override**. The default cap is **32 KiB combined** (`project_doc_max_bytes`); discovery stops at the cap. Fallback names are configured with `project_doc_fallback_filenames = ["TEAM_GUIDE.md", ".agents.md"]` in `~/.codex/config.toml`. The chain is rebuilt every run.
- Conflict: a third-party blog claims Codex reads only the root AGENTS.md ([danielvaughan.com, 2026-05-05](https://codex.danielvaughan.com/2026/05/05/agent-skills-open-standard-portable-skills-codex-cli-cross-agent/)). The official doc above contradicts this (nested files are concatenated). Trust the official doc.

**Codex / ChatGPT skills** ([OpenAI docs: Build skills](https://learn.chatgpt.com/docs/build-skills), redirected from developers.openai.com/codex/skills)
- Layout: `my-skill/SKILL.md` (required, with `name` and `description`), plus optional `scripts/`, `references/`, `assets/`, and `agents/openai.yaml` (UI `display_name`, icons, `policy.allow_implicit_invocation`, tool `dependencies`).
- Discovery order: `$CWD/.agents/skills`, `$REPO_ROOT/.agents/skills`, `$HOME/.agents/skills`, `/etc/codex/skills`, then built-in system skills.
- Invocation: explicitly with **`$skill-name` in Codex CLI/IDE** or **`@` in ChatGPT**, or implicitly when the description matches. The initial skill list takes at most 2% of context (8,000 chars), and the full SKILL.md loads only when selected.
- "Skills build on the open agent skills standard and **work across ChatGPT desktop, web, mobile, Codex CLI, and IDE extensions**." Distribute them as **plugins**.
- OpenAI API also has Skills (`POST /v1/skills` with a zip containing one top-level folder and exactly one SKILL.md, mounted in the hosted shell via `tools[].environment.skills`), reported February 2026. — [OpenAI API docs: Skills](https://developers.openai.com/api/docs/guides/tools-skills); [Simon Willison 2026-02-11](https://simonwillison.net/2026/Feb/11/skills-in-openai-api/)

**ChatGPT Projects / custom GPTs (the older "knowledge file" route)**
- Projects file caps (third-party summary): Free 5, Plus/Go 25, Pro/Team/Business/Enterprise 40; 10 per upload batch; 512 MB per file. — [fast.io](https://fast.io/resources/chatgpt-projects-file-limit.md)
- Custom GPT knowledge: fast.io says a 10-file hard ceiling and 2M tokens per doc ([fast.io](https://fast.io/resources/custom-gpt-file-limit.md)). This **conflicts with the long-standing 20-file figure** discussed on the OpenAI community forum ([community.openai.com](https://community.openai.com/t/chatgpt-projects-20-file-limit/1064482)). Not verified against an official OpenAI help page.

### Inferences
- **One source of truth layout** (recommended):
  - `AGENTS.md` (repo root, under 32 KiB): always-on team rules (lanes by Instance path, verify-in-Play loop, banned APIs, STATUS.md protocol). `CLAUDE.md` = `@AGENTS.md` plus a few Claude-only lines.
  - `.agents/skills/<skill>/SKILL.md` as the canonical skills folder, using only the portable frontmatter (`name`, `description`, optionally `metadata`/`license`/`compatibility`). Mirror it to `.claude/skills/` with a copy script. Windows symlinks need Developer Mode, and I found no doc saying Claude Code reads `.agents/skills`, so copying is safer.
  - Put long Roblox reference material (API pitfalls, Luau patterns, MCP tool cheat-sheet) in `references/*.md` and link it from SKILL.md, keeping SKILL.md under 500 lines.
  - Claude-only extras (`context: fork`, `allowed-tools: mcp__Roblox_Studio__*`, `paths`) go in a Claude-specific wrapper skill, or only in `.claude/skills` copies, because these fields break claude.ai upload.
  - For a ChatGPT custom GPT (such as "Astra") without skills support, upload the same `references/*.md` as knowledge files and paste AGENTS.md into the Instructions field.
- Good candidate skills for every new game: `roblox-mcp-workflow` (tool cheat-sheet, verify loop), `luau-conventions` (server/client split, RemoteEvent validation, no deprecated APIs), `team-create-handoff` (git pull, read STATUS, lanes, log Instance paths, commit drafts, push), `ui-style` (the user's no-emoji, square, one-accent rules), and `asset-pipeline` (generate vs insert vs upload, caps).
- A `.claude/agents/roblox-playtester.md` subagent with `mcpServers: [Roblox_Studio]`, a tool allowlist of read and playtest tools only, and `maxTurns` would keep screenshot and log noise out of the main context.

### Gaps
- No official doc confirms whether Claude Code also discovers `.agents/skills/`. Assume it does not.
- I did not fetch the Claude Code plugin manifest docs (`.claude-plugin/plugin.json`, marketplaces), so plugin packaging details are not cited here.
- Official OpenAI help-center numbers for custom GPT knowledge limits in 2026 were not verified.
- I didn't confirm whether ChatGPT's consumer `@skill` invocation is available on all plans or only on some.

---

## 4. Best practices for prompting and structuring agents for Roblox game dev (verify loops, screenshots, hallucinated APIs, small context, multi-agent on Team Create)

### Takeaway
The official guidance and the tools themselves point to one loop: **plan -> small edit -> run in Play (Server/Client DataModel) -> read console output and screenshot -> fix**, one tested phase at a time. Use subagents and async generation to keep the main context clean. For two agents on one place, the only safe coordination today is **human-agreed ownership by Instance path plus an external log**. Roblox gives you no locking or draft API, and Script Sync overwrites when two people edit the same script.

### Cited Findings
- Roblox's coding-harness tutorial: prompt the agent to "Use the Roblox MCP to read the current game tree" first, build "one tested phase at a time", give the agent a design doc (`WAVE_SURVIVAL.md`) as context, and commit to git after each verified phase. — [Roblox docs: Coding harness](https://create.roblox.com/docs/ai/coding-harness)
- The playtest agent needs "actionable, experience-specific directions". Vague prompts fail, and it reports false positives. — [DevForum playtest agent beta](https://devforum.roblox.com/t/studio-beta-studio-assistant-mcp-playtest-agent/4566767)
- MCP tool design rewards this loop: `execute_luau` targets Edit/Client/Server; `get_studio_state` -> `start_stop_play` -> `get_console_output` / `screen_capture` (with explicit camera position and look-at). `multi_edit` works only in Edit, so **stop Play before editing scripts**. Generators run async with `wait_job_finished`. — Observed live (2026-10-07); [Roblox docs](https://create.roblox.com/docs/en-us/studio/mcp.md). The same "stop Play before editing" rule is in the user's own memory index for Idle Medieval.
- Planning Mode outputs editable Markdown plans. Roblox frames plans as "task manifests for parallel agent execution". — [Roblox Newsroom 2026-04](https://about.roblox.com/newsroom/2026/04/roblox-studio-going-agentic); [Assistant guide](https://create.roblox.com/docs/assistant/guide)
- Hallucinated and deprecated APIs: AI tools suggest "deprecated API pattern[s] ... from older training data". — [RoWatcher](https://rowatcher.com/news/roblox-ai-tools-in-2026-what-s-actually-changed-for-developers). The MCP's `http_get` can fetch "allowed Roblox documentation URLs", so agents can check an API against create.roblox.com before using it. — [Roblox docs: MCP](https://create.roblox.com/docs/en-us/studio/mcp.md)
- Keeping context small: skill descriptions are always loaded and bodies load on demand. Subagents with inline `mcpServers` keep tool descriptions out of the main context. Background subagents keep MCP tools. — [Claude Code docs: Skills](https://code.claude.com/docs/en/skills); [Subagents](https://code.claude.com/docs/en/sub-agents). Roblox's playtest agent likewise runs separately to keep "the main Assistant context clean". — [DevForum](https://devforum.roblox.com/t/studio-beta-studio-assistant-mcp-playtest-agent/4566767)
- Multi-agent and Team Create: Script Sync shows in Explorer who is syncing which instances, but warns that simultaneous edits to the same synced script overwrite each other. — [Roblox docs: Script Sync](https://create.roblox.com/docs/scripting/sync). Agents can't see or commit Drafts. — [DevForum 2026-07-10](https://devforum.roblox.com/t/make-draftsservice-pluginsecurity/4730729). Assistant docs advise one chat at a time across devices. — [Assistant guide](https://create.roblox.com/docs/assistant/guide)
- This team's current protocol (the user's memory): lanes by Explorer path (Rufus owns mining, economy and data; his brother owns UI, effects and automation). Each session runs git pull, reads STATUS.md, works, logs exact Instance paths, then commits and pushes. — local file `C:\Users\rmcd9\.claude\projects\C--\memory\coal-mining-game.md`

### Inferences
- Rules worth encoding in AGENTS.md:
  1. Before editing, `search_game_tree` or `script_read` the target, and never write to a path outside your lane without a STATUS note.
  2. Shared modules (Config, Remotes) need a "claim" line in STATUS.md before editing.
  3. After every change, start Play, then read `get_console_output` with errors filtered, then take a `screen_capture` for any visual change, then stop Play.
  4. Check any API you haven't used in this place via `http_get` on create.roblox.com/docs/reference before using it.
  5. Run generators async, capped and logged (the 50/day procedural cap is shared per account).
  6. At session end, list touched Instance paths and commit drafts.
- Treat any agent "it works" claim as unverified unless console output or a screenshot is attached. This matters even more for the beta playtest agent, given its documented false positives.
- Each brother's Claude Code and Codex instance should use distinct `studio_id`-aware prompts. If either ever runs two Studio windows, `list_roblox_studios` stops edits going to the wrong place.

### Gaps
- No official Roblox guidance found on running two external agents on one Team Create place at once (locking, conflict behaviour of `multi_edit` against another user's open draft).
- No measured data on hallucination rates for Luau/Roblox APIs by model.

---

## 5. Real case studies of creators shipping Roblox games built heavily with AI (2025-2026)

### Takeaway
Reliable, named case studies of hit Roblox games built mainly by AI agents are **scarce**. The evidence is aggregate (Roblox's adoption stats), vendor marketing, or anecdote. The consistent message: AI speeds up prototyping and boilerplate, but architecture, performance, art direction and game feel are still human jobs.

### Cited Findings
- 44% of the top 1,000 creators use Assistant or third-party AI via MCP (Roblox, April 2026). — [Roblox Newsroom](https://about.roblox.com/newsroom/2026/04/roblox-studio-going-agentic)
- More than 160,000 objects were generated in the 4D/mesh early access, and Roblox claims a 64% play-time increase for games using 4D generation (company claim). — [The Next Web](https://thenextweb.com/news/roblox-ai-assistant-agentic-tools-planning-procedural-models)
- Search summaries of press and early-adopter coverage describe early adopters praising the jump "from a raw idea to a playable prototype". This is general, not a named game. — [Outlook Respawn](https://respawn.outlookindia.com/gaming/gaming-news/from-text-to-world-inside-robloxs-new-agentic-ai-studio-update) (via search snippet; not fetched)
- Secondary assessment: more games are being published at lower average quality, and players notice a "generic feel" in AI-template games. — [RoWatcher](https://rowatcher.com/news/roblox-ai-tools-in-2026-what-s-actually-changed-for-developers)
- A DevForum developer reports a real agentic workflow pain point: building a quest system with dialog, sounds and animations across many scripts produced dozens of drafts to finalize by hand. — [DevForum 2026-07-10](https://devforum.roblox.com/t/make-draftsservice-pluginsecurity/4730729)
- Third-party AI-for-Roblox products exist (Lemonade, SuperbulletAI, BloxBot, Ropilot "Use Claude & Codex", Obby.fun "vibe coding" export to Studio), but their claims are marketing. — [The Next Web](https://thenextweb.com/news/roblox-ai-assistant-agentic-tools-planning-procedural-models); [ropilot.ai](https://ropilot.ai/use-claude-in-roblox); [obby.fun blog, 2026-05-03](https://www.obby.fun/blog/vibe-coding-roblox)
- A transcript page titled "GPT6 Astra vs Fable viral roblox game" appeared in search ([sozai.app](https://sozai.app/transcript/gpt6-astra-vs-fable-viral-roblox-game/)). I didn't fetch or verify it, so treat it as an unverified lead for a YouTube head-to-head.

### Inferences
- The brothers' own projects (Coal Mining, Idle Medieval, Escape Verity) are probably better evidence for their playbook than any public case study. Their logged gotchas should become the "lessons" references inside the skills.
- Treat vendor claims about full AI-built hit games with scepticism until a named game with public player counts appears.

### Gaps
- No named Roblox game with public CCU or revenue numbers was found that is credibly documented as built mainly with Claude Code or Codex via MCP.
- No YouTube walkthrough was fetched or verified. The sorceress.games and obby.fun blogs are vendor content and weren't fetched in full.
