# Nushell Environment Config File
#
# version = "0.86.0"

def create_left_prompt [] {
    let home =  $nu.home-path

    # Perform tilde substitution on dir
    # To determine if the prefix of the path matches the home dir, we split the current path into
    # segments, and compare those with the segments of the home dir. In cases where the current dir
    # is a parent of the home dir (e.g. `/home`, homedir is `/home/user`), this comparison will
    # also evaluate to true. Inside the condition, we attempt to str replace `$home` with `~`.
    # Inside the condition, either:
    # 1. The home prefix will be replaced
    # 2. The current dir is a parent of the home dir, so it will be uneffected by the str replace
    let dir = (
        if ($env.PWD | path split | zip ($home | path split) | all { $in.0 == $in.1 }) {
            ($env.PWD | str replace $home "~")
        } else {
            $env.PWD
        }
    )

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

def create_right_prompt [] {
    # create a right prompt in magenta with green separators and am/pm underlined
    let time_segment = ([
        (ansi reset)
        (ansi magenta)
        (date now | format date '%x %X %p') # try to respect user's locale
    ] | str join | str replace --regex --all "([/:])" $"(ansi green)${1}(ansi magenta)" |
        str replace --regex --all "([AP]M)" $"(ansi magenta_underline)${1}")

    let last_exit_code = if ($env.LAST_EXIT_CODE != 0) {([
        (ansi rb)
        ($env.LAST_EXIT_CODE)
    ] | str join)
    } else { "" }

    ([$last_exit_code, (char space), $time_segment] | str join)
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
# FIXME: This default is not implemented in rust code as of 2023-09-08.
$env.PROMPT_COMMAND_RIGHT = {|| create_right_prompt }

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
$env.NU_LIB_DIRS = [
    # FIXME: This default is not implemented in rust code as of 2023-09-06.
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
]

# Directories to search for plugin binaries when calling register
$env.NU_PLUGIN_DIRS = [
    # FIXME: This default is not implemented in rust code as of 2023-09-06.
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
if $env.OS != 'Windows_NT' {
    $env.PATH = ($env.PATH | split row (char esep) | prepend '/home/linuxbrew/.linuxbrew/bin')
    $env.PATH = ($env.PATH | split row (char esep) | prepend '/home/linuxbrew/.linuxbrew/sbin')
    $env.PATH = ($env.PATH | split row (char esep) | prepend '/usr/local/bin')
    $env.PATH = ($env.PATH | split row (char esep) | prepend '/home/michi/.cargo/bin')
    $env.HELIX_RUNTIME = '/home/michi/helix/runtime'
    $env.config.buffer_editor = '/home/linuxbrew/.linuxbrew/bin/hx'
}
# Windows
if $env.OS == 'Windows_NT' {
    $env.Path = ($env.Path | split row (char esep) | prepend $"C:/Program Files/LibreOffice/program")
    $env.EDITOR = 'C:\Users\micha\scoop\shims\hx.exe'
    $env.YAZI_FILE_ONE = 'C:\Users\micha\scoop\apps\git\current\usr\bin\file.exe'
}

$env.RUST_BACKTRACE = 'full'
# $env.EDITOR = C:\Users\micha\scoop\apps\nu\current\nu.exe
# $env.VISUAL
# -- yazi

mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

use ~/.cache/starship/init.nu

# -- Custom functions


# -- Alias
# -- Docker
alias l = ls -la
alias du = docker compose up -d
alias dub = docker compose up -d --build
alias dbu = docker compose up -d --build
alias dd = docker compose down
alias db = docker compose build

alias s = start .

# -- Git
def gc [name: string] {
    git commit -m $'"($name)"'
    }
def ga [] {
    git add -A
    }
def gp [] {
    git push
    }
def gs [] {
    git status
    }
def gd [] {
    git diff
}
def gac [name: string] {
    git add -A
    git commit -m $'"($name)"'
    }
def gacp [name: string] {
    git add -A
    git commit -m $'"($name)"'
    git push
    }
# alias gitconfig=/usr/bin/git --git-dir=/home/michi/.cfg/ --work-tree=/home/michi

def cwe [name: string] {
    cargo watch -q -c -x run -p --example $name
    }

def cwp [name: string] {
    cargo watch -q -c -x run -p $name
    }
    
def --env yy [...args] {
    let tmp = (mktemp -t "yazi-cwd.XXXXXX")
    yazi ...$args --cwd-file $tmp
        let cwd = (open $tmp)
            if $cwd != "" and $cwd != $env.PWD {
                cd $cwd
            }
            rm -fp $tmp
        }
def cc [...args] {
    let config_dir = $'($env.HOMEPATH) + "/.config-gitdir"'
    let work_tree = $env.HOMEPATH
    git ...$args $'--git-dir=($config_dir)--work-tree=($work_tree)'
    
}
# alias cc = git --git-dir=$"($env.HOMEPATH)/.config-gitdir" --work-tree=$env.HOMEPATH
# alias cc = git --git-dir=\Users\micha\.config-gitdir --work-tree=\Users\micha

# fzf for cd
def --env ff [] {
    # cd (fd . --full-path 'C:\Users\micha' -H -t d -E .git -E node_modules -E AppData -E '$*' -E Windows -d 5 | fzf --no-multi --height 60% --layout reverse --border)
    cd (fd . -H -t d -E .git -E node_modules -E AppData -E '$*' -E Windows -d 5 | fzf --no-multi --height 60% --layout reverse --border)
}
def --env ffs [] {
    start (fd . --full-path 'C:\Users\micha' -H -t d -E .git -E node_modules -E AppData -E '$*' -E Windows -d 3 | fzf --no-multi --height 60% --layout reverse --border)
}
def --env ffg [] {
    cd (fd . --full-path 'C:\' -H -t d -E .git -E node_modules -E AppData -E '$*' -E Windows -d 3 | fzf --no-multi --height 60% --layout reverse --border)
}
