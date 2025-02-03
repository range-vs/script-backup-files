SOURCE_DIR="YOUR_SRC_DIR"
DEST_DIR="YOUR_DEST_DIR"
DEST_SMB_DIR="YOUR_DEST_SAMBA_DIR"
TOKEN="YOUR_TG_BOT_TOKEN"
CHAT_ID="YOUR_TG_CHAT_ID"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ZIP_NAME="bec_$TIMESTAMP.zip"

# create arch
zip -r -9 "$DEST_DIR/$ZIP_NAME" "$SOURCE_DIR"

cd "$DEST_DIR"
ls -t | grep -E 'bec_.*\.zip' | sed -n '4,$p' | xargs -d '\n' rm -f --

cp "$DEST_DIR/$ZIP_NAME" "$DEST_SMB_DIR"
cd "$DEST_SMB_DIR"
ls -t | grep -E 'bec_.*\.zip' | sed -n '4,$p' | xargs -d '\n' rm -f --

FILE_SIZE=$(du -BG "$DEST_DIR/$ZIP_NAME" | cut -f1)

BACKUPS_LIST=$(ls -lh --time-style=long-iso "$DEST_DIR"/bec_*.zip | awk '{print $8, $6, $5}' | column -t)
BACKUPS_SMB_LIST=$(ls -lh --time-style=long-iso "$DEST_SMB_DIR"/bec_*.zip | awk '{print $8, $6, $5}' | column -t)

MESSAGE="backup ok, date ${DATE}, size file ${FILE_SIZE}%0Alist backups:%0A${BACKUPS_LIST}\%0Alist backups:%0A${BACKUPS_SMB_LIST}"

curl -s -X POST "https://api.telegram.org/bot${TOKEN}/sendMessage" \
    -d chat_id="${CHAT_ID}" \
    -d text="${MESSAGE}"