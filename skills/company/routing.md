# Routing table

Match on what the request is **about**, not on single words. A pasted stack trace from a game mod is /studio if the user is designing, /war-room if a live server is down. Signals below are typical, not exhaustive.

| Signal in the request | Department |
|---|---|
| "down", "broken", "502", "outage", "not responding", "since this morning", error output from a **running** service, a deploy that just went wrong | `/war-room` |
| "can I build", "is it possible", "how fast / how strong / how cold", physics, high energy, novel hardware | `/skunkworks` |
| game, mod, mechanic, balance, economy, level, progression, Godot, Unity, NeoForge, Fabric, KSP | `/studio` |
| "what should I work on", "too many projects", priorities, "review everything", quarterly or monthly review | `/board-meeting` |
| "look into", "what exists", "prior art", "is this worth it", comparisons, an unfamiliar domain | `/research-desk` |
| uptime, disk, capacity, certs, "weekly check", "how's the homelab", renewals | `/ops-center` |
| build / add / implement a feature, fix a bug in code (not a live outage), refactor, "ship", "deploy this", an app or website end to end | `/team` |

## Tie-breaks
When a request fits two departments, route to the one that has to run **first** and record the other as a follow-up handoff.

1. **Something is broken in production → /war-room first.** Restore service before anything else. Example: "the server's in-game market is crashing it" → /war-room, follow-up /studio (why the design allowed it).
2. **Unknown whether it's worth doing → /research-desk before /skunkworks, /studio or /team.** Example: "is a coilgun worth building and what would it take" → /research-desk, follow-up /skunkworks.
3. **Unknown whether the physics works → /skunkworks before /team** (for anything with hardware).
4. **Game systems: design and balance (/studio) before code (/team).** A request that is purely "implement this already-designed mechanic" goes straight to /team.
5. **A bug in code vs an outage:** if users are affected right now, /war-room; otherwise `/team fix`.
6. **"Should I keep doing X" about one project → /board-meeting scoped to that project.**

## No match
If nothing fits, say so in one line and handle it as a normal request. A quick question, a one-line edit or a lookup never needs a department.
