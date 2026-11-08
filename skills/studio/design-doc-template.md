# Design doc template

Fill this in for the game-designer's output, saved as the Findings of `.company/YYYY-MM-DD_HHMM_studio_design.md` (shared memo format from `~/.claude/company/memo-template.md`). Delete the guidance text in angle brackets. No code in a design doc.

The doc has two parts on purpose.
- **Part A, player-facing:** only what a player will see, read or be told. The `player-advocate` receives Part A and nothing else.
- **Part B, internals:** rules detail, formulas, edge cases and implementation notes. The `qa-tester` receives both parts.

Never put the intent statement or design reasoning in Part A.

---

```markdown
# Design: <system name>

## Intent (creative-director)
<One paragraph: what the player should feel, and what this system is for. No numbers.>

Target: <engine or loader and version, for example NeoForge, Fabric, Godot, Unity, KSP mod> · <single-player | multiplayer, server-authoritative | listen server> · <expected session length>

---

# Part A: Player-facing

## A1. Elevator description
<Two sentences, as it would appear on a store page or mod page.>

## A2. How to start
<What the player does first, in order. Where they find the system. What they need.>

## A3. Player actions
| Action | How the player does it | What they see and hear in response |
|---|---|---|
| | | |

## A4. Feedback and information
<Every number, bar, tooltip, message, sound and particle the player sees. Quote the exact text of messages and tooltips.>

## A5. Progression
<What the player unlocks and when; what a first hour, a first day and a first week look like for the player.>

## A6. What the player is told about failure
<Error messages, refusals, loss conditions, how to recover.>

---

# Part B: Internals

## B1. Rules
<Numbered. Each rule is one testable sentence: "When X happens and Y holds, Z.">

## B2. Entities and state
| Thing | State it holds | Who owns it (player, world, server) | Saved where |
|---|---|---|---|
| | | | |

## B3. Systems and flows
<How resources, items, currency, time or information move. List every source (where things enter), every sink (where they leave), and every conversion. Numbers are named parameters here; their values live in the balance sheet `.company/balance/<system>.csv`.>

| Flow | From | To | Rate parameter | Cap or limit |
|---|---|---|---|---|
| | | | | |

## B4. Edge cases
<One line each, with the intended behaviour. Cover at least: disconnect or crash mid-action, two players act at the same moment, empty and full states, negative or overflow values, the world unloading or the game saving mid-transaction, a player leaving, undo and cancel, creative or admin mode, cross-version saves.>

## B5. Multiplayer and abuse
<Who is authoritative, what the client may request, rate limits, permissions, what happens with alt accounts, griefing, or AFK farming. Write "Single-player" if it does not apply.>

## B6. Engine and loader notes
<Constraints known up front: tick rate and threading, registries and data packs, save format and migration, networking packets, API versions. Mark each as KNOWN or TO CHECK.>

## B7. Balance targets
<Intent turned into measurable targets for the systems designer, for example "a new player earns the first upgrade within 20 to 30 minutes of play", "no single strategy beats the others by more than 20 percent at day 30".>

## B8. Acceptance items
<Numbered, observable. The test phase turns each into a scenario with setup, steps and expected result.>

## B9. Out of scope
<What this design deliberately does not do.>

## B10. Open questions
<Each with the options and the designer's recommendation. These feed the creative director or the user.>

## Verdict (game-designer)
PASS | REVISE (to <role>, numbered reasons)
```
