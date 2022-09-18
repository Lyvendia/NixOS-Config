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
#   Language Servers
    rnix-lsp
    sumneko-lua-language-server
    haskell-language-server
#   Gaming
    gamescope
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
    ffmpeg
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
    psmisc
    libgsf
    libva
    libva-utils
#   Other
    vscodium
    git-crypt
  ];
}
