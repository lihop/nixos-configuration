let
  makeBackend = ip: device: {
    deployment.targetEnv = "none";
    deployment.targetHost = ip;

    imports = [
      device
    ];
  };
in
{
  nz1 = makeBackend "127.0.0.1" ./devices/desktop;
  au1 = makeBackend "45.32.244.132" ./devices/vultr-vps;
  au2 = makeBackend "45.63.25.28" ./devices/vultr-vps;
}
