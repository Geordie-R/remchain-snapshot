#!/bin/bash

# This script provides a seperate log watch to calculate the sync progress
# of the node.  Every 2 seconds it writes the new difference between our
# head blocknumber and an external nodes head block number.

externalAPI=https://rem.eon.llc/

function writePercentage() {


##
##  \r = carriage return
##  \c = suppress linefeed
##


diff=$(($2-$1))
sumit=$(awk "BEGIN {print ($diff/$2)*100}")
percentage=$(awk "BEGIN {print (100 - $sumit) }")
#roundme=$(echo $percentage | awk '{print int($1+0.5)}')
echo -en "\r$percentage% Chain Sync Completed\c\b"
}



synclog=/root/data/snapshots/sync.log
touch $synclog
#Set a stupid low figure to start
echo -999999999999 > $synclog



their_head_block_num=$(remcli -u https://rem.eon.llc/ get info| jq '.head_block_num')
our_head_block_num=$(remcli get info | jq '.head_block_num')
sleep 1


 blockdiff=$(($their_head_block_num-$our_head_block_num))
echo "BLOCK HEIGHT DIFFERENCE: $blockdiff BLOCKS - THEIR HEAD BLOCK NUMBER: $their_head_block_num - OURS: $our_head_block_num"
# Now we wait for last irreversible block to pass our snapshot taken

if [[ $our_head_block_num -eq $their_head_block_num ]]; then
        echo 0 > $synclog
        #Were already sync
else



        while [[ 1 -eq 1 ]]
                do


                        their_head_block_num=$(remcli -u $externalAPI get info| jq '.head_block_num')
                        our_head_block_num=$(remcli get info | jq '.head_block_num')

                        blockdiff=$(($their_head_block_num-$our_head_block_num))

                        echo $blockdiff > $synclog
                        if [[ $their_head_block_num -le $our_head_block_num ]] ; then
                                break
                                # Weve sync'd!
                        else
                                writePercentage $our_head_block_num $their_head_block_num
                                #Dont need to loop too fast.  Sleep for a few secs
                                sleep 2

                        fi
                done

fi


echo "Issuing stop chain command..."
./stop.sh
