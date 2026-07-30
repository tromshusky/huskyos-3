# HuskyOS — family-friendly NixOS customizations

HuskyOS is a small collection of NixOS configuration and helpers that make a modern, family-friendly desktop based on NixOS. It keeps the maintenance work with upstream NixOS and composes existing, well-supported pieces (GNOME, Flatpak/Flathub, signed UEFI images, btrfs) into a single, easy-to-understand setup.

This repository contains the flake and modular configuration for HuskyOS. It is designed to be stable, easy to reset, and safe for family computers — while still giving power users the full reproducible benefits of Nix.

Why HuskyOS is great for families

- Friendly and predictable updates: HuskyOS uses Nix builds for system images. Updates are atomic — when an update is applied the whole system switches to a new generation, and you can roll back easily. The updater only rebuilds the parts that changed, so updates are fast and bandwidth-friendly.
- Fast resets and recovery: The system separates writable data (userdata and systemdata) from system images using btrfs subvolumes. That means cleaning or resetting a machine is quick and safe without re-downloading a full installer image.
- App sandboxing and safe apps: Apps are run from Flatpak/Flathub and confined to per-user .var folders, improving isolation between applications and protecting personal files.
- Clear separation of user files vs system: Personal files live in a userdata area while system/runtime data lives in systemdata. This makes backups, migrations, and parental controls simpler to implement.
- Secure boot-friendly: HuskyOS supports building a signed UEFI image and signing it with sbctl, then switching the boot entry automatically. This keeps the boot process secure and seamless for families.

Easy to understand — not a fork

HuskyOS does not re-implement Linux or NixOS. Instead it composes NixOS with a small set of opinions and scripts so you get a friendly desktop experience while upstream keeps the heavy lifting. That means less maintenance for the HuskyOS project and more reliability for you.

What you get today (high level)

- A flake-based NixOS configuration that builds a system called `huskyos`.
- Btrfs subvolume layout for /nix, /userdata, /systemdata and a tmpfs root for fast boot/resets.
- Systemd services to bind userdata and systemdata into standard Linux paths so applications behave normally while data stays isolated.
- An update script that builds the next UEFI image (uki), signs it, installs it into the EFI partition and rotates boot entries. This enables atomic updates and easy rollback.
- GNOME desktop defaults (auto-login optional) and fetched wallpapers to make machines look friendly out of the box.
- Small helper scripts for emergency reset and system reset.

Quick start (developer / tester)

> These are the minimal commands to build the system on a machine that already has Nix. Follow a full install guide before using these on production machines.

```bash
# Build the UEFI image and system to a local out-link (requires network and nix)
nix build .#nixosConfigurations.huskyos.config.system.build.{uki,toplevel} --print-out-paths --out-link /nix/var/nix/gcroots/next-system

# Install and sign the UEFI image (run as root)
uki=$(nix build .#nixosConfigurations.huskyos.config.system.build.{uki,toplevel} --print-out-paths --out-link /nix/var/nix/gcroots/next-system | head -n1)/nixos.efi
sudo cp "$uki" /boot/efi/boot/BOOTX64-unsigned.EFI
sudo sbctl sign /boot/efi/boot/BOOTX64-unsigned.EFI
sudo mv --force --no-target-directory /boot/efi/boot/BOOTX64-unsigned.EFI /boot/efi/boot/BOOTX64_NEXT.EFI

# Clean old builds
sudo nix-collect-garbage --delete-older-than 3d
```

Important files and expectations

- flake.nix — exposes the huskyos NixOS configuration
- configuration.nix — main configuration that imports modules
- filesystems.nix — btrfs/EFI device layout (expects `EFI` and `BTR` path files in the flake folder)
- critical.nix — update script, auto-upgrade and boot rotation logic
- bind-mounts.nix — places userdata/systemdata into regular paths using bind mounts
- gnome.nix, wallpaper.nix — desktop choices and defaults
- huskyos-reset-system.sh / huskyos-emergency-full-reset.sh — helper scripts

What makes HuskyOS family-friendly (plain language)

- Safe updates: Updates never overwrite your personal files. If an update behaves badly you can boot the previous version.
- Fast "factory reset": Because the OS uses btrfs subvolumes and keeps system data separate, resetting a machine for a child or guest is much faster than re-installing a whole image.
- Safer apps: Applications installed as Flatpaks run in a contained space. They can't casually modify your personal files unless you explicitly allow it.
- Consistent look-and-feel: A default GNOME setup and curated wallpapers make it approachable for children and parents alike.

Planned and suggested features (we will add these to the repo)

- Downloadable ISO with a simple GUI installer: Produce a signed ISO that users can boot and install using a graphical installer that walks through disk setup, accounts, and a one-click factory snapshot.
- One-click parental profiles: Predefined user profiles (Child, Teen, Adult) with sensible defaults (time limits, allowed applications, web filtering via optional add-on).
- App store UI: A simple curated Flatpak app-store UI that points to Flathub and recommends family-friendly apps.
- Easy backup + restore UI: Tools to snapshot userdata and restore or migrate to another machine.
- Automatic nightly builds: Build artifacts (signed UEFI images, ISOs) published to a releases page for easy downloads.
- Graphical first-run wizard: Guides users through privacy, update cadence, and which apps to allow.

Contributing and roadmap

HuskyOS is meant to be small and composable. If you want to help:

- File issues for bugs and feature ideas.
- Open PRs for installer components, build pipelines (ISO/installer), or better GNOME/Flatpak defaults.
- Suggest family-friendly app lists for the curated store.

Security and privacy

HuskyOS prefers sandboxed apps (Flatpak) and signed boot images. The system is reproducible via Nix flakes so the build inputs are visible — this helps audits and trust.

Next steps

We will add a `README-technical.md` that explains the layout and design decisions for power users and an `INSTALLER.md` with step-by-step install instructions. If you want a guided installer or an ISO download page, say so and we will prioritize a simple GUI installer and nightly ISO builds.

License

See LICENSE in this repository.

Enjoy HuskyOS! If you are new to Nix we are happy to help — open an issue and tell us what you want the desktop to do for your family.
