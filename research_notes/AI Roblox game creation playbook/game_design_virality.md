# What Makes Roblox Games Succeed in 2025-2026: Design, Core Loops, Retention, Discovery and Virality

Research date: 2026-10-07. Dates are marked where sources give them. Note: some third-party pages show "last updated" stamps (e.g. GameAnalytics pages stamped Aug/Sep 2026) that may be refresh dates rather than original publish dates; the underlying data periods are given where known.

Source-quality legend used below: [PRIMARY] = Roblox official (creator docs, newsroom, DevForum staff posts) or developer's own words; [INDUSTRY] = analytics/industry firm (GameAnalytics, Dubit) or reputable press (GamesBeat, Wikipedia); [BLOG] = smaller third-party dev-advice sites (creation.dev, rowatcher, rolearn) with little or no stated methodology; treat as heuristics, not facts.

---

## 1. How does Roblox discovery/recommendation work in 2025-2026, and what metrics matter?

### Takeaway
The Home page "Recommended For You" (RFY) algorithm (live globally since March 2025) is now the main growth engine; it ranks on per-user averages (not totals) of play-through, early bounce, play days, playtime, co-play and spend, measured from players acquired via recommendations. Since June 15, 2026 it measures retention over a 28-day window (D1, D2-7, D8-28) and replaced qualified play-through rate (qPTR) with play-through rate (PTR) plus first-play bounce rate (<180 seconds) — so a clicky thumbnail with a weak first 3 minutes and weak week-2-to-4 return is actively penalised.

