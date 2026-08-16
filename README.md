# TFAR Persistence

TFAR Persistence remembers personal Task Force Arrowhead Radio settings across
missions and Arma sessions. Saving and restoration occur only when deliberately
requested by the player.

The first MVP supports:

- instanced short-range radios in the player's inventory;
- the player's long-range backpack radio;
- active channel, main/additional volume, stereo routing, additional channel, speakers, and
  channel frequencies;
- named, cross-session radio setups created through an in-game preset manager;
- deliberate, manual restoration to matching radios currently carried;
- manual active-profile save and restore actions through unbound CBA keybinds.

Vehicle radios are intentionally not included because their settings belong to
the vehicle and may be shared by multiple crew members.

## Requirements

- Arma 3
- CBA_A3
- ACE3
- Task Force Arrowhead Radio (TFAR)

## Installation

1. Download the latest release archive from GitHub.
2. Extract it into an `@TFAR-Persistence` folder in an Arma 3 mod directory.
3. Enable TFAR Persistence together with CBA_A3, ACE3, and TFAR.

TFAR Persistence stores profiles locally and performs its work on the player
client. A server does not need to execute its persistence logic, although
communities using signature verification should install the included public
key or distribute the addon through their normal modset.

## Build

Install [HEMTT](https://hemtt.dev/) and run:

```text
hemtt check
hemtt build
```

The built mod is written to `.hemttout/build`.

## In-game setup

Frequency persistence and notifications are per-player options under **Options
> Addon Options > TFAR Persistence**. These options are local and do not create
server traffic. Named-profile saving and restoration are always manual.

The primary controls are under **ACE Self Interaction > Radios > Settings**:

- **Show Currently Active Profile Settings (profile name)** displays the active
  profile for ten seconds.
- **Restore Settings > Confirm** immediately restores the active profile
  to matching radios currently carried.
- **Save Settings > Confirm** updates the active profile.
- **Manage Profiles** opens the interface used to create, activate and restore,
  inspect, rename, and delete profiles.

Every player starts with a profile named **Default**. Creating or restoring a
named profile makes that profile active, so all top-level save, show, and
restore behavior uses its name and settings. **Default** is not
permanent: it can be renamed or deleted once another profile exists. The
manager always retains at least one profile because saving and manual restore
need an active profile.

The active profile is labelled **(Active)** and shown in `#F7F4AA`. Hovering a
profile shows a condensed tooltip with one line per saved radio, including its
main and additional channel, frequency, volume, stereo, speaker, and active
radio state. **Set active** immediately makes the selection active and restores
it to matching carried radios; double-clicking a profile does the same thing.
**Create new** opens a compact name layer over the still-visible manager and
saves the current radio settings. Profile names are unique without regard to
letter case, and duplicate creation is rejected rather than overwriting saved
settings. **Rename** uses the same embedded layer without changing the
profile's settings. **Delete** works for any profile except the last remaining
one.

The confirmation steps and notification-based saved-settings display follow the
interaction pattern used by ACRE Persistence.

Equivalent unbound CBA keybinds remain available under
**Options > Controls > Configure Addons** as an accessibility fallback.

The named profiles are versioned and stored in the local player's
`profileNamespace`. A setup includes every supported handheld radio
currently carried plus the player's backpack radio. It contains radio base
classes and user-facing radio properties, never TFAR instance IDs, player
ownership IDs, or encryption codes.

Profile restoration occurs only after a deliberate player action. It affects
matching radios currently carried and then ends. Missing radios are reported
and left unchanged; no request remains pending for radios acquired later. This
prevents received, loaned, captured, or specially configured radios from being
silently changed.

## Current status

Version 0.1.1 is the manual-only public release. See
[docs/TESTING.md](docs/TESTING.md) for the multiplayer and regression test
matrix.

## License

[MIT](LICENSE)
