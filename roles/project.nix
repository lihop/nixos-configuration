{ config, pkgs, ... }:

let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    toolsVersion = "25.2.5";
    platformToolsVersion = "28.0.1";
    buildToolsVersions = [ "28.0.1" ];
    platformVersions = [ "28" ];
    useGoogleAPIs = true;
    includeExtras = [
      "extras;google;gcm"
    ];
  };

  responsiveTheme = pkgs.stdenv.mkDerivation {
    name = "responsive-theme";
    src = pkgs.fetchurl {
      url = http://wordpress.org/themes/download/twentytwenty.1.2.zip;
      sha256 = "0rrj8nwaiphf057ss334c8nrvg6frky72isf9p82pk7smqdcsii8";
    };
    buildInputs = [ pkgs.unzip ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  akismetPlugin = pkgs.stdenv.mkDerivation {
    name = "akismet-plugin";
    src = pkgs.fetchurl {
      url = https://downloads.wordpress.org/plugin/akismet.3.1.zip;
      sha256 = "1wjq2125syrhxhb0zbak8rv7sy7l8m60c13rfjyjbyjwiasalgzf";
    };
    buildInputs = [ pkgs.unzip ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
  woocommercePlugin = pkgs.stdenv.mkDerivation {
    name = "woocommerce-plugin";
    src = pkgs.fetchurl {
      url = https://downloads.wordpress.org/plugin/woocommerce.4.0.1.zip;
      sha256 = "16ic5hj304szmbz6nw1k7ld0z9bwylr1yfh9751gs1lxl8hmj61s";
    };
    buildInputs = [ pkgs.unzip ];
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  woocommerceLangVi = pkgs.stdenv.mkDerivation {
    src = pkgs.fetchurl {
      url = "https://translate.wordpress.org/projects/wp-plugins/woocommerce/stable/vi/default/export-translations/?format=mo";
      sha256 = pkgs.lib.fakeSha256;
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };

  wpGraphqlPlugin = pkgs.stdenv.mkDerivation {
    name = "wpGraphql-plugin";
    src = pkgs.fetchFromGitHub {
      owner = "wp-graphql";
      repo = "wp-graphql";
      rev = "v0.8.3";
      sha256 = "1m1gfmiq518pgnf05w3hb64yjbibaqmj82gxvhcsmv4zsi29j1fj";
    };
    installPhase = "mkdir -p $out; cp -R * $out/";
  };
in

{
  programs.adb.enable = true;
  users.users.leroy.extraGroups = ["adbusers"];

  nixpkgs.config.android_sdk = {
    accept_license = true;
  };

#  # Install VirtualBox for Genymotion
#  virtualisation.virtualbox.host = {
#    enable = true;
#    enableHardening = false;
#  };
#  users.extraGroups.vboxusers.members = [ "leroy" ];
#  # Fix issue https://github.com/NixOS/nixpkgs/issues/6037
#  boot.cleanTmpDir = true;
#
  environment.systemPackages = with pkgs; [
    #androidComposition.androidsdk
    android-studio
    awscli
    #dfeet
    #docker_compose
    #dotnetPackages.Paket
    #fastlane
    #gd
    #genymotion
    #gitlab-runner
    #gitAndTools.git-filter-repo
    #jdk
    #jetbrains.idea-ultimate
    #k6
    kops
    kubectl
    kubectx
    kubernetes-helm
    #kustomize
    #libimobiledevice
    #(libguestfs.override {appliance = libguestfs-appliance;})
    #minio-client
    #mongodb
    #mongodb-tools
    nodejs-13_x
    #nodePackages.node2nix
    #nodePackages.react-native-cli
    #pkgconfig
    #python
    #react-native-debugger
    #robo3t
    slack
    #virt-viewer
    vscode
    #(vscode-with-extensions.override {
    #  vscodeExtensions = with vscode-extensions; [
    #    bbenoist.Nix
    #    #ms-dotnettools.csharp
    #    #ms-vscode.cpptools
    #  ] ++ vscode-utils.extensionsFromVscodeMarketplace [
    #    # Misc
    #    {
    #      name = "vscode-apollo";
    #      publisher = "apollographql";
    #      version = "1.14.4";
    #      sha256 = "1zv5vzmf1c2a3v207ix1kh4fwhp7a2vcwx0lmmgr24g2a74q84w5"; 
    #    }
    #    {
    #      name = "debugger-for-chrome";
    #      publisher = "msjsdiag";
    #      version = "4.12.6";
    #      sha256 = "1dlplz72830shqbi7zkgg7pb45ijwajwhkmapx4lmlw13z41jw1g"; 
    #    }
    #    {
    #      name = "vscode-eslint";
    #      publisher = "dbaeumer";
    #      version = "2.1.1";
    #      sha256 = "11ybn0hrarp1v06zjql9lcbvr70ryhij8v2v23q45gm0qgmpk5ib"; 
    #    }
    #    {
    #      name = "debugger-for-chrome";
    #      publisher = "msjsdiag";
    #      version = "4.12.6";
    #      sha256 = "1dlplz72830shqbi7zkgg7pb45ijwajwhkmapx4lmlw13z41jw1g"; 
    #    }

    #    # C#
    #    {
    #      name = "Ionide-Paket";
    #      publisher = "Ionide";
    #      version = "2.0.0";
    #      sha256 = "1455zx5p0d30b1agdi1zw22hj0d3zqqglw98ga8lj1l1d757gv6v";
    #    }

    #    # Database
    #    {
    #      name = "sqltools";
    #      publisher = "mtxr";
    #      version = "0.21.6";
    #      sha256 = "0iyxmj29p6ymnvjwraxxh883gm3asn25azbg1v6dqam700bjlgr2";
    #    }
    #    #{
    #    #  name = "vscode-postgres";
    #    #  publisher = "ckolkman";
    #    #  version = "1.1.11";
    #    #  sha256 = "0xr5x6a3qncky55wd7v3wp8df3lyvjsl8xz35x8hhwam0niy35wq"; 
    #    #}

    #    #{
    #    #  name = "jshint";
    #    #  publisher = "dbaeumer";
    #    #  version = "0.10.21";
    #    #  sha256 = lib.fakeSha256;
    #    #}
    #    #{
    #    #  name = "beautify";
    #    #  publisher = "HookyQR";
    #    #  version = "1.5.0";
    #    #  sha256 = lib.fakeSha256;
    #    #}
    #    #{
    #    #  name = "npm";
    #    #  publisher = "eg2";
    #    #  version = "0.3.11";
    #    #  sha256 = lib.fakeSha256;
    #    #}
    #    #{
    #    #  name = "npm-intellisense";
    #    #  publisher = "christian-kohler";
    #    #  version = "1.3.0";
    #    #  sha256 = lib.fakeSha256;
    #    #}

    #    # Common
    #    {
    #      name = "vim";
    #      publisher = "vscodevim";
    #      version = "0.16.12";
    #      sha256 = "07j5mm6ghrdbvwnlw3qap7276n74l41ww28xljffkiq0qmbhnr8i";
    #    }

    #    # Git
    #    {
    #      name = "gitlens";
    #      publisher = "eamodio";
    #      version = "10.1.0";
    #      sha256 = "1j3mi0lwjy8va5mx6vkg9rx3k1lzjhrwaichg22hm7n5sgg8bgrd";
    #    }

    #    # Javascript
    #    {
    #      name = "prettier-vscode";
    #      publisher = "esbenp";
    #      version = "2.3.0";
    #      sha256 = "0jv1pzm8bpd7ajvl797gbvxllic1ir8lwc93lq54bdyaizj9sbvz";
    #    }

    #    # Nix
    #    {
    #      name = "nix-env-selector";
    #      publisher = "arrterian";
    #      version = "0.0.7";
    #      sha256 = "1xg3kyvrhjn34k4zfab5qdxk70rf5hdz3viicyr67qwak9jx36qa";
    #    }

    #    # Rust
    #    {
    #      name = "rust";
    #      publisher = "rust-lang";
    #      version = "0.6.3";
    #      sha256 = "1r5q1iclr64wmgglsr3na3sv0fha5di8xyccv7xwcv5jf8w5rz5y";
    #    }
    #    {
    #      name = "vscode-rust";
    #      publisher = "kalitaalexey";
    #      version = "0.4.2";
    #      sha256 = "03hjx2xcilikp8cfswr7jljm683c1w5gcngjadxlsvcmybsgzhh2";
    #    }
    #    #{
    #    #  name = "rust-test-lens";
    #    #  publisher = "hdevalke";
    #    #  version = "0.1.2";
    #    #  sha256 = "1shayly4m5mqhyn90bxhpac3mjkkv5ddr8h477xdbpv4dvgljim3";
    #    #}
    #    #{
    #    #  # Dependency of rust-test-lens
    #    #  name = "vscode-lldb";
    #    #  publisher = "vadimcn";
    #    #  version = "1.3.0";
    #    #  sha256 = "1ac6inzpc15ghdk063mvlh90p4d0ykqp4mqfhyhsg2pyjpw76vpm";
    #    #}

    #    # Godot
    #    {
    #      name = "godot-tools";
    #      publisher = "geequlim";
    #      version = "0.3.7";
    #      sha256 = "0fa8n32v50jjb1y4kd6nz80g1sgh88qqfmf571cjv10bx5cr26ky";
    #    }

    #    #{
    #    #  name = "vsliveshare";
    #    #  publisher = "ms-vsliveshare";
    #    #  version = "0.3.954";
    #    #  sha256 = "0rs8cnk50xkgg6jj2krfzwpwwfada83y56sf7q9vs7iaapa8w1vy";
    #    #}
    #    #{
    #    #  name = "vsliveshare-pack";
    #    #  publisher = "ms-vsliveshare";
    #    #  version = "0.2.2";
    #    #  sha256 = "1chvdwl2lrsnqkixivi3xgb02h3inp4h4d80171gjxdvd4xlrvf7";
    #    #}
    #  ];
    #})
    (yarn.overrideAttrs (oldAttrs: {
      # Use different version of nodejs with yarn.
      buildInputs = [ nodejs-12_x ];
    }))

    # cycool
    #clang
    #dbus_libs

    # Project management.
    #ganttproject-bin
    #plantuml

    #cypress

    #travis
  ];

  # Set environment variables required by PlantUML LaTeX plugin.
  #environment.variables.PLANTUML_JAR = "${pkgs.plantuml}/lib/plantuml.jar";
  #environment.variables.GRAPHVIZ_DOT = "${pkgs.graphviz}/bin/dot";

  # cycool
  #environment.variables.LIBCLANG_PATH = "${pkgs.llvmPackages.libclang}/lib";

  services.postgresql = {
    enable = false;
    package = pkgs.postgresql_12;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
    initialScript = pkgs.writeText "postgres-init-script" ''
      CREATE USER leroy;
      ALTER USER leroy WITH SUPERUSER;

      CREATE USER nodejs WITH PASSWORD 'nodejs';
      ALTER USER nodejs WITH SUPERUSER;

      CREATE DATABASE "hocphatam";
      GRANT ALL PRIVILEGES ON DATABASE hocphatam TO leroy;
      GRANT ALL PRIVILEGES ON DATABASE hocphatam TO nodejs;
    '';
  };

  docker-containers.pgadmin4 = {
    autoStart = false;
    image = "dpage/pgadmin4:4.15";
    ports = [
      "5433:80"
    ];
    volumes = [
      "/var/lib/pgadmin:/var/lib/pgadmin"
    ];
    environment = {
      PGADMIN_DEFAULT_EMAIL = "postgres@postgres.com";
      PGADMIN_DEFAULT_PASSWORD = "postgres";
      PGADMIN_LISTEN_PORT = "5433";
    };
    extraDockerOptions = [
      "--network=host"
    ];
  };

  # nhà thuốc gia đình
  #services.wordpress."webservice5" = {
  #  database = {
  #    host = "127.0.0.1";
  #    name = "wordpress";
  #    passwordFile = pkgs.writeText "wordpress-insecure-dbpass" "wordpress";
  #    createLocally = true;
  #  };
  #  themes = [ responsiveTheme ];
  #  plugins = [ akismetPlugin woocommercePlugin wpGraphqlPlugin ];
  #  virtualHost = {
  #    adminAddr = "admin@example.com";
  #    serverAliases = [ "webservice5" "www.webservice5" ];
  #  };
  #};
}
