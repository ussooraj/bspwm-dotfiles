#!/bin/sh
#     ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ 
#     ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
#     ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
#     ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
#     ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
#     ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝
#
#     Z0mbi3 BSPWM Theme Installer
#     Repository: https://github.com/ussooraj/bspwm-dotfiles
#     Based on: https://github.com/gh0stzk/dotfiles

# Colors
CRE=$(tput setaf 1)
CYE=$(tput setaf 3)
CGR=$(tput setaf 2)
CBL=$(tput setaf 4)
BLD=$(tput bold)
CNC=$(tput sgr0)

# Get the absolute path to the script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

logo() {
    text="$1"
    printf "%b" "
                             
    ▄▄▄▄      ██▀▀██  ▒██   ██▒  
    ▒████▄   ░██  ▒█▒ ░ ██ ██░░  
    ▒██  ▀█▄ ░██  █▀░░░   █   ░  
    ▒██▄▄▄▄██░██▀▀█▄   ░ █ █ ░   
    ░██   ▓██░██  ▒██░░██▒ ▒██▒  
    ░▒▓   ░▓█░▓█░ ░▒█░▓█ ░ ░░█▓  
    ░░   ░░▓  ▓▒ ░ ▓░░░   ░░ ░  
    ░   ░     ░   ░  ░    ░    
        ░     ░      ░    ░    
                             
   ${BLD}${CRE}[ ${CYE}${text} ${CRE}]${CNC}\n\n"
}

initial_checks() {
    if [ "$(id -u)" = 0 ]; then
        printf "%b\n" "${BLD}${CRE}This script MUST NOT be run as root user.${CNC}"
        exit 1
    fi

    if [ ! -f "$SCRIPT_DIR/install.sh" ]; then
        printf "%b\n" "${BLD}${CRE}Error: Could not determine script directory.${CNC}"
        exit 1
    fi

    if [ ! -d "$SCRIPT_DIR/config" ] || [ ! -d "$SCRIPT_DIR/assets" ]; then
        printf "%b\n" "${BLD}${CRE}Error: Required directories not found.${CNC}"
        printf "%b\n" "${BLD}${CYE}Make sure you're running this from the repository root.${CNC}"
        exit 1
    fi

    # Check if z0mbi3 rice exists
    if [ ! -d "$SCRIPT_DIR/config/bspwm/rices/z0mbi3" ]; then
        printf "%b\n" "${BLD}${CRE}Error: z0mbi3 rice not found in repository!${CNC}"
        exit 1
    fi
}

welcome() {
    clear
    logo "Z0mbi3 Theme Installer"

    printf "%b" "${BLD}${CGR}This script will install the z0mbi3 BSPWM theme:${CNC}

  ${BLD}${CGR}[${CYE}✓${CGR}]${CNC} Install core dependencies (pacman)
  ${BLD}${CGR}[${CYE}✓${CGR}]${CNC} Install AUR dependencies (EWW from AUR)
  ${BLD}${CGR}[${CYE}✓${CGR}]${CNC} Install fonts via pacman
  ${BLD}${CGR}[${CYE}✓${CGR}]${CNC} Install themes, icons & cursors (system-wide)
  ${BLD}${CGR}[${CYE}✓${CGR}]${CNC} Backup existing configurations
  ${BLD}${CGR}[${CYE}✓${CGR}]${CNC} Install dotfiles from this repository
  ${BLD}${CGR}[${CYE}✓${CGR}]${CNC} Configure services (MPD)
  ${BLD}${CGR}[${CYE}✓${CGR}]${CNC} Change shell to zsh

${BLD}${CYE}What makes this different:${CNC}
  • ${BLD}NO${CNC} Chaotic-AUR repository needed
  • ${BLD}NO${CNC} external repos added to pacman.conf
  • EWW installed from AUR (not polybar)
  • Only z0mbi3 theme (single, focused setup)
  • All assets bundled in this repository

${BLD}${CRE}[!]${CNC} ${BLD}${CRE}Backup your files before proceeding!${CNC}

"

    while :; do
        printf " %b" "${BLD}${CGR}Do you wish to continue?${CNC} [y/N]: "
        read -r yn
        case "$yn" in
            [Yy]) break ;;
            [Nn]|"") printf "\n%b\n" "${BLD}${CYE}Operation cancelled${CNC}"; exit 0 ;;
            *) printf "\n%b\n" "${BLD}${CRE}Error:${CNC} Just write '${BLD}${CYE}y${CNC}' or '${BLD}${CYE}n${CNC}'" ;;
        esac
    done
}

