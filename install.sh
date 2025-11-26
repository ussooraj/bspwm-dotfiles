#!/bin/sh
#     ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗     ███████╗██████╗ 
#     ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║     ██╔════╝██╔══██╗
#     ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║     █████╗  ██████╔╝
#     ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║     ██╔══╝  ██╔══██╗
#     ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗███████╗██║  ██║
#     ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝
#
#     Z0mbi3 (Minimal) BSPWM Theme Installer

# Colors
CRE=$(tput setaf 1)
CYE=$(tput setaf 3)
CGR=$(tput setaf 2)
CBL=$(tput setaf 4)
BLD=$(tput bold)
CNC=$(tput sgr0)

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
    if [ ! -d "$SCRIPT_DIR/config" ]; then
        printf "%b\n" "${BLD}${CRE}Error: config directory not found in repo.${CNC}"
        exit 1
    fi
}

welcome() {
    clear
    logo "Minimal Z0mbi3 Installer"
    printf "%b" "${BLD}${CGR}This script will install the customized BSPWM theme:${CNC}
  ${BLD}${CGR}[${CYE}✓${CGR}]${CNC} Install core & font packages (Pacman)
  ${BLD}${CGR}[${CYE}✓${CGR}]${CNC} Install AUR tools (Paru, EWW)
  ${BLD}${CGR}[${CYE}✓${CGR}]${CNC} Copy Local Assets (Fonts, sysfetch, etc.)
  ${BLD}${CGR}[${CYE}✓${CGR}]${CNC} Sync Configs (mpDris2, xfce4, bspwm)
  ${BLD}${CGR}[${CYE}✓${CGR}]${CNC} Enable Services (MPD, Updates, Media Keys)
  ${BLD}${CGR}[${CYE}✓${CGR}]${CNC} Install Optional Apps (SDDM, Btop, etc.)

${BLD}${CRE}[!]${CNC} ${BLD}${CRE}Backup your files before proceeding!${CNC}
"
    read -p " Continue? [y/N]: " yn
    case "$yn" in [Yy]*) ;; *) exit 0 ;; esac
}

install_core_dependencies() {
    clear
    logo "Installing Core Dependencies"
    
    printf "%b\n" "${BLD}${CYE}Updating package database...${CNC}"
    sudo pacman -Syy

    core_deps="bspwm sxhkd picom dunst rofi xorg-server xorg-xsetroot xorg-xrandr xorg-xprop xorg-xkill xorg-xdpyinfo xorg-xwininfo xorg-xrdb xdo xdotool xdg-user-dirs lxsession xsettingsd base-devel git alacritty kitty feh maim xclip xcolor jq brightnessctl redshift bat eza fzf clipcat thunar tumbler gvfs-mtp yazi mpd mpc ncmpcpp pamixer pacman-contrib imagemagick libwebp webp-pixbuf-loader neovim geany npm rustup python-gobject firefox network-manager-applet zsh zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting mpdris2 playerctl socat ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-inconsolata ttf-terminus-nerd ttf-ubuntu-mono-nerd papirus-icon-theme"

    printf "%b\n" "${BLD}${CBL}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${CNC}"
    if ! sudo pacman -S --noconfirm --needed $core_deps; then
        printf "\n%b\n" "${BLD}${CYE}Some packages failed. Continuing (check missing_apps.txt later)...${CNC}"
    fi
    sleep 2
}

install_aur_dependencies() {
    clear
    logo "Installing AUR Dependencies"
    
    # Paru Check
    if ! command -v paru >/dev/null 2>&1; then
        printf "%b\n" "${BLD}${CYE}Installing Paru...${CNC}"
        git clone https://aur.archlinux.org/paru-bin.git "$HOME/paru-bin"
        (cd "$HOME/paru-bin" && makepkg -si --noconfirm)
        rm -rf "$HOME/paru-bin"
    fi

    # EWW & Extras
    aur_deps="eww xwinwrap-0.9-bin i3lock-color simple-mtpfs fzf-tab-git"
    for pkg in $aur_deps; do
        printf "%b\n" "${BLD}${CYE}Installing AUR: ${CBL}$pkg${CNC}"
        paru -S --skipreview --noconfirm "$pkg"
    done
    sleep 2
}

install_optional_packages() {
    clear
    logo "Optional Packages"

    packages_to_install=""
    install_sddm="n"

    # Quick prompt function
    ask() {
        printf "%b" "${BLD}${CGR}Install $1?${CNC} [y/N]: "
        read -r r
        [ "$r" = "y" ] || [ "$r" = "Y" ]
    }

    if ask "btop (resource monitor)"; then packages_to_install="$packages_to_install btop"; fi
    if ask "xarchiver"; then packages_to_install="$packages_to_install xarchiver"; fi
    if ask "thunar-archive-plugin"; then packages_to_install="$packages_to_install thunar-archive-plugin"; fi
    if ask "blueman (Bluetooth manager)"; then packages_to_install="$packages_to_install blueman"; fi
    if ask "vesktop (Discord)"; then packages_to_install="$packages_to_install vesktop"; fi
    if ask "visual-studio-code-bin"; then packages_to_install="$packages_to_install visual-studio-code-bin"; fi
    if ask "linux-wifi-hotspot"; then packages_to_install="$packages_to_install linux-wifi-hotspot"; fi
    if ask "SDDM (Display Manager)"; then install_sddm="y"; fi

    if [ -n "$packages_to_install" ]; then
        printf "\n%b\n" "${BLD}${CYE}Installing selected packages...${CNC}"
        paru -S --skipreview --noconfirm $packages_to_install
    fi

    if [ "$install_sddm" = "y" ]; then
        printf "\n%b\n" "${BLD}${CYE}Installing & Enabling SDDM...${CNC}"
        sudo pacman -S --noconfirm --needed sddm
        sudo systemctl enable sddm
    fi
    sleep 2
}

