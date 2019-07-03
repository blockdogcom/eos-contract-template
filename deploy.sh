if [ "$1" = "mainnet" ]
then
  url=https://api.eoslaomao.com
  contract=buckwalletio
elif [ "$1" = "jungle" ]
then
  url=https://jungle.eosio.cr
  contract=buckwalletio
else
  echo "mainnet | jungle"
  exit 0
fi

cleos -u $url set contract $contract dist hello.wasm hello.abi -p $contract