# Roblox code architecture, data saving, security, testing, publishing and live-ops for AI-written code

Research date: 2026-10-07. Items are dated where the source gave a date. Every fact is sourced; unsourced practitioner knowledge is kept in "Inferences" and labelled as such.

## 1. Project architecture (server/client split, modules, frameworks, networking, types, packages) and MCP-in-Studio vs Rojo for AI agents

### Takeaway
Keep all authoritative logic and data in ServerScriptService. Put pure game logic in plain ModuleScripts that don't depend on Roblox, so they can be unit-tested headlessly. Knit is archived, so plain modules (or a maintained successor) are the safer default. File-based Rojo projects suit CI, linting, type-checking and diffs. The official Studio MCP server, which gained agentic play-test tools in Feb 2026, suits in-engine work: building, inspecting and play-testing. The strongest setup uses both.

### Cited Findings
- Roblox's guidance: keep critical logic and data in ServerScriptService from the start. Avoid putting sensitive elements in replicated containers (ReplicatedStorage, Workspace), because exploiters can decompile or manipulate them. The client handles input and rendering; the server validates, executes and updates state — [Roblox: Security tactics](https://create.roblox.com/docs/scripting/security/security-tactics)
- Knit is archived and no longer receives updates, and its creator no longer recommends it. A community successor, "OwlKnit", was rewritten in 2026. It keeps the Services/Controllers model and adds topological init, middleware, lifecycle hooks and typed components. This is a community project, so maturity is unverified — [DevForum: OwlKnit](https://devforum.roblox.com/t/owlknit-a-modern-and-knit-inspired-framework-v112/4761632)
- Reference "agent-friendly" repo layout (dinoderek/rob):
  - Rokit manages the toolchain (Rojo, StyLua, Selene, luau-lsp, Lune).
  - Game logic lives in `src/shared` as pure code with no Roblox dependencies, so it can be unit-tested under Lune.
  - Services use dependency injection. Adapters are thin Roblox glue.
  - One command, `lune run check`, runs every gate: formatting, linting, type analysis, unit tests and the place build.
  - The repo ships AGENTS.md, STYLE.md and CLAUDE.md for AI coding partners.
  - Everything runs on Linux/CI with zero Roblox credentials.
  - [GitHub: dinoderek/rob](https://github.com/dinoderek/rob)
- Roblox's own CI/CD demo uses Rojo to build and deploy, Selene for linting, StyLua for formatting, and Open Cloud Luau Execution for tests. It runs on GitHub Actions — [GitHub: Roblox/place-ci-cd-demo](https://github.com/Roblox/place-ci-cd-demo)
- Official Studio MCP server agentic update, **24 Feb 2026**:
  - New tools: `get_console_output` (playtest logs), `start_stop_play`, `run_script_in_play_mode` (auto-stop plus logging) and `get_studio_mode`.
  - The goal is for the AI to plan, write, test and fix code without creator intervention.
  - BYOK supports Claude, OpenAI and Gemini.
  - [MoguraVR report](https://www.moguravr.com/roblox-studio-mcp-server-agentic-update/) (secondary source, Japanese trade press)
- Community MCP servers also exist; for example, boshyxd/robloxstudio-mcp needs a Studio plugin plus HTTP Requests enabled. Templates such as RobloxUI CLI scaffold Rojo + Wally/roblox-ts + Studio MCP together — [Glama: robloxstudio-mcp](https://glama.ai/mcp/servers/@boshyxd/robloxstudio-mcp/blob/3a3876a9d2c79303954292f0939bf9cd492837b6/README.md); [Glama: robloxui-cli](https://images.glama.ai/mcp/servers/erickow/robloxui-cli)
- Studio command line, docs live as of **July 2026**:
  - `--task RunScript` runs Luau scripts from the command line.
  - `--openScriptPath` / `--openScriptFromId` launch Studio with a given script open.
  - [DevForum weekly recap July 13-17 (2026)](https://devforum.roblox.com/t/weekly-recap-july-13-%E2%80%93-17-animation-graphs-go-live-5%C3%97-more-data-store-storage/4743286)

### Inferences
- **Recommended hybrid for AI agents.**
  - Code lives in files (Rojo), so agents get git diffs, linting (Selene), formatting (StyLua), type checks (luau-lsp with `--!strict` at the top of modules) and headless unit tests.
  - Studio MCP is used for world building, inspecting the DataModel, play-testing and reading console output.
  - Pure-only MCP editing loses version control and CI gates. Pure Rojo loses in-engine verification.
- **One source of truth.** If a Rojo sync is live, MCP edits to synced scripts get overwritten. Agents should edit scripts only on the file side and use MCP for non-script instances. This is inferred from how Rojo sync works and is not sourced.
- **Suggested layout (practitioner convention, not from an official Roblox source):**
  - `ServerScriptService/Server` holds services such as DataService, CombatService and EconomyService.
  - `StarterPlayerScripts/Client` holds controllers.
  - `ReplicatedStorage/Shared` holds pure modules, config tables, types and the remote definitions.
  - Each service exposes `Init()` / `Start()`, and one bootstrap script requires them in order.
  - Remotes are created on the server, defined in one module, and named declaratively.
- **Networking libraries** (ByteNet, Blink, Zap, Warp, Red) are popular for typed or compressed remotes. I found no reliable 2025-26 source comparing them (see Gaps).
- **Wally** is the usual package manager for Rojo projects. Rokit or Aftman pins tool versions. This is general knowledge, not verified this session.
- **This user's environment** already exposes official-style Roblox_Studio MCP tools: `execute_luau`, `start_stop_play`, `get_console_output`, `screen_capture`, `script_grep`, `multi_edit`, `character_navigation` and `user_keyboard_input`. That is enough for agents to run play-mode verification loops.

### Gaps
- No primary source found comparing ByteNet, Blink and Zap in 2025-26, or giving Roblox's official stance on frameworks.
- No primary Roblox doc found on `--!strict` adoption rates or the new type solver's rollout status in 2026.
- Wally's maintenance status in 2026 was not verified.

## 2. DataStores: ProfileStore vs raw DataStoreService, session locking, budgets/limits, MemoryStore, migrations, GDPR/RTBF

### Takeaway
For player data, use ProfileStore (loleris's successor to ProfileService) instead of hand-rolled DataStore code. It handles session locking, auto-save and server hand-off, which is exactly where AI-written raw DataStore code tends to duplicate items or lose data. Design around the request budgets and storage limits below. Set up RTBF deletion templates on day one, using the `{UserId}` key pattern.

### Cited Findings
**ProfileStore**
- ProfileStore is a single-ModuleScript DataStore wrapper. It caches data, auto-saves, and session-locks each profile so that only one server owns a player's data at a time. This prevents duplication in games with trading.
- It hands ownership between servers smoothly, without failing new session requests.
- It is explicitly "not designed (and never will be) for in-game leaderboards or any kind of global state".
- Apache 2.0 licence, by loleris.
- [GitHub: MadStudioRoblox/ProfileStore](https://github.com/MadStudioRoblox/ProfileStore)

**Per-server request budgets (per minute)**

| Data store type | Read | Write | List | Remove |
|---|---|---|---|---|
| Standard | 60 + 40×players | 60 + 40×players | 5 + 2×players | 60 + 40×players |
| Ordered | 60 + 40×players | 30 + 5×players | 5 + 2×players | 30 + 5×players |

[Roblox: Error codes and limits](https://create.roblox.com/docs/cloud-services/data-stores/error-codes-and-limits)

**Other DataStore limits**
- Per-key throughput: reads 25 MB/min, writes 4 MB/min, with each request rounded up to the next KB.
- Sizes: a value can hold at most 4,194,304 characters. Key name, data store name and scope are each limited to 50 characters.
- Each request queue holds at most 30 requests. Overflow fails with error codes 301-306 (DatastoreThrottled / KeyThrottled).
- [Same source](https://create.roblox.com/docs/cloud-services/data-stores/error-codes-and-limits)

**Storage limit**
- Total latest-version storage = 500 MB + 1 MB × lifetime user count. Only the latest version of each key counts — [same source](https://create.roblox.com/docs/cloud-services/data-stores/error-codes-and-limits)
- Dated changes:
  - **April 2025:** Roblox announced new Data Stores access and storage limits.
  - **July 2026:** base storage raised 5× from 100 MB to 500 MB. In-game and Open Cloud requests were unified into one per-experience budget (baseline "300 requests"). "No existing games are expected to be immediately constrained." Usage can be monitored in Data Stores Observability and the Data Stores Manager.
  - [DevForum weekly recap July 2026](https://devforum.roblox.com/t/weekly-recap-july-13-%E2%80%93-17-animation-graphs-go-live-5%C3%97-more-data-store-storage/4743286); [DevForum: Unifying Data Stores Open Cloud and Game APIs, and Increasing Storage Limits](https://devforum.roblox.com/t/unifying-data-stores-open-cloud-and-game-apis-and-increasing-storage-limits/4739240?page=3); [DevForum: Announcing Roblox Extended Services](https://devforum.roblox.com/t/announcing-roblox-extended-services/3621439)
  - Note: the search snippet said limits would start "April 2026", while the recap says the storage boost took effect July 2026. The exact enforcement timeline is unclear.

**MemoryStore**
- Memory quota: 64 KB + 1.2 KB × users, with an 8-day traceback when users leave.
- Request units: 1000 + 120 × concurrent users per minute.
- Items are at most 32 KB. Each structure holds at most 1,000,000 items and 100 MB in total.
- TTL is at most 3,888,000 s (45 days).
- A single partition throttles at about 30,000 RU/min. Hash maps also have per-key limits of about 5,000 writes and 15,000 reads per minute.
- Use queues for matchmaking, sorted maps for global leaderboards and auctions, and hash maps for shared inventories and caching.
- [Roblox: Memory stores](https://create.roblox.com/docs/cloud-services/memory-stores)

**GDPR / right to be forgotten (RTBF)**
- If you store PII, including User IDs, you must delete it on a user's request.
- When Roblox Support receives a request, a webhook fires with the UserId and the start place IDs of games they joined. Your bot can then delete the data with the Open Cloud data store API.
- Users request deletion via privacy@roblox.com or a form. Roblox responds within 45 days, extendable by 45 more.
- [Roblox: Automate right to erasure](https://create.roblox.com/docs/cloud/webhooks/automate-right-to-erasure)
- **RTBF deletion templates** let Roblox delete matching data automatically, with no hosted code.
  - Set them up in Creator Hub → Configure → Data Stores Manager → RTBF Deletion tab → Create Template, or through the Open Cloud Configs API (`DataStoresConfig` repository).
  - Key patterns use the case-sensitive token `{UserId}`; `{userId}` is rejected. Examples: `PlayerInventory_{UserId}`, `Player_{UserId}_Save`.
  - Supported targets: standard keys, ordered keys, and entire standard data stores.
  - Verify the data is removed within 30 days.
  - [Roblox: Right to be forgotten](https://create.roblox.com/docs/en-us/cloud-services/data-stores/right-to-be-forgotten.md)
- Values should be valid UTF-8 (check with `utf8.len`) and must not contain Instances; NaN/inf should be rejected before saving — [Roblox: Client-server boundary](https://create.roblox.com/docs/en-us/scripting/security/client-server-boundary.md)

### Inferences
- **Key naming checklist for agents.**
  - Keep exactly one data store, such as `PlayerData`, keyed as `Player_{UserId}`.
  - Put the UserId in the key so an RTBF template can match it.
  - Never store other players' UserIds inside a profile (for example trade history) without a cleanup plan.
- **Migrations.** Store a `DataVersion` field and run ordered migration functions on profile load. Use ProfileStore's reconcile-from-template so new fields get added. (Practitioner convention; ProfileStore's README fetch did not detail Reconcile.)
- **Session-lock bugs to watch for in AI-written code:**
  - saving on PlayerRemoving with no `BindToClose` handler;
  - calling `SetAsync` on a key another server holds;
  - loops that call GetAsync for every player every few seconds, which blows the budget formulas above.

### Gaps
- The ProfileStore README fetch did not show the auto-save interval, version or release date, or exact method names (e.g. `StartSessionAsync`, `Reconcile`, `MessageAsync`). Check the repo docs directly.
- No official Roblox migration or versioning guide found. The `ListVersionsAsync`/`GetVersionAsync` backup approach was not verified this session.

## 3. Security: server authority, remote validation, rate limiting, simulator exploits, anti-cheat basics

### Takeaway
Treat every RemoteEvent argument as hostile. On every remote handler, the server should:
- check types (`typeof`);
- reject NaN/inf (`math.isfinite`);
- check that instances are real and in an expected place (`IsDescendantOf`);
- cap string and table sizes and check UTF-8 (`utf8.len`);
- check state and permissions;
- check range or distance against the server-side character position;
- apply a per-player token-bucket rate limit.

Purchases go only through `ProcessReceipt`.

### Cited Findings
- **Threat model.** "A determined exploiter has complete control over their local state and network traffic." For each feature, ask:
  - What if the client sends arbitrary values?
  - What if it fires 1,000+ times a second?
  - Can it disrupt other players?
  - What is the most internal state you need to expose?
  - [Roblox: Security tactics](https://create.roblox.com/docs/scripting/security/security-tactics)
- **Concrete validation techniques:**
  - `typeof(value) ~= "number"` checks.
  - `math.isfinite()` to reject NaN and ±inf. NaN is type "number" but fails every comparison, so it slips past `if x > max` checks. The self-inequality test `x ~= x` also catches it.
  - Instance args: `typeof(item) == "Instance"` plus `item:IsDescendantOf(expectedFolder)`.
  - `utf8.len()` returns nil on invalid UTF-8.
  - Cap string length so payloads can't be huge.
  - Check table keys for NaN or nil before serialising.
  - [Roblox: Securing the client-server boundary](https://create.roblox.com/docs/en-us/scripting/security/client-server-boundary.md)
- **Rate limiting.** The docs give a token-bucket pattern, `TokenBucket.new(capacity, windowSeconds)` and `limiter:allow(userId)`, and limits must be enforced on the server — [same source](https://create.roblox.com/docs/en-us/scripting/security/client-server-boundary.md)
- **Built-in input instances.**
  - ProximityPrompt properties (Enabled, MaxActivationDistance) can be changed on the client, so the server must re-validate.
  - ClickDetector and DragDetector have "no checks at all on the server".
  - Anchor critical parts or control network ownership to stop position spoofing.
  - [same source](https://create.roblox.com/docs/en-us/scripting/security/client-server-boundary.md)
- **Ability remotes.** Validate the type (e.g. Vector3), NaN, permissions or state (player owns the spell, character is alive) and range against the server-side position before acting or broadcasting — [same source](https://create.roblox.com/docs/en-us/scripting/security/client-server-boundary.md)
- **Monetisation.** Use the `MarketplaceService.ProcessReceipt` callback. Never trust client signals such as `PromptProductPurchaseFinished` — [same source](https://create.roblox.com/docs/en-us/scripting/security/client-server-boundary.md)

### Inferences
- **Simulator and idle exploit patterns.** These are inferred by applying the doc principles to common simulator remotes; I did not find a dedicated 2025-26 source.
  - Remote spam on "collect", "mine" or "click" remotes. Defend with server cooldowns plus a token bucket, and work out the reward on the server from server state, never from a client-sent amount.
  - Negative or NaN amounts sent to sell or trade remotes.
  - Teleporting to resources. Defend with a server distance check from `HumanoidRootPart` to the target.
  - Firing remotes for pets or items the player doesn't own.
  - Exploiting a race between two trade confirmations. Defend with server-side trade state and atomic `UpdateAsync` or profile logic.
- **Agent rule of thumb.** A remote should send intent ("I want to mine ore X"), never results ("give me 50 coins"). The server re-derives everything.
- **Client-side anti-cheat** (speed or fly detection in LocalScripts) can be bypassed. Server-side sanity checks on position deltas are the baseline.

### Gaps
- No official Roblox statement found on Hyperion/Byfron's 2025-26 status or on platform-level anti-cheat features for developers.
- No sourced list of exploit patterns specific to simulators.

## 4. Testing: TestEZ/Jest-Lua, Studio testing, automated play tests, Open Cloud Luau Execution for CI, agent verification in Play mode

### Takeaway
Use a three-layer test pyramid:
1. Headless unit tests of pure modules (Lune, or Jest-Lua inside Roblox).
2. Open Cloud Luau Execution against an uploaded test place in CI (Roblox's own reference pipeline).
3. Agent-driven play tests through Studio MCP (`start_stop_play`, `run_script_in_play_mode`, `get_console_output`) for behaviour that needs players or physics.

Luau Execution has no physics and no players, so it cannot replace the play-test layer.

### Cited Findings
**Open Cloud Luau Execution**
- Endpoints:
  - `POST /cloud/v2/universes/{universe_id}/places/{place_id}/luau-execution-session-tasks` runs against the current version.
  - `.../places/{place_id}/versions/{version_id}/luau-execution-session-tasks` runs against a specific version.
  - Status and logs are fetched with GET on the task and `/logs` paths.
  - Binary inputs use `.../luau-execution-session-task-binary-inputs`.
- Scopes: `universe.place.luau-execution-session:write` / `:read`.
- Limits:
  - Script ≤ 4 MB.
  - Timeout up to 5 min.
  - ≤ 10 incomplete tasks per place.
  - Binary input ≤ 100 MiB; output ≤ 256 MiB.
  - Return values ≤ 4 MB as JSON.
  - Logs keep 450 KB; task info is kept 24 h.
  - Rate limits: 5 task creates/min, 200 gets/min, 45 log lists/min.
- What doesn't run: no physics simulation, server and local scripts don't auto-run, there are no players or clients, and DataModel changes are local unless you call `AssetService:SavePlaceAsync`.
- DataStore APIs *can* be called, so use them with caution: point CI at a test universe.
- [Roblox: Luau Execution](https://create.roblox.com/docs/en-us/cloud/reference/features/luau-execution.md)

**Roblox/place-ci-cd-demo pipeline**
- Steps: Selene + StyLua → Rojo builds the rbxl → upload to a test place → run tests through Luau Execution → report as GitHub Actions checks, usable as branch protection → deploy to production with Rojo.
- It needs a `ROBLOX_API_KEY` secret with `universe.places:write` and `universe.place.luau-execution-session:write`.
- It uses a concurrency group because Luau Execution is "limited to 2 per universe". This **conflicts** with the docs' "10 incomplete tasks per place"; the demo may predate a limit increase.
- [GitHub: Roblox/place-ci-cd-demo](https://github.com/Roblox/place-ci-cd-demo)

**Jest-Lua and Lune**
- Jest-Lua is a test-for-test port of Jest, under the jsdotlua org. Upstream says it "can currently only run inside of Roblox". Lune is a standalone Luau runtime written in Rust — [Yarn: @jsdotlua/jest-environment-roblox](https://classic.yarnpkg.com/en/package/@jsdotlua/jest-environment-roblox); [lib.rs: lune-std](https://lib.rs/crates/lune-std)
- The rob repo instead runs headless unit tests under Lune for pure `src/shared` logic, with no Roblox credentials — [GitHub: dinoderek/rob](https://github.com/dinoderek/rob)

**Agent play-mode verification**
- The Feb 2026 Studio MCP tools let an agent start and stop Play, run a script in play mode with auto-stop and logging, and read console output — [MoguraVR](https://www.moguravr.com/roblox-studio-mcp-server-agentic-update/)
- Studio CLI `--task RunScript` (July 2026) is another headless hook — [DevForum recap](https://devforum.roblox.com/t/weekly-recap-july-13-%E2%80%93-17-animation-graphs-go-live-5%C3%97-more-data-store-storage/4743286)

### Inferences
- **Agent play-test protocol.**
  1. Before editing, stop Play; edits made during Play are lost. This matches the user's own logged gotcha.
  2. Make the edit.
  3. Start Play.
  4. Run a verification script that asserts state, such as currency changed or a remote rejected a NaN.
  5. Read the console for errors and warnings.
  6. Take a screenshot for UI checks.
  7. Stop Play.
  8. Report evidence, never "should work".
- **Keep CI off live data.** Use a separate test universe for Luau Execution so CI never touches production DataStores.
- **TestEZ** is the older Roblox test framework and Jest-Lua is its successor in Roblox's own OSS. I did not verify TestEZ's archive status this session.

### Gaps
- TestEZ's deprecation status and an official Roblox recommendation between TestEZ and Jest-Lua for 2026 were not found.
- No official "automated multi-client play test in CI" capability was found; Luau Execution has no players.

## 5. Common bugs AI agents introduce in Roblox code, and how to catch them

### Takeaway
I found little primary sourcing on AI-specific Roblox bugs. The defensible approach is mechanical gates plus a review checklist:
- Selene for lint and deprecated API calls;
- luau-lsp type analysis with `--!strict`;
- StyLua;
- headless tests;
- a play-test reading console output.

The typical failure classes are trusting the client, making unvalidated remotes, using legacy globals, leaking connections and assuming the wrong side of replication.

### Cited Findings
- The rob repo runs StyLua, Selene, luau-lsp type analysis, unit tests and the place build as one gate (`lune run check`). It also documents error contracts in STYLE.md for AI partners — [GitHub: dinoderek/rob](https://github.com/dinoderek/rob)
- Roblox's CI demo gates merges on Selene and StyLua — [GitHub: Roblox/place-ci-cd-demo](https://github.com/Roblox/place-ci-cd-demo)
- Security bug classes to check: NaN and inf passing comparisons; non-UTF-8 strings breaking DataStore saves; Instances inside saved tables; and trusting `PromptProductPurchaseFinished` — [Roblox: Client-server boundary](https://create.roblox.com/docs/en-us/scripting/security/client-server-boundary.md)
- The Roblox `task` library page lists `task.wait`, `task.spawn`, `task.delay` and `task.defer` but makes no explicit deprecation statement about the legacy `wait`, `spawn` and `delay` — [Roblox: task library](https://create.roblox.com/docs/reference/engine/libraries/task)
- Animations that play for the developer but not for others are a common DevForum issue. The cause is ownership: the animation is owned by the user while the game is owned by a group (see §7) — [DevForum: animations won't work for other accounts](https://devforum.roblox.com/t/2388217)

### Inferences
These are practitioner knowledge, not verified this session.

**Review checklist**
- Use `task.*` instead of `wait()`, `spawn()` and `delay()`.
- Use `Players.PlayerAdded` together with a loop over existing players, because players may join before the script connects.
- Use `:WaitForChild` on the client for replicated instances.
- A LocalScript only runs in client containers such as StarterPlayerScripts, StarterGui and the Character.
- A server Script in ReplicatedStorage does not run.
- Changes the client makes to Workspace don't replicate, apart from network-owned physics.
- Disconnect every `:Connect` stored per player or object, or use Trove/Janitor/Maid. Clean up on PlayerRemoving and Destroying.
- Avoid deprecated APIs such as `Humanoid:LoadAnimation` (use `Animator:LoadAnimation`), `BodyVelocity`/`BodyGyro` (use constraint movers) and `Instance.new(class, parent)` (set Parent last).

**Catching them**
- Use Selene's `roblox` standard library for deprecated-API warnings.
- Run luau-lsp with sourcemaps from `rojo sourcemap`.
- In Studio, check the Developer Console memory and Script Performance views during a long play test to spot leaks.

### Gaps
- No primary or academic source found on error rates or bug taxonomies for LLM-written Luau.
- An official list of deprecated APIs was not fetched; consult the engine API reference's "Deprecated" tags.

## 6. Publishing and live-ops: experience settings, maturity questionnaire, devices, places/teleports, versioning/rollback, Open Cloud publishing, analytics, cadence, localization

### Takeaway
The Maturity & Compliance Questionnaire is mandatory: unrated experiences became unplayable for everyone except their developers on **30 Sep 2025**. CI can publish with Open Cloud (`versionType=Published`), but some instance types must still be published from Studio. Instrument with AnalyticsService before launch; events are server-only, work only in published games, and are capped at 100 event names.

### Cited Findings
**Maturity & Compliance Questionnaire**
- Unrated experiences are restricted to the developer and collaborators. Since **30 Sep 2025**, unrated experiences have been unplayable for everyone else.
- The questionnaire takes about 5 minutes. It asks what content players can encounter and how often, and the answers produce a maturity label.
- Experiences without content maturity info cannot contain Restricted content without risking moderation.
- [ShaneTheGamer](https://www.shanethegamer.com/esports-news/roblox-will-disable-all-unrated-games-on-september-30/); [Roblox: Experience guidelines](https://create.roblox.com/docs/en-us/production/promotion/experience-guidelines)
- **Aug 2025:** Roblox extended its policy on romantic and sexual content — [Roblox newsroom](https://about.roblox.com/newsroom/2025/08/extending-roblox-policy-on-romantic-and-sexual-content)

**Open Cloud place publishing**
- Endpoint: `POST https://apis.roblox.com/universes/v1/{universeId}/places/{placeId}/versions?versionType=Published`.
- The API key needs the universe-places write permission.
- Body: `.rbxlx` (`application/xml`) or `.rbxl` (`application/octet-stream`). The response returns a `versionNumber`.
- It **cannot** update EditableImage, EditableMesh, PartOperation (unions), SurfaceAppearance or BaseWrap instances; publish those from Studio.
- [Roblox: Place publishing](https://create.roblox.com/docs/cloud/guides/usage-place-publishing)

**Analytics**
- `AnalyticsService:LogCustomEvent(player, "EventName" [, value])`.
- Limits: at most 100 custom events per game. Event names have a much tighter cardinality limit than custom fields, so prefer custom fields.
- Events work server-side only, in published games only (not in Studio or on the client).
- Data is batched daily, so charts can take up to 24 h to appear.
- Built-in aggregations: count, unique users, avg/sum/min/max, and average per user.
- [Roblox: Custom events](https://create.roblox.com/docs/production/analytics/custom-events)
- `LogEconomyEvent`, `LogProgressionEvent` and `LogOnboardingFunnelStepEvent` / `LogFunnelStepEvent` are referenced on that page but not documented there — [same source](https://create.roblox.com/docs/production/analytics/custom-events)

**Other live-ops items**
- **July 2026:** a Client CPU Time graph was added to the Performance page, broken down by Scripts, Networking, Physics, Animation and Misc — [DevForum recap July 2026](https://devforum.roblox.com/t/weekly-recap-july-13-%E2%80%93-17-animation-graphs-go-live-5%C3%97-more-data-store-storage/4743286)
- **July 2026:** the Input Action Manager entered Studio beta. It is a visual editor for cross-platform control mapping, relevant to device support — [same source](https://devforum.roblox.com/t/weekly-recap-july-13-%E2%80%93-17-animation-graphs-go-live-5%C3%97-more-data-store-storage/4743286)

### Inferences
These are practitioner-standard steps, not individually verified this session.

**Launch checklist**
1. Group-own the experience from the start.
2. Enable Studio API access only where needed, and keep HTTP off unless used.
3. Complete the maturity questionnaire.
4. Set device support (phone, tablet, console, VR) to match tested input.
5. Set max players and server fill.
6. Add a private-server price if relevant.
7. Set the icon, thumbnails and description.
8. Use a private test universe or place for CI and soft-launch to friends.
9. Turn on the DataStore RTBF templates.
10. Publish.

**Versioning and rollback.** Each publish creates a place version. Roll back by restoring a previous version in Creator Dashboard's version history or by republishing an older rbxl from git. Use "Restart servers for updates" or migration on publish.

**Updates.** Publish behind a server-side `GameVersion` config so data migrations stay forward-compatible.

**Teleports.** TeleportService between places in the same universe shares DataStores. ProfileStore session hand-off is designed for this.

### Gaps
- No primary source fetched on how to roll back a place version (Creator Dashboard UI or API), on update cadence or live-event best practice, or on localization (LocalizationService, automatic translation, translator portal).
- Device-support settings and the questionnaire's exact question list were not fetched from create.roblox.com directly. The Sep 30 2025 date comes from secondary press and is consistent across sources.
- Rate and size limits for the Open Cloud place publishing endpoint are not given in the guide.

## 7. Animation publishing (KeyframeSequence → Animation asset) and asset ownership for groups vs users

### Takeaway
Animations must be owned by the same creator that owns the experience. For a group-owned game, publish each animation to the group, not to your personal account, even if you own the group. Otherwise they only play for you in Studio, or fail for other players. Only Images, Decals and Meshes follow the Asset Privacy system; Animations have their own defaults.

### Cited Findings
- Roblox has a "Transfer animations" doc. To stop animations breaking when an experience moves to a group, publish them to the new owner. The community "Roblox Animation Transfer" tool can re-upload in bulk and remap old AnimationIds to new ones — [Roblox: Transfer animations](https://create.roblox.com/docs/projects/transfer-animations)
- Community reports agree:
  - A user-owned animation used in a group-owned place is rejected.
  - "If it's a group-owned place, the group itself must be the owner of the animation, even if you own the group."
  - The symptom is that it works for the developer but not for others.
  - [DevForum: Animations wont play under group game](https://devforum.roblox.com/t/animations-wont-play-under-group-game/839286); [DevForum: works for me but not others](https://devforum.roblox.com/t/why-does-the-animation-work-for-me-but-not-for-others/823535)
- Asset Privacy (Restricted vs Open Use) applies only to Images, Decals and Meshes at creation. Audio, Video, Models, MeshParts, Animations and Packages have separate defaults.
- Granting permission:
  - You can grant restricted assets to experiences by universeId under Creator Dashboard → asset → Permissions → Experiences.
  - Granting a game permission cannot be revoked. Open Use is irreversible.
  - When a group is granted permission, members with Edit access can use the asset in that group's games.
  - [Roblox: Asset privacy](https://create.roblox.com/docs/projects/assets/privacy)
- Load animations with `Animator:LoadAnimation()` — [Roblox: Using animations](https://create.roblox.com/docs/animation/using)
- **July 2026:** Animation Graphs reached full release. They offer a visual editor for complex character motion, under Studio's Avatar tab, with automatic replication in live games and more than 280 fixes since beta — [DevForum recap July 2026](https://devforum.roblox.com/t/weekly-recap-july-13-%E2%80%93-17-animation-graphs-go-live-5%C3%97-more-data-store-storage/4743286)

### Inferences
**Pipeline for this coal-mining project (group-owned with Team Create)**
1. A KeyframeSequence, made in the Animation Editor or imported, is only an editor asset; the game cannot play it by ID.
2. Publish it via Animation Editor → Publish to Roblox, choosing the **group** as creator.
3. Copy the resulting `rbxassetid://` into an Animation instance or a config module.
4. Verify in a live server with a second account or a teammate, not just in Studio.

**Agents can't publish.** An agent cannot complete step 2 through MCP; that step needs a human Studio click. Agents should instead prepare a manifest mapping each animation name to its KeyframeSequence path and target AnimationId, so the human step is quick.

### Gaps
- I did not fetch the official doc text on whether Studio play-testing can load an unpublished KeyframeSequence (via `KeyframeSequenceProvider:RegisterKeyframeSequence`, Studio-only).
- No source found for an Open Cloud API that uploads Animation assets; the Assets API's supported types were not checked.
- The exact current wording of the "Transfer animations" page was not fetched in full, only the search summary.
