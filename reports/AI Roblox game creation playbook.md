# Turn Every Lesson Into Shared Agent Skills

The AI tools are not what makes a Roblox game "look and play great every time". The method around them is. The tools are already good enough. Roblox Studio now ships its own MCP server, so Claude Code, Codex and other agents can read and edit the place, run Luau, start Play mode, read the console, take screenshots and generate meshes ([Roblox docs](https://create.roblox.com/docs/en-us/studio/mcp.md)). **44% of the top 1,000 Roblox creators already use AI this way** ([Roblox Newsroom](https://about.roblox.com/newsroom/2026/04/roblox-studio-going-agentic)). The same reporting says AI "raises the floor" but not the roof: projects get generic looks, deprecated APIs, and confident claims that things work when they don't ([RoWatcher](https://rowatcher.com/news/roblox-ai-tools-in-2026-what-s-actually-changed-for-developers)). The fix is to write down your taste and your checks once, then make every agent use them. That means a style bible, a scale sheet, a performance budget, a UI checklist, a security checklist, a shop template and a launch checklist, all enforced by a loop of "build, play, read the console, screenshot, fix". Packaging is now simple. **Claude and ChatGPT/Codex both read the same open "Agent Skills" format**: a folder with a `SKILL.md` file. Claude Code looks in `.claude/skills/` and Codex/ChatGPT look in `.agents/skills/`. One shared `AGENTS.md` can hold the always-on rules for both agents, with `CLAUDE.md` importing it ([Claude Code docs](https://code.claude.com/docs/en/skills); [OpenAI docs](https://learn.chatgpt.com/docs/build-skills)). The stakes are real. Roblox's recommendation algorithm now judges a game on its first 180 seconds and on whether players return over 28 days ([Roblox docs](https://create.roblox.com/docs/discovery)). So quality has to be repeatable rather than lucky. This report covers each part of game making in turn, then ends with a ready-to-build skill package and a per-game checklist.

## The verify loop beats the model: what the Studio MCP can and can't do

The built-in Studio MCP server is the center of the setup. Turn it on in Studio under **Assistant → ... → Manage MCP Servers → "Enable Studio as MCP server"**. On Windows, any client connects with `cmd.exe /c %LOCALAPPDATA%\Roblox\mcp.bat` ([Roblox docs](https://create.roblox.com/docs/en-us/studio/mcp.md)). It replaced the open-source `studio-rust-mcp-server`, which was archived on 3 April 2026 ([GitHub](https://github.com/Roblox/studio-rust-mcp-server)). Its tools fall into five groups:

- **Scripts:** read, multi-edit, search and grep.
- **The game tree:** search it and inspect any instance.
- **Running code:** `execute_luau` in the Edit, Client or Server DataModel. Each "DataModel" is a different copy of the game: the editor, the player's view, or the server.
- **Playtesting:** `start_stop_play`, `get_console_output`, `screen_capture`, and simulated keyboard, mouse and character movement.
- **Generation:** `generate_mesh`, `generate_procedural_model` and `generate_material`, plus asset search and insert.

The tool list changes faster than the docs. In this session on 2026-10-07 the live server also offered `generate_texture` and `segment_mesh`. Its subagent types were "explore, screen_capture, unit_test", while the docs page still says "explore and playtest". **Skills should therefore tell the agent to read the live tool list instead of hard-coding it.**

Several hard limits shape how agents must work:

- `multi_edit` works only in the Edit DataModel, so **Play must be stopped before editing scripts**. Your own CLAUDE.md already learned this the hard way.
- `script_search` returns at most 10 results and `script_grep` at most 50, so big sweeps need narrow searches or a custom `execute_luau` traversal ([Roblox docs](https://create.roblox.com/docs/en-us/studio/mcp.md)).
- Procedural models are capped at **50 per rolling 24 hours** per account ([Assistant guide](https://create.roblox.com/docs/assistant/guide)). The two brothers share that budget if they use one account.
- The biggest problem for a two-agent Team Create setup is drafts. When scripts are collaboratively edited, agents can change them but **cannot list, diff, commit or discard drafts**. A big agent-built feature leaves "dozens of uncommitted drafts" that a human must finalize one by one ([DevForum, 2026-07-10](https://devforum.roblox.com/t/make-draftsservice-pluginsecurity/4730729)).
- Roblox gives you no locking between two agents. Its Script Sync feature also warns that two people editing the same synced script will overwrite each other ([Script Sync docs](https://create.roblox.com/docs/scripting/sync)).

Your current protocol is lanes by Explorer path, a STATUS.md claim before you touch shared modules, and logging exact Instance paths at session end. That is the only safe coordination available today, so encode it rather than replace it.

Roblox's own "coding harness" tutorial gives the loop that makes results repeatable. First, read the game tree. Then give the agent a design doc and build "one tested phase at a time", committing to git after each verified phase ([Roblox docs](https://create.roblox.com/docs/ai/coding-harness)). In practice each phase runs like this:

1. Stop Play.
2. Make a small edit.
3. Start Play.
4. Run a check script that asserts the result, for example "coins went up" or "the remote rejected a bad value".
5. Read the console for errors.
6. Take a screenshot of anything visual.
7. Stop Play.

**Never accept "it should work"** without console output or a screenshot attached.

Be careful with Roblox's own beta Playtest Agent. It reports false positives, fails on vague instructions, has daily caps and a 50-turn maximum, and cannot handle reflex gameplay such as vehicles or combat ([DevForum](https://devforum.roblox.com/t/studio-beta-studio-assistant-mcp-playtest-agent/4566767)). Use it, but treat a "pass" as a hint rather than proof.

AI models also suggest deprecated APIs from old training data ([RoWatcher](https://rowatcher.com/news/roblox-ai-tools-in-2026-what-s-actually-changed-for-developers)). The MCP's `http_get` tool can fetch Roblox documentation pages, so a skill rule like "check any API you haven't used in this place against create.roblox.com first" costs almost nothing.

Your current setup is MCP-only with no Rojo, so the game code has no git history. Roblox's official recommendation is **Script Sync for code plus MCP for everything else**. Script Sync mirrors Script, LocalScript, ModuleScript and Folder instances to `.luau` files on disk ([Coding harness](https://create.roblox.com/docs/ai/coding-harness)). It cannot sync scripts that carry attributes or tags. It also overwrites when two people edit the same file. The low-risk upgrade is for each brother to sync only the code folders in his own lane. If that proves awkward, a nightly `execute_luau` export of all script sources into the docs repo still gives you a history to diff and roll back.

The agents should split the work this way:

| Tool | Best job | Caveat |
|---|---|---|
| Claude Code + Studio MCP | Building, wiring systems, playtest loops, subagents for QA | Needs the verify loop. Drafts need human commit. |
| Codex / ChatGPT + Studio MCP | Same jobs (Codex CLI is a listed quick-connect client) | Reads `AGENTS.md` and `.agents/skills/`, not `CLAUDE.md` |
| Roblox Assistant | Planning Mode (Markdown plans kept in the cloud), Code Assist, quick material and mesh generation | Can use your own Anthropic/OpenAI/Google key ([docs](https://create.roblox.com/docs/ai/accelerated-workflows)) |
| Gemini / OpenAI image models | Concept sheets, reference images for 3D, icons, thumbnails | Never bake text into images |
| Meshy / Tripo | Image-to-3D props in one locked style | Credits. Retiring models (see below). |
| Blender (+ MCP) | Cleanup, decimation, pivots, export | Runs arbitrary code. Keep it on localhost. |
| Figma (+ MCP) | Designing screens, the design system and the icon grid | An importer plugin or Luau rebuild is needed to reach Studio |
| Open Cloud | Uploading models and images, publishing places, CI tests, GDPR deletion | API key scopes and the IP allowlist cause most 403 errors |

## Discovery rewards the first three minutes and the fourth week

Design comes first because Roblox's discovery system now judges games against a specific scorecard. The Home page "Recommended For You" algorithm ranks games on **per-user averages, not totals**. That means a small new game with strong numbers can compete. Roblox lists these signals as most important ([Roblox docs](https://create.roblox.com/docs/discovery)):

- **Play-through rate:** how often people who see the game click into it.
- **First-play bounce:** players leaving within **180 seconds** counts against you.
- **Play days per user:** how many days players come back.
- **Playtime per user**, capped at 60 minutes a day.

Co-play days (playing with friends) and spend days are ranked "important". On **15 June 2026** Roblox stretched the measurement window from 7 to 28 days (day 1, days 2-7, days 8-28). It also dropped the old "qualified play-through" metric because short-term numbers were rewarding "exciting thumbnails" over lasting games ([DevForum](https://devforum.roblox.com/t/recommended-for-you-algorithm-improvements-that-better-value-long-term-retention/4684575); [Roblox Newsroom](https://about.roblox.com/newsroom/2026/06/optimizing-discovery-great-games-reach-millions-players-roblox)). Metadata that leads with "free Robux"-style rewards, or that doesn't match the gameplay, gets less exposure ([Roblox docs](https://create.roblox.com/docs/discovery)).

The good news for a small two-person team: the algorithm strongly favours new games. Dubit's analysis covers the top 20 games by visits. Before the new recommendation system, games under six months old drew **1.3%** of those visits; afterwards they drew **60.7%**. Median tenure in the top 20 halved from 14 months to 7 ([Dubit](https://dubit.io/blog/roblox-top-20-rfy)).

The 2025 breakouts share one shape: **a simple core action, a visible collection, a reason to come back tomorrow, and something social at stake.**

- **Grow a Garden** was built "in a few days" by a 16-year-old. Its twist was plants that keep growing while you're offline. It had about 500 players online at once (concurrent users, or CCU) when an experienced live-ops partner joined. It went on to peak at **22.3M CCU** ([GamesBeat](https://gamesbeat.com/janzen-madsen-interview/)).
- **Steal a Brainrot** added stealing to an idle-collection game. The viral fuel was TikTok clips of kids reacting to losing their characters ([Wikipedia](https://en.wikipedia.org/wiki/Steal_a_Brainrot)).
- **99 Nights in the Forest** began as a week-long game-jam project by three leads and one artist. Their advice: keep scope small, playtest constantly, and watch players without them knowing ([DevForum Creator Spotlight](https://devforum.roblox.com/t/creator-spotlight-the-story-behind-99-nights-in-the-forest/4036940)).

GameAnalytics' benchmark data points the same way. **Return frequency, not session length,** was the big 2025 shift, driven by daily quests, offline progress and co-play. Games with 0-3 minute sessions have a median day-1 retention of **4.31%**, against **11.46%** for 19-24 minute games ([GameAnalytics](https://www.gameanalytics.com/cn/reports/2025-roblox-report)). One blog claims much higher "healthy" genre benchmarks of 20-35% D1 ([RoWatcher](https://rowatcher.com/news/retention-benchmarks-by-roblox-genre-what-good-actually-looks-like)), but gives no method. Trust the measured data and your own dashboard's benchmarks against similar games.

For the first session, Roblox's onboarding guide says:

- teach only the core loop;
- get to the fun within minutes, using low early level-up thresholds and starter items;
- end the session with visible short-, mid- and long-term goals and a "moment of joy".

It also recommends funnel events and A/B tests on the tutorial ([Roblox docs](https://create.roblox.com/docs/production/game-design/onboarding)). The simulator rules of thumb are about a dozen affordable upgrades in the first five minutes, cost steps of 1.5-2.5x, and rebirths that each run faster than the last. These come from a single blog without data ([creation.dev](https://www.creation.dev/blog/roblox-simulator-game-guide)), so treat them as starting values to tune, not rules.

For marketing, Roblox's thumbnail rules are:

- 16:9 at 1920×1080, with up to 10 images;
- real gameplay only, with no ad text;
- nothing important along the bottom edge.

Keeping several thumbnails live lets Roblox test them automatically per audience. That averaged **+8.5% play-through** in Roblox's tests ([Roblox docs](https://create.roblox.com/docs/production/publishing/thumbnails)). Off-platform, the spark came from short videos and big YouTubers. Dead Rails broke out after Roblox's own social posts and a 2M-view video from a large creator, which pushed it into the trending sorts ([GameAnalytics](https://www.gameanalytics.com/blog/dead-rails-and-the-hit-makers-formula)).

For an AI-assisted team, the lesson is: **ship small prototypes fast, measure the per-user signals, and put weekly live ops only behind the winners.** Weekly live ops means fixed-time weekly events and regular updates, as Steal a Brainrot and 99 Nights both run.

## Maps look good when the agent places a kit, not freeform parts

AI "slop" in maps has three usual signs: wrong scale, floating props, and a jumble of mismatched assets. The cure is structure, not a better prompt. Community agent skills for MCP map building use a six-phase order:

1. **Layout**
2. **Ground**
3. **Zone shells**
4. **Landmarks**
5. **Fill**
6. **Environment** (lighting and atmosphere)

They build with coordinates measured from a map origin to avoid drift, and run a validation script after each phase ([ohzw/roblox-dev-skills](https://github.com/ohzw/roblox-dev-skills)). For simulators, the layout rules are:

- a central spawn hub with shops and display pedestals;
- paths in a contrasting material;
- tall landmarks and sightlines that point to the next goal;
- hills, trees or cliffs as natural boundaries instead of invisible walls;
- never any empty dead space ([taozhuo map-design skill](https://playbooks.com/skills/taozhuo/game-dev-skills/map-design)).

For a mining game, this fits naturally. The hub sits on the surface, and each mine depth is a gated zone you can see from the one before.

Scale must come from a character, not from real life. A default R15 character is about **5.1-5.2 studs tall**. Builders who use "1 stud = 1 foot" end up with cramped rooms, because Roblox characters are wide and blocky ([DevForum](https://devforum.roblox.com/t/measurement-conversion/137419)). Starting conventions to check against a placed dummy:

- doors about 4-5 studs wide and 8-9 tall;
- ceilings 10-14 studs;
- tunnels 8-12 studs wide;
- pickups and ore nodes 2-4 studs, so they read on a phone.

No official Roblox source gives these numbers. They belong in a per-game scale sheet that the agent checks automatically.

Style consistency comes from a short, fixed list of choices:

- **Colours:** a locked palette.
- **Materials:** an allowed list, with MaterialVariants named base-first (e.g. `GrassWet`) so whole sets can be swapped ([Roblox docs](https://create.roblox.com/docs/parts/materials)).
- **Building pieces:** one reusable modular kit.
- **Lighting:** one lighting style.

Lighting changed in January 2025. "Unified Lighting" replaced the old Technology dropdown with two settings: **LightingStyle** (Realistic or Soft) and **PrioritizeLightingQuality**. Future maps to Realistic, and ShadowMap maps to Soft ([DevForum](https://devforum.roblox.com/t/let-there-be-unified-light-unified-lighting-is-fully-live/3401512)). Any AI advice to "pick ShadowMap for mobile" is out of date. Soft suits bright toy styles. Realistic suits caves lit by lanterns, as long as only a few lights cast shadows. Lighting that looks right in Studio can look wrong on a phone, so test on a device ([DevForum](https://devforum.roblox.com/t/my-lighting-works-well-in-studio-but-is-terrible-in-game-solved/3620334)).

Set a performance budget before you build. Roblox's example budget is **under 1,000 draw calls and 1M triangles** on a baseline device. (A draw call is roughly one batch of things the graphics chip draws.) A respected community engineer targets **≤500 draw calls, ≤500k triangles in view and under 1.3 GB client memory**. That covers 90%+ of phones, including 2 GB ones ([Roblox docs](https://create.roblox.com/docs/performance-optimization/design); [MrChickenRocket, DevForum](https://devforum.roblox.com/t/3127146)). Habits that keep you within budget:

- **Reuse the same mesh many times.** Copies of one mesh with one material collapse into one draw call, even with different colours ([Roblox docs](https://create.roblox.com/docs/performance-optimization/improve)).
- **Prefer Blender meshes over unions.** Roblox's built-in union tool (CSG) usually adds triangles ([DevForum](https://devforum.roblox.com/t/unions-vs-meshparts-2023/2638232)).
- **Use cheap collision.** Set decor collision to Box or Hull.
- **Stream the world.** Turn on StreamingEnabled with the **Opportunistic** stream-out setting, which Roblox says "significantly" cuts out-of-memory crashes ([Streaming docs](https://create.roblox.com/docs/workspace/streaming)).
- **Merge voxels.** In stud-voxel worlds, "greedy meshing" merges neighbouring same-material blocks so part counts don't explode ([DevForum](https://devforum.roblox.com/t/how-to-make-a-greedy-mesher/474436)).

After every build phase, the map skill should run a QA script through `execute_luau`. Downward raycasts work up to 15,000 studs and can exclude the object being tested ([Raycasting docs](https://create.roblox.com/docs/workspace/raycasting)). The script should flag:

- props hovering more than about 0.25 studs above the ground;
- props buried in other geometry;
- duplicate overlapping parts;
- unanchored decor;
- off-palette colours and off-list materials;
- doorways and tunnels too small for the clearance box;
- blocked spawns;
- the instancing ratio (copies per unique mesh).

Then take screenshots from fixed camera bookmarks and do a `character_navigation` walk from spawn to each zone.

## 3D models: image first, then Blender, then Open Cloud

**Image-to-3D beats text-to-3D for a consistent look**, even though it costs more per asset. The method:

1. Write one locked style prompt.
2. Generate a 2D master reference sheet.
3. Generate each asset's image against that reference.
4. Convert each image to 3D.

Text-to-3D drifts in style from asset to asset. Your existing `asset-artist` pipeline (Gemini/OpenAI reference image, then Meshy image-to-3D, then Roblox) already follows this route.

Prices, in credits:

| Tool | Image-to-3D | Text-to-3D | Extras | Source |
|---|---|---|---|---|
| Meshy | 20 mesh-only, 30 with 2K textures | 20 to preview | Remesh 5, auto-rig 5 | [Meshy](https://docs.meshy.ai/en/api/pricing) |
| Tripo H3.1 | 20-40 | 10-30 | Smart low-poly +10, quad +5, at most 3 parallel tasks | [Tripo](https://developers.tripo3d.com/en/models/v3-1) |

One date matters right now. Meshy's **"meshy-5" model retires on 10 October 2026** and its **"lowpoly" model on 30 October 2026** ([Meshy](https://docs.meshy.ai/en/api/pricing)). Your `art/meshy.py` asks for `"latest"`, which should avoid both. Hard-coded model names in any future skill script would not. For a flat-coloured toy style, turn off PBR (Tripo `pbr=false`) or use only the base colour, and ask for a low triangle count.

Roblox's import limits are fixed:

- **20,000 triangles per mesh.**
- Watertight geometry with no zero-thickness faces.
- At most 4 bone influences per vertex, with the root at the origin.
- Textures are shown at up to **1024×1024**, even though 4K files are accepted.
- Normal maps must use the OpenGL convention ([Mesh specs](https://create.roblox.com/docs/art/modeling/specifications); [Texture specs](https://create.roblox.com/docs/art/modeling/texture-specifications)). Some AI tools export the DirectX convention by default.

The 3D Importer handles FBX, glTF and OBJ. FBX and glTF both keep vertex colours, which gives a zero-texture option for flat-colour assets ([3D Importer](https://create.roblox.com/docs/art/modeling/3d-importer)).

Blender cleans up between generation and Roblox. Blender MCP (ahujasid's version) exposes a code-execution tool, a viewport-look tool and `generate_3d` (Tripo, Hunyuan3D or Rodin). One agent can therefore generate, clean and check a model in a single session. Its socket server has no authentication, so keep it on localhost ([blender-mcp](https://github.com/ahujasid/blender-mcp)). This machine also has its own Blender MCP connected. A standard cleanup script should:

1. import the model;
2. join the parts that belong together;
3. merge duplicate vertices;
4. fix the normals;
5. decimate down to the triangle budget;
6. set the origin to the bottom centre;
7. apply scale and rotation;
8. export.

Check this recipe on the first asset, because no Roblox source gives exact export values.

Upload skips the importer UI entirely. Open Cloud's `POST https://apis.roblox.com/assets/v1/assets` takes `.fbx`, `.gltf`, `.glb` or `.rbxm` files up to **20 MB** as a **Model** asset. You then poll the returned operation until it finishes and moderation clears ([Assets API guide](https://create.roblox.com/docs/cloud/guides/usage-assets)). After that, MCP `insert_asset` drops the model into the place. A raw "Mesh" asset type cannot be uploaded from a file.

Most 403 errors come from three causes ([rblx-open-cloud docs](https://rblx-open-cloud.readthedocs.io/en/latest/guides/group.html); [DevForum](https://devforum.roblox.com/t/opencloud-assets-api/2298007)):

1. The key is missing read and write permission for the Assets API.
2. The key owner doesn't match the creator. A group game needs a key created by the group, using `groupId`.
3. The calling IP isn't on the key's allowlist.

The same thread notes that a name blocked by the text filter returns a 400 error.

Roblox's own Cube generator (`generate_mesh`, `GenerationService`) is fine for placeholders and variety at runtime. Use the external pipeline for "hero" props that must match the style bible exactly ([GenerationService](https://create.roblox.com/docs/reference/engine/classes/GenerationService)).

## UI: commit to the genre look, build it in code, check it with screenshots

Top simulator UIs are image-based and loud: custom-drawn buttons, cartoon fonts, thick outlines and colour-coded actions ([DevForum](https://devforum.roblox.com/t/unique-or-good-looking-ui/2914121)). The Grow a Garden-era kit sold on itch.io lists the screens players now expect: Seed Shop, Confirmation, Codes, Limited Shop, Pet/Cosmetic Shop, HUD, Inventory, Hotbar, Notifications, Quests and Settings ([itch.io](https://adrianart.itch.io/gag-ui-pack)). That list works as a screen checklist for any new game.

"AI slop" UI is the statistical average: default fonts, purple-to-blue gradients, rounded web cards ([925studios](https://www.925studios.co/blog/ai-slop-web-design-guide)). The published fix has five steps ([Superdesign](https://www.superdesign.dev/blog/how-to-make-ai-ui-look-less-generic)):

1. Start from a real reference.
2. Commit to one named aesthetic.
3. Replace adjectives with hard numbers.
4. Do a "subtraction" pass against a checklist.
5. Iterate from screenshots.

Your existing `UI_RULES.md` and `ui-critic` agent are exactly this pattern. They belong in the reusable package as a template.

The 2025-26 technical rules an agent should follow:

- **Outlines that scale.** UIStroke gained **StrokeSizingMode = ScaledSize**, so outlines no longer look fat on phones and thin on 4K screens. It also gained ZIndex, so you can stack a dark outer stroke and a coloured inner stroke for the "sticker" look ([UIStroke API](https://create.roblox.com/docs/en-us/reference/engine/classes/UIStroke.md)).
- **Safe areas.** Keep ScreenGuis on **CoreUISafeInsets** so nothing sits under the top bar or a notch ([ScreenGui API](https://create.roblox.com/docs/en-us/reference/engine/classes/ScreenGui.md)).
- **Readable text.** Never let minimum text size drop below **9** ([Size modifiers](https://create.roblox.com/docs/en-us/ui/size-modifiers)).
- **Themed frames.** Use 9-slice images so frames resize without stretching ([9-slice docs](https://create.roblox.com/docs/en-us/ui/9-slice)).
- **Fonts.** Fredoka One (`Enum.Font.FredokaOne`) and LuckiestGuy are built in for the cartoon look ([Font enum](https://create.roblox.com/docs/reference/engine/enums/Font)).
- **Image size.** Images over 1024×1024 are shrunk on upload ([DevForum](https://devforum.roblox.com/t/uploading-4k-images/30343)), so design icons and frames at or below that size.

There are two routes from Figma. Figma's official MCP server can **write** to the canvas (frames, components, variables, auto layout) as well as read designs and take screenshots ([Figma docs](https://developers.figma.com/docs/figma-mcp-server/)). Two DevForum plugins import Figma designs into Studio. Both use layer-name tags like `_Button` and `_Scroll`:

- **RoImport** is free and can auto-upload images through an Open Cloud key ([DevForum, July 2026](https://devforum.roblox.com/t/free-figma-to-roblox-plugin-roimport/4731967)).
- **UILint v2** is freemium ([DevForum, July 2026](https://devforum.roblox.com/t/plugin-uilint-v2-import-figma-ui-into-roblox-studio/4765869)).

For agents, UI built in Luau (Frames plus UICorner, UIStroke and UIGradient) is usually easier to maintain than an import. It can be diffed, re-run and checked by screenshot. Save images for themed frames, icons and illustrations. Name Figma layers in the importer style anyway, so you can switch routes later.

For icons, generate a whole set as one grid image on a flat chroma background. Image models often fake transparency with a checkerboard pattern. Then cut, trim and re-pad each icon. AI gets icon sets about 80-90% of the way, and a manual polish pass finishes them ([Dreamina](https://dreamina.capcut.com/resource/ai-image-generator-for-icon-sets)). Your existing pixel-grid background-removal pipeline already does that cleanup step.

## Code that survives exploiters, data loss and the agent's own mistakes

Three rules cover most of what AI-written Roblox code gets wrong.

**First, the server decides everything.** Keep logic and data in ServerScriptService. Treat every RemoteEvent argument as hostile. A remote should send intent ("mine ore X"), never results ("give me 50 coins"). On every handler, the server should ([Security tactics](https://create.roblox.com/docs/scripting/security/security-tactics); [Client-server boundary](https://create.roblox.com/docs/en-us/scripting/security/client-server-boundary.md)):

- check types with `typeof`;
- reject NaN and infinity with `math.isfinite`. NaN slips past `if x > max` checks;
- confirm instances belong where expected with `IsDescendantOf`;
- cap string and table sizes and validate UTF-8;
- check distance against the server's own copy of the character position;
- rate-limit each player with a token bucket.

ProximityPrompt settings can be changed on the client, and ClickDetectors have "no checks at all on the server", so re-check both on the server.

**Second, never hand-roll player saving.** Use **ProfileStore**. It session-locks each player's data so only one server owns it, auto-saves, and hands off between servers. That stops the duplication and data-loss bugs that raw DataStore code invites ([ProfileStore](https://github.com/MadStudioRoblox/ProfileStore)). Design around Roblox's request budgets: about 60 + 40×players reads and writes per minute per server ([DataStore limits](https://create.roblox.com/docs/cloud-services/data-stores/error-codes-and-limits)). Put the UserId in every key, as in `Player_{UserId}`. That way a GDPR "right to be forgotten" deletion template can wipe a player's data automatically. The template token is case-sensitive: `{UserId}` works, `{userId}` is rejected ([RTBF docs](https://create.roblox.com/docs/en-us/cloud-services/data-stores/right-to-be-forgotten.md)).

**Third, test in layers.** Each layer catches a different kind of bug:

| Layer | What it is | What it catches | Limits |
|---|---|---|---|
| Unit tests | Plain-logic modules tested headlessly (the dinoderek/rob repo uses Lune with one `check` command for format, lint, types and tests) ([GitHub](https://github.com/dinoderek/rob)) | Logic bugs | None that matter |
| Cloud tests | Open Cloud Luau Execution runs scripts against an uploaded place, used by Roblox's own CI demo with Selene and StyLua ([Luau Execution](https://create.roblox.com/docs/en-us/cloud/reference/features/luau-execution.md); [CI demo](https://github.com/Roblox/place-ci-cd-demo)) | Bugs that need the Roblox engine | **No physics, no players**, 5-minute timeout. Point it at a test universe, because it can touch real DataStores. |
| Agent playtest | The MCP playtest loop | Anything needing a character or physics | Needs the evidence rule (console plus screenshot) |

The docs allow 10 incomplete Luau Execution tasks per place, but the CI demo says 2 per universe. The demo may simply be older.

Animations are a recurring trap, and your notes already log it. A KeyframeSequence plays only in Studio. Each animation must be published to the **same owner as the game**. For a group game that means the group, even if you own the group. Otherwise it "works for me but not for others" ([DevForum](https://devforum.roblox.com/t/animations-wont-play-under-group-game/839286); [Transfer animations](https://create.roblox.com/docs/projects/transfer-animations)). Agents can't click Publish, so the skill should have them write a manifest that maps each animation name to its KeyframeSequence path. A human then publishes them in one sitting.

## Monetization: cheap passes, honest odds, one receipt handler

The money maths is simple:

- **Creators keep 70%** of a pass or product sale ([RoWatcher](https://rowatcher.com/news/devex-math-in-2026-what-you-actually-take-home-per-1-000-players)).
- **DevEx** (Roblox's cash-out) pays **$0.0038 per Robux** since 5 September 2025 ([bloxodes](https://bloxodes.com/tools/roblox-devex-calculator)).
- **Since 8 June 2026, qualifying spend from age-checked US adults in R15-avatar games earns 42% more** ([Roblox Newsroom](https://about.roblox.com/newsroom/2026/04/roblox-fuels-high-fidelity-games-over-18-players-increases-qualifying-devex-rate-42)).

That last point is a reason to default new games to R15 and to give them some adult appeal.

What else you can sell:

- **Subscriptions:** up to 50 per game, priced in Robux or in local currency ([Subscriptions](https://create.roblox.com/docs/production/monetization/subscriptions)).
- **Roblox Plus rewards:** Plus replaced Premium on 30 April 2026. It pays creators up to 750 Robux per new subscriber won through the in-game prompt ([Roblox Plus docs](https://create.roblox.com/docs/production/monetization/roblox-plus); [Tubefilter](https://tubefilter.com/2026/04/13/roblox-plus-creator-payouts)).
- **Ads:** these only matter at scale. Rewarded Video needs **100K+ daily users** ([DevForum](https://devforum.roblox.com/t/more-creators-can-now-use-rewarded-video-ads/3838678)). Immersive Ads need 2,000 unique visitors a month and an approved maturity questionnaire ([Immersive Ads](https://create.roblox.com/docs/production/monetization/immersive-ads)).

Leave **managed pricing** on. It prices items by region (between 30% and 100% of the default price) and automatically tests price points. Participating creators saw about 4% higher median earnings ([Managed Pricing](https://create.roblox.com/docs/production/monetization/managed-pricing); [AllThingsHow](https://allthings.how/roblox-rdc-2025-10-creator-tools-and-updates-that-matter/)).

A sensible launch shop copies the biggest hit. Steal a Brainrot is reported to sell a 2x Money pass at 119 Robux that stacks with a 499 Robux VIP pass ([Buffget](https://buffget.com/news/steal-a-brainrot-gamepasses-guide-vip-and-2x-money-2026)). That is a fan-site source, so prices may have changed. Passes promoted on the Buy Robux page must cost more than 49 and less than 801 Robux ([Passes](https://create.roblox.com/docs/production/monetization/passes)). Add repeatable boosts as developer products and a starter pack. Roblox names the usual reasons for weak sales as prices too high, a shop that's hard to find, and unappealing items ([Monetization analytics](https://create.roblox.com/docs/production/analytics/monetization)).

Two rules must be built in from day one.

**Paid random items** include eggs, crates, spins, and luck boosts bought with Robux or Robux-bought currency. They must show every outcome's odds as percentages that add up to exactly 100%, behind a visible "Info" or "Details" label rather than an icon alone. Players flagged by `PolicyService` as restricted must get a free or non-random alternative ([Paid random items](https://create.roblox.com/docs/production/monetization/paid-random-items)).

**Purchases go through one `ProcessReceipt` callback**, which only one server script may set. It works like this ([MarketplaceService](https://create.roblox.com/docs/reference/engine/classes/MarketplaceService)):

1. Record each `PurchaseId` with `UpdateAsync` so a purchase is never granted twice.
2. Return `NotProcessedYet` if the player has left or the save failed.
3. Return `PurchaseGranted` only after the grant is saved.

Never grant from the client-side `PromptProductPurchaseFinished` event.

Platform context matters for expectations. Roblox had 123M daily users and $19.25 of bookings per paying user per month in Q2 2026. Yet it guided Q3 bookings **down 14-18%**, blaming lower spend per hour among younger US and Canadian players ([Roblox Q2 2026 8-K](https://www.sec.gov/Archives/edgar/data/0001315098/000162828026051059/ex991-robloxq22026earnin.htm)). That makes the adult-player boost more valuable.

Publishing has three requirements an agent can't skip:

- **The Maturity & Compliance Questionnaire.** Unrated games became unplayable for everyone except their developers on 30 September 2025 ([ShaneTheGamer](https://www.shanethegamer.com/esports-news/roblox-will-disable-all-unrated-games-on-september-30/)).
- **Analytics events.** `AnalyticsService` custom events work only from the server, only in published games, and only up to 100 event names ([Custom events](https://create.roblox.com/docs/production/analytics/custom-events)).
- **Studio for some publishes.** Open Cloud can publish a place file with `versionType=Published`, but it cannot update unions, SurfaceAppearance or editable meshes. Those still need a Studio publish ([Place publishing](https://create.roblox.com/docs/cloud/guides/usage-place-publishing)).

## One skill folder serves both Claude and ChatGPT

Claude and ChatGPT/Codex converged on the same packaging in 2026. A skill is a folder with a `SKILL.md` whose YAML header has a `name` and a `description`. It can also hold optional `scripts/`, `references/` and `assets/` folders. Only the short description sits in the agent's context all the time. The full body loads when the skill is used.

**Claude Code** ([Claude Code docs](https://code.claude.com/docs/en/skills)):

- Reads `~/.claude/skills/` (personal) and `.claude/skills/` (project).
- Keep `SKILL.md` under 500 lines and move detail into linked files.
- Extra fields like `context: fork`, `allowed-tools` and `paths` work only in Claude Code. The portable set is `name`, `description`, `license`, `compatibility`, `metadata` and `allowed-tools`. Any other field "will fail upload" to claude.ai.

**Codex and ChatGPT** ([OpenAI docs](https://learn.chatgpt.com/docs/build-skills)):

- Read `.agents/skills/` in the project and `$HOME/.agents/skills`.
- You invoke a skill with `$skill-name` in Codex or `@` in ChatGPT, or it triggers automatically when its description matches.
- OpenAI says skills work across ChatGPT desktop, web and mobile, the Codex CLI and IDE extensions.

**Always-on rules:**

- Codex reads `AGENTS.md`, concatenated from the repo root down to the folder it's working in, with a 32 KiB cap ([OpenAI docs](https://learn.chatgpt.com/docs/agent-configuration/agents-md)).
- Claude reads `CLAUDE.md`, which can start with `@AGENTS.md` to import it. On Windows, use that import rather than a symlink ([travis.media](https://travis.media/blog/claude-md-import-agents-md)).

There is one uncertainty. No doc confirms that Claude Code reads `.agents/skills/`, so the safe pattern is one canonical folder plus a copy script. For a ChatGPT custom GPT without skill support (like the earlier "Astra"), upload the same `references/*.md` files as knowledge files and paste `AGENTS.md` into the GPT's Instructions. Sources disagree on the file cap (10 vs 20 files), so keep the reference set small.

The design choice that matters most is **splitting the generic playbook from each game's own taste**:

- **The playbook** (how to build maps, check UI, write secure code, launch) is the same for every game. It lives in its own repo and is installed globally for both agents.
- **Each game's repo** holds what makes that game different: the spec, style bible, UI rules, lanes, ledger and status log.

The skills always tell the agent to read the per-game files first. That way the same "map-builder" skill makes a toy-brick mine for one game and a medieval keep for another.

### The package layout

Create a GitHub repo called `roblox-ai-playbook`, with this structure:

```
roblox-ai-playbook/
├── AGENTS.md                         # Rules for working ON the playbook itself
├── README.md                         # Install steps for Claude Code, Codex, ChatGPT
├── install.ps1                       # Copies skills/ to ~/.claude/skills and ~/.agents/skills
├── skills/                           # CANONICAL source; portable frontmatter only
│   ├── roblox-new-game/              # Orchestrator: scaffold a new game repo
│   │   ├── SKILL.md
│   │   └── assets/game-repo-template/   # (see per-game template below)
│   ├── roblox-team-workflow/         # Session start/end, lanes, drafts, STATUS
│   │   ├── SKILL.md
│   │   └── references/lessons.md     # Every gotcha you've logged, across all games
│   ├── roblox-studio-mcp/            # Tool cheat-sheet + verify loop
│   │   ├── SKILL.md
│   │   ├── references/tool-limits.md
│   │   ├── references/api-pitfalls.md
│   │   └── scripts/export_scripts.luau   # Dump all script sources for git
│   ├── roblox-game-design/
│   │   ├── SKILL.md
│   │   ├── references/discovery-signals.md
│   │   ├── references/core-loops.md      # sim/idle/tycoon/find-the-X/co-op patterns
│   │   ├── references/ftue.md
│   │   └── assets/GAME_SPEC.template.md
│   ├── roblox-map-builder/
│   │   ├── SKILL.md                      # 6 phases + QA gate per phase
│   │   ├── references/scale-sheet.md
│   │   ├── references/lighting-presets.md
│   │   ├── references/perf-budget.md
│   │   └── scripts/map_qa.luau           # floating/buried/palette/clearance/instancing report
│   ├── roblox-3d-assets/
│   │   ├── SKILL.md                      # generate vs insert vs Cube decision; budget rules
│   │   ├── references/meshy-tripo-settings.md
│   │   ├── references/import-limits.md
│   │   ├── references/open-cloud-403.md
│   │   ├── scripts/gen_refs.py           # from CoalMiningGame/art
│   │   ├── scripts/meshy.py              # from CoalMiningGame/art
│   │   ├── scripts/blender_cleanup.py
│   │   └── scripts/roblox_upload.py      # from CoalMiningGame/art
│   ├── roblox-ui/
│   │   ├── SKILL.md
│   │   ├── references/genre-screens.md
│   │   ├── references/tech-rules.md      # UIStroke, insets, text, 9-slice, tweens
│   │   ├── references/figma-route.md
│   │   ├── references/icon-pipeline.md
│   │   └── references/slop-checklist.md
│   ├── roblox-luau-code/
│   │   ├── SKILL.md
│   │   ├── references/architecture.md
│   │   ├── references/remote-validation.md
│   │   ├── references/data-profilestore.md
│   │   ├── references/review-checklist.md
│   │   └── assets/RemoteGuard.luau       # typeof/isfinite/utf8/rate-limit helper
│   ├── roblox-monetization/
│   │   ├── SKILL.md
│   │   ├── references/streams-and-rates.md
│   │   ├── references/paid-random-items.md
│   │   ├── assets/ProcessReceipt.luau
│   │   └── assets/shop-template.md
│   └── roblox-launch-liveops/
│       ├── SKILL.md
│       ├── references/launch-checklist.md
│       ├── references/analytics-events.md
│       ├── references/thumbnails-marketing.md
│       └── references/animation-publish.md
├── claude/                           # Claude-only extras (copied into each game's .claude/)
│   └── agents/
│       ├── roblox-playtester.md      # MCP play/console/screenshot only; maxTurns
│       ├── map-qa.md
│       ├── ui-critic.md              # from CoalMiningGame/.claude/agents
│       ├── ui-researcher.md
│       └── asset-artist.md
├── chatgpt/
│   └── custom-gpt-knowledge/         # Flattened references/*.md for a GPT without skills
└── evals/                            # skill-creator evals: with-skill vs without-skill
```

What each skill's `SKILL.md` must contain:

| Skill | Description line (what triggers it) | Body must contain |
|---|---|---|
| `roblox-new-game` | "Use when starting a new Roblox game or repo" | Copy the template. Fill in GAME_SPEC through a short interview. Pick the genre loop. Create the style bible and UI rules. Set budgets. Write the first TASKS lanes. |
| `roblox-team-workflow` | "Use at the start and end of every Studio session" | `git pull`. Read STATUS/TASKS. Claim shared instances. Use `list_roblox_studios` to confirm the target. At session end: log the Instance paths changed, list any drafts to commit, commit and push. |
| `roblox-studio-mcp` | "Use whenever editing or testing a place via MCP" | Read the live tool list. Stop Play before edits. Follow the 7-step verify loop. Narrow searches (10/50 caps). Check APIs with `http_get`. Generators run async and get logged. Evidence or it didn't happen. |
| `roblox-game-design` | "Use when designing loops, progression, onboarding or deciding whether to keep a prototype" | The recommendation signals and the 180-second bounce. The loop formula. The FTUE timings. Kill/continue decisions based on per-user metrics. |
| `roblox-map-builder` | "Use when building or changing maps, zones, lighting" | Read STYLE_BIBLE and the scale sheet. The 6 phases. Run `map_qa.luau` and take bookmarked screenshots after each phase. The performance budget. Kit instancing, not freeform parts. |
| `roblox-3d-assets` | "Use when a model, prop or texture is needed" | A decision tree (existing kit → Cube placeholder → image-to-3D). Budget and ledger. Image QA rules. Blender cleanup. Upload, poll, insert. The 403 checklist. |
| `roblox-ui` | "Use when creating or reviewing any screen" | Read UI_RULES. The genre screen list. Build in Luau. Tech rules. Icon pipeline. Run ui-critic with a screenshot before calling a screen done. |
| `roblox-luau-code` | "Use when writing or reviewing Luau" | Server authority. RemoteGuard on every remote. ProfileStore. `task.*` instead of legacy calls. Connection cleanup. The review checklist. Test layers. |
| `roblox-monetization` | "Use when adding passes, products, shops, eggs or crates" | The shop template. ProcessReceipt template. Odds table plus PolicyService gate. Managed pricing on. R15 for the 18+ boost. |
| `roblox-launch-liveops` | "Use before publishing or planning updates" | Launch checklist. Questionnaire. RTBF template. Funnel and economy events. 3+ thumbnails. Weekly event cadence. Animation publish manifest. |

Each brother runs `install.ps1` once after cloning, and again after each `git pull` of the playbook. Claude Code and Codex then pick the skills up in every game folder. Only the portable fields go in the canonical files. Claude-only behaviour, such as forked context or MCP-restricted tools, lives in `claude/agents/`, which the new-game skill copies into each game's `.claude/agents/`. Codex follows the same instructions directly from the skill. Test skills with the skill-creator evals before trusting them ([Claude Code docs](https://code.claude.com/docs/en/skills)).

### The per-game template

The `roblox-new-game` skill copies `assets/game-repo-template/` into a new GitHub repo for each game. It contains:

| File | Purpose |
|---|---|
| `AGENTS.md` | Always-on rules for both agents (under 32 KiB): place ID, lanes by Explorer path, hard style rules, "use the roblox-* skills", the evidence rule, no secrets in the repo |
| `CLAUDE.md` | `@AGENTS.md` plus Claude-only notes (which subagents to use) |
| `GAME_SPEC.md` | One verb, the collection, the return hook, the social stake, rebirth, the "later, not now" list |
| `docs/STYLE_BIBLE.md` | Palette hex codes with roles, allowed materials and MaterialVariants, kit grid, LightingStyle and Atmosphere values, the 3D prompt block, triangle budgets |
| `docs/SCALE_SHEET.md` | Door, ceiling, tunnel, path and pickup sizes checked against an R15 dummy |
| `docs/UI_RULES.md` | Font pair, stroke rules, colour roles, corner radius, screen list, mobile thumb zones |
| `docs/MONETIZATION.md` | Pass and product IDs, prices, the odds tables |
| `docs/LAUNCH.md` | The checklist below, ticked off |
| `STATUS.md`, `TASKS.md` | Session log (newest first) and lanes |
| `art/LEDGER.md` | Every spend on Meshy, Tripo or image APIs |
| `.claude/agents/` | Copied from the playbook |

## Per-game checklist

Copy this into each game's `docs/LAUNCH.md`. It is the "every time" part.

**0. Concept (day 1)**
- [ ] One-sentence pitch names a trend or familiar loop plus one novel twist
- [ ] GAME_SPEC lists the verb, the collection, the return hook (offline growth, daily quest or timed event) and the social stake
- [ ] Decide R15 vs R6 (R15 qualifies for the 18+ DevEx boost)
- [ ] Group owns the place from day one, so animations and assets are group-owned too

**1. Setup**
- [ ] Run `roblox-new-game`. The template is copied and the repo is on GitHub
- [ ] Both brothers ran `install.ps1`. Studio MCP is enabled and `list_roblox_studios` shows the right place
- [ ] Lanes written in TASKS.md. Shared modules (Config, Remotes) need a claim in STATUS.md
- [ ] Code backup chosen: Script Sync per lane, or a nightly `export_scripts.luau` commit
- [ ] Budgets set: art spend, triangles, draw calls, memory

**2. Greybox and core loop (prove the fun)**
- [ ] Map phases 1-3 built in neutral parts. The first shop or sell point is visible from spawn
- [ ] Core loop playable. First reward within about 30 s, first upgrade within about 1 min (starting targets, not official numbers)
- [ ] Unwatched playtest with 2-3 real players. Every confusion point is noted
- [ ] Kill or continue decision recorded in STATUS.md

**3. Art pass**
- [ ] STYLE_BIBLE locked. The 3D prompt block and master reference sheet exist
- [ ] Props made image-to-3D, cleaned in Blender, under budget, OpenGL normals, pivot at the bottom
- [ ] Uploaded as Model via Open Cloud and inserted, with each mesh reused (instanced)
- [ ] Map phases 4-6 done. `map_qa.luau` is clean. Bookmark screenshots taken. Navigation walk passes
- [ ] Lighting tested on a real phone

**4. UI**
- [ ] Every genre screen on the list exists or is consciously skipped
- [ ] Fonts, strokes (ScaledSize), colour roles and corners are consistent. Text is never below 9
- [ ] CoreUISafeInsets on. Nothing in thumb zones. Tested at phone size
- [ ] ui-critic passes and the "would a player guess AI made this?" check passes

**5. Systems, data, security**
- [ ] ProfileStore with `Player_{UserId}` keys, a DataVersion field, and a BindToClose handler
- [ ] RemoteGuard on every remote. Intent-only payloads. Server distance checks
- [ ] Review checklist passes: no legacy `wait`/`spawn`, connections cleaned up, no deprecated movers
- [ ] Playtest evidence (console output and screenshot) attached for every feature in STATUS.md
- [ ] All drafts committed. Animations published to the group from the manifest

**6. Monetization**
- [ ] Cheap 2x pass, stacking VIP pass, repeatable boosts and a starter pack
- [ ] One ProcessReceipt with PurchaseId de-duplication, tested in Studio
- [ ] Every paid random item shows odds that sum to 100% behind an "Info" label, and is gated by PolicyService
- [ ] Managed pricing left on

**7. Pre-launch**
- [ ] Maturity questionnaire done. Device support matches what was tested
- [ ] RTBF deletion template created with the `{UserId}` token
- [ ] Funnel events for the first-session steps, economy events for every source and sink (under 100 names)
- [ ] 3-5 honest 1920×1080 thumbnails, a 512×512 icon, a plain searchable title, no "free Robux" claims
- [ ] Low-end phone test: no early crashes (crashes inflate bounce rate)

**8. Launch and weekly live ops**
- [ ] Soft launch to friends. Check the Home Recommendations signal panel after the first days
- [ ] Short vertical clips posted several times a week, built around the game's most clip-worthy moment
- [ ] A fixed weekly event day and time announced in-game
- [ ] One A/B experiment per update. New thumbnails tested with each major update
- [ ] After each game, new gotchas are added to `roblox-team-workflow/references/lessons.md` in the playbook

## Conclusion

The research changes what "using AI to make a great game" means. The scarce resource is not generation. Meshes, icons, code and whole maps are now cheap. The scarce resource is judgment written down where every agent will read it. Hit games show that the winning concept is usually simple. Roblox's 28-day recommendation window means a polished first impression without a reason to return won't last. So the playbook's job is to make every game clear two bars automatically: does it look and run right (style bible, budgets, QA scripts, evidence loop), and does it bring players back (return hook, social stake, weekly cadence). Your own logged gotchas, such as stopping Play before edits, publishing animations to the group, and committing drafts, are worth more than any vendor case study, because no credible public example yet exists of a hit built mainly by Claude or Codex through MCP.

Two things are still uncertain and worth re-checking each quarter. The Studio MCP tool set is changing faster than its docs. Roblox has also said it plans "Assistant Skills" and Open Cloud tools callable from external agents ([DevForum roadmap](https://devforum.roblox.com/t/creator-roadmap-2026-spring-update/4625473)), which could later absorb parts of this package. Keeping the playbook in the open Agent Skills format, in its own repo, means it will move to whichever agent or Roblox-native skill system comes next without a rewrite. Because the format is open, many small prototypes cost little each. A portfolio of quick tests is the strategy the 2025 hit makers' record supports.
