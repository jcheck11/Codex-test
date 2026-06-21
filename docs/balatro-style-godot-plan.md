# Balatro-Style Godot Game Plan

## Vision
Build a poker-inspired roguelike deckbuilder in Godot where players score escalating blinds by creating poker hands, modifying a deck, and combining build-defining passive modifiers. The project should use original art, names, UI, audio, and modifier concepts rather than copying any existing game's protected assets or presentation.

## Target Engine and Scope
- **Engine:** Godot 4.x.
- **Primary language:** GDScript for gameplay systems and UI; C# only if profiling shows a clear bottleneck.
- **Initial platform:** Desktop export for Windows, macOS, and Linux.
- **MVP run length:** 8 antes with small, big, and boss blinds per ante.
- **MVP deck:** Standard 52-card deck with rank, suit, and optional enhancements.

## Core Gameplay Loop
1. Start a run with a basic deck and empty modifier slots.
2. Enter a blind that defines a score target, hand count, and discard count.
3. Draw a hand of cards.
4. Player selects up to five cards to play or discard.
5. Played cards are evaluated as a poker hand and converted into chips and multiplier.
6. Passive modifiers, card enhancements, seals, editions, and boss effects adjust scoring.
7. Clearing a blind grants currency and opens a shop/reward phase.
8. Player buys, sells, upgrades, or skips rewards before choosing the next blind.
9. Run ends when the player fails a blind or clears the final ante.

## MVP Feature Set
### Cards and Deck
- Card resource with rank, suit, base chip value, enhancement, seal, edition, and unique runtime ID.
- Deck manager that supports draw pile, hand, discard pile, played pile, and temporary removed cards.
- Deterministic shuffle driven by a run seed.
- Selection rules for play and discard actions.

### Poker Hand Evaluation
- Detect high card, pair, two pair, three of a kind, straight, flush, full house, four of a kind, straight flush, and five-card variants if deck mutation enables them.
- Assign each hand type a level, chip value, and multiplier value.
- Support hand upgrades through consumables or shop rewards.

### Scoring Pipeline
Use an ordered scoring pipeline so modifiers remain debuggable:
1. Determine poker hand type.
2. Add hand-level base chips and multiplier.
3. Score each played card in display order.
4. Apply card enhancements and editions.
5. Apply passive modifier effects in slot order.
6. Apply boss blind effects.
7. Calculate final score and animate score events.

### Roguelike Progression
- Ante/blind generator with scaling score targets.
- Three blind types: small, big, and boss.
- Boss blinds that alter one rule for the round, such as disabling a suit or limiting hand size.
- Currency rewards based on blind type, remaining hands, and interest.

### Shop and Rewards
- Shop scene with purchasable passive modifiers, consumables, card packs, and vouchers.
- Reroll button with escalating cost.
- Sell passive modifiers for partial value.
- Skip blind rewards for risk/reward pacing.

### Passive Modifiers
Create original modifier archetypes inspired by deckbuilder synergies:
- Flat chip gain based on suit, rank, or hand type.
- Multiplier gain based on repeated actions.
- Multiplicative multiplier effects with strict rarity limits.
- Economy effects that alter currency gains or shop costs.
- Deck-shaping effects that add, remove, or transform cards.

## Godot Architecture
### Scene Layout
- `Main.tscn`: bootstraps global services and routes to menus/runs.
- `screens/MainMenu.tscn`: new run, continue, settings, credits.
- `run/RunController.tscn`: owns run state and transitions between blind and shop phases.
- `blind/BlindScene.tscn`: card hand UI, scoring UI, draw/discard/play controls.
- `shop/ShopScene.tscn`: shop inventory, rerolls, purchases, selling, rewards.
- `cards/CardView.tscn`: reusable card presentation and interaction node.
- `modifiers/ModifierSlot.tscn`: passive modifier display and tooltip.

### Autoloads
- `GameConfig`: static balancing constants and feature flags.
- `RunRng`: seeded random number generation helpers.
- `SaveService`: save/load run state and settings.
- `AudioBus`: sound and music routing helpers.

### Resource Types
- `CardDefinition`: immutable rank/suit metadata.
- `CardInstance`: runtime card state.
- `HandDefinition`: poker hand base chips, multiplier, and level.
- `ModifierDefinition`: passive metadata, rarity, price, and effect script reference.
- `BlindDefinition`: blind target, rewards, and rule modifier.
- `ShopPoolDefinition`: weighted shop inventory data.

### Signal Flow
- Card views emit selection and hover signals to `BlindController`.
- `BlindController` requests scoring from `ScoreService` and emits score events for animation.
- `RunController` listens for blind completion/failure and advances phase.
- Shop interactions emit purchase/sell events to `RunController`, which validates state changes.

## Data and Balancing
- Store balance data as Godot resources for editor-friendly iteration.
- Add optional JSON import/export for spreadsheet-driven balancing later.
- Keep every random reward weighted and seeded for reproducible bug reports.
- Maintain debug overlays for current seed, draw pile order, scoring breakdown, and active effects.

## Milestones
### Milestone 1: Playable Card Round
- Godot project scaffold.
- Basic deck creation, shuffle, draw, card selection, play, discard.
- Poker hand evaluator with unit tests.
- Simple scoring UI with no shop or modifiers.

### Milestone 2: Full Blind Loop
- Antes and blind selection.
- Blind targets, win/loss states, and reward currency.
- Score animation sequence and scoring breakdown panel.
- Run reset and seed entry.

### Milestone 3: Shop and Deckbuilding
- Shop scene and rerolls.
- Passive modifier inventory.
- Consumables for upgrading hands and transforming cards.
- Basic save/load for active run.

### Milestone 4: Content Pass
- 50+ original passive modifiers.
- 10+ boss blind rules.
- Card enhancements, editions, and seals.
- First-pass audio, visual effects, and accessibility settings.

### Milestone 5: Polish and Release Readiness
- Controller support.
- Settings, localization-ready text, and key remapping.
- Performance profiling on target desktop hardware.
- Export presets, itch/Steam packaging, and crash-report workflow.

## Testing Strategy
- Unit tests for hand evaluation, score pipeline ordering, deck mutations, and seeded randomness.
- Golden tests for known scoring scenarios.
- Integration tests for blind completion, shop purchases, and save/load round trips.
- Manual QA checklist for tooltips, animations, controller navigation, and accessibility options.

## Key Risks and Mitigations
- **Scoring complexity:** Keep modifiers composable through a single event-based score pipeline.
- **Balance drift:** Use seeded runs and scenario fixtures to compare balance changes.
- **UI overload:** Build the scoring breakdown early so players can understand why scores changed.
- **Legal/IP risk:** Use original names, art direction, sounds, modifier identities, and UX layout.
- **Save compatibility:** Version save data from the first implementation milestone.
