# systemd-boot-snapper-tools

A lightweight, robust suite of tools for Arch Linux to bridge the gap between **Snapper** snapshots and **systemd-boot** using Unified Kernel Images (UKIs).

## Why this exists?
Standard Snapper setups often fail to boot snapshots correctly because the kernel/modules version in the snapshot doesn't match the current kernel on the EFI partition. This suite solves that by:
1. **Kernel Pooling:** Archiving the exact kernel (UKI) used for every snapshot in a versioned pool.
2. **Automated Entries:** Creating `systemd-boot` entries automatically via a Snapper plugin.
3. **Kernel rollback:** Automatically restoring the correct kernel to the main boot path during a rollback.

## Components

| Script | Function |
| :--- | :--- |
| `snapper-boot-sync` | A Snapper plugin that syncs UKIs to the EFI pool and creates `.conf` entries. |
| `snapper-rollback` | Performs a writable rollback of the `@` subvolume from a chosen snapshot. |
| `snapper-prune-broken` | Cleans up orphaned snapshot directories and old rollback backups. |

## Installation

### Prerequisites
- **Filesystem:** Btrfs with a standard `@` and `@snapshots` layout.
- **Bootloader:** `systemd-boot` configured with Unified Kernel Images (UKIs) in `/boot/EFI/Linux/`.
- **Packages:** `snapper`, `btrfs-progs`, `binutils`.

### Install from Git
```bash
git clone [https://github.com/youruser/systemd-boot-snapper-tools.git](https://github.com/youruser/systemd-boot-snapper-tools.git)
cd systemd-boot-snapper-tools
sudo make install
```

## How it Works

### 1. Automatic Sync

When you run `snapper create`, the plugin triggers. It hashes your current UKI, copies it to `/boot/EFI/Linux/pool/<hash>.efi`, and creates a boot entry in `/boot/loader/entries/@snapshot-<id>.conf`.

### 2. Performing a Rollback

To revert your system to a previous state:

1. Identify the snapshot ID: `snapper list`
2. Run the rollback: `sudo snapper-rollback <id>`
3. Reboot.

On reboot, the script detects it is running from a snapshot path and ensures the main `arch-linux.efi` is synchronized with the kernel version required by that snapshot.

## Cleanup

Over time, your EFI partition may fill up with pooled kernels. Run the following to clean up entries for snapshots that no longer exist:

```bash
sudo snapper-boot-sync manual
```

To prune old `@_backup` subvolumes created during rollbacks:

```bash
sudo snapper-prune-broken

```

## License

GPLv3