install_core_dependencies() {
    clear
    logo "Installing core dependencies"
    sleep 2

    printf "%b\n" "${BLD}${CYE}Updating package database...${CNC}"
    sudo pacman -Syy

    printf "\n%b\n\n" "${BLD}${CYE}Installing core packages (this may take a while)...${CNC}"
    
    # Core packages needed for z0mbi3 theme
    core_deps="bspwm sxhkd picom dunst rofi xorg-server xorg-xsetroot xorg-xrandr xorg-xprop xorg-xkill xorg-xdpyinfo xorg-xwininfo xorg-xrdb xdo xdotool xdg-user-dirs lxsession xsettingsd base-devel git alacritty kitty feh maim xclip xcolor jq brightnessctl redshift bat eza fzf clipcat thunar tumbler gvfs-mtp yazi mpd mpc ncmpcpp playerctl pamixer pacman-contrib imagemagick libwebp webp-pixbuf-loader neovim geany npm rustup python-gobject firefox blueman network-manager-applet ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-inconsolata ttf-terminus-nerd ttf-ubuntu-mono-nerd zsh zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting"

    failed_deps=""

    # Install all packages at once with visible output
    printf "%b\n" "${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}"
    if ! sudo pacman -S --noconfirm --needed $core_deps; then
        printf "\n%b\n" "${BLD}${CRE}Some packages failed during installation.${CNC}"
        printf "%b\n" "${BLD}${CYE}Checking which packages failed...${CNC}\n"
        
        # Check each package individually to find failures
        for pkg in $core_deps; do
            if ! pacman -Q "$pkg" >/dev/null 2>&1; then
                failed_deps="$failed_deps $pkg"
            fi
        done
        
        if [ -n "$failed_deps" ]; then
            printf "%b\n" "${BLD}${CRE}Failed packages:${CYE}${failed_deps}${CNC}"
            printf "%b\n" "${BLD}${CYE}Retrying failed packages individually...${CNC}\n"
            
            retry_failed=""
            for pkg in $failed_deps; do
                printf "%b\n" "${BLD}${CBL}→ Retrying: ${CNC}$pkg"
                if ! sudo pacman -S --noconfirm --needed "$pkg"; then
                    retry_failed="$retry_failed $pkg"
                fi
            done
            
            if [ -n "$retry_failed" ]; then
                printf "\n%b\n" "${BLD}${CRE}Could not install:${CYE}${retry_failed}${CNC}"
                printf "%b\n" "${BLD}${CBL}missing_apps.txt ${CYE}created in HOME${CNC}"
                printf "# Failed packages from pacman\nInstall these manually with: sudo pacman -S <package>\n\n%s\n" "$retry_failed" > "$HOME/missing_apps.txt"
            fi
        fi
    fi
    
    printf "%b\n" "${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}"
    printf "\n%b\n" "${BLD}${CGR}Core dependencies installation completed!${CNC}"
    sleep 2
}

