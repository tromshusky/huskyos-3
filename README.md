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

- Rolling release (carefully): Like an app that gets regular updates, HuskyOS receives ongoing improvements and fixes. We balance freshness with stability so everyday users get updates without surprises.

- Atomic updates: Updates are downloaded and prepared quietly in the background, then activated at reboot — just like a phone. If something goes wrong, you can boot the previous working version.

- sudo disabled by default: On phones you don't run apps as the system. HuskyOS disables sudo by default so people don't accidentally change critical system parts. When administrative access is needed, there are safe, documented ways to do it.

- Secure Boot enabled by default: This is like a phone's verified boot. It checks the system hasn't been tampered with before starting, making it much harder for malware to hijack the core system.

Together these choices make HuskyOS predictable and hard to break while remaining flexible for power users.

## How it's different from Windows (simple terms) 🔍
- You control your system: no forced apps, no ads, and no commercial software bundled into the OS.
- Less noise: no surprise pop-ups, forced AI features, or apps shoved onto you.
- Safer apps: sandboxing prevents installed apps from breaking the system or accessing your files without permission.
- Faster resets and smaller upgrades: resets are quick because user data is separate, and upgrades reuse unchanged parts so they download less.

## Quick peek 👀
This repository is a Nix flake that builds the HuskyOS system image and small helper scripts for install, reset, and updates. All base-system code lives in this repo and is intentionally kept small and simple so you can read and understand how things fit together without a computer science degree. The whole point is to assemble a modern system from well-supported upstream components rather than reinvent core pieces.

Enjoy — and welcome to HuskyOS! 🎉
