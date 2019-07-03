#include <hello.hpp>
ACTION hello::hi( name nm ) {
   print_f("Name : %\n", nm);
}

ACTION hello::check( name nm ) {
   print_f("Name : %\n", nm);
   eosio::check(nm == "hello"_n, "check name not equal to `hello`");
}


extern "C"
{
    void apply(uint64_t receiver, uint64_t code, uint64_t action)
    {
        if (code == receiver || ("transfer"_n.value == action && "eosio.token"_n.value == code))
        {
            switch (action)
            {
                EOSIO_DISPATCH_HELPER(hello, (check) (hi))
            }
        }
    }
}