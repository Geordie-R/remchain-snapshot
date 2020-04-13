# REMChain Snapshots

#IMPORTANT PLEASE READ

If you wish to retain a historical API, be warned, this solution will DELETE any previous block data as at the moment I do not offer blocks.log files to go with the snapshot.  This will be covered in a future improvement to this solution.
---
This readme is split into two parts.  
1)  Taking a snapshot i.e. what i do to upload them to my webserver for you to be able to download them.
2)  Restoring from a snapshot. 

# Taking a snapshot

## Install dependencies
* [jq](https://stedolan.github.io/jq/) - command line json parser
```
sudo apt-get install jq -y
```

## takesnapshot.sh
This file takes the snapshot, compresses it and sends it to the VPS. This is for my own benefit or for anyone else that would like to take a snapshot (must have the producer API enabled).

To install the takesnapshot.sh do the following
```
mkdir -p /root/data/snapshots/
cd /root/data/snapshots/
sudo rm -rf takesnapshot.sh
sudo wget https://raw.githubusercontent.com/Geordie-R/remchain-snapshot/master/takesnapshot.sh && sudo chmod +x takesnapshot.sh
```

Now we can add this to crontab manually for now and choose to run it every 24hours etc
```
crontab -e
```

Now add the following line to run it at every 3am
```
0 3 * * * /root/data/snapshots/takesnapshot.sh
```
# Restoring a snapshot
## restoresnapshot.sh - Without autorun

This will download the restoresnapshot.sh to your snapshot folder WITHOUT running restoresnapshot.sh.  For automatically running the script immediately after download, see the next section below called with autorun.

```
mkdir -p /root/data/snapshots/
cd /root/data/snapshots/
sudo rm -rf restoresnapshot.sh
sudo wget https://raw.githubusercontent.com/Geordie-R/remchain-snapshot/Geordie-R-v2/restoresnapshot.sh && sudo chmod +x restoresnapshot.sh
```
## restoresnapshot.sh - With autorun
The code below is identical to the code above but it actually runs it immediately afterwards.

```
mkdir -p /root/data/snapshots/
cd /root/data/snapshots/
sudo rm -rf restoresnapshot.sh
sudo https://raw.githubusercontent.com/Geordie-R/remchain-snapshot/Geordie-R-v2/restoresnapshot.sh && sudo chmod +x restoresnapshot.sh && ./restoresnapshot.sh
```
Once everything has synced use Ctrl + C to cancel out but please fire it up right away using the code below

```
remnode --config-dir ./config/ --data-dir ./data/ >> remnode.log 2>&1 &
```
Now when you press Ctrl + C, it will run successfully in the background this time.



