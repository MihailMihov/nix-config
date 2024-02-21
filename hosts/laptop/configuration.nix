# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./../../flakes/kmonad.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 4;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    supportedFilesystems = [ "bcachefs" ];
  };
  boot.plymouth.enable = true;

  networking.hostName = "laptop"; # Define your hostname.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  time.timeZone = "Europe/Sofia";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    desktopManager.plasma5.enable = true;
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  services.printing.enable = true;

  services.kmonad = {
     enable = true;
     package = pkgs.haskellPackages.kmonad;
     keyboards = {
 	kmonad = {
	    defcfg = {
                enable = true;
		fallthrough = true;
	    };
 	    device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
 	    config = ''
(defsrc
  esc     f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
  grv     1    2    3    4    5    6    7    8    9    0    -    =    bspc
  tab     q    w    e    r    t    y    u    i    o    p    [    ]    \
  caps    a    s    d    f    g    h    j    k    l    ;    '    ret
  lsft      z    x    c    v    b    n    m    ,    .    /    rsft
  lctl    lmet lalt           spc            ralt rmet cmp  rctl
)
 
(defalias
  ext  (layer-toggle extend) ;; Bind 'ext' to the Extend Layer
)

(defalias
  cpy C-c
  pst C-v
  cut C-x
  udo C-z
  all C-a
  fnd C-f
  bk Back
  fw Forward
)

(deflayer colemak-dh
  esc     f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
  grv      1    2    3    4    5    6    7    8    9    0    -    =    bspc
  tab      q    w    f    p    b    j    l    u    y    ;    [    ]    \\
  @ext     a    r    s    t    g    m    n    e    i    o    '    ret
  lsft       x    c    d    v    z    k    h    ,    .    /    rsft
  lctl     lmet lalt           spc            ralt rmet _    _
)

(deflayer colemak-dhk
  esc     f1   f2   f3   f4   f5   f6   f7   f8   f9   f10  f11  f12
  grv      1    2    3    4    5    6    7    8    9    0    -    =    bspc
  tab      q    w    f    p    b    j    l    u    y    ;    [    ]    \\
  @ext     a    r    s    t    g    k    n    e    i    o    '    ret
  lsft       x    c    d    v    z    m    h    ,    .    /    rsft
  lctl     lmet lalt           spc            ralt rmet _    _
)

(deflayer extend
  _        play rewind previoussong nextsong ejectcd refresh brdn brup www mail prog1 prog2
  _        f1   f2   f3   f4   f5   f6   f7   f8   f9  f10   f11  f12  _
  _        esc  @bk  @fnd @fw  ins  pgup home up   end  menu prnt slck _
  _        lalt lmet lsft lctl ralt pgdn lft  down rght del  caps _
  _          @cut @cpy  tab  @pst @udo pgdn bks  lsft lctl comp _
  _        _    _              ret            _    _    _    _
)


(deflayer empty
  _        _    _    _    _    _    _    _    _    _    _    _    _    
  _        _    _    _    _    _    _    _    _    _    _    _    _    _
  _        _    _    _    _    _    _    _    _    _    _    _    _    _
  _        _    _    _    _    _    _    _    _    _    _    _    _ 
  _          _    _    _    _    _    _    _    _    _    _    _ 
  _        _    _              _              _    _    _    _
)
		     '';
 	  };
     }; 
  };

  sound.enable = true;
  # hardware.pulseaudio.enable = true;

  users.mutableUsers = false;
  users.users.root.initialHashedPassword = "$6$PW9fNC5AgCh7KSiQ$qLa8NZF1vj6tJs.imaOrK6RHpU5Uyp03fGTKKdA1gAu7PgJa/JV2mpodByvLAqToQ/ExF9ofHha2axNXt7kRU.";
  users.users.mihail = {
    initialHashedPassword = "$6$PW9fNC5AgCh7KSiQ$qLa8NZF1vj6tJs.imaOrK6RHpU5Uyp03fGTKKdA1gAu7PgJa/JV2mpodByvLAqToQ/ExF9ofHha2axNXt7kRU.";
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  # Enable flakes and new nix CLI
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" "ca-derivations" ];
    auto-optimise-store = true;
    trusted-users = [ "mihail" ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than-1w";
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?

}

