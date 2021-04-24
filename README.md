# cw-borg-backup
Automated backup scripts using Borg Backup and systemd.

This will backup the source files and folders of your choice to a
[Borg](https://borgbackup.readthedocs.io/en/stable/) repository of your choice.
You can (and should) run it daily and for now it will keep 7 daily, 4 weekly,
12 monthly and unlimited yearly archives of your source files.

# Installation
Fork and then clone the repository.
1. Install `borg` on your system.
1. Create the directory `/etc/borg-backup`.
1. Create the symbolic links `/etc/borg-backup/config` and `/etc/borg-backup/archives`
   to point to the file/directory with the same name in your cloned git repository.
1. Edit the config file and the directories and files in `archives/` to reflect your wishes (see below).
1. Edit the service file such that `ExecStart` points to the script in the git repository.
   You might also need to fix the `[Unit]` section for your personal situation.
1. Copy cw-borg-backup.service and cw-borg-backup.timer from the repository to
   `/etc/systemd/system/cw-borg-backup.service` and `/etc/systemd/system/cw-borg-backup.timer`
   respectively. These can't be symbolic links when the repository is on a mounted
   filesystem (as oppose to the root).

# Configuration
To add a new archive, create a directory in `/etc/borg-backup/archives` containing
a file `patterns`. See the `borg-patterns(1)` man page for a description of its format.

# Automated backups
To run the script daily, start the systemd timer:
```bash
systemctl enable cw-borg-backup.timer
systemctl start cw-borg-backup.timer
```
or, run
```bash
systemctl enable --now cw-borg-backup.timer
```
to immediately start a backup.

# Verification
New backup files should appear in `BORG_REPO` as defined in the config file.
Also make sure that the timer is enabled and active with:
```bash
systemctl status cw-borg-backup.timer
```
and is listed in the output of
```bash
systemctl list-timers
```
Check that after a reboot this is still the case.
