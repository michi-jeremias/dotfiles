rm ~\AppData\Roaming\helix\config.toml
rm ~\AppData\Roaming\helix\languages.toml
mklink ~\AppData\Roaming\helix\config.toml ~\.config\helix\config.toml
mklink ~\AppData\Roaming\helix\languages.toml ~\.config\helix\languages.toml
rm ~\AppData\Roaming\nushell\env.nu
rm ~\AppData\Roaming\nushell\config.nu
mklink ~\AppData\Roaming\nushell\env.nu ~\.config\nushell\env.nu
mklink ~\AppData\Roaming\nushell\config.nu ~\.config\nushell\config.nu
rm ~\applications.json
rm ~\komorebi.bar.json
rm ~\komorebi.json
mklink ~\applications.json ~\.config\komorebi\applications.json
mklink ~\komorebi.bar.json ~\.config\komorebi\komorebi.bar.json
mklink ~\komorebi.json ~\.config\komorebi\komorebi.json
