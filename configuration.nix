# My NixOS + Orbstack configuration
# /etc/nixos/configuration.nix in the VM imports this file at
# ${HOME}/etc/nixos/configuration.nix on host
#
# not much to see here at the moment, or maybe ever
#
# (+) everything I like about macos
# (+) everything I like about linux
# (+) host stays pristine
# (+) while also having great host integration [orbstack]
# (+) extremely light on resources [orbstack]
# (+) easy to manage configuration [nix]
# (+) easy to recreate environment [nix]
# (-) Nix documentation leaves a lot to be desired


# home manager configs: https://home-manager-options.extranix.com

{ config, pkgs, modulesPath, ... }:

let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in
{
  imports =
    [
      #<home-manager/nixos>
      (import "${home-manager}/nixos")
    ];

  environment.systemPackages = [ pkgs.zsh ];
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  home-manager.useUserPackages = true;
  home-manager.users.josh = { pkgs, ... }: {
    home.sessionPath = [
      "/Users/josh/opt/bin"
      "\$\{HOME\}/bin"
    ];

    home.packages = [
      pkgs.ack
      pkgs.docker-client
      pkgs.docker-compose
      pkgs.dockerfile-language-server-nodejs
      pkgs.git
      pkgs.go
      pkgs.inetutils
      pkgs.nix-search-cli
      pkgs.nodejs
      pkgs.openssh
      pkgs.postgresql
      pkgs.python3
      pkgs.shellcheck
      pkgs.shfmt
      pkgs.sipcalc
      pkgs.sqlite
      pkgs.tailscale
      pkgs.textql
    ];
    programs.neovim.enable = true;
    programs.ssh.enable = true;
    programs.bash.enable = false;
    programs.home-manager.enable = true;
    programs.nnn.enable = true;
    programs.tmux.enable = true;
    programs.git.enable = true;
    programs.zsh.enable = true;
    programs.starship.enable = true;


    programs.tmux = {
      #mouse = true;
      #keyMode = "vi";
      clock24 = true;
      extraConfig = ''
	      set-option -g set-titles on
        set-option -g set-titles-string "#{session_name} - #{host}"
      '';
    };
    programs.git = {
	    ignores = [ ".secret" ".secrets"];
    };
    programs.zsh = {
      autocd = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      plugins = [{
	      name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }];
      shellAliases = {
        ll = "ls -la";
	      nix-edit   = "sudo nvim /etc/nixos/configuration.nix";
	      nix-reload = "sudo nixos-rebuild switch";
	      dc = "docker-compose";
	      g = "git";
	      n = "nnn";
	      ts = "tailscale";
	      m = "~~"; # mac home
	      o = "~"; # orbstack home
      };
    initExtra = ''
      ~~(){
        cd "$( sudo mac sh -c 'echo ~' )"
      }
      reminder(){
        local -r uuid="''${1}"
        local -r url='shortcuts://x-callback-url/run-shortcut?name=open-reminder&input=text&text='
        sudo open "''${url}''${uuid}"
      }
      nova(){
        open -a Nova ''${@}
      }
    '';
   };

    programs.neovim = {
	    defaultEditor = true;
	    viAlias = true;
	    vimAlias = true;
	    extraConfig = ''
    	  set number relativenumber
  	  '';
    };
    programs.starship = {
      # Configuration written to ~/.config/starship.toml
      settings = {
        add_newline = false;

        # character = {
        #   success_symbol = "[➜](bold green)";
        #   error_symbol = "[➜](bold red)";
        # };

        # package.disabled = true;
      };
    };
#
#    # The state version is required and should stay at the version you
#    # originally installed.
    home.stateVersion = "23.11";
  };

  system.stateVersion = "24.05";
}
