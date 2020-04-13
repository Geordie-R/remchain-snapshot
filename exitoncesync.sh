synclog=/root/data/snapshots/sync.log
touch $synclog
echo -999999999999 > $synclog



their_head_block_num=$(remcli -u https://rem.eon.llc/ get info| jq '.head_block_num')
our_head_block_num=$(remcli get info | jq '.head_block_num')
sleep 1



echo "THEIRS: $their_head_block_num and OURS: $our_head_block_num"
# Now we wait for last irreversible block to pass our snapshot taken

if [[ $our_head_block_num -eq $their_head_block_num ]]; then
echo 0 > $synclog
echo "chain synced (a)"
else



while [[ 1 -eq 1 ]]
do


their_head_block_num=$(remcli -u https://rem.eon.llc/ get info| jq '.head_block_num')
our_head_block_num=$(remcli get info | jq '.head_block_num')

ans=$(($their_head_block_num-$our_head_block_num))
echo "ans is $ans"
echo $ans > $synclog
if [[ $their_head_block_num -le $our_head_block_num ]] ; then

                echo "SYNCED as ans is $ans (b)"
break
else
echo "Block $our_head_block_num < $their_head_block_num"
        fi

done

fi


echo "Issuing stop chain command..."
./stop.sh
