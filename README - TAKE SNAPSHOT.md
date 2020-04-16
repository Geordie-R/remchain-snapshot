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

Now add the following line to run it every hour (What runs exactly is determined inside the file.  snapshots every 3 hours, blocks every 12 and state history every 24 hours / once per day is the default.
```
0 * * * * /root/data/snapshots/takesnapshot.sh
```
