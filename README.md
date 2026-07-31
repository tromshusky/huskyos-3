# HuskyOS — computers made easy 🐾💻

HuskyOS is a friendly, ready-made Linux for families and people who just want their computer to work — like a smartphone, but for a full PC. It uses well-supported pieces (GNOME, Flatpak, signed boot) and puts them together so updates, resets, and app installs feel simple and safe.

## Why you'll like it 😊
- Small by default: HuskyOS itself is quite empty, compared to Smartphones, that come full of apps you never asked for. On the first launch you can then download all you need, or look for the apps you need on the Flathub store at anytime.
- Fast, safe updates: updates are "atomic" - the update prepares in the background and is activated instantly when booting the computer the next time - zero waiting time. The updater only rebuilds what changed, so not much internet is needed, and updates are quick.
- Easy factory reset: Apps and Settings are in a container, that you can discard at any time instantly, whilst keeping your documents.
- Apps are sandboxed: apps come from Flatpak and are isolated from your personal files.
- Secure boot and rootless software: once HuskyOS is installed, no app can modify the core system but the updater. That makes it almost impossible to break it.

## How it's different from Windows (in simple terms) 🔍
- 100% Ownership, 0% Cost: you decide what's on your system, no ads and nothing commercial is part of the system.
- Annoying-free: No update popus, apps or ai that is forced onto you
- App stores and App sandboxing: No app you install can break your computer. 
- Faster resets and less downloading — the system reuses parts that didn’t change, so upgrades are lighter.

## Quick peek 👀
This repo is a Nix flake that builds a HuskyOS system image and small helper scripts for install, reset, and updates. It aims to keep maintenance upstream in NixOS so HuskyOS stays small and maintainable.

## Try it / Learn more ➡️
If you’re comfortable downloading an image and trying a new OS, we can add a simple ISO + GUI installer and an app-store-like experience for family-friendly apps. Want that? Open an issue or say “make the installer” and we’ll draft the plan.

Enjoy — and welcome to HuskyOS! 🎉
