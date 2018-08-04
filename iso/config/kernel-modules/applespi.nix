with import <nixpkgs> {}; with linuxPackages_4_17;

stdenv.mkDerivation rec {
  name = "applespi-0.1+git2018-08-02-${kernel.version}";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "roadrunner2";
    repo = "macbook12-spi-driver";
    rev = "c6fa6a37fd9b1382b36044d418cd7cf2045c2b9f";
    sha256 = "1f6amh8ff4symh1anrx46zyikqz50l88gd0jknxz0l1qh8s50mkf";
  };

  nativeBuildInputs = kernel.moduleBuildDependencies;

  makeFlags = [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
    "INSTALL_MOD_PATH=$(out)"
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/roadrunner2/macbook12-spi-driver;
    description = ''
      Very simple, work in progress, input driver for the SPI keyboard/trackpad found on 12" MacBooks (2015 and later)
      and newer MacBook Pros (late 2016 and later), as well a simple touchbar driver for 2016 MacBook Pros.
    '';
    license = licenses.gpl2;
    maintainers = [ maintainers.lihop ];
    platforms = platforms.linux;
  };
}
