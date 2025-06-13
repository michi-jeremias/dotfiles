# Determine the operating system
let os = sys host | get name

# List of packages to install via Scoop (Windows)
let scoop_packages = ["helix", "fnm", "yazi", "fd", "lazygit", "wget", "lua-language-server"]

# List of packages to install via Homebrew (Linux)
let brew_packages = ["helix", "zellij", "fnm", "fd", "fzf", "yazi", "lazygit"]

# Function to install packages with Scoop
def install_with_scoop [packages: list<string>] {
    scoop install ...$packages
}

# Function to install packages with Homebrew
def install_with_brew [packages: list<string>] {
    brew install ...$packages
}

# Check if the system is Windows
if $os == "Windows" {
    # Install packages using Scoop
    install_with_scoop $scoop_packages
} else {
    # Assuming Linux or other Unix-like systems where brew might be used
    install_with_brew $brew_packages
}
