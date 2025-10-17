# Illogical Impulse NixOS Flake

A production-ready NixOS flake for [end-4's Illogical Impulse Hyprland dotfiles](https://github.com/end-4/dots-hyprland) with complete QuickShell integration.

**Based on**: [xBLACKICEx/end-4-dots-hyprland-nixos](https://github.com/xBLACKICEx/end-4-dots-hyprland-nixos)

## Overview

This flake provides a comprehensive NixOS module that installs end-4's stunning Material Design 3 Hyprland desktop environment with full functionality out of the box. Everything from wallpaper-based dynamic theming to Python scripts for color analysis is properly configured and working.

### Key Features

- ✅ **Complete QuickShell Integration**: All Qt/QML modules including QtPositioning properly configured
- ✅ **Working Wallpaper Analysis**: Python environment with all required packages for dynamic color generation
- ✅ **Automatic Configuration Copying**: Dotfiles copied to writable locations for proper config management
- ✅ **Flexible Dotfiles Sourcing**: Use end-4's original dotfiles or your own fork from any Git source
- ✅ **Zero Manual Configuration**: All dependencies, fonts, and utilities included
- ✅ **Production Ready**: Tested and working with all major features functional

## Quick Start

### 1. Add the flake to your inputs

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    illogical-flake = {
      url = "github:soymou/illogical-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, illogical-flake, ... }: {
    nixosConfigurations.yourhostname = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
        outputs = self.outputs;
        # These are automatically inherited from illogical-flake:
        inherit (illogical-flake.inputs) quickshell hyprland nur dotfiles;
      };
      modules = [
        ./configuration.nix
        illogical-flake.nixosModules.default
      ];
    };
  };
}
```

### 2. Enable in your configuration.nix

```nix
services.illogical-flake = {
  enable = true;
  user = "yourusername";
};
```

### 3. Rebuild and enjoy!

```bash
sudo nixos-rebuild switch --flake .#yourhostname
```

## Configuration

### Basic Configuration

```nix
services.illogical-flake = {
  enable = true;
  user = "yourusername";

  # Hyprland settings
  hyprland = {
    enable = true;
    ozoneWayland.enable = true;  # Chromium/Electron Wayland support
  };

  # Default applications (all enabled by default)
  dotfiles = {
    fish.enable = true;     # Fish shell with custom config
    kitty.enable = true;    # Kitty terminal emulator
    starship.enable = true; # Starship prompt
  };
};
```

### Using Your Own Dotfiles Fork

The flake supports multiple methods for sourcing dotfiles:

#### GitHub (Short URL format)
```nix
dotfiles.source = {
  url = "github:yourusername/dots-hyprland";
  sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
};
```

#### GitHub (Explicit format)
```nix
dotfiles.source = {
  type = "github";
  owner = "yourusername";
  repo = "dots-hyprland";
  rev = "main";  # branch, tag, or commit
  sha256 = "sha256-...";
};
```

#### Any Git Repository
```nix
dotfiles.source = {
  type = "git";
  url = "https://git.sr.ht/~user/dotfiles";
  rev = "main";
  sha256 = "sha256-...";
};
```

#### GitLab
```nix
dotfiles.source = {
  type = "gitlab";
  owner = "username";
  repo = "dots-hyprland";
  sha256 = "sha256-...";
};
```

**Getting the SHA256**: Use a fake hash initially, rebuild, and copy the correct hash from the error message.

### Advanced Configuration

```nix
services.illogical-flake = {
  enable = true;
  user = "yourusername";

  # Hyprland configuration
  hyprland = {
    enable = true;

    # Monitor configuration
    monitor = [
      ",preferred,auto,1"                    # Auto-detect
      "DP-1,1920x1080@144,0x0,1"           # Specific monitor
      "HDMI-A-1,1920x1080@60,1920x0,1.5"   # Second monitor
    ];

    # Use specific Hyprland version (optional)
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xdgPortalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;

    # Chromium/Electron Wayland support
    ozoneWayland.enable = true;
  };

  # Customize which shell tools to use
  dotfiles = {
    source = {
      url = "github:end-4/dots-hyprland";
      sha256 = "sha256-...";
    };
    fish.enable = true;      # Use Fish shell
    kitty.enable = true;     # Install Kitty terminal
    starship.enable = true;  # Use Starship prompt
  };
};
```

## What's Included

### Desktop Environment
- **Hyprland**: Modern Wayland compositor with beautiful animations
- **QuickShell**: Qt6-based desktop shell with Material Design 3
- **Dynamic Theming**: Automatic color palette generation from wallpapers
- **Complete UI**: Bar, sidebars, lock screen, logout menu, and more

### System Integration
- **Power Management**: hypridle (idle detection), hyprlock (lock screen), hyprsunset (blue light filter)
- **Audio**: PipeWire integration with pavucontrol-qt mixer
- **Media Controls**: playerctl for media key handling
- **Notifications**: Integrated notification system
- **Screenshots**: hyprshot with swappy for annotation
- **System Monitoring**: Real-time CPU, memory, and resource monitoring

### Applications & Tools
- **Terminal**: Kitty with custom configuration
- **Shell**: Fish with custom functions and themes
- **Prompt**: Starship with custom styling
- **Launcher**: Fuzzel application launcher
- **File Manager**: Integrated Dolphin file manager
- **Screen Recording**: wf-recorder for screen capture
- **Color Picker**: hyprpicker for color selection

### Developer Features
- **Python Environment**: Complete setup for wallpaper analysis scripts
  - opencv4, pillow, numpy for image processing
  - kde-material-you-colors for Material You color extraction
  - All required Python packages pre-installed
- **Proper Environment Variables**: All paths and virtual environments configured
- **Qt/QML Modules**: Complete Qt6 module setup including QtPositioning for location services

### Fonts
- **Material Symbols**: Google's Material Design icons
- **Nerd Fonts**: Ubuntu, JetBrains Mono, Caskaydia Cove, and more
- **UI Fonts**: Rubik, Gabarito for interface elements
- **Complete Coverage**: All required fonts for the desktop environment

### System Utilities
All required command-line tools are included:
- jq, ripgrep, bc, curl, wget, rsync, axel
- imagemagick, ffmpeg for media processing
- tesseract for OCR
- translate-shell for translations
- xdg-user-dirs, slurp, wl-clipboard
- And many more...

## Technical Details

### How It Works

1. **QuickShell Configuration**: Both `qs` and `quickshell` commands are wrapped with:
   - All required Qt6/QML module paths (QtPositioning, Qt5Compat, etc.)
   - Python environment in PATH for wallpaper analysis scripts
   - Fake virtual environment for compatibility with upstream scripts

2. **Configuration Management**:
   - Dotfiles are copied (not symlinked) to `~/.config/` for writability
   - The `illogical-impulse/config.json` is only copied on first setup
   - Subsequent changes to settings are preserved across rebuilds
   - QuickShell can modify its configuration without conflicts

3. **Automatic Updates**:
   - Change your dotfiles source URL and rebuild to update
   - Settings changes in QuickShell persist across updates
   - User customizations are preserved

### Environment Variables

The following are automatically set:
- `ILLOGICAL_IMPULSE_DOTFILES_SOURCE`: Points to `~/.config`
- `ILLOGICAL_IMPULSE_VIRTUAL_ENV`: Python environment for scripts
- `qsConfig`: QuickShell configuration path
- `QML2_IMPORT_PATH`: Qt module paths for QuickShell
- `QT_QPA_PLATFORMTHEME`: KDE platform theme integration

## System Requirements

- **NixOS**: 23.11+ (unstable/25.05+ recommended)
- **Architecture**: x86_64-linux, aarch64-linux
- **Graphics**: Hardware acceleration recommended for smooth animations
- **Memory**: 4GB+ RAM (8GB+ recommended)
- **Storage**: ~3-4GB for all packages and dependencies

## Troubleshooting

### QuickShell not starting
- Check that your username is correct in the configuration
- Verify home-manager is properly integrated
- Look at logs: `journalctl --user -u home-manager-yourusername.service`

### Wallpaper colors not changing
- Ensure the wallpaper is set correctly
- Python environment should be automatically available
- Try manually: `quickshell -c ~/.config/quickshell/ii`

### Settings not persisting
- Most settings save automatically to `~/.config/illogical-impulse/config.json`
- Some UI updates may require a system rebuild to take effect

### SHA256 hash errors
When updating dotfiles source:
1. Change the URL/rev in your configuration
2. Set `sha256 = "";` (empty string) or use `lib.fakeSha256`
3. Run rebuild - it will fail with the correct hash
4. Copy the correct hash from the error message
5. Update your configuration and rebuild again

### Missing packages
All required packages are included by default. If something is missing, please open an issue.

## Known Limitations

- **First Build**: Initial build downloads ~3GB of packages - subsequent builds are much faster
- **Home Manager Required**: This flake uses home-manager for configuration management

## Updating

### Update the flake itself
```bash
nix flake update illogical-flake
sudo nixos-rebuild switch --flake .#yourhostname
```

### Update your dotfiles source
Change the `rev` or `sha256` in your configuration and rebuild.

### Update all inputs
```bash
nix flake update
sudo nixos-rebuild switch --flake .#yourhostname
```

## Credits

- **[end-4](https://github.com/end-4)** - Creator of the stunning Illogical Impulse dotfiles
- **[xBLACKICEx](https://github.com/xBLACKICEx)** - Original NixOS flake that inspired this implementation
- **[outfoxxed](https://git.outfoxxed.me/outfoxxed/quickshell)** - QuickShell developer
- **[hyprwm](https://github.com/hyprwm)** - Hyprland compositor team
- **[vaxerski](https://github.com/vaxerski)** - Hyprland lead developer

## License

This flake packaging is provided as-is. The original dotfiles and their dependencies have their own licenses. See the [end-4/dots-hyprland repository](https://github.com/end-4/dots-hyprland) for details.

## Contributing

Contributions are welcome! Please:
- Test changes thoroughly before submitting
- Keep the flake minimal and focused on proper NixOS integration
- Don't modify upstream dotfiles - keep changes in the NixOS module layer
- Open issues for bugs or feature requests

## Support

For issues specific to:
- **This flake**: Open an issue in this repository
- **The dotfiles themselves**: See [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland)
- **QuickShell**: See [QuickShell repository](https://git.outfoxxed.me/outfoxxed/quickshell)
- **Hyprland**: See [Hyprland repository](https://github.com/hyprwm/Hyprland)

---

**Enjoy your beautiful Material Design 3 desktop! 🎨**
