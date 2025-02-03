# script-backup-files

Full copy all files and subfolders to archive.zip(deflate 9).
Support notify to telegram bot.
Support copy to two dest:
* folder on any disk;
* folder on samba (or any other folder on any disk).

Install:
* copy ```bac.sh``` to ```YOUR_PATH```;
* edit ```bac.sh``` (set variable in beginned script);
* copy ```bac.service``` to ```/etc/systemd/system/```;
* copy ```bac_timer.service``` to ```/etc/systemd/system/```;
* edit ```/etc/systemd/system/bac.service``` (change to path to your ```bac.sh```);
* sudo systemctl enable ```bac.service```;
* sudo systemctl enable ```bac_timer.service```;
* sudo systemctl start ```bac_timer.service```;
* test!

P.S.:
for first test run command:
* sudo systemctl start ```bac.service```.