### Cited Findings
- RFY runs in two stages: retrieval (picks candidate games using "engagement, retention, and monetization" signals) and ranking (personalises order per user). It prioritises organic engagement from users acquired through recommendations — not from ads, search or other sources. [PRIMARY] — [Roblox Creator Docs: Discovery](https://create.roblox.com/docs/discovery)
- "Most important" signals per Roblox docs: play-through rate; first play bounce rate (users leaving after <180 seconds, a negative signal); play days per user (segmented D1, D2-7, D8-28); playtime per user (capped at 60 minutes/day). "Important" signals: co-play days per user (joins/invites), qualified play sessions (filters accidental clicks), spend days per user, Robux spent per user. [PRIMARY] — [Roblox Creator Docs: Discovery](https://create.roblox.com/docs/discovery)
- All signals are averages, not totals, "ensuring smaller games aren't disadvantaged." [PRIMARY] — [Roblox Creator Docs: Discovery](https://create.roblox.com/docs/discovery)
- June 15, 2026 update: window expanded from 7 days to 28 days (D1, D2-7, D8-28) for playtime, play days, qualified play sessions, intentional co-play days, spend days and Robux spent; qPTR removed; PTR and first-play bounce rate added "to better understand what happens immediately after a player decides to click on a game." Signal metrics and relative importance are shown in Creator Analytics under Acquisition > Home Recommendations. [PRIMARY] — [DevForum: RFY Algorithm Improvements That Better Value Long-Term Retention](https://devforum.roblox.com/t/recommended-for-you-algorithm-improvements-that-better-value-long-term-retention/4684575); [Roblox Newsroom, June 2026](https://about.roblox.com/newsroom/2026/06/optimizing-discovery-great-games-reach-millions-players-roblox)
- Roblox's stated reason: the old 7-day system was "overvaluing" short-term engagement, letting games with "exciting thumbnails but don't deliver long-term value" displace better games. Testing of the 28-day version reportedly increased DAU and engagement. [PRIMARY] — [Roblox Newsroom, June 2026](https://about.roblox.com/newsroom/2026/06/optimizing-discovery-great-games-reach-millions-players-roblox)
- Developer concerns in the thread: cold-start for brand-new games without 28-day data; low-RAM devices (1.5GB) crashing in the first minutes inflate bounce rate. [PRIMARY, community replies] — [DevForum thread](https://devforum.roblox.com/t/recommended-for-you-algorithm-improvements-that-better-value-long-term-retention/4684575)
- Reduced exposure ("eligibility" penalties) for: leading with monetary rewards in metadata (e.g. "free Robux"-style claims), metadata that mismatches actual gameplay, and non-unique/derivative games. [PRIMARY] — [Roblox Creator Docs: Discovery](https://create.roblox.com/docs/discovery)
- Other discovery surfaces: Sponsored sort (paid ads), Standout Games (hand-curated novel experiences), Live Events (limited-time quests with rewards), semantic natural-language Search, Discover page (top charts and trending sorts), and Notifications (friend activity, milestones, high scores). [PRIMARY] — [Roblox Creator Docs: Discovery](https://create.roblox.com/docs/discovery)
- Earlier (2025-era) analytics reporting noted that "7-day spend days per user" and "7-day Robux spent per user" fed recommendations — i.e. monetisation frequency is a discovery input (now 28-day). [INDUSTRY] — [GameAnalytics 2025 Roblox Benchmark Report](https://www.gameanalytics.com/cn/reports/2025-roblox-report)
- Impact of RFY (Dubit analysis of Top 20 visits, July 2024-Dec 2025): mature games (24+ months) fell from 84% of Top-20 visits pre-RFY to 18% six months after; brand-new games (<6 months) rose from 1.3% to 60.7%. Top-20 total visits grew from 8.0B (July 2024) to 28.7B (Aug 2025), all incremental growth from games <18 months old. Median Top-20 tenure fell from 14 to 7 months; only 7 of the July 2024 Top 20 remained by Dec 2025. Grow a Garden hit 48.1% share (8.1B visits) in June 2025; Steal a Brainrot held 35-40% share for six months, 9.9B visits by August 2025. [INDUSTRY] — [Dubit: Roblox Top 20 and RFY](https://dubit.io/blog/roblox-top-20-rfy)
- "Top Trending" and "Up-and-Coming" lists acted as a feedback loop for Dead Rails once CCU surged (more players -> more visibility). [INDUSTRY] — [GameAnalytics: Dead Rails and the Hit Makers Formula](https://www.gameanalytics.com/blog/dead-rails-and-the-hit-makers-formula)

### Inferences
- The algorithm now rewards three distinct things a design checklist must target: (a) the first 180 seconds (bounce), (b) return days across weeks 1-4 (play days D2-7 and D8-28), (c) intentional co-play and spend *frequency* (spend days, not just spend size). Because signals are per-user averages, a small new game with excellent per-user numbers can be surfaced — RFY favours new games strongly, as Dubit's data shows.
- Playtime is capped at 60 min/day, so there is little discovery benefit to designing for multi-hour sessions; frequency of return matters more.
- Thumbnails that oversell will now hurt (PTR and bounce), so thumbnail and first-minute experience must match.

### Gaps
- Roblox has not published numeric thresholds (e.g. a D1 or PTR cut-off) for entering Top Trending/Up-and-Coming or for RFY promotion; the relative-importance chart is only visible in each creator's dashboard. I found no reliable public thresholds.
- Exact current eligibility rules for the "Up-and-Coming" sort (age of game, minimum CCU) were not found in primary docs during this research.

---

## 2. Core loop and progression design for simulators, incrementals, tycoons, "find the X" and co-op games

### Takeaway
The 2025-26 hits are "simple core action + visible collection/progress + reason to come back tomorrow + something social at stake." Return frequency (offline growth, daily quests, timed weekly events) matters more than session length. For simulators/incrementals, the widely repeated heuristics are: ~a dozen affordable upgrades in the first 5 minutes, exponential costs ~1.5-2.5x per step, and rebirths that each run faster than the last.

### Cited Findings
- Grow a Garden's key novelty: a persistent world where plants grow while offline, creating a reason to return regularly; theme with universal appeal ("Everyone likes to farm, to watch something grow"). [PRIMARY, developer interview] — [GamesBeat: Janzen 'Jandel' Madsen interview](https://gamesbeat.com/janzen-madsen-interview/)
- Grow a Garden loop: plant/harvest -> sell for Sheckles -> buy seeds, gear, eggs, decor; quests, seasonal events, land expansion; eggs hatch pets with passive abilities; weather mutations boost crop value. [INDUSTRY/press] — [iTWire: Australia's top Roblox obsessions of 2025](https://itwire.com/your-it-news/entertainment/roblox-from-gardens-to-brainrots-australia%E2%80%99s-top-roblox-gaming-obsessions-of-2025)
- Steal a Brainrot loop: buy "Brainrot" characters off a conveyor belt or steal them from other players; characters generate passive income; buy defensive items; "rebirth" to reset for better stats; core mechanic resembles capture-the-flag. Genre listed as idle/multiplayer. [INDUSTRY] — [Wikipedia: Steal a Brainrot](https://en.wikipedia.org/wiki/Steal_a_Brainrot)
- Steal a Brainrot merges tycoon/idle with PvP — your collection is displayed in your base and can be stolen, so stakes are visible in the world. [INDUSTRY/press] — [iTWire](https://itwire.com/your-it-news/entertainment/roblox-from-gardens-to-brainrots-australia%E2%80%99s-top-roblox-gaming-obsessions-of-2025)
- 99 Nights in the Forest: co-op survival where each friend gets an obvious job (scout, gather, cook/craft) without being locked into a class. [BLOG] — [Bloxodes: Roblox co-op survival games](https://bloxodes.com/articles/roblox-co-op-survival-games)
- Simulator core loop: (1) action to earn resources, (2) spend on upgrades that make earning faster, (3) hit a ceiling, then reset with a permanent bonus. [BLOG, 2026-02-16] — [creation.dev: Roblox simulator guide](https://www.creation.dev/blog/roblox-simulator-game-guide)
- Upgrade costs should scale ~1.5x-2.5x per step; "give players a dozen upgrades they can afford within the first five minutes"; early upgrade density much higher than late. [BLOG] — [creation.dev](https://www.creation.dev/blog/roblox-simulator-game-guide)
- Rebirth pacing: each cycle faster than the last (e.g. 2h -> 1h -> 30 min); multiple rebirth tiers extend longevity. [BLOG] — [creation.dev](https://www.creation.dev/blog/roblox-simulator-game-guide)
- Pets/eggs: randomised hatches with rarity tiers (Common->Legendary) create collection goals; fusion as a sink. World design: hub-and-spoke, 5-8 areas at launch, each more impressive than the last. Monetisation: 2x/3x multiplier passes, auto-click, exclusive eggs, dev products, but free players must be able to experience the game at a reasonable pace. [BLOG] — [creation.dev](https://www.creation.dev/blog/roblox-simulator-game-guide)
- Caution: front-loading rewards to lift D1 can harm D7 ("borrowing anticipation from future sessions"). [BLOG] — [rowatcher: Reward pacing / D7 is a loop problem](https://rowatcher.com/news/roblox-d7-retention-is-a-loop-problem-not-a-content-problem)
- GameAnalytics' conclusion from 2023-mid-2025 data: the biggest 2025 shift is return frequency, not session length — driven by daily quest design, offline progression and friend-to-friend co-play incentives. 90th-percentile sessions/day rose to 6.0 (+33% YoY). [INDUSTRY] — [GameAnalytics 2025 Roblox Benchmark Report](https://www.gameanalytics.com/cn/reports/2025-roblox-report)
- Roblox docs: set short-, mid- and long-term goals (skill trees, quests, season passes) and surface them prominently in UI or world. [PRIMARY] — [Roblox Docs: Onboarding](https://create.roblox.com/docs/production/game-design/onboarding)
- "Find the X" games (e.g. Find the Brainrot): dense scavenger hunt across multiple maps (312 items in Find the Brainrot), some in plain sight, others behind obbies, mini-quests, multi-day logins, and RNG Lucky Blocks with boosted odds during Admin Abuse events. [BLOG/guide] — [AllThings.How: Find the Brainrot](https://allthings.how/find-the-brainrot-roblox-how-the-312-brainrots-actually-work/)
- Live-ops cadence used by hits: Steal a Brainrot runs a weekly Saturday update event (6 PM UTC) and a "Taco Tuesday" event (11 PM UTC), each 30-45 minutes, plus "admin abuse" sessions with exclusive characters. [BLOG/guide] — [Deltia's Gaming: Taco Tuesday guide](https://deltiasgaming.com/?p=328482); [FindingDulcinea: admin abuse schedule](https://findingdulcinea.com/steal-a-brainrot-admin-abuse-schedule/)
- 99 Nights runs weekly 45-minute weekend "Update Parties" where devs interact with players, give items and spot bugs; Halloween 2025 update was a three-part release with new classes, crafting and limited-time items. [PRIMARY] — [DevForum Creator Spotlight: 99 Nights in the Forest](https://devforum.roblox.com/t/creator-spotlight-the-story-behind-99-nights-in-the-forest/4036940)
- Grow a Garden's growth plan centred on "a live service" with weekly updates. [PRIMARY] — [GamesBeat](https://gamesbeat.com/janzen-madsen-interview/)
- Cross-game events are huge: an Aug 23, 2025 mock "admin war" between Steal a Brainrot and Grow a Garden drove a platform-wide 47.4M CCU record; a Jan 2026 Bruno Mars concert in Steal a Brainrot drew 12.8M CCU. [INDUSTRY] — [Wikipedia: Steal a Brainrot](https://en.wikipedia.org/wiki/Steal_a_Brainrot)

### Inferences
- Checklist for loop design: (1) one verb learnable in seconds; (2) a collection with rarity tiers visible to others; (3) passive/offline progress or timers that pay out on return; (4) a weekly, fixed-time live event (same day/time each week) to train habit and spike co-play; (5) a social stake (stealing, trading, co-op roles, shared base) to drive co-play days; (6) rebirth/prestige for long-term goals.
- "Find the X" games are cheap to extend (add N more items per update) and pair naturally with multi-day-login items and event-only items to drive D2-7 / D8-28 play days.

### Gaps
- The 1.5-2.5x cost multiplier, "dozen upgrades in 5 min" and rebirth-halving rules come from one blog source (creation.dev) without data; I found no Roblox-official or analytics-backed upgrade-curve numbers.
- No reliable public source on Prehistoric Farm or "Find the Needle"-type games specifically.

---

## 3. Case studies of breakout hits (2025-2026)

### Takeaway
The big 2025 hits were built fast by small teams (days to ~3 months), often riffed on a trend, and then exploded once an experienced live-ops team added weekly updates and events; social virality (TikTok/YouTube, official Roblox channels, big creators) plus RFY amplification did the rest.

### Cited Findings
- **Grow a Garden** (launched March 26, 2025): originally made by a 16-year-old (BMWLux) "in a few days"; Jandel/Splitting Point Studios partnered when it had ~500 CCU and 10-20k DAU (Jandel also quoted ~1,000-2,000 CCU); within two weeks ~100k CCU; ~1M CCU in about a month; peaks of 22.3M CCU and 60M DAU, ~30B plays in ~4 months; won Best New Experience at the Roblox Innovation Awards. [PRIMARY interview] — [GamesBeat](https://gamesbeat.com/janzen-madsen-interview/). Do Big Studios also involved. [press] — [AOL: How this 16-year-old's game took over Roblox](https://www.aol.com/roblox-kids-yearning-farm-grow-124048865.html). Guinness record cited at 21.6M CCU in July 2025 — [iTWire](https://itwire.com/your-it-news/entertainment/roblox-from-gardens-to-brainrots-australia%E2%80%99s-top-roblox-gaming-obsessions-of-2025) (minor discrepancy with 22.3M peak; likely different dates).
- **Steal a Brainrot** (released May 16, 2025; developer SpyderSammy; owner DoBig Studios): rode the 2025 "Italian brainrot" meme; viral TikTok/YouTube content showing strategy tips and kids crying after their Brainrots were stolen; CCU 5M (July 2025) -> 20M (Aug) -> 24M (Sept 13) -> 25.4M (Oct 2025, first game over 25M); 7B visits by July 2025. Controversies: Tung Tung Tung Sahur licensing dispute (Sept-Nov 2025); lawsuit against a Fortnite copycat (Oct 2025). [INDUSTRY] — [Wikipedia](https://en.wikipedia.org/wiki/Steal_a_Brainrot)
- **99 Nights in the Forest** (Grandma's Favourite Games, released June 2025): core team of 3 leads plus one artist/animator; started as a "week-long project" in a casual game jam; dev from ~March to June 2025 — their fastest cycle (previous projects ~6 months); combined the "survive N days" trend with Dead Rails inspiration and a forest aesthetic; mascot designed to be "scary without ostracizing younger users"; pushed as much to the client as possible for snappy combat with server verification; Cultist Stronghold dungeon built in 2 days; ~14M peak CCU (summer 2025). Their advice: keep scope small, make content you'd play, continuous playtesting, watch players unobserved, pivot quickly. [PRIMARY] — [DevForum Creator Spotlight](https://devforum.roblox.com/t/creator-spotlight-the-story-behind-99-nights-in-the-forest/4036940). Later: 14.2M peak CCU, ~26B lifetime visits, 90.6% rating, 20th Century Studios film rights. [press] — [TheWrap](https://www.thewrap.com/creative-content/movies/20th-century-studios-roblox-game-99-nights-in-the-forest/); [Bloxodes](https://bloxodes.com/articles/roblox-co-op-survival-games)
- **Dead Rails** (RCM Games, first published Jan 1, 2025; studio has ~70 titles): late Feb 2025 Roblox's official channels featured it (TikTok 499K+ likes, Instagram 114K+, X 224K+ views); creator Flamingo (11M+ subs) video got 2M+ views; then it hit Top Trending and Up-and-Coming; MAYA principle — familiar mechanics (Build A Boat-style) plus a novel 1899 Wild West zombie-train setting. [INDUSTRY] — [GameAnalytics: Dead Rails and the Hit Makers Formula](https://www.gameanalytics.com/blog/dead-rails-and-the-hit-makers-formula). Peak CCU reported as 600K+ by GameAnalytics vs "near 1.3 million" by [Earnaldo](https://earnaldo.com/blog/99-nights-in-the-forest-vs-dead-rails) — conflicting; unresolved. Estimated revenue $51.4M, 92.75% like ratio (third-party estimate, unverified). — [GameAnalytics](https://www.gameanalytics.com/blog/dead-rails-and-the-hit-makers-formula) search summary.
- Later breakouts named in Dubit's data: Plants Vs Brainrots, The Forge. [INDUSTRY] — [Dubit](https://dubit.io/blog/roblox-top-20-rfy)

### Inferences
- Pattern: (1) small prototype in days/weeks; (2) find signal at hundreds-low thousands of CCU; (3) then apply live ops (weekly updates, scheduled events) — that is where growth compounded. A portfolio approach (RCM's ~70 titles) increases odds.
- Trend-riding (Italian brainrot memes, "survive N days", farming) plus one novel twist (offline growth, stealing, train survival) is the recurring formula.
- For an AI-assisted team, the evidence supports shipping many small prototypes fast and only investing live ops in those with strong early per-user metrics.

### Gaps
- No reliable public source on how much (if any) AI tooling these specific teams used; none of the primary interviews mention AI.
- Team size of Grow a Garden's live team and Steal a Brainrot's team not disclosed in sources found.

---

## 4. Onboarding/FTUE best practices and what kills retention

### Takeaway
Roblox's own guidance: teach only the essentials, get to the fun within minutes (fast early level-ups, starter resources), and end the first session with clear short/mid/long-term goals and a "moment of joy". The first 180 seconds is now an explicit negative algorithm signal (first-play bounce), so the FTUE is directly a discovery lever.

### Cited Findings
- Roblox principles: (1) Teach the essentials — controls and the core loop, both what to do and why; (2) Get to the fun quickly — players decide within minutes; use low XP thresholds early so players level up quickly, social motivators, starter currency/items (balanced); (3) Leave players wanting more — short/mid/long goals surfaced in UI, end with "moments of joy" (rewards, animations, celebration). [PRIMARY] — [Roblox Docs: Onboarding](https://create.roblox.com/docs/production/game-design/onboarding)
- Measure D1 retention and FTUE completion via funnel events; A/B test tutorial variants (dialogue vs guided arrows), starting currency amounts, social grouping; tune progression live with Configs. [PRIMARY] — [Roblox Docs: Onboarding](https://create.roblox.com/docs/production/game-design/onboarding)
- First-play bounce = leaving within 180 seconds, a negative RFY signal. [PRIMARY] — [Roblox Docs: Discovery](https://create.roblox.com/docs/discovery)
- Low-RAM devices crashing early inflate bounce (developer report) — performance on low-end mobile is part of FTUE. [PRIMARY, community] — [DevForum RFY thread](https://devforum.roblox.com/t/recommended-for-you-algorithm-improvements-that-better-value-long-term-retention/4684575)
- 99 Nights devs: watch players play unobserved to find genuine confusion points. [PRIMARY] — [DevForum Creator Spotlight](https://devforum.roblox.com/t/creator-spotlight-the-story-behind-99-nights-in-the-forest/4036940)
- Short-session games struggle: in GameAnalytics' 2025 data, games with 0-3 min sessions have median D1 of 4.31% and D7 0.41%, while 19-24 min games have median D1 11.46% and D7 1.61% (95th pct D1 23.6%, D7 7.88%). [INDUSTRY] — [GameAnalytics 2025 Roblox Benchmark Report](https://www.gameanalytics.com/cn/reports/2025-roblox-report)
- Over-generous early rewards borrow anticipation from later sessions and can hurt D7. [BLOG] — [rowatcher](https://rowatcher.com/news/roblox-d7-retention-is-a-loop-problem-not-a-content-problem)
- Misleading thumbnails/metadata are penalised (reduced exposure) and worsen bounce. [PRIMARY] — [Roblox Docs: Discovery](https://create.roblox.com/docs/discovery); [Roblox Docs: Thumbnails](https://create.roblox.com/docs/production/publishing/thumbnails)

### Inferences
- FTUE checklist: first reward within ~30 seconds; first upgrade/level within the first minute; core loop understood before 180 s; a visible next goal at all times; a tease of tomorrow's reward (offline growth, daily quest, timed event) before the player leaves; test on low-end mobile.
- Retention killers: confusing start, long loading/unskippable text, crashes on low-end devices, thumbnail-gameplay mismatch, walls without visible next goal, front-loading everything on day 1.

### Gaps
- No primary Roblox source gives a target tutorial length in seconds; the timing numbers above are inference.

---

## 5. Testing and iteration: playtesting, analytics, funnels, A/B tests, benchmarks

### Takeaway
Roblox now provides a near-complete built-in stack: Creator Analytics (retention, Home Recommendations signal panel, segmentation), custom funnel and economy events, Experiments (A/B tests), Configs (live tuning) and thumbnail personalization (automatic thumbnail bandit testing). Benchmarks vary hugely by source and session length; compare against same-genre peers and track relative change.

### Cited Findings
- Funnel events track progress through key stages (onboarding, shopping) to find drop-off; economy events track currency sources/sinks; events can be segmented by age, gender, platform, OS and up to three custom fields. [PRIMARY] — [Roblox Docs: Funnel events](https://create.roblox.com/docs/production/analytics/funnel-events) (search summary); [Pocket Tactics](https://www.pockettactics.com/roblox/analytics-tools)
- Aug 2026 creator tools: player-segmentation dashboard (slice by in-game activity, engagement level, platform activity, tenure, platform spend), real-time performance alerts, custom error reporting, an Experiments system for A/B testing, updated Configs. Adopt Me! team said Roblox's platform "covers probably 60–70% of what we built internally"; segmentation showed chat-capable matching was critical for trading. Platform context: 123M DAU (down from 152M peak in 2025). [INDUSTRY press, quotes from Roblox staff] — [GamesBeat: Roblox announces new creator tools](https://gamesbeat.com/roblox-announces-new-creator-tools-for-analytics-a-b-testing-and-live-ops-exclusive/)
- RFY signal values per game are visible under Acquisition > Home Recommendations. [PRIMARY] — [DevForum RFY thread](https://devforum.roblox.com/t/recommended-for-you-algorithm-improvements-that-better-value-long-term-retention/4684575)
- Thumbnail personalization: needs 2+ active thumbnails; shows each to random users, then gives more impressions to the winner per user group while keeping exploration traffic; average +8.5% qualified play-through rate in testing, some up to +50%. [PRIMARY] — [Roblox Docs: Thumbnails](https://create.roblox.com/docs/production/publishing/thumbnails); [Thumbnail Personalization docs](https://create.roblox.com/docs/zh-cn/cloud/reference/features/thumbnail-personalization)
- GameAnalytics Roblox benchmarks (data Jan 2023-Jul 2025): median daily playtime 16.77 min (95th pct 93.84); median 2.02 sessions/day; session length 25th pct 2.36 min vs 95th pct 37.10 min; median payer ARPPU under $1/day, 95th pct $20.65/day. By session-length bucket, median D1 ranges 4.3%-11.5% and 95th pct D1 up to ~24.8%; D7 95th pct tops out ~7.9%; D30 95th pct ~1.9%. [INDUSTRY] — [GameAnalytics 2025 Roblox Benchmark Report](https://www.gameanalytics.com/cn/reports/2025-roblox-report)
- CONFLICT: a blog benchmark claims much higher "healthy" retention by genre — tycoons/incrementals D1 20-28%, D7 12-18%; obbies D1 25-35%, D7 10-15% — without methodology, and warns that genre-agnostic benchmarks are harmful. [BLOG] — [rowatcher: Retention benchmarks by genre](https://rowatcher.com/news/retention-benchmarks-by-roblox-genre-what-good-actually-looks-like). These conflict sharply with GameAnalytics' measured percentiles; definitions (cohort vs rolling retention, sample of games) likely differ. Prefer GameAnalytics for measured data, and Roblox's in-dashboard benchmarks for your own genre.
- Playtest advice from hit developers: continuous playtesting, watch unobserved play, pivot from failed concepts quickly. [PRIMARY] — [DevForum Creator Spotlight](https://devforum.roblox.com/t/creator-spotlight-the-story-behind-99-nights-in-the-forest/4036940)

### Inferences
- Minimum instrumentation for every new game: funnel for FTUE steps (spawn -> first action -> first reward -> first upgrade -> first goal set -> leave), economy events for every currency source/sink, custom fields for variant and platform; launch with 3+ thumbnails active; one Experiment per update.
- Kill/continue criteria should be based on per-user RFY signals (PTR, bounce, D1, D2-7 play days, co-play) compared with the dashboard's similar-experience benchmarks, not raw visits.

### Gaps
- Roblox's in-dashboard genre benchmarks are not public; I found no Roblox-official public D1/D7 targets.

---

## 6. Marketing: thumbnails, icons, titles, TikTok/Shorts, ads, influencers, update logs

### Takeaway
Off-platform short video (TikTok/YouTube Shorts) and big Roblox YouTubers were the ignition for most 2025 hits; on-platform, thumbnails must be honest gameplay (or be penalised by bounce/PTR), and multiple thumbnails should stay active for personalization. Fixed-schedule weekly events double as marketing moments.

### Cited Findings
- Thumbnail rules: 16:9, 1920x1080; up to 10 images/videos; use unique imagery showing what players should expect; don't put essential elements at the bottom (metadata overlays them); use colour to express theme; show real gameplay — no UI or mechanics not in the game, no real-life footage, no voice-over or lyrical music, no ad text/promotional claims/subjective language. Test new thumbnails with each major update, then leave them until the next; keep multiple active rather than picking one winner. [PRIMARY] — [Roblox Docs: Thumbnails](https://create.roblox.com/docs/production/publishing/thumbnails)
- Icon: square, at least 512x512; images under 3 MB. [secondary/PRIMARY via search summary] — [Roblox Docs: Thumbnails](https://create.roblox.com/docs/production/publishing/thumbnails)
- Metadata that leads with monetary rewards or mismatches gameplay reduces exposure. [PRIMARY] — [Roblox Docs: Discovery](https://create.roblox.com/docs/discovery)
- Paid: Sponsored sort exists; but RFY prioritises engagement from recommendation-acquired users, not ad-acquired users. [PRIMARY] — [Roblox Docs: Discovery](https://create.roblox.com/docs/discovery)
- Steal a Brainrot's virality came via TikTok/YouTube clips (strategy tips, kids' reactions to having Brainrots stolen) — i.e. a mechanic that creates shareable emotional moments. [INDUSTRY] — [Wikipedia](https://en.wikipedia.org/wiki/Steal_a_Brainrot)
- Dead Rails ignition: Roblox official social posts (TikTok 499K+ likes) and Flamingo's video (2M+ views), then algorithmic sorts. [INDUSTRY] — [GameAnalytics](https://www.gameanalytics.com/blog/dead-rails-and-the-hit-makers-formula)
- TikTok described as the most powerful off-platform discovery engine for Roblox games; volume beats polish (e.g. ~5 videos/week); Shorts pipelines of 3-5 clips/week. [BLOG] — [rolearn: TikTok content strategy](https://rolearn.dev/guidance/roblox-tiktok-content-strategy-viral); [Eklipse: Roblox YouTube Shorts strategy](https://blog.eklipse.gg/beginner-guide-2/roblox-youtube-shorts-strategy.html)
- Roblox "entering its TikTok era" — Clip It (in-Roblox short-video app) had 1B+ views and 8M MAU (Sept 2025). [press] — [Tubefilter](https://www.tubefilter.com/2025/09/09/roblox-is-entering-its-tiktok-era/)
- Scheduled community events (99 Nights' weekend Update Parties; Steal a Brainrot's Saturday/Tuesday events and admin abuse) are de facto marketing beats. [PRIMARY] — [DevForum Creator Spotlight](https://devforum.roblox.com/t/creator-spotlight-the-story-behind-99-nights-in-the-forest/4036940); [BLOG] — [Deltia's Gaming](https://deltiasgaming.com/?p=328482)
- Licensing risk: meme-based characters can trigger IP disputes (Tung Tung Tung Sahur, Sept-Nov 2025). [INDUSTRY] — [Wikipedia](https://en.wikipedia.org/wiki/Steal_a_Brainrot)

### Inferences
- Design for clip-ability: at least one moment per session that produces a strong visible reaction (rare hatch, theft, jumpscare, giant number) that a 15-30 s vertical clip can show.
- Marketing checklist: 3-5 honest thumbnails live; plain descriptive title using searchable genre words (semantic search exists); no "free Robux"-style claims; vertical clips posted several times per week from launch; outreach to Roblox YouTubers; fixed weekly event time announced in-game and on socials.

### Gaps
- No primary data found on Sponsored ad ROI, cost-per-play, or influencer-code (Creator Rewards/affiliate) effectiveness in 2025-26.
- No primary evidence on title wording effects (emoji/brackets like "[UPDATE]") on click-through.
