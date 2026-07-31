# HuskyOS — computers made easy 🐾💻

HuskyOS is a friendly, ready-made Linux for families and people who just want their computer to work — like a smartphone, but for a full PC. It assembles a modern, reliable system from trusted upstream components (GNOME, Flatpak, signed boot, and Nix) so we don't have to reinvent the wheel.

## Why you'll like it 😊
- Small by default: the core system is intentionally minimal so you only add the apps you want.
- Fast, safe updates: system updates are atomic — they prepare in the background and switch in on reboot with no long waits.
- Easy factory reset: user apps and settings live in a disposable container you can discard while keeping your documents.
- Sandboxed apps: applications come from Flatpak and are isolated from your personal files.
- Secure by default: Secure Boot is enabled and the core system is read-only to apps; only the updater can change it.

## Design choices — explained like a smartphone 📱
HuskyOS is made to feel simple and safe, like using a phone, but for a full PC. Here are the main decisions and what they mean for you:

- Rolling release: Like an app that gets regular updates, HuskyOS receives ongoing improvements and fixes.

- Atomic updates: Updates are downloaded and prepared quietly in the background, then activated at reboot — just like a phone. If something goes wrong, it automatically boots a backup version.

- Not rooted by default: On phones you need to take intentional steps to modify the core system. In contrast to other Linux systems, HuskyOS does not ship with sudo and disallows to run commands on root level, that could potentially harm the system.

- Secure Boot enabled by default: Like your smartphone, it starts only with the intended Operating System (now HuskyOS). No virus can secretly install a malicious Operating System. 

Together these choices make HuskyOS predictable and hard to break while remaining flexible for power users.

## How it's different from Windows (simple terms) 🔍
- You control your system: no forced apps, no ads, and no commercial software bundled into the OS.
- Less noise: no surprise pop-ups, forced AI features, or apps shoved onto you.
- Safer apps: sandboxing prevents installed apps from breaking the system or accessing your files without permission.
- Faster resets and smaller upgrades: resets are quick because user data is separate, and upgrades reuse unchanged parts so they download less.

## Quick peek 👀
This repository is a Nix flake that builds the HuskyOS system image and small helper scripts for install, reset, and updates. All base-system code lives in this repo and is intentionally kept small and simple so you can read and understand how things fit together without a computer science degree. The whole point is to assemble a modern system from well-supported upstream components rather than reinvent core pieces.

Enjoy — and welcome to HuskyOS! 🎉
