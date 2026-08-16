# Multiplayer test matrix

Use a dedicated server with CBA_A3, TFAR, and TFAR Radio Settings Save & Restore
loaded on the client. Start with the addon's default settings.

For each case, configure clearly recognizable values for channel, frequency,
volume, stereo side, additional channel, and speakers.

| Case | Expected result |
| --- | --- |
| Open ACE Self Interaction | **Radios > Settings** contains TFAR Radio Settings Save & Restore controls |
| First use, before creating a profile | **Default (Active)** appears in `#F7F4AA` in the manager |
| Save active settings through ACE | **Save Settings > Confirm** updates the active profile |
| Show active settings through ACE | **Show Currently Active Profile Settings (profile name)** displays every saved supported radio for ten seconds |
| Restore active settings through ACE | **Restore Settings > Confirm** immediately restores matching carried radios |
| Inspect ACE **Radios > Settings** | No named-profile list or automatic-saving toggle appears there |
| Press **Create new** in the manager | A compact name layer appears over the still-visible manager, asks for a profile name, and saves the current radios |
| Try to create a profile using an existing name with different letter case | Creation is rejected with an explanatory message; the existing profile is unchanged |
| Select a profile and press **Rename** | The embedded name layer asks for the new name; settings and active status are retained |
| Select an inactive profile and press **Set active** | It gains **(Active)** and `#F7F4AA`; the old profile loses both |
| Double-click an inactive profile | It becomes active and restores exactly as if **Set active** were pressed |
| Adjust a radio after saving a profile | The named profile does not change until the player manually saves it |
| Hover a profile in the manager | A condensed tooltip shows one line per radio with main/additional channel, frequency, volume, stereo, speaker, and active-radio state |
| Press **Set active** | The profile immediately becomes active and is restored to matching carried radios without another confirmation |
| Join a mission with a saved active profile | No settings restore until the player manually confirms a restore |
| Save and restore a named setup | The selected named setup restores |
| Restart Arma before restoring a named setup | The setup remains available and restores |
| Save a setup while carrying several radios | Every supported carried radio is recorded |
| Manually restore while a saved radio is missing | Carried matching radios restore; the missing radio is reported and not queued |
| Receive another player's radio | Its settings remain unchanged until the receiving player deliberately restores a profile |
| Replace the loadout with a new radio of the same model | Its settings remain unchanged until the player manually restores again |
| Adjust a restored radio manually | The addon does not reapply and overwrite the player's adjustment |
| Die and respawn | TFAR Radio Settings Save & Restore performs no automatic radio save, comparison, or restoration |
| Change to a different handheld model | No unrelated preset is applied |
| Carry two handhelds of the same base type | Each radio matches by stable inventory order |
| Enter a vehicle with an LR radio | Vehicle radio remains unchanged |
| Disable **Persist channel frequencies** | Mission/server frequencies remain unchanged |
| Delete **Default** while another profile exists | **Default** is removed and the other profile remains available |
| Delete a named setup and reject confirmation | The setup remains |
| Delete a named setup and confirm | The setup is removed from future sessions |
| Try to delete the last remaining profile | Deletion is blocked and a message explains that another profile must be created first |

Capture the client RPT when a case fails. Include the TFAR version, loadout
script timing, and radio class names.
