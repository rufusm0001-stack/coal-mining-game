# Roblox Game Monetization (2025-2026)

Research date: 2026-10-07. Every claim has a source. Older items are dated. Source quality is flagged where it is weak (fan sites or SEO aggregators).

## 1. Revenue streams, mechanics, payout rates, and DevEx

### Takeaway
A Roblox game earns mainly from Robux sales: passes (one-time), developer products (repeatable), subscriptions, and private servers. The creator gets 70% of the Robux, and DevEx turns earned Robux into USD at $0.0038 per Robux (since 5 Sep 2025). Since 8 Jun 2026, qualifying spend from age-checked US players aged 18+ in R15 games gets a rate 42% higher. Smaller streams sit on top: Roblox Plus bonuses (Plus replaced Premium in April 2026), Immersive Ads, Rewarded Video (only for games with 100K+ DAU), and managed or regional pricing, which raises yield.

### Cited Findings
**DevEx (cash-out)**
- The DevEx rate rose about 8.5%, from $0.0035 to $0.0038 per earned Robux, on 5 Sep 2025 (announced at RDC 2025). Robux earned before 5 Sep 2025 at 10am PT still cash out at $0.0035. — [Roblox DevEx calculator / summary](https://bloxodes.com/tools/roblox-devex-calculator); [AllThingsHow RDC 2025 roundup](https://allthings.how/roblox-rdc-2025-10-creator-tools-and-updates-that-matter/). Note: one DevForum thread disputes the "8.5%" headline math. — [DevForum](https://devforum.roblox.com/t/incorrect-devex-rate-percentage-update-85-claim-is-not-accurate-%F0%9F%A5%80%E2%98%A0%EF%B8%8F/3920224)
- The old minimum cash-out of 30,000 earned Robux paid $105 at $0.0035. The minimum is unchanged, so at $0.0038 the same 30,000 Robux pays about $114 (my arithmetic). — [bloxodes](https://bloxodes.com/tools/roblox-devex-calculator)
- **The 18+ boost:** In April 2026 Roblox announced a 42% DevEx rate increase for in-game spend by age-checked US players aged 18+ in eligible games, effective 8 Jun 2026. — [Roblox Newsroom, Apr 2026](https://about.roblox.com/newsroom/2026/04/roblox-fuels-high-fidelity-games-over-18-players-increases-qualifying-devex-rate-42)
  - Eligible games must use R15 avatars.
  - Eligible transactions: game passes, Robux subscriptions, "select in-game items", and private servers. — [Roblox Newsroom](https://about.roblox.com/newsroom/2026/04/roblox-fuels-high-fidelity-games-over-18-players-increases-qualifying-devex-rate-42)
  - The creator's effective share of qualifying spend rises from 26.6% to 37.8%. — [NetInfluencer](https://www.netinfluencer.com/roblox-to-raise-developer-exchange-rate-for-games-aimed-at-18-plus-players-as-adult-cohort-surges/). The official newsroom page I fetched did not state these two percentages or the new per-Robux rate.
- Roblox says its 18-34 US cohort "monetizes over 50% higher than our under 18 users" and is growing over 50% YoY. Creators earned over $1.5B through DevEx in 2025. — [Roblox Newsroom](https://about.roblox.com/newsroom/2026/04/roblox-fuels-high-fidelity-games-over-18-players-increases-qualifying-devex-rate-42)
- In Q2 2026 Roblox said: "In June, we rolled out a targeted DevEx rate increase to incentivize novel game creation." DevEx fees in Q2 2026 were $363M, up 15% YoY. — [Roblox Q2 2026 8-K](https://www.sec.gov/Archives/edgar/data/0001315098/000162828026051059/ex991-robloxq22026earnin.htm)

**Passes (game passes)**
- A pass is a one-time Robux purchase for a permanent privilege.
- A "listed" pass can be sold outside the game: on the homepage, in search, and on post-purchase pages. No ProcessReceipt fix is needed for passes.
- Promoted passes shown on the Buy Robux page must cost more than 49 and less than 801 Robux, and cannot grant paid random items. — [Roblox Docs: Passes](https://create.roblox.com/docs/production/monetization/passes)
- The creator nets 70% of a pass sale (Roblox takes 30%). Example: a pass priced at 400 Robux nets 280 Robux. — [RoWatcher](https://rowatcher.com/news/devex-math-in-2026-what-you-actually-take-home-per-1-000-players). Weak source: the same article still quotes the old $0.0035 DevEx rate.

**Developer products**
- Repeatable purchases (currency, ammo, potions). Price range is 1 to 1,000,000,000 Robux.
- They can be sold outside the game in the Shop tab if marked "Listed", but only when ProcessReceipt is correctly implemented. Roblox monitors this and removes non-compliant products from outside sale.
- Related APIs: `RankProductsAsync` (personalized ordering) and `RecommendTopProductsAsync` (needs at least 1 sale in the last 28 days). — [Roblox Docs: Developer Products](https://create.roblox.com/docs/production/monetization/developer-products)

**Subscriptions (in-game, recurring)**
- **Local-currency subscriptions:** fixed tiers of $2.99, $4.99, $7.99, $9.99, or $14.99.
  - Payout: 70% in the first month, then 100% in later months, credited as Robux at US $0.01 = 1 Robux, after a 30-day hold.
  - Requires ID or phone verification. Unavailable in 12+ countries, including Argentina, China, India, Japan, Russia, and Vietnam.
- **Robux subscriptions:** minimum 49 Robux, custom price, open to all creators. Payout is 70% every month after about a 5-day hold. Regional pricing is on by default.
- **Rules:** max 50 subscriptions per game; all are single-tier (a player can own several at once); Robux prices can change at most once every 60 days; benefits cannot be gated behind extra tasks.
- APIs: `GetUserSubscriptionStatusAsync`, `PromptSubscriptionPurchase`, `GetUserSubscriptionPaymentHistoryAsync`. — [Roblox Docs: Subscriptions](https://create.roblox.com/docs/production/monetization/subscriptions)

**Roblox Plus (replaced Premium; affects Premium Payouts)**
- Roblox Plus launched 30 Apr 2026 at $4.99/month. It replaced the three-tier Premium plan ($4.99, $9.99, $19.99). — [Tubefilter, 13 Apr 2026](https://tubefilter.com/2026/04/13/roblox-plus-creator-payouts)
- Plus members get 10% off eligible purchases in their first two months and 20% off from month three. "Roblox covers this discount for you", so creators earn the same per sale. — [Roblox Docs: Roblox Plus](https://create.roblox.com/docs/production/monetization/roblox-plus)
- Ways creators earn from Plus:
  - Up to 750 Robux per new subscriber acquired through the in-game Plus prompt (250 Robux per month for 3 months). Earning starts once the subscription is paid, not during free trials, and has a 60-day hold.
  - Up to 100 Robux per Plus member who spends 60+ minutes a month in the creator's paid private servers.
  - 10% of in-game Robux transfers made by subscribers, eligible for DevEx. — [Roblox Docs: Roblox Plus](https://create.roblox.com/docs/production/monetization/roblox-plus)
- The current monetization docs index lists Roblox Plus and no longer lists "Premium Payouts / engagement-based payouts" as a separate method. — [Roblox Docs: Monetization](https://create.roblox.com/docs/production/monetization)

**Private servers, paid access, and other streams**
- Paid private servers are a subscription-based feature and are regionally priced automatically. — [Roblox Docs: Monetization](https://create.roblox.com/docs/production/monetization); [Roblox Docs: Managed Pricing](https://create.roblox.com/docs/production/monetization/managed-pricing)
- Paid access: a one-time fee to enter the game, payable in Robux or local currency. Other streams: catalog items and accessories (UGC, commission-based), and Creator Store plugins (minimum $4.99) and models (minimum $2.99) with a 30-day escrow. — [Roblox Docs: Monetization](https://create.roblox.com/docs/production/monetization)

**Immersive Ads**
- Formats:
  - Video ads up to 30 seconds, click-to-play or autoplay.
  - Static image ads.
  - Portal ads that teleport players to the advertiser's game.
- Payment basis: click-to-play video per 15-second view; autoplay video per impression of 0.5+ seconds; image per impression of 1+ second; portal per teleport. Payouts arrive on the 25th of the following month.
- Publisher requirements: public game, owner aged 13+, ID verification and 2FA, an approved Maturity and Compliance Questionnaire, and 2,000 unique visitors per month.
- Ad units must be 8×4.5 to 32×18 studs. Artificially incentivizing ad engagement is banned, and fraud leads to Robux deductions or suspension. — [Roblox Docs: Immersive Ads](https://create.roblox.com/docs/production/monetization/immersive-ads)

**Rewarded Video Ads (Google partnership)**
- Self-serve for games averaging 100K+ DAU over the past 28 days, with minimal or mild content maturity, in good standing, from a verified creator. — [DevForum: More Creators Can Now Use Rewarded Video Ads](https://devforum.roblox.com/t/more-creators-can-now-use-rewarded-video-ads/3838678); [ppc.land](https://ppc.land/roblox-expands-google-advertising-partnership-with-rewarded-video-launch/)
- Nearly 100 publishers had onboarded at RDC 2025. — [AllThingsHow](https://allthings.how/roblox-rdc-2025-10-creator-tools-and-updates-that-matter/)
- Roblox guided that Rewarded Video would be "up to 3% of earnings" early on, with a long-term goal of 5-10% revenue uplift for most creators from Roblox Ads products. A Studio drag-and-drop plugin is expected in Q4 2026. — [rolearn.dev](https://rolearn.dev/insights/rewarded-video-ads-new-revenue-stream). Weak source: an aggregator. Its claim that "creators say Roblox keeps 70% of ad revenue" is unverified.

**Managed pricing (regional pricing plus price optimization)**
- One opt-in system in Creator Hub. Passes and developer products are eligible for both parts. Subscriptions, private servers, and developer servers are regionalized automatically, and subscriptions are excluded from price tests.
- Regional prices are "bound between 30% and 100% of the default price". New games and items are enrolled by default, and any item can be opted out. — [Roblox Docs: Managed Pricing](https://create.roblox.com/docs/production/monetization/managed-pricing)
- Regional pricing for in-game items was introduced in April 2025. — [Tubefilter, 22 Apr 2025](https://www.tubefilter.com/2025/04/22/roblox-regional-pricing-in-experience-items/)
- Price optimization results (RDC 2025): about 4% higher median earnings for participating creators, up to 15% for some games, and 35% of the top 100 games by spend were using it. — [AllThingsHow RDC 2025](https://allthings.how/roblox-rdc-2025-10-creator-tools-and-updates-that-matter/)

### Inferences
- The 26.6% and 37.8% shares match 70% × DevEx rate ÷ $0.01 per Robux: 0.7 × 0.0038 / 0.01 = 26.6%. So the boosted rate is about $0.0054 per Robux (0.0038 × 1.42 ≈ 0.0054, and 0.7 × 0.0054 / 0.01 ≈ 37.8%). This is my derivation, not an official figure.
- For a new small game, the core streams are passes, developer products, and Robux subscriptions, with managed pricing left on. Ads are minor until the game is large: Rewarded Video needs 100K DAU, and Immersive Ads pay per impression.
- Building with R15 avatars and making content that appeals to 18+ players gives roughly 42% more cash per qualifying US adult purchase.

### Gaps
- I found no official confirmation of whether Premium engagement-based payouts ("Premium Payouts") ended outright when Plus launched, or of any transition date. The docs index no longer lists them, and Tubefilter frames Plus as the replacement.
- I could not find official per-impression rates for Immersive Ads or Rewarded Video (CPMs), or an official revenue split for ads.
- I found no 2026 data on Commerce / real-world items (Shopify-style physical goods) eligibility or payouts.
- I did not re-verify DevEx eligibility rules this session (age 13+, verified email, ID, account standing, minimum balance). Check the official DevEx Terms page.

## 2. Pricing strategies and shop structure

### Takeaway
I found little hard 2025-2026 data on conversion by price point. The verifiable pattern from the biggest simulators is a few cheap permanent multiplier passes (VIP, 2x currency), plus repeatable consumables, luck items, and starter packs sold as developer products. Roblox's own tools (price optimization, ranked and recommended products) should set the final numbers.

### Cited Findings
- **Steal a Brainrot** (2025, SpyderSammy) is the only Roblox game to pass 25M concurrent users. Grow a Garden was the first past 20M. — [Wikipedia](https://en.wikipedia.org/wiki/Steal_a_Brainrot)
- Steal a Brainrot sells two core passes:
  - VIP at 499 Robux: permanent +50% earnings, a chat tag, and +10 seconds lock time.
  - 2x Money at 119 Robux: doubles income and stacks with VIP for 3x.
  - Its shop also sells gear from 199 to 1,999 Robux, cash packs, lucky blocks, and starter packs. — [Buffget](https://buffget.com/news/steal-a-brainrot-gamepasses-guide-vip-and-2x-money-2026); [Deltia's Gaming](https://deltiasgaming.com/roblox-steal-a-brainrot-all-gear-and-game-passes). Weak sources: fan or guide sites, so prices may have changed.
- Roblox's own reasons for low conversion: items too expensive, poor item or shop visibility, and unappealing content. — [Roblox Docs: Monetization analytics](https://create.roblox.com/docs/production/analytics/monetization)
- Personalization tools: `RankProductsAsync` orders products per player, and `RecommendTopProductsAsync` returns top picks. — [Roblox Docs: Developer Products](https://create.roblox.com/docs/production/monetization/developer-products)
- Promoted passes on the Buy Robux page must be priced 50-800 Robux, which sets a natural ceiling for flagship passes. — [Roblox Docs: Passes](https://create.roblox.com/docs/production/monetization/passes)
- Price optimization tests price points automatically, using demand, conversion, spend, and spender penetration by country. — [Roblox Docs: Managed Pricing](https://create.roblox.com/docs/production/monetization/managed-pricing)

### Inferences
- A sensible launch shop for a simulator or incremental game:
  - A cheap 2x-currency pass (around 100-200 Robux) as the first purchase.
  - A VIP pass (around 400-500 Robux) that stacks with it.
  - Repeatable boosts and luck items as developer products, each with odds disclosed (see section 3).
  - A one-time starter pack offered early in the session.
- Leave managed pricing on so Roblox's A/B tests tune the exact numbers.
- Luck boosts and gacha-style eggs or crates count as paid random items. They carry disclosure duties and need region-restricted alternatives.

### Gaps
- I found no authoritative 2025-2026 data (Naavik, Bloxbiz, Roblox) on the best price points, starter-pack conversion, or limited-time-offer uplift on Roblox. My search for Naavik analysis of Grow a Garden and Steal a Brainrot returned nothing usable.
- I found no sourced breakdown of how top games split revenue between passes and products.

## 3. Policy constraints: loot boxes, age, ads, spending, refunds

### Takeaway
Paid random items need full odds disclosure before purchase, shown as percentages that sum to 100%. Luck boosts and pity systems are covered too. Games must use PolicyService to give compliant alternatives where paid random items are restricted. Under-13 users have been shielded from standard ads. Since June 2026, contextual ads for under-13s are allowed only through SuperAwesome. Rewarded Video needs minimal or mild maturity, and ads need an approved maturity questionnaire.

### Cited Findings
**Paid random items (loot boxes)**
- What counts: prize wheels, eggs, chests, random-effect potions, combination items, probability modifiers (luck boosts, pity, rate-up), and indirect purchases (keys, re-roll tokens, spin tickets) bought with Robux or with currency that can be bought with Robux. — [Roblox Docs: Paid random items](https://create.roblox.com/docs/production/monetization/paid-random-items)
- The rule: games must "indicate all possible outcomes and the actual numerical odds" before purchase. — [Roblox Docs: Paid random items](https://create.roblox.com/docs/production/monetization/paid-random-items)
- Display format:
  - Odds are shown as percentages that sum to exactly 100%.
  - Long decimals are rounded to four or more places below the first non-zero digit, with a disclaimer if rounding was applied.
  - Odds can sit in a pop-up labelled "Details" or "Info"; an (i) icon alone is not enough.
  - When a luck modifier is active, the displayed odds must update to match. — [Roblox Docs: Paid random items](https://create.roblox.com/docs/production/monetization/paid-random-items)
- Restricted players and regions:
  - `PolicyService` returns `ArePaidRandomItemsRestricted`. For restricted players the game must use an alternative: an earnable free version, a fixed non-random sequence, a direct purchase at expected-value price, hiding the feature, or blocking it with a message.
  - When `IsPaidItemTradingAllowed` is false, those players cannot trade outcomes. Free random rewards need no disclosure. — [Roblox Docs: Paid random items](https://create.roblox.com/docs/production/monetization/paid-random-items)

**Ads and age**
- Roblox's Advertising Standards prohibited showing ads to under-13s, and required ads for users 13+ to be clearly disclosed. — [Adweek](https://www.adweek.com/media/roblox-will-ban-all-advertising-aimed-at-children-under-13-with-new-standards/) (2024-era standards)
- On 4 Jun 2026 Roblox named SuperAwesome its sole partner for COPPA-compliant contextual advertising to under-13 users worldwide, which partly changes the earlier blanket rule. — [PocketGamer.biz](https://www.pocketgamer.biz/superawesome-partners-with-roblox-as-under-13-advertising-partner/); [godisageek, Jun 2026](https://godisageek.com/2026/06/roblox-superawesome-under-13-ad-partner/)
- Immersive Ads show only to eligible users; ineligible users see a Roblox logo instead. Publishers should use `GetPolicyInfoForPlayerAsync()`, and the Maturity and Compliance Questionnaire must be approved. — [Roblox Docs: Immersive Ads](https://create.roblox.com/docs/production/monetization/immersive-ads)
- Rewarded Video needs a minimal or mild maturity label. — [ppc.land](https://ppc.land/roblox-expands-google-advertising-partnership-with-rewarded-video-launch/)
- Age checks: by the end of Q2 2026, 57% of global DAUs had age-checked, and over 70% in the US and Australia. The 18+ DevEx boost applies only to age-checked US adults. — [Roblox Q2 2026 8-K](https://www.sec.gov/Archives/edgar/data/0001315098/000162828026051059/ex991-robloxq22026earnin.htm); [Roblox Newsroom](https://about.roblox.com/newsroom/2026/04/roblox-fuels-high-fidelity-games-over-18-players-increases-qualifying-devex-rate-42)

**Subscription and pass rules**
- Subscriptions cannot gate benefits behind extra tasks, and cannot direct users to buy elsewhere in the game. — [Roblox Docs: Subscriptions](https://create.roblox.com/docs/production/monetization/subscriptions)
- Promoted passes cannot grant paid random items. — [Roblox Docs: Passes](https://create.roblox.com/docs/production/monetization/passes)

### Inferences
- Build odds UI and PolicyService checks into every egg, crate, or luck item from day one. Retrofitting is costly, and loot-box rules vary by country.
- Making the game minimal or mild maturity keeps Rewarded Video eligibility open.

### Gaps
- **Refund rules:** search returned only SEO spam pages, so I have no reliable source. Check Roblox's Terms of Use and Help Center directly.
- I did not get primary-source detail on parental spending controls or spending limits, or the full content-maturity-label taxonomy and its effect on monetization. Check the Roblox Help Center and the Experience Guidelines docs.

## 4. Benchmarks: ARPDAU, conversion, payer share

### Takeaway
Platform level, Q2 2026: 123M DAU, $1.557B bookings, $12.66 quarterly bookings per DAU, 27M monthly unique payers (about 22% of DAU), and $19.25 per payer per month. Per-game benchmarks are weakly sourced: about 1.25% daily payer conversion, and ARPDAU of $0.003-0.025 in creator take-home terms. Use Roblox's in-dashboard benchmark scorecards, available at 100+ DAU, for real comparisons.

### Cited Findings
- **Q2 2026 headline numbers:**
  - Revenue $1,469M (+36% YoY); bookings $1,557M (+8% YoY).
  - DAU 123M (+10%); hours engaged 29B (+5%).
  - Monthly unique payers 27M (+15%); DevEx fees $363M (+15%). — [Roblox Q2 2026 8-K](https://www.sec.gov/Archives/edgar/data/0001315098/000162828026051059/ex991-robloxq22026earnin.htm)
- **Q2 2026 per-user numbers:**
  - ABPDAU was $12.66, down 2% YoY. — [Roblox Q2 2026 Supplemental](https://s27.q4cdn.com/984876518/files/doc_financials/2026/q2/Roblox-Q2-2026-Supplemental-Materials.pdf) (figure from the search excerpt)
  - Average bookings per monthly unique payer were $19.25. — [Outlook Respawn](https://respawn.outlookindia.com/gaming/gaming-news/roblox-q2-2026-revenue-soars-36-to-15b-despite-bookings-miss)
- **Q3 2026 guidance:** bookings of $1,576M-$1,653M, a 14-18% YoY decline. The bookings miss was blamed on "a decline in per hour monetization most notably with younger cohorts in the U.S. and Canada". — [Roblox Q2 2026 8-K](https://www.sec.gov/Archives/edgar/data/0001315098/000162828026051059/ex991-robloxq22026earnin.htm)
- **Payer conversion and daily spend:** about 1.25% DAU-to-purchase conversion, and DBPU (daily bookings per user) of $0.14. — [Newzoo via GameDev Reports](https://gamedevreports.substack.com/p/newzoo-roblox-as-a-platform-in-2025) (2025 data; seen in a search excerpt only, not verified in full)
- **ARPDAU (creator take-home):** $0.003-0.006 for conservative monetization and $0.015-0.025 for well-monetized games. With about 4,000 DAU (≈1,000 CCU), that is $360-720 or $1,800-3,000 a month pre-tax. — [RoWatcher](https://rowatcher.com/news/devex-math-in-2026-what-you-actually-take-home-per-1-000-players). Weak source: it uses the outdated $0.0035 rate.
- **Dashboard benchmarks:** the Creator Dashboard shows conversion, ARPPU, and ARPDAU, plus benchmark scorecards against similar games once a game has 100+ DAU. — [Roblox Docs: Monetization analytics](https://create.roblox.com/docs/production/analytics/monetization)
- **Anecdote:** a battle royale game that grew from 50-150 to about 1,000 CCU (Aug 2025) saw payer conversion and ARPDAU fall. Replies blamed the influx of new players. — [DevForum](https://devforum.roblox.com/t/payer-conversion-rate-and-arpdau-decreasing-as-game-gains-more-popularity/3898921)

### Inferences
- 27M monthly payers ÷ 123M DAU ≈ 22% at platform level per month. Daily conversion in a single game is far lower, around 1-2%.
- Expect conversion to fall when traffic spikes. Judge pricing on cohorts, not raw averages.

### Gaps
- I found no reliable source for each stream's share of game revenue (passes vs products vs Premium/Plus vs ads), or for genre-level ARPDAU.
- I did not capture regional ABPDAU (US and Canada, Europe, APAC) from the supplemental PDF.

## 5. Implementation: ProcessReceipt, passes, Studio testing

### Takeaway
Set `MarketplaceService.ProcessReceipt` once, from a single server script. The handler should:
- check the `PurchaseId` against a DataStore purchase history (using `UpdateAsync`) to make grants idempotent;
- return `NotProcessedYet` (or nil) if the player is gone or saving failed;
- return `PurchaseGranted` only after the grant is saved.

For passes, check `UserOwnsGamePassAsync` before calling `PromptGamePassPurchase`, and grant on the server.

### Cited Findings
- "Set the callback; this can only be done once by one script on the server." — [Roblox Engine API: MarketplaceService](https://create.roblox.com/docs/reference/engine/classes/MarketplaceService)
- **Idempotency:** the official sample records each `PurchaseId` with `UpdateAsync`. When an id is already recorded, it treats the purchase as previously handled: "This purchase was already recorded as granted, so it must have previously been handled." — [MarketplaceService](https://create.roblox.com/docs/reference/engine/classes/MarketplaceService)
- **Player absent:** "Avoids granting the purchase if the player is not in the server. When they rejoin, this receipt processor will be called again." — [MarketplaceService](https://create.roblox.com/docs/reference/engine/classes/MarketplaceService)
- **Receipt fields:** `PurchaseId`, `PlayerId`, `ProductId`, `CurrencySpent`, `PlaceIdWherePurchased`. — [MarketplaceService](https://create.roblox.com/docs/reference/engine/classes/MarketplaceService)
- **Return values:** `PurchaseGranted` ends retries. `NotProcessedYet` retries "next time the user joins the game".
- **Other ProcessReceipt rules:**
  - Never use `PromptProductPurchaseFinished` to grant purchases.
  - Validate the user, the product, and that status is "Open".
  - A correct ProcessReceipt is required before products can be sold outside the game. — [Roblox Docs: Developer Products](https://create.roblox.com/docs/production/monetization/developer-products)
- **Passes:**
  - Check `UserOwnsGamePassAsync` before `PromptGamePassPurchase`.
  - Handle `PromptGamePassPurchaseFinished` in ServerScriptService to grant privileges.
  - Listed passes bought outside the game are granted on join. — [Roblox Docs: Passes](https://create.roblox.com/docs/production/monetization/passes)
- **Subscriptions:** check status with `GetUserSubscriptionStatusAsync`. — [Roblox Docs: Subscriptions](https://create.roblox.com/docs/production/monetization/subscriptions)

### Inferences
- Recommended pattern:
  1. Look up the product handler by `ProductId`.
  2. Get the Player from `PlayerId`; if absent, return `NotProcessedYet`.
  3. Use `UpdateAsync` on a purchase-history key such as `PlayerId_PurchaseId`. If the id is already recorded, return `PurchaseGranted` without granting again.
  4. Apply the grant to the player's session-locked profile and save it.
  5. Return `PurchaseGranted` only after the save succeeds. On any error, return `NotProcessedYet`.
- Cache pass ownership at join, and update it from `PromptGamePassPurchaseFinished`.

### Gaps
- The docs I fetched did not cover Studio test purchases. My understanding (not verified this session) is that purchases in Studio play-test are simulated and don't charge Robux. Check the current docs before relying on this.
- The fetched docs did not specify a DataStore session-locking approach beyond `UpdateAsync` keyed by `PurchaseId`.
