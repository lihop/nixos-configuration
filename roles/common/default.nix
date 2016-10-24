{ config, pkgs, ... }:

rec {
  environment.variables = {
    EDITOR = "vim";
  };

  environment.sessionVariables = {
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  time.timeZone = "Pacific/Auckland";
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "dvp";
    defaultLocale = "en_NZ.UTF-8";
  };

  environment.systemPackages = with (import ../../envs { inherit pkgs; }); [
    environments.common
  ];

  programs.ssh = {
    startAgent = false;
  };
  programs.bash.enableCompletion = true;

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = false;

  networking.firewall.allowedTCPPorts = [ 22 ];

  services.printing = {
    enable = true;
  };

  nix.trustedBinaryCaches = [
    "https://cache.nixos.org"
    "https://hydra.server.geek.nz"
  ];
  nix.binaryCaches = nix.trustedBinaryCaches; 
  nix.binaryCachePublicKeys = [ "hydra.server.geek.nz:PuvqB5dPNOzATMJnkwEIENc8/9Hp8PCWGSTXnKjT8Kw=" ];

  users.extraGroups.leroy.gid = 1000;
  users.extraUsers.leroy = {
    isNormalUser = true;
    home = "/home/leroy";
    description = "Leroy Hopson";
    extraGroups = [ "wheel" "docker" "libvirtd" "leroy" "dialout" "video" ];
    uid = 1000;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCsJ44pUGqS8r73K0UuhTl9S7o2hENdSATug45Vb28UhuuBaiVIF8w0o7Q/sa0DhBowKB26Rre+9GJrvgglh4B3NcF/rlS9sHUAfyaAJ6bmp281buXL3FQEz4jYjfoxgX/n4aTTCfGf27eegQo/BF45aTFZEetcCQLTkh2HeihNOAMf+eUS+hDTdCvMHv2+spo9BTnogbCAy4V3Joka9tc3oskayneeY7vGhPbAMqCrI9mLRWN2f9vu8KEONEoJbhBmk8yoVW0rbICxfzNICWTJUEh4UV4R0We5eS2qhdXjSzVQf/pzQzNlOWkVL+tvi7P3KDFFrBli55qAwpE+y4qW0orao4E4f5bPcHHr5GbDQI5YN+V6DNBjT83S3t3LRafSFLGsLz1WYiAqQynDZbiigC2Kw7jzKWQ20qmwWTBQDfyhQM0JKeoyquEbCjlc7bV8vASJDPPzOe/uAVRC96FuqlGv665y+cpNEyWomFG1AyjzZAhh8e7//4F5bXbb/keQS3wnYXUq6wy0L9KYdhJzlFjySl3muZJnH8IL3vrSrI2tri/SQQwmATIM3NoMd4l9co2opchQkW2XMaVfU7yDdvt5Mkzp9/HqASjmVPW0G+aPokjyb1J+DfboeKAtwcJ/es2aRDNKIPWx2vH5r4/WzRzEgrdtHrwtz1eEN1wKDw== leroy@hilly"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC/8b8JkweYgWAuPFlKc8P1dNCQEPfqN9hi8UDKwhOt9N2qJLozA6xjgq5QtjkAGXfum/ez2AQ8pzqYBXc6YpFu1xmS2bP6hcB2XN4afeCa+9lvsyF60mnU5ny0bY/BMEmRfvMY/8rxvmjTI11alqC5RmIC1FIRo71UoFAtufYT8aDc9OvPBrBZP/C1KxBjWXMdHeX7/SNkqsCkKh29jKQdUaXYbV4IBWIniL5KTApM2W77cydB6/nBxY5KaXenx3zkOHLpJkee7AxNphqhe8d74F8I1IyKOcJV2U9UWc0ctjIi1oFAIfTtFTJaBrm3kTcXTTEkY6UA6uiFnKYSzWbcNOq+q8IfxLKCA4xQrM65bCerOhh46q95y9aN9QkkJghT6I8p7L7t8hhYE2o9njaUJXQoQBhqEz2kc+UFbCJZB7tuoSwh5DbDfjnHPt9Lga7DbJWK5H9Qn0DuQV5o22mFhEuag3y1COpybC87UnLZspiwNyVfGC2MtI7+/MZP8tIi4R5xo7RNl9a/mkSHycNwcOsSZNRzUDeYwibNlxDMy8q1d6qYz5r7QihgeU4+sn3FdFT+DeDyTfDnmyptAqu3V0ldu1t/Niot4H1+ViwMCTSoQO7GNRmWHZoQNoWUE7kRbG+cAuaqj8YIAVPErNeBUXR6rvfkTRGvtPTdXQ6i2Q== root@nixos"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9RMa88ozQvtuIxjvPhxUS1AuE1jvXF/TH2GwZfUp7WHOQQsO1ZpwyZGs9RHqn056wMTrY4d6x3CgezAWL9IJ/+6oPIR/iAqdRapYu48FZUcvkAFSXVTLXD2J7OGn7VDJGlDY+M64lMEb9oDIK3KfmoN+pj07MmjmHvZK2Ms3JMpGIL9QE36HEcdeeXRcTuFX5ZWr0I+dbR+ytoVbiIOj/oy/JH27wgfrX0CRzjRSbr6se2mC6jKHt+nTWt+U9sZ946IK2J4LwWDT/7NK+bz0+6HF/3xxuvZzDKNHnB3F5wiVXsBaYSKGFfcqeQMsekhvcIFjYL36t0wPU7Iw++pQi0ga2L7x2khHXshXR0rLKM+iiID4azyrXzxwPCn7ZYy+p1aZlpOkRyE2IWirAy5edG8E2bPqQinb3djG1cml4B3jYhZt2BbiNcJQRjGo7W+XDxMs84LDduci0mbva9P2/dYxbHZ30+uJ7L1rWorDeqPYdNoai2yjMRrm1r8x6Ot0em4GsZoCKlPwfJ6hhR7C44u9gsIFtYQv+SOZkrMbDYy4pZ1jNGkZ9EQIH3h8N67pmz1bz/xW0R/Wcz+C9vHv3KYBSDwBNSB1yve0gDT7oqoYDGBbIvJfCFve3OvYxVt7LJ/dxH1+2RnP2kI4/GNfi0Un3WXxKYe8/oOJz+tbmjQ== leroy@peaches"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC78/H0GPELM0KFIdgV4xFCeKdjJrQwXF9ZIukWd49GQu5sCrwATXVnFhihl5WKNHvr7lFgWaH1DozD6CMin6QF5WsR5/vBFmhI2wOu/SiAyyjgiK3iAOO2erL+5lXgNjfvubXjDm3noI/28ttrUWHpo6987nkpEUCNdj/GL065XjfnNXqnJTQwvptUybH9qNqMEz0/tBbHsrVEQWnabId6/BWxY2GlWTlthWm4thZXe0XaUcU/0BlzzdUDXnePO3mX3kpRRUl2T3izjiJgJt7BUDxt8X1/aQ8Ry+yDZ7fQmNlkbWLw0OtlnHkABThYjkL1qm4gyWN8KVSQAcqIWybaDdepXW6mr6zj2u+1mNKw39/NbO1vufWJJCBlKtbAAZa0qUUN36W4+9l7o/Pii8BjVwqqwh48xyPecD9jrwcBbwu4gY6O160upiFZ++LYF2yrpzLCelc+Kc2y9HJahDIbDHkMbj8AOJ/o/QvgollLu6//YNZ1QyNPtS2XMBRiLPxEpdmEb3PGqI8nhy5N7J2VqfOO826JtluAr62DMrW7+BJJa8wlJBCOUZ8HFLELOrD0FGla/fnMxqZcMYoH8yZyI1zKPZxZEV+Qt2HKSiCU4sbd6FlSPhADwGr4r/+Wf2EJeqRaEMF+S+BclsWyzhQzI554iMIs9HLFSBxkD10Xbw== leroy@zeno"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5F2m2zeLTHg3jS1xaBGWk6xqzu5DT76A1C8eZYwHoJRzCrneztY/3eVSV9jCSvC1hKVfrp8lWEccsBEiOFkTuubOIjP1CU1XGMvv2ZTTvhqp6rw4jfWdR3xA6uC0A75jq63WEvicPysBSg8hRz7lZKZ9aERMbbMasumXuK3NgyUMz2ByBYgeJKKjD7KBvJHWd8G+DkqrtgknvMtFcA3u/P+pmU4GQzoToENWOpDID44vygqGdcfTtFSdqQAoIvYV+4rn5l41VH01qQuZOL7nT/Ffihr5Qhzt6M9HbdacH//kUHfU2200SMjWhu3KJBFNoNaZy41YqWMqmV7jrLdhVokfIMhs9Rlt4NME7YjGZwjYMpy+U0IZqHF1WLjE6K/FlkUQKGITbKasuvxG0F8LpDK+bx2Wt4Y3Rhq7v7Ym32E8mC63klC7/OthgAwEsmAOcv8nIoRcVhJX6d5DUIrLgWFnkQupy6XUBhLEIBuT3l7ktq+xfPiVzjVyEYTfkTfhI/UlJvNAy2w2uhbKyk1B8GnRugbQ1+shK7iyDB27247mvWBoUwX6Y4Z4QHlsI98deWvudGz6imb0On4YivB6llJ5dOgjZs00vIfMja6AHMX/ZsnYW7+JTiBMQat19uKFyA3RBDJzvwJufdYEXLbfFwWEHTFrEX6nUZe32I2cXRw== lih18@cssecs1"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC9xH6kEz/U+zHb0IkkKVRcaRxzo8L8o/4M8hVVzbs2STfnvziHSEMXnqxLAhRpdgeRbunCScmLGt6XEG9csxliR1eIUxNP4fmhRoQxVPLvY+s/zl7s9MMlKZt/M9ohqPq5nG+gLWD1itI3ShYZyyxd6FYRNssaMih7N8Z5ZMz+WE3fyJLThCsSEkji8911jTMpFMtRMfJlGMnVGUPPK0e10RKeQSgRsa3C86DMSQLBKCsL7CoEmwX4tOX0xCG94CV9Clj8npcNijK7iaTRfbtaLCVwpOC1z2ujUz5EOW1FsuSMZ9AAhIz0jtsQCzp0sBGu0gfKsHmpEadEgBuH958M1MgUezzeSb79coCPo3lmRyY6HsYsx06Hmi6MFYvm1y9Znl8ejrGBx5vnVrmLldQA4/0D5BgOG1cOIhg1dU3SGaBolL4z31KfdAYh9QvoKo4j2aSeOO+53Foi2UdMNBnP5X36wgOw+eK+lHfDANmKn/yl7bIGMtuFobFGHYoyywAzPYVDyFajeAXCxU3RosqcFqixjfFLfhCxaqHCKzPB7JDJNyP2Q4ASrmOqciSDAkbj+foCJ7G2vkGe6KCgqMuZb4Yig4gYhZYoTnczZQ9MdXIeWGALN3oGtOnmSyHEBI7/rkYxciQQazD9THCuvXIuxfz1CdC163eli2jMoORjMQ== leroy@nowmac-12s-MBP"
    ];
  };

  nix.extraOptions = ''
    auto-optimise-store = true
  '';

  nix.buildCores = 0;

  users.extraUsers.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC78/H0GPELM0KFIdgV4xFCeKdjJrQwXF9ZIukWd49GQu5sCrwATXVnFhihl5WKNHvr7lFgWaH1DozD6CMin6QF5WsR5/vBFmhI2wOu/SiAyyjgiK3iAOO2erL+5lXgNjfvubXjDm3noI/28ttrUWHpo6987nkpEUCNdj/GL065XjfnNXqnJTQwvptUybH9qNqMEz0/tBbHsrVEQWnabId6/BWxY2GlWTlthWm4thZXe0XaUcU/0BlzzdUDXnePO3mX3kpRRUl2T3izjiJgJt7BUDxt8X1/aQ8Ry+yDZ7fQmNlkbWLw0OtlnHkABThYjkL1qm4gyWN8KVSQAcqIWybaDdepXW6mr6zj2u+1mNKw39/NbO1vufWJJCBlKtbAAZa0qUUN36W4+9l7o/Pii8BjVwqqwh48xyPecD9jrwcBbwu4gY6O160upiFZ++LYF2yrpzLCelc+Kc2y9HJahDIbDHkMbj8AOJ/o/QvgollLu6//YNZ1QyNPtS2XMBRiLPxEpdmEb3PGqI8nhy5N7J2VqfOO826JtluAr62DMrW7+BJJa8wlJBCOUZ8HFLELOrD0FGla/fnMxqZcMYoH8yZyI1zKPZxZEV+Qt2HKSiCU4sbd6FlSPhADwGr4r/+Wf2EJeqRaEMF+S+BclsWyzhQzI554iMIs9HLFSBxkD10Xbw== leroy@zeno"
  ];

  # Add builduser to the list of trusted users so that it can build derivations
  nix.trustedUsers = [ "builduser" ];

  users.extraUsers.builduser = {
    useDefaultShell = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCYdVPvJcVvPERJwXe9PVtvpYRDVRV1axT6vUt+H3vww5loFxv2oJvI6TJD2xZ1zekT7BCKIy7jq+t2b4tDQNta/h5J/wsQ2InMNuvqAv5XyWCTBrdGU38ow9jQsxSFe8GyTPMez/FudqU/qKgC2B8gyWv6PUdniwOUQl1Pe13R6PMiXKL9e1WeBbnTlZ7YpjSHbmxCXQa1lEUnZWA9TeJD2t1thgP4gBGhED4z3GnYE3oOl6zzWXM4j9suEiafjmJ6QKndstJOHUF1rPf7PgFOsbt6VXJ8hLZczBvGrkzUTHknoLkOKbOOJFSMUDmTf29i8vhOR2/cWMDnM6JFeLikfVeYK5dsAIRVQE16+octcOP3qklGpWyNrTOCNxVoqZYLi3JpWe65CNw9C9Pj8OzbIXjnBI4ycU0EA1T0N01uWCnc/gyOqZj7MaO7tgNlk1B4xzfdNM8jfYttwMCQpefl+AJPdFrndHTfA7gPwAzIcEjfSGWVM3bWDPUk3P18gaVqx9kuxqEE5ClaIS5z160+xvFKxb/E6yHaEVdnJrqC6Q0aNV1z5PXlSRVT6OR3nOHSuV2yqC7FMc2IaMMRU0j9tARopjLtd69X/CYk4bvdgrtneMYUVO/XOiEas4H6LQxQTqgZ96kDSDex/QcFyMVW3UMqkuaAY0rFTLH1isbEBw== root@zeno"
    ];
  };
}
