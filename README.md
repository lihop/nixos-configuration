This is a work in progess. Some quick pointers...

Deploy the machines in logical.nix and physical.nix with nixops:
```
nixops create -d <deployment-name> logical.nix physical.nix
nixops deploy -d <deployment-name>
```

Install environments declared in the `envs` directory:
```
ln -s config.nix ~/.nixpkgs/config.nix
nix-env -iA nixos.environments.<environment>.<sub-environment>
```

Install using nixos-rebuild (not implemented yet):
```
ln -s <this-repo> /etc/nixos
nixos-rebuild switch
```
