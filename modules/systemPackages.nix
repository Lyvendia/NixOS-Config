{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
#   Browsers
    firefox
    tor-browser-bundle-bin
#   Files
    pcmanfm
#   Utils
    bitwarden
    remmina
    virt-manager
    virt-viewer
    arandr
    scrot
    htop
    ncdu
    usbutils
    checkra1n
    file
    lm_sensors
    nmap
    smartmontools
    android-udev-rules
    neofetch
    xclip
    killall
    xorg.xkill
    hsetroot
    pciutils
#   Menus etc
    dmenu
#   Audio
    pavucontrol
    helvum
    easyeffects
#   NUR
    config.nur.repos.dukzcry.gamescope
#   Language Servers
    rnix-lsp
    sumneko-lua-language-server
    haskell-language-server
#   Games
    polymc
    minetest
    superTuxKart
#   Chat
    signal-desktop
#   Vpn
    strongswan
    openconnect
#   Media
    gimp
    vlc
    mpv
    tauon
    # office
    onlyoffice-bin
    libreoffice-fresh
    # spelling etc
    hunspell
    hunspellDicts.en_US
    hunspellDicts.de_DE
    # libs
    ffmpegthumbnailer
    poppler
    freetype
    libgsf
    pstree
#   Other
    vscodium
    git-crypt
  ];
}
