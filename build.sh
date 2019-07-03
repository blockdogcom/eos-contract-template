if [ "$1" = "all" ]
then
  eosio-cpp -abigen -I include -R ricardian -contract hello -o dist/hello.wasm src/hello.cpp
else
  eosio-cpp -I include -R ricardian -contract hello -o dist/hello.wasm src/hello.cpp
fi


