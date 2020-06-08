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
1. Edit the config file and the directories and files in archives/ to reflect your wishes (see below).
1. Create time symbolic links `/etc/systemd/system/cw-borg-backup.service` and
   `/etc/systemd/system/cw-borg-backup.timer` to point to the files with the same name
   in your cloned git repository.
1. Edit the service file such that `ExecStart` points to the script in the git repository.
   You might also need to fix the `[Unit]` section for your personal situation.

# Automated back ups
To run the script daily, start the systemd timer:
```bash
systemctl enable cw-borg-backup.timer
systemctl start cw-borg-backup.timer
```
