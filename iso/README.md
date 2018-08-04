# NixOS ISO Builder
Build a bootable NixOS ISO image inside a docker container.

The main purpose of these files is to help me install NixOS on a Macbook Pro.
The standard installation CD boots on Mac but is missing many important kernel modules.
This is an attempt to create a bootable ISO for the Macbook from the Macbook.

## Usage
```sh
docker-compose up
```

Will use the nixos config specified in the `config` directory to build a bootable iso file.
The iso will be copied to the `out` directory (which will be created if it doesn't exist).

You can then use `dd` to create a bootable usb stick.
Linux:
```sh
dd if=./out/<iso-name>.iso of=/dev/sdX bs=1M
```
Mac:
```sh
dd if=./out/<iso-name>.iso of=/dev/rdiskX bs=1m
```
