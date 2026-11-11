{
  # Enable Firefox
  programs.firefox = {
    enable = true;

    # Firefox policies (managed configuration)
    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
      OfferToSaveLogins = false;
      PasswordManagerEnabled = true;

      Homepage = {
        StartPage = "homepage";
        URL = "https://nixos.org";
      };

      SearchBar = "unified";

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      ExtensionSettings = {
        "*" = {
          installation_mode = "allowed";
        };
      };
    };
  };
}
