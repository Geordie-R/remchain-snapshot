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
statehistory=$datafolder/state-history
snapshotsfolder=$datafolder/snapshots
lastdownloadfolder=$snapshotsfolder/lastdownload

# create download folder in snapshots
mkdir -p $lastdownloadfolder
cd $lastdownloadfolder
echo "clearing lastdownload folder"
#rm -f *.bin

#download the latest snapshot
#latestsnapshot=$(curl -s https://geordier.co.uk/snapshotsfull/latestsnapshot.php)
#echo "downloading full snapshot please wait..."
#wget -c https://www.geordier.co.uk/snapshotsfull/$latestsnapshot -q --show-progress
#echo "exiting..."
#exit 1









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
rm -rf $statefolder


if [[ $snapresult -eq 1 ]]
then


mkdir -p $lastdownloadfolder/snapshot
cd $lastdownloadfolder/snapshot






echo "Downloading snapshot now..."
  wget -c https://www.geordier.co.uk/snapshots/$snap -q --show-progress  -O - | sudo tar -Sxz --strip=4
  echo "Downloaded Snapshot $snap"
fi


if [[ $blocksresult -eq 1 ]]
then

mkdir -p $lastdownloadfolder/blocks
cd $lastdownloadfolder/blocks


echo "Downloading blocks log now from https://www.geordier.co.uk/snapshots/blocks/$blocks"

  wget -c https://www.geordier.co.uk/snapshots/blocks/$blocks -q --show-progress -O - | sudo tar -Sxz --strip=3
  echo "Blocks log downloaded:  $blocks"
cp -a $lastdownloadfolder/blocks/. $blocksfolder/
fi



if [[ $stateresult -eq 1 ]]
then
echo "Downloading state history now from https://www.geordier.co.uk/snapshots/state-history/$state"

mkdir -p $lastdownloadfolder/state-history
cd $lastdownloadfolder/state-history
  wget -c https://www.geordier.co.uk/snapshots/state-history/$state -q --show-progress -O - | sudo tar -Sxz --strip=3

  echo "State history downloaded:  $state"
cp -a $lastdownloadfolder/state-history/. $statehistory/
fi

#exit 1;

echo "NOTGERTHERE"




#UPTOHERE BELOW

#wget -c https://www.geordier.co.uk/snapshotsfull/$latestsnapshot -O - | sudo tar -Sxz --strip=4
binfile=$lastdownloadfolder/snapshot/*.bin

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

# start remnode with snapshot
cd ~



if [[ $stateresult -eq 1 ]]
then
echo "Starting REMChain - state history start version"
remnode --config-dir $configfolder/ --snapshot $binfile --disable-replay-opts --data-dir $datafolder/ >> $logfile 2>&1 &
else
echo "Starting REMChain"
remnode --config-dir $configfolder/ --snapshot $binfile --data-dir $datafolder/ >> $logfile 2>&1 &
fi



sleep 3
tail -f $logfile
