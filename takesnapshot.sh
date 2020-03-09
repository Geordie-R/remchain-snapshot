#!/bin/bash
###### Parameter Section #####
sshportno=466
datename=$(date +%Y-%m-%d_%H-%M)
snapshotsfolder=/root/data/snapshots
shcreate=$snapshotsfolder/compressandsendlastsnapshot.sh
compressedfolder=$snapshotsfolder/compressed/
filename="$compressedfolder$datename.tar.gz"
mkdir -p $compressedfolder
chmod +x $compressedfolder
snapname=$(curl http://127.0.0.1:8888/v1/producer/create_snapshot | jq '.snapshot_name')

rm -f $shcreate
touch $shcreate && chmod +x $shcreate

#List all .gz files especially the last 5 by filename aand remove the rest
ls -F $compressedfolder*.gz | head -n -5 | xargs -r rm
echo "tar -cvzf $filename $snapname" >> $shcreate
rm -f $snapname
echo "rsync -rv -e 'ssh -p $sshportno' --progress $filename root@website.geordier.co.uk:/var/www/geordier.co.uk/snapshots" >> $shcreate
$shcreate