backup_existing_config() {
    clear
    logo "Backing up Configs"
    backup_folder="$HOME/.RiceBackup/$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_folder"
    printf "%b\n" "${BLD}${CYE}Backup: ${CBL}$backup_folder${CNC}"
    
    cfg_list="bspwm sxhkd eww dunst picom kitty alacritty gtk-3.0 ncmpcpp mpd mpDris2 xfce4 rofi systemd"
    for item in $cfg_list; do
        [ -d "$HOME/.config/$item" ] && mv "$HOME/.config/$item" "$backup_folder/"
    done
    [ -f "$HOME/.Xresources" ] && mv "$HOME/.Xresources" "$backup_folder/"
    [ -f "$HOME/.zshrc" ] && mv "$HOME/.zshrc" "$backup_folder/"
}

install_dotfiles() {
    clear
    logo "Deploying Configuration"

    mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/share"

    # 1. Config Directory (Recursive Copy)
    printf "%b\n" "${BLD}${CYE}Syncing .config directories...${CNC}"
    if [ -d "$SCRIPT_DIR/config" ]; then
        cp -rf "$SCRIPT_DIR/config"/* "$HOME/.config/"
    fi

    # 2. Home Directory Files (.zshrc, .Xresources, etc)
    printf "%b\n" "${BLD}${CYE}Syncing Home files...${CNC}"
    if [ -d "$SCRIPT_DIR/home" ]; then
        cp -rf "$SCRIPT_DIR/home"/.??* "$HOME/" 2>/dev/null
    fi

    # 3. Local Bin (sysfetch)
    if [ -d "$SCRIPT_DIR/home/.local/bin" ]; then
        printf "%b\n" "${BLD}${CYE}Installing bin scripts (sysfetch)...${CNC}"
        cp -rf "$SCRIPT_DIR/home/.local/bin"/* "$HOME/.local/bin/"
        chmod +x "$HOME/.local/bin/"*
    fi

    # 4. Local Share (Fonts & Applications)
    if [ -d "$SCRIPT_DIR/home/.local/share" ]; then
        printf "%b\n" "${BLD}${CYE}Installing local assets (fonts, apps)...${CNC}"
        cp -rf "$SCRIPT_DIR/home/.local/share"/* "$HOME/.local/share/"
    fi
    
    # Permissions
    chmod +x "$HOME/.config/bspwm/bspwmrc"
    chmod +x "$HOME/.config/sxhkd/sxhkdrc"
    find "$HOME/.config/bspwm" -name "*.sh" -exec chmod +x {} \;
    find "$HOME/.config/bspwm" -name "*.bash" -exec chmod +x {} \;
    find "$HOME/.config/bspwm" -name "*.py" -exec chmod +x {} \;

    # Reload Font Cache (Critical for local fonts)
    printf "%b\n" "${BLD}${CYE}Refreshing font cache...${CNC}"
    fc-cache -fv >/dev/null

    # Apply .Xresources immediately
    if [ -f "$HOME/.Xresources" ]; then
        printf "%b\n" "${BLD}${CYE}Applying .Xresources (DPI Fix)...${CNC}"
        xrdb -merge "$HOME/.Xresources"
    fi
    sleep 2
}

configure_services() {
    clear
    logo "Enabling Services"
    
    # MPD (User Service)
    printf "%b\n" "${BLD}${CYE}Configuring MPD...${CNC}"
    systemctl --user enable --now mpd.service 2>/dev/null
    
    # mpDris2 (Media Keys Bridge)
    printf "%b\n" "${BLD}${CYE}Configuring mpDris2 (Media Bridge)...${CNC}"
    systemctl --user enable --now mpDris2 2>/dev/null

    printf "%b\n" "${BLD}${CGR}✓ All services enabled${CNC}"
    sleep 2
}

final_prompt() {
    clear
    logo "Installation Complete!"
    printf "%b\n" "${BLD}${CGR}Z0mbi3 Environment Deployed.${CNC}\n"
    printf "\n%b\n" "${BLD}${CRE}Please reboot your system now.${CNC}"
}

# ═══════════════════════════════════════════════════════════
#                     EXECUTION ORDER
# ═══════════════════════════════════════════════════════════
initial_checks
welcome
install_core_dependencies
install_aur_dependencies
install_optional_packages
backup_existing_config
install_dotfiles
configure_services
final_prompt