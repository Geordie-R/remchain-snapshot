#!/bin/bash
###############################################################################################
#                                                                                            #
# ███████████   ██████████ ██████   ██████   █████████  █████                 ███            #
#░░███░░░░░███ ░░███░░░░░█░░██████ ██████   ███░░░░░███░░███                 ░░░             #
# ░███    ░███  ░███  █ ░  ░███░█████░███  ███     ░░░  ░███████    ██████   ████  ████████  #
# ░██████████   ░██████    ░███░░███ ░███ ░███          ░███░░███  ░░░░░███ ░░███ ░░███░░███ #
# ░███░░░░░███  ░███░░█    ░███ ░░░  ░███ ░███          ░███ ░███   ███████  ░███  ░███ ░███ #
# ░███    ░███  ░███ ░   █ ░███      ░███ ░░███     ███ ░███ ░███  ███░░███  ░███  ░███ ░███ #
# █████   █████ ██████████ █████     █████ ░░█████████  ████ █████░░████████ █████ ████ █████#
#░░░░░   ░░░░░ ░░░░░░░░░░ ░░░░░     ░░░░░   ░░░░░░░░░  ░░░░ ░░░░░  ░░░░░░░░ ░░░░░ ░░░░ ░░░░░ #
#                                                                                            #
#                                                                                            #
#                                                                                            #
#  █████████                                         █████                █████              #
# ███░░░░░███                                       ░░███                ░░███               #
#░███    ░░░  ████████    ██████   ████████   █████  ░███████    ██████  ███████             #
#░░█████████ ░░███░░███  ░░░░░███ ░░███░░███ ███░░   ░███░░███  ███░░███░░░███░              #
# ░░░░░░░░███ ░███ ░███   ███████  ░███ ░███░░█████  ░███ ░███ ░███ ░███  ░███               #
# ███    ░███ ░███ ░███  ███░░███  ░███ ░███ ░░░░███ ░███ ░███ ░███ ░███  ░███ ███           #
#░░█████████  ████ █████░░████████ ░███████  ██████  ████ █████░░██████   ░░█████            #
# ░░░░░░░░░  ░░░░ ░░░░░  ░░░░░░░░  ░███░░░  ░░░░░░  ░░░░ ░░░░░  ░░░░░░     ░░░░░             #
#                                  ░███                                                      #
#                                  █████                                                     #
#                                 ░░░░░                                                      #
# ███████████                     █████                                                      #
#░░███░░░░░███                   ░░███                                                       #
# ░███    ░███   ██████   █████  ███████    ██████  ████████   ██████  ████████              #
# ░██████████   ███░░███ ███░░  ░░░███░    ███░░███░░███░░███ ███░░███░░███░░███             #
# ░███░░░░░███ ░███████ ░░█████   ░███    ░███ ░███ ░███ ░░░ ░███████  ░███ ░░░              #
# ░███    ░███ ░███░░░   ░░░░███  ░███ ███░███ ░███ ░███     ░███░░░   ░███                  #
# █████   █████░░██████  ██████   ░░█████ ░░██████  █████    ░░██████  █████                 #
#░░░░░   ░░░░░  ░░░░░░  ░░░░░░     ░░░░░   ░░░░░░  ░░░░░      ░░░░░░  ░░░░░                  #


#From the manual
#Get the following:

#A portable snapshot (data/snapshots/snapshot-xxxxxxx.bin)
#The contents of data/state-history
#Optional: a block log which includes the block the snapshot was taken at. Do not include data/blocks/reversible.
#Make sure data/state does not exist
#Start nodeos with the --snapshot option, and the options listed in the state_history_plugin.
#Do not stop nodeos until it has received at least 1 block from the network, or it won't be able to restart.

# path definitions
logfile=/root/remnode.log
configfolder=/root/config
datafolder=/root/data
blocksfolder=$datafolder/blocks
statefolder=$datafolder/state
statehistoryfolder=$datafolder/state-history
snapshotsfolder=$datafolder/snapshots
lastdownloadfolder=$snapshotsfolder/lastdownload
startcreate=/root/startrestored.sh

# create download folder in snapshots
mkdir -p $lastdownloadfolder
cd $lastdownloadfolder
echo "clearing lastdownload folder"
rm -f *.bin

PS3='Please enter the menu number below: '
options=("Snapshot Only" "Snapshot and Blocks Log" "Snapshot and Blocks Log and State History" "Quit")
snaptypephp=""
select opt in "${options[@]}"
do
    case $opt in
        "Snapshot Only")
        snaptypephp="snap"
            echo "you chose snapshot only"
        break
            ;;
        "Snapshot and Blocks Log")
            echo "you chose blocks log and snapshot"
        snaptypephp="blocks"
        break
            ;;
       "Snapshot and Blocks Log and State History")
            echo "you chose state history and blocks log and snapshot"
        snaptypephp="state-history"
break
            ;;
        "Quit")
            break
            ;;
        *) echo "invalid option $REPLY";;
    esac
done




