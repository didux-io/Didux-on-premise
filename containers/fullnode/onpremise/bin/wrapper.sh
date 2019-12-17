#!/bin/bash

echo "Launching Didux Blockchain..."

## Bootoptions
datadir="--datadir /opt/didux/data"
verbosity="--verbosity 2"
networkid="--networkid 1010"

syncmode="--syncmode full"
port="--port 21000"
rpc="--rpc --rpcaddr 0.0.0.0 --rpcvhosts=* --rpcapi personal,eth,net,web3,txpool,admin --rpccorsdomain '*' --rpcport 22000"
ws="--ws --wsaddr 0.0.0.0 --wsorigins '*' --wsapi personal,eth,net,web3,txpool --wsport 23000"
ipc="--ipcpath /opt/didux/data/didux.ipc"
disc="--v5disc"
smilobft="--maxpeers 128 --smilobft.blockperiod 1 --smilobft.requesttimeout 10000"
sport="--sport --onpremise"

mine="--mine"
gasprice="--miner.gasprice 1"
minerthreads="--miner.threads 1"

bootnodes="--bootnodes=enode://ab38484683ac9c9d499a42119a3938789d590ef855cb61b5a2ef66394455e60d5450ac12525f25d81fd7df671f3a9e0e5cd011390e421ee0e77273863d573f41@172.20.0.10:21000,enode://ff9f0d3725ddbeecb7b1c6dbd004273143710e8ef7fe5961ed9503509a74e5cf81918a9d152a3ad27d4b4424cceea0e0daf64f29201794e91db44c63c5c6d6db@172.20.0.2:21000,enode://e369746216e3246d6b6e570d76f86f6714f33230fa1fcfdfe0802f493c6b4da7a19d6b66212c7d8230f2afa1277c5f14ea9fac12ae24e7d71536f43e5fd3dba9@172.20.0.3:21000,enode://581c061680f1769badf6ca7dd1609ccfacebf332afafd27082575d0204ad0292630c267d4e6293c7aebddf725c5f07c1ee730f3ffd4bc79d071729c8d2da5cda@172.20.0.4:21000,enode://8fe8e1a5be95e4f7483d5fe38d6c3e0d001ec0386eeac828cfcb575736c07d5a1e965be20f438dd1873a73206a02d4d5bfa5478ced6ec6c60e70a1268f9802f6@172.20.0.5:21000,enode://4fb0d401e68e0c7fdf9a183a6a977e660501215ae5b7252929399b3dda713e42c9b3181a42e5a7959c6c875faae950004e56bb24e207827a3481d565c3aa6261@172.20.0.6:21000,enode://5dea91ff09bf3bc23fc381fb46d9282793e5e5da03584333ba448749b28749d8a5db582bac171c449f20dd4cecfc77920a115e72e8700ced2d625c316fe8df7a@172.20.0.7:21000"

cd /opt/didux/bin

## Initialize genesis block
initargs="$datadir $verbosity $networkid $sport"
if [ ! -d /opt/didux/data/geth ]; then
    echo "Initialising chain!"
    ./go-didux $initargs --bootnodes="" init /opt/didux/data/genesis.json
fi

## Prepare keys
if [ "$KEY" ]
then
    address=$(sed -n 's/^Address: 0x//p' /opt/didux/keys/key$KEY.info)
    password="--unlock $address --password /opt/didux/data/passwords.txt --allow-insecure-unlock"
    cp /opt/didux/keys/key$KEY /opt/didux/data/keystore/key
    cp /opt/didux/nodekeys/nodekey$KEY /opt/didux/data/geth/nodekey
    cp /opt/didux/keys/tm$KEY.pub /opt/didux/data/blackbox.pub
    cp /opt/didux/keys/tm$KEY.key /opt/didux/data/blackbox.key
fi
args="$datadir $verbosity $networkid $bootnodes $syncmode $port $rpc $ws $ipc $disc $smilobft $sport $mine $gasprice $minerthreads $password"

./blackbox -configfile /opt/didux/data/blackbox-config.json > /var/log/blackbox.log 2>&1 &
VAULT_IPC=/opt/didux/data/blackbox.ipc ./go-didux $args