#! /bin/bash

# This is a symbolic link to /usr/src/borg/cw-borg-backup/cw-borg-backup.conf,
# the canonical version in the git repository.
CONFIG_FILE=/etc/borg-backup/config

source $CONFIG_FILE

function fatal_error()
{
  echo "ERROR: $1"
  exit 2
}

# Sanity checks on BORG_REPO.
if [ -z "$BORG_REPO" ]; then
  echo "ERROR: No BORG_REPO set. Please edit $CONFIG_FILE."
  exit 2
fi
if [ ! -e "$BORG_REPO" ]; then
  echo "ERROR: $BORG_REPO does not exist."
  exit 2
fi
if [ ! -d "$BORG_REPO" ]; then
  echo "ERROR: $BORG_REPO is not a directory."
  exit 2
fi
if [ ! -w "$BORG_REPO" ]; then
  echo "ERROR: $BORG_REPO is not writable."
  exit 2
fi
# So we don't have to pass it to borg on the command line all the time.
export BORG_REPO

# Does it look like this is a Borg Backup repository?
if ! grep -sq '^additional_free_space = ' "$BORG_REPO/config"; then
  if [ -n "$(ls -A "$BORG_REPO")" ]; then
    echo "ERROR: $BORG_REPO doesn't look like a (readable) Borg Backup repository."
    exit 2
  fi
  echo "Creating NEW Borg Backup repository in $BORG_REPO..."
  if [ -z "$ENCRYPTION_MODE" ]; then
    echo "ERROR: No ENCRYPTION_MODE set. Please edit $CONFIG_FILE."
    exit 2
  fi
  /usr/bin/borg init --encryption="$ENCRYPTION_MODE" || fatal_error "'borg init' failed"
  if [ -n "$ADDITIONAL_FREE_SPACE" ]; then
    /usr/bin/borg config :: additional_free_space "$ADDITIONAL_FREE_SPACE" || fatal_error "'borg conf' failed"
  fi
fi

echo "Making backup using config $CONFIG_FILE"

for archive in $(find /etc/borg-backup/archives -follow -mindepth 1 -maxdepth 1 -type d -printf '%f\n'); do
  echo "Backing up $archive..."
  /usr/bin/borg create --noatime --exclude-caches \
    --patterns-from /etc/borg-backup/archives/$archive/patterns \
    "::$HOSTNAME-$archive-{now:%Y%m%d-%H%M%S}"
done
