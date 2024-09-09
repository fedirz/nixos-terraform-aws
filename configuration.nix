{
  modulesPath,
  pkgs,
  nixpkgs,
  ...
}:
{
  imports = [
    "${modulesPath}/virtualisation/amazon-image.nix"
    ./nvidia.nix
  ];
  system.stateVersion = "24.11";

  nix = {
    registry.nixpkgs.flake = nixpkgs;
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    autoPrune.enable = true;
  };

  environment.systemPackages = with pkgs; [
    docker-buildx
    docker-compose
    nettools
    neovim
    curl
    python312
    git
    wget
    dust
    ripgrep
    fd
    bat
    tree
    unzip
    htop
    btop
  ];

  security.sudo.wheelNeedsPassword = false;
  services.openssh.enable = true;

  users.mutableUsers = true;
  users.users.nixos = {
    isNormalUser = true;
    initialPassword = "nixos"; # <<< This is the password you'll need to enter when sshing as `nixos` user
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
    ];
    # If you don't want to use a password, put your public ssh key here 
    # openssh.authorizedKeys.keys = [
    # ];
  };
}
