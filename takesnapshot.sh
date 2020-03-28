#!/bin/bash
# Local Folder Params #####################################################
datafolder=/root/data
statehistoryfolder=$datafolder/state-history
blocksfolder=$datafolder/blocks
snapshotsfolder=$datafolder/snapshots
compressedfolder=$snapshotsfolder/compressed/

#Script files #############################################################
shcreate=$snapshotsfolder/compressandsendlastsnapshot.sh
shcreatefull=$snapshotsfolder/compressandsendlastsnapshot_full.sh
shcreatefullstate=$snapshotsfolder/compressandsendlastsnapshot_fullstate.sh

#Remote Server Params #####################################################
remote_server_folder=/var/www/geordier.co.uk/snapshots
remote_user=root@website.geordier.co.uk

#Misc Params ##############################################################
sshportno=22
datename=$(date +%Y-%m-%d_%H-%M)
filename="$compressedfolder$datename"
chainstopped=0
#End of Parameters ########################################################

mkdir -p $compressedfolder
chmod +x $compressedfolder

thehour=$(date +"%H")
#thehour=0

#Run every 3 hours a day by MOD the hour by 3
if [[ $(($thehour%3)) -eq 0 ]]
then



echo "# Snapshot Only Start. Hour is $thehour #"

snapname=$(curl http://127.0.0.1:8888/v1/producer/create_snapshot | jq '.snapshot_name')
rm -f $shcreate
touch $shcreate && chmod +x $shcreate
echo "tar -Scvzf $filename-snaponly.tar.gz $snapname" >> $shcreate
echo "ssh -p $sshportno $remote_user 'find $remote_server_folder -name \"*.gz\" -type f -size -1000k -delete'" >> $shcreate
echo "ssh -p $sshportno $remote_user 'ls -F $remote_server_folder/*.gz | head -n -8 | xargs -r rm'" >> $shcreate
echo "rsync -rv -e 'ssh -p $sshportno' --progress $filename-snaponly.tar.gz $remote_user:$remote_server_folder" >> $shcreate
echo "Sending snapshot only..."
$shcreate

else
echo "Snapshot is not due..Aborting"
fi


#Run twice a day by MOD the hour by 12
if [[ $(($thehour%12)) -eq 0 ]]
then


echo "Get Head and Irreversible Block Numbers"
head_block_num=$(remcli get info | jq '.head_block_num')
last_irr_block_num=$(remcli get info | jq '.last_irreversible_block_num')

# Now we wait for last irreversible block to pass our snapshot taken
while [ $last_irr_block_num -le $head_block_num ]
do
        last_irr_block_num=$(remcli get info | jq '.last_irreversible_block_num')
ans=$head_block_num-$last_irr_block_num
        echo "Last Irreversible Block $last_irr_block_num < $head_block_num - $ans remaining"
        sleep 10
done

echo "Last Irreversible Block Number Passed - Great, Lets Continue!"

echo "Stopping the chain"
~/stop.sh
chainstopped=1


echo "#Blocks Log Start #"
rm -f $shcreatefull
touch $shcreatefull && chmod +x $shcreatefull
echo "tar -Scvzf $filename-blockslog.tar.gz $blocksfolder/blocks.log $blocksfolder/blocks.index" >> $shcreatefull
echo "ssh -p $sshportno $remote_user 'find $remote_server_folder/blocks -name \"*.gz\" -type f -size -1000k -delete'" >> $shcreate
echo "ssh -p $sshportno $remote_user 'ls -F $remote_server_folder/blocks/*.gz | head -n -1 | xargs -r rm'" >> $shcreatefull
echo "rsync -rv -e 'ssh -p $sshportno' --progress $filename-blockslog.tar.gz $remote_user:$remote_server_folder/blocks" >> $shcreatefull
echo "Sending blocks..."
$shcreatefull
else
echo "Blocks Log is not due..Aborting"
fi



#Run twice a day by MOD the hour by 12
if [[ $(($thehour%12)) -eq 0 ]]
then

echo "#State History Start #"
rm -f $shcreatefullstate
touch $shcreatefullstate && chmod +x $shcreatefullstate
echo "tar -Scvzf $filename-statehistory.tar.gz $statehistoryfolder  " >> $shcreatefullstate
echo "ssh -p $sshportno $remote_user 'find $remote_server_folder/state-history -name \"*.gz\" -type f -size -1000k -delete'" >> $shcreate
echo "ssh -p $sshportno $remote_user 'ls -F $remote_server_folder/state-history/*.gz | head -n -1 | xargs -r rm'" >> $shcreatefullstate
echo "rsync -rv -e 'ssh -p $sshportno' --progress $filename-statehistory.tar.gz $remote_user:$remote_server_folder/state-history" >> $shcreatefullstate
echo "Sending state history..."
$shcreatefullstate
else
echo "State History is not due...Aborting"
fi


############ Cleanup ##############
echo "Cleaning Up..."
rm -f $shcreate
rm -f $shcreatefull
rm -f $shcreatefullstate
rm -R $snapshotsfolder/*.gz
rm -R $snapshotsfolder/*.bin
rm -R $compressedfolder/*.gz
rm -R $statehistoryfolder/*.gz
rm -R $blocksfolder/*.gz

if [[ $chainstopped -eq 1 ]]
then
echo "Starting chain..."
cd ~
./start.sh
fi
echo "We are done"
