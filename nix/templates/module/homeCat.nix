{ config, lib, inputs, ... }: let
  utils = inputs.nixCats.utils;
  # the options for this are defined at the end of the file,
  # and will be how to include this template module in your system configuration.
  cfg = config.myNixCats;
in {
  imports = [
    inputs.nixCats.homeModule
  ];
  config = {
    # this value, nixCats is the defaultPackageName you pass to mkNixosModules
    # it will be the namespace for your options.
    nixCats = lib.mkIf cfg.enable {
      # these are some of the options. For the rest see
      # :help nixCats.flake.outputs.utils.mkNixosModules
      # you do not need to use every option here, anything you do not define
      # will be pulled from the flake instead.
      enable = true;
      # this will add the overlays from ./overlays and also,
      # add any plugins in inputs named "plugins-pluginName" to pkgs.neovimPlugins
      # It will not apply to overall system, just nixCats.
      addOverlays = (import ./overlays inputs) ++ [
        (utils.standardPluginOverlay inputs)
      ];
      packageNames = [ "myHomeModuleNvim" ];

      luaPath = "${./.}";
      # you could also import lua from the flake though, by not including this.

      # categoryDefinitions.replace will replace the whole categoryDefinitions with a new one
      categoryDefinitions.replace = ({ pkgs, settings, categories, name, ... }@packageDef: {
        propagatedBuildInputs = {
          # add to general or create a new list called whatever
          general = [];
        };
        lspsAndRuntimeDeps = {
          general = [];
        };
        startupPlugins = {
          general = [];
          # themer = with pkgs; [
          #   # you can even make subcategories based on categories and settings sets!
          #   (builtins.getAttr packageDef.categories.colorscheme {
          #       "onedark" = onedark-vim;
          #       "catppuccin" = catppuccin-nvim;
          #       "catppuccin-mocha" = catppuccin-nvim;
          #       "tokyonight" = tokyonight-nvim;
          #       "tokyonight-day" = tokyonight-nvim;
          #     }
          #   )
          # ];
        };
        optionalPlugins = {
          general = [];
        };
        environmentVariables = {
          test = {
            CATTESTVAR = "It worked!";
          };
        };
        extraWrapperArgs = {
          test = [
            '' --set CATTESTVAR2 "It worked again!"''
          ];
        };
        extraPythonPackages = {
          test = [ (_:[]) ];
        };
        extraPython3Packages = {
          test = [ (_:[]) ];
        };
        extraLuaPackages = {
          test = [ (_:[]) ];
        };
      });

      # see :help nixCats.flake.outputs.packageDefinitions
      packages = {
        # These are the names of your packages
        # you can include as many as you wish.
        myHomeModuleNvim = {pkgs , ... }: {
          # they contain a settings set defined above
          # see :help nixCats.flake.outputs.settings
          settings = {
            wrapRc = true;
            # IMPORTANT:
            # you may not alias to nvim
            # your alias may not conflict with your other packages.
            aliases = [ "vim" "homeVim" ];
            # nvimSRC = inputs.neovim;
          };
          # and a set of categories that you want
          # (and other information to pass to lua)
          categories = {
            test = true;
            example = {
              youCan = "add more than just booleans";
              toThisSet = [
                "and the contents of this categories set"
                "will be accessible to your lua with"
                "nixCats('path.to.value')"
                "see :help nixCats"
              ];
            };
          };
        };
      };
    };
  };

}
