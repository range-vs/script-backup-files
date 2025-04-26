#!/bin/bash

SOURCE_DIR="YOUR_SRC_DIR"
DEST_DIR="YOUR_DEST_DIR"
DEST_SMB_DIR="YOUR_DEST_SAMBA_DIR"
TOKEN="YOUR_TG_BOT_TOKEN"
CHAT_ID="YOUR_TG_CHAT_ID"
KEY="[BACKUP_SERVICE]"

# mount smd resources
SMB_MOUNT_LOG=$(mount -a)
echo "$SMB_MOUNT_LOG"

# test connect to smb
SMB_MOUNTS=$(mount | grep smb)

if [ -z "$SMB_MOUNTS" ]; then
    CURL_OUTPUT_SMB=`curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
        -d chat_id="${CHAT_ID}" \
        -d text="${KEY} Error test connect to smb. Break"`
    echo "$CURL_OUTPUT_SMB"
    echo "${KEY}Error test connect to smb. Break"
    exit 1
fi

# create arch music
if [ ! -d "$DEST_DIR" ]; then
  echo "${KEY} Error: folder $DEST_DIR is not exist!"
  exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
  echo "${KEY} Error: folder $SOURCE_DIR is not exist!"
  exit 1
fi

zip -r -9 "$DEST_DIR/$ZIP_NAME" "$SOURCE_DIR"

# clear old arch from disk
cd "$DEST_DIR"
ls -t | grep -E 'music_bec_.*\.zip' | sed -n '4,$p' | xargs -d '\n' rm -f --

# copy to smb
if [ ! -f "$DEST_DIR/$ZIP_NAME" ]; then
  echo "${KEY} Error: file $DEST_DIR/$ZIP_NAME is not exist!"
  exit 1
fi

if [ ! -d "$DEST_SMB_DIR" ]; then
  echo "${KEY} Error: folder $DEST_SMB_DIR is not exist!"
  exit 1
fi

cp "$DEST_DIR/$ZIP_NAME" "$DEST_SMB_DIR"

# clear old arch from smb
cd "$DEST_SMB_DIR"
ls -t | grep -E 'music_bec_.*\.zip' | sed -n '4,$p' | xargs -d '\n' rm -f --

# tg
FILE_SIZE=$(du -BG "$DEST_DIR/$ZIP_NAME" | cut -f1)

BACKUPS_LIST=$(ls -lh --time-style=long-iso "$DEST_DIR"/music_bec_*.zip | awk '{print $8, $6, $5}' | column -t)
BACKUPS_SMB_LIST=$(ls -lh --time-style=long-iso "$DEST_SMB_DIR"/music_bec_*.zip | awk '{print $8, $6, $5}' | column -t)

MESSAGE="range music backup ok, date ${TIMESTAMP}, size file ${FILE_SIZE}%0Alist backups:%0A${BACKUPS_LIST}%0Alist backups:%0A${BACKUPS_SMB_LIST}"

echo "${KEY} Final msg copy output"
echo "${KEY} ${MESSAGE}"

CURL_OUTPUT=`curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
    -d chat_id="${CHAT_ID}" \
    -d text="${MESSAGE}"`

echo "${KEY} Curl output"
echo "${KEY} $CURL_OUTPUT"

# TODO: send error to tg