install_aur_dependencies() {
    clear
    logo "Installing AUR dependencies (including EWW)"
    sleep 2

    # Install paru if not present
    if ! command -v paru >/dev/null 2>&1; then
        printf "%b\n\n" "${BLD}${CYE}Installing PARU AUR helper...${CNC}"
        printf "%b\n" "${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}"
        cd "$HOME" || exit
        git clone https://aur.archlinux.org/paru-bin.git
        cd paru-bin || exit
        makepkg -si --noconfirm
        cd "$HOME" || exit
        rm -rf paru-bin
        printf "%b\n" "${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}"
        printf "\n%b\n" "${BLD}${CGR}✓ Paru installed successfully${CNC}"
    else
        printf "%b\n" "${BLD}${CGR}✓ Paru already installed${CNC}"
    fi

    # EWW is CRITICAL for z0mbi3 theme + other AUR packages
    aur_deps="eww xwinwrap-0.9-bin i3lock-color simple-mtpfs fzf-tab-git ttf-material-design-icons-desktop-git"

    printf "\n%b\n" "${BLD}${CYE}Installing AUR packages...${CNC}"
    printf "%b\n\n" "${BLD}${CRE}⚠ This will take some time as packages are built from source!${CNC}"
    
    failed_deps=""
    
    for pkg in $aur_deps; do
        printf "%b\n" "${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}"
        printf "%b\n" "${BLD}${CYE}Installing: ${CBL}$pkg${CNC}"
        printf "%b\n" "${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}"
        
        if ! paru -S --skipreview --noconfirm "$pkg"; then
            printf "\n%b\n" "${BLD}${CRE}✗ Failed to install $pkg${CNC}"
            failed_deps="$failed_deps $pkg"
        else
            printf "\n%b\n" "${BLD}${CGR}✓ Successfully installed $pkg${CNC}"
        fi
        printf "\n"
    done

    if [ -n "$failed_deps" ]; then
        printf "%b\n" "${BLD}${CRE}Could not install:${CYE}${failed_deps}${CNC}"
        if echo "$failed_deps" | grep -q "eww-git"; then
            printf "\n%b\n" "${BLD}${CRE}⚠ WARNING: EWW is REQUIRED for z0mbi3 theme!${CNC}"
            printf "%b\n" "${BLD}${CYE}Install manually with: paru -S eww-git${CNC}"
        fi
        printf "\n# Failed AUR packages\nInstall these manually with: paru -S <package>\n\n%s\n" "$failed_deps" >> "$HOME/missing_apps.txt"
    else
        printf "%b\n" "${BLD}${CGR}All AUR packages installed successfully!${CNC}"
    fi
    sleep 2
}

