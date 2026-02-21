{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    usePredictableInterfaceNames = false;
    interfaces.eth0.useDHCP = true;
    hostName = "settlers";
    domain = "site";
  };

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services.openssh.enable = true;

  services.mediawiki = {
    enable = true;
    name = "Android Boot Manager Wiki";
    httpd.virtualHost = {
      hostName = let
        inherit (config.networking) hostName domain;
      in "wiki.${hostName}.${domain}";
      adminAddr = "shymega+abm@shymega.org.uk";
    };
    webserver = "nginx";
    # Administrator account username is admin.
    passwordFile = pkgs.writeText "password" "hunter123"; # This is a temporary password set.;
    extraConfig = ''
      # Disable anonymous editing
      $wgGroupPermissions['*']['edit'] = false;
    '';

    extensions = {
      # some extensions are included and can enabled by passing null
      VisualEditor = null;
    };
  };

  services.wordpress.sites."localhost" = {};

  system.stateVersion = "25.11"; # Did you read the comment?
}