latestsnapshot=$(curl -s https://www.geordier.co.uk/snapshots/latestSnapshotType.php?type=$snaptypephp)
read -a arr <<< $latestsnapshot
state=${arr[0]};
blocks=${arr[1]};
snap=${arr[2]};
#echo "exiting"
#exit 1


function downloadType (){
#echo "this is: $1"
local result=0
  if [[ $1 == "NULL" ]]
  then
    result=0;
  else
    result=1;
  fi

echo $result
}


stateresult=$(downloadType "$state")
blocksresult=$(downloadType "$blocks")
snapresult=$(downloadType "$snap")
echo "stateresult is $stateresult"
echo "blocksresult is $blocksresult"
echo "snapresult is $snapresult"


rm -rf $blocksfolder*/
rm -rf $statefolder*/
echo "lets see"
ls $statefolder

if [[ $snapresult -eq 1 ]]
then


mkdir -p $lastdownloadfolder/snapshot
cd $lastdownloadfolder/snapshot



echo "Downloading snapshot now..."
  wget -Nc https://www.geordier.co.uk/snapshots/$snap -q --show-progress  -O - | sudo tar -Sxz --strip=4
  echo "Downloaded Snapshot $snap"
cp -a $lastdownloadfolder/snapshot/. $snapshotsfolder/
binfile=$(ls *.bin | sort -n | head -1)

fi


if [[ $blocksresult -eq 1 ]]
then

mkdir -p $lastdownloadfolder/blocks
cd $lastdownloadfolder/blocks


echo "Downloading blocks log now from https://www.geordier.co.uk/snapshots/blocks/$blocks"

  wget  -Nc https://www.geordier.co.uk/snapshots/blocks/$blocks -q --show-progress -O - | sudo tar -Sxz --strip=3
  echo "Blocks log downloaded:  $blocks"
cp -a $lastdownloadfolder/blocks/. $blocksfolder/
fi



if [[ $stateresult -eq 1 ]]
then
echo "Downloading state history now from https://www.geordier.co.uk/snapshots/state-history/$state"

mkdir -p $lastdownloadfolder/state-history
cd $lastdownloadfolder/state-history

wget  -Nc https://www.geordier.co.uk/snapshots/state-history/$state -q --show-progress -O - | sudo tar -Sxz --strip=3
echo "State history downloaded:  $state"
cp -a $lastdownloadfolder/state-history/. $statehistoryfolder/
fi


echo "copied files from lastdownload folder"

rm -R $lastdownloadfolder/*

echo "BIN IS $binfile"

function stopNode() {
echo "stopping node..."
# gracefully stop remnode
remnode_pid=$(pgrep remnode)

if [ ! -z "$remnode_pid" ]; then
    if ps -p $remnode_pid > /dev/null; then
        kill -SIGINT $remnode_pid
    fi
    while ps -p $remnode_pid > /dev/null; do
        sleep 1
    done
fi
echo "Node stopped"
}


function createStartNodeWithSnapshot() {
rm -f $startcreate
touch $startcreate && chmod +x $startcreate
echo "Creating $startcreate"
echo "echo \"Starting REMChain w Snapshot- CONFIG: $configfolder BINFILE: $snapshotsfolder/$binfile DATAFOLDER: $datafolder\"" >> $startcreate
echo "remnode --config-dir $configfolder/ --disable-replay-opts --snapshot $snapshotsfolder/$binfile --data-dir $datafolder/ >> $logfile 2>&1 &" >> $startcreate
}

function startNode() {
    echo "Starting REMChain - CONFIG: $configfolder BINFILE: $snapshotsfolder/$binfile DATAFOLDER: $datafolder"
  remnode --config-dir $configfolder/ --disable-replay-opts --data-dir $datafolder/ >> $logfile 2>&1 &
}

function startNodeSnapshot() {
    echo "Starting REMChain - CONFIG: $configfolder BINFILE: $snapshotsfolder/$binfile DATAFOLDER: $datafolder"
 remnode --config-dir $configfolder/ --disable-replay-opts --snapshot $snapshotsfolder/$binfile --data-dir $datafolder/ >> $logfile 2>&1 &
}


sleep 3
stopNode
sleep 1
# start remnode with snapshot
cd ~
sleep 1
echo "Creating and running startrestored.sh..."
#createStartNodeWithSnapshot
sleep 2
echo "starting now..."
#$startcreate
#remnode --config-dir $configfolder/ --disable-replay-opts --snapshot $snapshotsfolder/$binfile --data-dir $datafolder/ >> $logfile 2>&1 &
startNodeSnapshot


sleep 5
echo "Delegating to exitoncesync.sh please wait..."
$snapshotsfolder/exitoncesync.sh &
sleep 3



#Bit lazy but its late and 1=1 works right :D
while [[ "1" == "1" ]]
do
val=$(<$snapshotsfolder/sync.log)

if [[ $val -eq 0 ]]; then
echo "val is 0...breaking"
        break;
fi
        sleep 5
echo "$val blocks to go to catch up and sync"
done

echo "Synced in main!!!"
echo "final difference is blocks was $(<$snapshotsfolder/sync.log)"
rm $snapshotsfolder/sync.log
cd ~
echo "starting chain..."
startNode
#remnode --config-dir $configfolder/ --disable-replay-opts --data-dir $datafolder/ >> $logfile 2>&1 &
echo "FINISHED"