install_assets() {
    clear
    logo "Installing Icons, Themes & Cursors"
    sleep 2
    
    printf "%b\n" "${BLD}${CYE}Fonts are already installed via pacman packages${CNC}"
    printf "%b\n" "${BLD}${CGR}✓ JetBrains Mono (with Nerd Font)${CNC}"
    printf "%b\n" "${BLD}${CGR}✓ Inconsolata${CNC}"
    printf "%b\n" "${BLD}${CGR}✓ Terminus Nerd Font${CNC}"
    printf "%b\n" "${BLD}${CGR}✓ Ubuntu Mono Nerd Font${CNC}"
    
    printf "\n%b\n" "${BLD}${CYE}Refreshing font cache...${CNC}"
    fc-cache -fv
    printf "%b\n" "${BLD}${CGR}✓ Font cache refreshed${CNC}"

    # Install icon themes system-wide
    printf "\n%b\n" "${BLD}${CYE}Installing icon themes (system-wide to /usr/share/icons/)...${CNC}"
    if [ -d "$SCRIPT_DIR/assets/icons" ]; then
        for icon_theme in "$SCRIPT_DIR/assets/icons"/*; do
            if [ -d "$icon_theme" ]; then
                theme_name=$(basename "$icon_theme")
                printf "%b\n" "${BLD}${CBL}  → Installing: ${CNC}$theme_name"
                sudo cp -rf "$icon_theme" "/usr/share/icons/"
                sudo gtk-update-icon-cache -f "/usr/share/icons/$theme_name" 2>/dev/null || true
                printf "%b\n" "${BLD}${CGR}    ✓ Installed${CNC}"
            fi
        done
    else
        printf "%b\n" "${BLD}${CRE}✗ Icon themes not found in assets${CNC}"
    fi

    # Install cursor themes system-wide
    printf "\n%b\n" "${BLD}${CYE}Installing cursor themes (system-wide to /usr/share/icons/)...${CNC}"
    if [ -d "$SCRIPT_DIR/assets/cursors" ]; then
        for cursor_theme in "$SCRIPT_DIR/assets/cursors"/*; do
            if [ -d "$cursor_theme" ]; then
                theme_name=$(basename "$cursor_theme")
                printf "%b\n" "${BLD}${CBL}  → Installing: ${CNC}$theme_name"
                sudo cp -rf "$cursor_theme" "/usr/share/icons/"
                printf "%b\n" "${BLD}${CGR}    ✓ Installed${CNC}"
            fi
        done
    else
        printf "%b\n" "${BLD}${CRE}✗ Cursor themes not found in assets${CNC}"
    fi

    # Install GTK themes system-wide
    printf "\n%b\n" "${BLD}${CYE}Installing GTK themes (system-wide to /usr/share/themes/)...${CNC}"
    if [ -d "$SCRIPT_DIR/assets/gtk-themes" ]; then
        for gtk_theme in "$SCRIPT_DIR/assets/gtk-themes"/*; do
            if [ -d "$gtk_theme" ]; then
                theme_name=$(basename "$gtk_theme")
                printf "%b\n" "${BLD}${CBL}  → Installing: ${CNC}$theme_name"
                sudo cp -rf "$gtk_theme" "/usr/share/themes/"
                printf "%b\n" "${BLD}${CGR}    ✓ Installed${CNC}"
            fi
        done
    else
        printf "%b\n" "${BLD}${CRE}✗ GTK themes not found in assets${CNC}"
    fi

    printf "\n%b\n" "${BLD}${CGR}All assets installed successfully!${CNC}"
    sleep 2
}

backup_existing_config() {
    clear
    logo "Backing up existing configs"
    sleep 2

    printf "%b\n" "My dotfiles come with a lightweight Neovim configuration."
    printf "%b\n\n" "If you have your own Neovim setup, you can skip installing mine."

    while :; do
        printf "%b" "${BLD}${CYE}Install my Neovim setup? ${CNC}[y/N]: "
        read -r USE_NVIM
        case "$USE_NVIM" in
            [Yy]) USE_NVIM="y"; break ;;
            [Nn]|"") USE_NVIM="n"; break ;;
            *) printf " %b%bError:%b write 'y' or 'n'\n" "${BLD}" "${CRE}" "${CNC}" ;;
        esac
    done

    backup_folder="$HOME/.RiceBackup/$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_folder"
    printf "\n%b\n\n" "${BLD}${CYE}Backup directory: ${CBL}$backup_folder${CNC}"
    sleep 1

    # Config directories to backup
    cfg_dir="bspwm alacritty clipcat picom rofi dunst kitty geany gtk-3.0 ncmpcpp yazi zsh mpd paru systemd"
    for cfg in $cfg_dir; do
        if [ -d "$HOME/.config/$cfg" ]; then
            printf "%b" "${BLD}${CBL}  → ${CNC}Backing up $cfg... "
            mv "$HOME/.config/$cfg" "$backup_folder/" 2>/dev/null
            printf "%b\n" "${BLD}${CGR}✓${CNC}"
        fi
    done

    # Home directory files to backup
    for f in ".icons" ".zshrc" ".gtkrc-2.0"; do
        if [ -e "$HOME/$f" ]; then
            printf "%b" "${BLD}${CBL}  → ${CNC}Backing up $f... "
            mv "$HOME/$f" "$backup_folder/" 2>/dev/null
            printf "%b\n" "${BLD}${CGR}✓${CNC}"
        fi
    done

    # Local directories
    if [ -d "$HOME/.local/bin" ]; then
        printf "%b" "${BLD}${CBL}  → ${CNC}Backing up .local/bin... "
        mv "$HOME/.local/bin" "$backup_folder/" 2>/dev/null
        printf "%b\n" "${BLD}${CGR}✓${CNC}"
    fi

    # Neovim config
    if [ "$USE_NVIM" = "y" ] && [ -d "$HOME/.config/nvim" ]; then
        printf "%b" "${BLD}${CBL}  → ${CNC}Backing up nvim... "
        mv "$HOME/.config/nvim" "$backup_folder/" 2>/dev/null
        printf "%b\n" "${BLD}${CGR}✓${CNC}"
    fi

    printf "\n%b\n\n" "${BLD}${CGR}Backup completed!${CNC}"
    sleep 3
}

install_dotfiles() {
    clear
    logo "Installing z0mbi3 theme"
    printf "%s%s Installing configuration files...%s\n\n" "$BLD" "$CBL" "$CNC"
    sleep 2

    # Create required directories
    for dir in "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/share" "$HOME/.local/share/applications"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            printf "%s%sCreated: %s%s%s\n" "$BLD" "$CGR" "$CBL" "$dir" "$CNC"
        fi
    done

    printf "\n%b\n" "${BLD}${CYE}Copying configuration files...${CNC}"

    # Copy BSPWM configuration (includes all rices and eww)
    printf "%b" "${BLD}${CBL}  → ${CNC}BSPWM config... "
    cp -rf "$SCRIPT_DIR/config/bspwm" "$HOME/.config/" 2>/dev/null
    printf "%b\n" "${BLD}${CGR}✓${CNC}"
    
    # Copy all other configs
    dots_config="alacritty clipcat geany gtk-3.0 kitty mpd ncmpcpp paru systemd yazi zsh"
    for cfg in $dots_config; do
        if [ -d "$SCRIPT_DIR/config/$cfg" ]; then
            printf "%b" "${BLD}${CBL}  → ${CNC}$cfg... "
            cp -rf "$SCRIPT_DIR/config/$cfg" "$HOME/.config/" 2>/dev/null
            printf "%b\n" "${BLD}${CGR}✓${CNC}"
        fi
    done

    # Copy Neovim config if user wants it
    if [ "$USE_NVIM" = "y" ] && [ -d "$SCRIPT_DIR/config/nvim" ]; then
        printf "%b" "${BLD}${CBL}  → ${CNC}Neovim... "
        cp -rf "$SCRIPT_DIR/config/nvim" "$HOME/.config/" 2>/dev/null
        printf "%b\n" "${BLD}${CGR}✓${CNC}"
    fi

    # Copy home directory files
    printf "\n%b\n" "${BLD}${CYE}Copying home directory files...${CNC}"
    
    if [ -f "$SCRIPT_DIR/home/.zshrc" ]; then
        printf "%b" "${BLD}${CBL}  → ${CNC}.zshrc... "
        cp -f "$SCRIPT_DIR/home/.zshrc" "$HOME/" 2>/dev/null
        printf "%b\n" "${BLD}${CGR}✓${CNC}"
    fi

    if [ -f "$SCRIPT_DIR/home/.gtkrc-2.0" ]; then
        printf "%b" "${BLD}${CBL}  → ${CNC}.gtkrc-2.0... "
        cp -f "$SCRIPT_DIR/home/.gtkrc-2.0" "$HOME/" 2>/dev/null
        printf "%b\n" "${BLD}${CGR}✓${CNC}"
    fi

    if [ -d "$SCRIPT_DIR/home/.icons" ]; then
        printf "%b" "${BLD}${CBL}  → ${CNC}.icons... "
        cp -rf "$SCRIPT_DIR/home/.icons" "$HOME/" 2>/dev/null
        printf "%b\n" "${BLD}${CGR}✓${CNC}"
    fi

    # Copy .local/share contents
    if [ -d "$SCRIPT_DIR/home/.local/share" ]; then
        printf "%b" "${BLD}${CBL}  → ${CNC}.local/share... "
        cp -rf "$SCRIPT_DIR/home/.local/share"/* "$HOME/.local/share/" 2>/dev/null
        printf "%b\n" "${BLD}${CGR}✓${CNC}"
    fi

    # Copy misc/applications (desktop entries)
    if [ -d "$SCRIPT_DIR/misc/applications" ]; then
        printf "%b" "${BLD}${CBL}  → ${CNC}Desktop applications... "
        cp -rf "$SCRIPT_DIR/misc/applications"/* "$HOME/.local/share/applications/" 2>/dev/null
        printf "%b\n" "${BLD}${CGR}✓${CNC}"
    fi

    # Ensure z0mbi3 is set as default theme
    printf "\n%b\n" "${BLD}${CYE}Setting z0mbi3 as default theme...${CNC}"
    printf "z0mbi3" > "$HOME/.config/bspwm/.rice"
    printf "%b\n" "${BLD}${CGR}✓ Default theme set${CNC}"
    
    # Make all scripts executable
    printf "\n%b\n" "${BLD}${CYE}Setting executable permissions...${CNC}"

    # Main bspwmrc
    printf "%b" "${BLD}${CBL}  → ${CNC}bspwmrc... "
    chmod +x "$HOME/.config/bspwm/bspwmrc" 2>/dev/null
    printf "%b\n" "${BLD}${CGR}✓${CNC}"

    # All scripts in bin/ directory (main utilities)
    if [ -d "$HOME/.config/bspwm/bin" ]; then
        printf "%b" "${BLD}${CBL}  → ${CNC}bin/ scripts... "
        find "$HOME/.config/bspwm/bin" -type f -exec chmod +x {} \; 2>/dev/null
        printf "%b\n" "${BLD}${CGR}✓${CNC}"
    fi

    # Scripts in each rice's bar/scripts/ directory (EWW bar scripts)
    if [ -d "$HOME/.config/bspwm/rices/z0mbi3/bar/scripts" ]; then
        printf "%b" "${BLD}${CBL}  → ${CNC}z0mbi3 bar scripts... "
        find "$HOME/.config/bspwm/rices/z0mbi3/bar/scripts" -type f -exec chmod +x {} \; 2>/dev/null
        printf "%b\n" "${BLD}${CGR}✓${CNC}"
    fi

    if [ -d "$HOME/.config/bspwm/rices/andrea/bar/scripts" ]; then
        printf "%b" "${BLD}${CBL}  → ${CNC}andrea bar scripts... "
        find "$HOME/.config/bspwm/rices/andrea/bar/scripts" -type f -exec chmod +x {} \; 2>/dev/null
        printf "%b\n" "${BLD}${CGR}✓${CNC}"
    fi

    # Rice configuration scripts (Bar.bash, theme-config.bash, etc.)
    printf "%b" "${BLD}${CBL}  → ${CNC}rice config scripts... "
    find "$HOME/.config/bspwm/rices" -maxdepth 2 -type f \( -name "*.sh" -o -name "*.bash" -o -name "*.py" \) -exec chmod +x {} \; 2>/dev/null
    printf "%b\n" "${BLD}${CGR}✓${CNC}"

    # EWW profilecard scripts
    if [ -d "$HOME/.config/bspwm/eww/profilecard/scripts" ]; then
        printf "%b" "${BLD}${CBL}  → ${CNC}eww profilecard scripts... "
        find "$HOME/.config/bspwm/eww/profilecard/scripts" -type f -exec chmod +x {} \; 2>/dev/null
        printf "%b\n" "${BLD}${CGR}✓${CNC}"
    fi

    printf "%b\n" "${BLD}${CGR}✓ All executable permissions set${CNC}"

    # Refresh font cache
    printf "\n%b\n" "${BLD}${CYE}Refreshing font cache...${CNC}"
    fc-cache -r > /dev/null 2>&1
    printf "%b\n" "${BLD}${CGR}✓ Font cache refreshed${CNC}"

    # Create XDG user directories if they don't exist
    if [ ! -e "$HOME/.config/user-dirs.dirs" ]; then
        printf "%b\n" "${BLD}${CYE}Creating XDG user directories...${CNC}"
        xdg-user-dirs-update
        printf "%b\n" "${BLD}${CGR}✓ XDG directories created${CNC}"
    fi

    printf "\n%s%sz0mbi3 theme installed successfully!%s\n" "$BLD" "$CGR" "$CNC"
    sleep 3
}

install_optional_packages() {
    clear
    logo "Optional Packages"
    sleep 2

    printf "%b\n" "${BLD}${CYE}The following packages are optional but recommended:${CNC}\n"
    
    # Package list with descriptions
    printf "  ${BLD}btop${CNC}              - Resource monitor (modern htop alternative)\n"
    printf "  ${BLD}xarchiver${CNC}         - Archive manager for Thunar\n"
    printf "  ${BLD}thunar-archive-plugin${CNC} - Thunar integration for archives\n"
    printf "  ${BLD}blueman${CNC}           - Bluetooth manager (GUI)\n"
    printf "  ${BLD}vesktop${CNC}           - Discord client with Vencord\n"
    printf "  ${BLD}visual-studio-code-bin${CNC} - VS Code (Microsoft build)\n"
    printf "  ${BLD}sddm${CNC}              - Display manager (login screen)\n"

    printf "\n%b\n" "${BLD}${CYE}You'll be asked for each package individually.${CNC}"
    sleep 2

    # Array to store packages to install
    packages_to_install=""
    install_sddm="n"

    # Package prompts
    printf "\n%b" "${BLD}${CGR}Install btop (resource monitor)?${CNC} [y/N]: "
    read -r response
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        packages_to_install="$packages_to_install btop"
    fi

    printf "%b" "${BLD}${CGR}Install xarchiver?${CNC} [y/N]: "
    read -r response
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        packages_to_install="$packages_to_install xarchiver"
    fi

    printf "%b" "${BLD}${CGR}Install thunar-archive-plugin?${CNC} [y/N]: "
    read -r response
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        packages_to_install="$packages_to_install thunar-archive-plugin"
    fi

    printf "%b" "${BLD}${CGR}Install blueman (Bluetooth manager)?${CNC} [y/N]: "
    read -r response
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        packages_to_install="$packages_to_install blueman"
    fi

    printf "%b" "${BLD}${CGR}Install vesktop (Discord client)?${CNC} [y/N]: "
    read -r response
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        packages_to_install="$packages_to_install vesktop"
    fi

    printf "%b" "${BLD}${CGR}Install visual-studio-code-bin?${CNC} [y/N]: "
    read -r response
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        packages_to_install="$packages_to_install visual-studio-code-bin"
    fi

    printf "%b" "${BLD}${CGR}Install SDDM (display manager/login screen)?${CNC} [y/N]: "
    read -r response
    if [ "$response" = "y" ] || [ "$response" = "Y" ]; then
        install_sddm="y"
    fi

    # Install selected packages
    if [ -n "$packages_to_install" ] || [ "$install_sddm" = "y" ]; then
        clear
        logo "Installing Optional Packages"
        sleep 1

        if [ -n "$packages_to_install" ]; then
            printf "\n%b\n\n" "${BLD}${CYE}Installing selected AUR packages...${CNC}"
            
            for pkg in $packages_to_install; do
                printf "%b\n" "${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}"
                printf "%b\n" "${BLD}${CYE}Installing: ${CBL}$pkg${CNC}"
                printf "%b\n" "${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}"
                
                if ! paru -S --skipreview --noconfirm "$pkg"; then
                    printf "\n%b\n\n" "${BLD}${CRE}✗ Failed to install $pkg${CNC}"
                    printf "\n%s\n" "$pkg" >> "$HOME/missing_apps.txt"
                else
                    printf "\n%b\n\n" "${BLD}${CGR}✓ Successfully installed $pkg${CNC}"
                fi
            done
        fi

        # Handle SDDM installation separately (it's from official repos)
        if [ "$install_sddm" = "y" ]; then
            printf "\n%b\n" "${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}"
            printf "%b\n" "${BLD}${CYE}Installing SDDM...${CNC}"
            printf "%b\n" "${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}"
            
            if sudo pacman -S --noconfirm --needed sddm; then
                printf "\n%b\n" "${BLD}${CGR}✓ SDDM installed${CNC}"
                
                printf "%b\n" "${BLD}${CYE}Enabling sddm.service...${CNC}"
                if sudo systemctl enable sddm.service; then
                    printf "%b\n" "${BLD}${CGR}✓ SDDM enabled - will start on next boot${CNC}"
                else
                    printf "%b\n" "${BLD}${CRE}✗ Failed to enable SDDM service${CNC}"
                fi
            else
                printf "\n%b\n" "${BLD}${CRE}✗ Failed to install SDDM${CNC}"
            fi
            printf "%b\n" "${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}"
        fi

        printf "\n%b\n" "${BLD}${CGR}Optional packages installation completed!${CNC}"
    else
        printf "\n%b\n" "${BLD}${CYE}No optional packages selected. Skipping...${CNC}"
    fi
    
    sleep 3
}

configure_services() {
    clear
    logo "Configuring services"
    picom_config="$HOME/.config/bspwm/config/picom.conf"
    sleep 2

    # MPD Service Management
    if systemctl is-enabled --quiet mpd.service 2>/dev/null; then
        printf "%b\n" "${BLD}${CYE}Disabling global MPD service...${CNC}"
        sudo systemctl disable --now mpd.service 2>/dev/null
    fi

    printf "%b\n" "${BLD}${CYE}Enabling user MPD service...${CNC}"
    systemctl --user enable --now mpd.service 2>/dev/null
    printf "%b\n" "${BLD}${CGR}✓ MPD service configured${CNC}"

    # ArchUpdates timer (if systemd service exists)
    if [ -f "$HOME/.config/systemd/user/ArchUpdates.timer" ]; then
        printf "%b\n" "${BLD}${CYE}Enabling ArchUpdates service...${CNC}"
        systemctl --user enable --now ArchUpdates.timer 2>/dev/null || true
        printf "%b\n" "${BLD}${CGR}✓ ArchUpdates timer enabled${CNC}"
    fi

    # VM detection and picom optimization
    if systemd-detect-virt --quiet >/dev/null 2>&1; then
        printf "\n%b\n" "${BLD}${CYE}Virtual machine detected${CNC}"
        printf "%b\n" "${BLD}${CYE}Adjusting Picom for VM performance...${CNC}"

        if [ -f "$picom_config" ]; then
            sed -i 's/backend = "glx"/backend = "xrender"/' "$picom_config" 2>/dev/null
            sed -i 's/vsync = true/vsync = false/' "$picom_config" 2>/dev/null
            printf "%b\n" "${BLD}${CGR}✓ Picom optimized for VM${CNC}"
        else
            printf "%b\n" "${BLD}${CYE}Note: Picom config not found, skipping VM optimization${CNC}"
        fi
    fi
    sleep 3
}

change_default_shell() {
    clear
    logo "Changing default shell to zsh"
    zsh_path=$(command -v zsh)
    sleep 2

    if [ -z "$zsh_path" ]; then
        printf "%b\n\n" "${BLD}${CRE}Zsh not installed! Cannot change shell${CNC}"
        return
    fi

    if [ "$SHELL" != "$zsh_path" ]; then
        printf "%b\n" "${BLD}${CYE}Changing shell to Zsh...${CNC}"
        if chsh -s "$zsh_path"; then
            printf "%b\n" "\n${BLD}${CGR}Shell changed successfully!${CNC}"
        else
            printf "%b\n\n" "\n${BLD}${CRE}Error changing shell. Try manually: chsh -s /usr/bin/zsh${CNC}"
        fi
    else
        printf "%b\n\n" "${BLD}${CGR}Zsh already default shell!${CNC}"
    fi
    sleep 3
}

final_prompt() {
    clear
    logo "Installation Complete!"

    printf "%b\n" "${BLD}${CGR}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}"
    printf "%b\n" "${BLD}${CGR}    Z0mbi3 Theme Installation Complete!${CNC}"
    printf "%b\n\n" "${BLD}${CGR}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}"

    printf "%b\n" "${BLD}${CYE}Essential Information:${CNC}"
    printf "  ${BLD}Theme:${CNC} z0mbi3 (set as default)\n"
    printf "  ${BLD}Widgets:${CNC} EWW (ElKowar's Wacky Widgets)\n"
    printf "  ${BLD}Window Manager:${CNC} BSPWM with SXHKD\n"
    printf "  ${BLD}Compositor:${CNC} Picom\n\n"

    printf "%b\n" "${BLD}${CYE}Key Bindings (default):${CNC}"
    printf "  ${BLD}Super + Enter${CNC}      → Terminal (Alacritty)\n"
    printf "  ${BLD}Super + Space${CNC}      → App launcher (Rofi)\n"
    printf "  ${BLD}Super + X${CNC}          → Power menu\n"
    printf "  ${BLD}Super + L${CNC}          → Lock screen\n"
    printf "  ${BLD}Super + Shift + R${CNC}  → Reload BSPWM\n"
    printf "  ${BLD}Super + Shift + Q${CNC}  → Close window\n\n"

    printf "%b\n" "${BLD}${CYE}After Reboot:${CNC}"
    printf "  1. Select ${BLD}BSPWM${CNC} from your display manager\n"
    printf "  2. Check ${BLD}~/.config/bspwm/config/sxhkdrc${CNC} for all keybindings\n"
    printf "  3. Wallpapers: ${BLD}~/.config/bspwm/rices/z0mbi3/walls/${CNC}\n"
    printf "  4. Customize EWW widgets in ${BLD}~/.config/bspwm/eww/${CNC}\n\n"

    if [ -f "$HOME/missing_apps.txt" ]; then
        printf "%b\n\n" "${BLD}${CRE}⚠ Some packages failed to install. Check ~/missing_apps.txt${CNC}"
    fi

    printf "%b\n\n" "${BLD}${CRE}You ${CBL}MUST ${CRE}restart to apply all changes!${CNC}"

    while :; do
        printf "%b" "${BLD}${CYE}Reboot now?${CNC} [y/N]: "
        read -r yn
        case "$yn" in
            [Yy])
                printf "\n%b\n" "${BLD}${CGR}Rebooting in 3 seconds...${CNC}"
                sleep 3
                sudo reboot
                break ;;
            [Nn]|"")
                printf "\n%b\n" "${BLD}${CYE}Don't forget to reboot${CNC}"
                printf "%b\n\n" "${BLD}${CGR}Enjoy your z0mbi3 rice!${CNC}"
                break ;;
            *) printf " %b%bError:%b write 'y' or 'n'\n" "${BLD}" "${CRE}" "${CNC}" ;;
        esac
    done
}


# ═══════════════════════════════════════════════════════════
#                     MAIN EXECUTION
# ═══════════════════════════════════════════════════════════
initial_checks
welcome
install_core_dependencies
install_aur_dependencies
install_assets
backup_existing_config
install_dotfiles
install_optional_packages
configure_services
change_default_shell
final_prompt