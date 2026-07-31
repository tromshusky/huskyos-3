# HuskyOS — computers made easy 🐾💻

HuskyOS is a friendly, ready-made NixOS setup for families and people who just want their computer to work — like a smartphone, but for a full PC. It uses well-supported pieces (GNOME, Flatpak, signed boot) and puts them together so updates, resets, and app installs feel simple and safe.

## Why you'll like it 😊
- Fast, safe updates: updates are "atomic" — they switch the whole system at once and you can undo them if something breaks. The updater only rebuilds what changed, so updates are quick.
- Easy factory reset: user files and system files are kept separate, so wiping a machine for a kid or guest is quick without re-downloading everything.
- Apps are sandboxed: apps come from Flatpak (like apps on your phone) and are isolated from your personal files unless you allow access.
- Secure boot and signed images: boot code can be signed so the machine boots only trusted software.

## How it's different from Windows (in simple terms) 🔍
- Safer updates and simple rollbacks — no more worrying an update bricked the PC. 
- App sandboxing by default (less chance of apps snooping around your files). 
- Faster resets and less downloading — the system reuses parts that didn’t change, so upgrades are lighter.

## Quick peek 👀
This repo is a Nix flake that builds a HuskyOS system image and small helper scripts for install, reset, and updates. It aims to keep maintenance upstream in NixOS so HuskyOS stays small and maintainable.

## Try it / Learn more ➡️
If you’re comfortable downloading an image and trying a new OS, we can add a simple ISO + GUI installer and an app-store-like experience for family-friendly apps. Want that? Open an issue or say “make the installer” and we’ll draft the plan.

Enjoy — and welcome to HuskyOS! 🎉
