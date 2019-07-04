市面上EOS智能合约开发的工具挺多，其中也不乏一些优秀的团队。但对于长年跟代码打交道的程序员来说，可能都有自己的一套开发环境，或许vscode或者sublime会更顺手一些，下面我们来体验vscode的环境搭建。

1. [点击下载vscode](https://code.visualstudio.com/Download "vscode")  

2. 安装eosio和eosio.cdt, 并导入私钥
```
brew tap eosio/eosio
brew install eosio
brew tap eosio/eosio.cdt
brew install eosio.cdt

cleos wallet import
```

3. 智能合约项目的文件结构如下[github](https://github.com/blockdogcom/eos-contract-template "github")  
```
.vscode      //vscode 配置文件
dist         //编译后的wasm和abi文件
include      //头文件
ricardian    //李嘉图合约说明文件
src          //源码
- build.sh   //构建脚本
- deploy.sh  //发布脚本
```

4. 配置c_cpp_properties.json用于查找相关的include文件
```
{
    "configurations": [
        {
            "name": "Mac",
            "includePath": [
                "${workspaceFolder}/include",
                "/usr/local/Cellar/eosio.cdt/1.6.1/opt/eosio.cdt/include/eosiolib/contracts/**",
                "/usr/local/Cellar/eosio.cdt/1.6.1/opt/eosio.cdt/include"
            ],
            "defines": [],
            "macFrameworkPath": [
                "/Library/Developer/CommandLineTools/SDKs/MacOSX10.14.sdk/System/Library/Frameworks"
            ],
            "compilerPath": "/usr/bin/clang",
            "cStandard": "c11",
            "cppStandard": "c++17",
            "intelliSenseMode": "clang-x64"
        }
    ],
    "version": 4
}
```

5. 配置忽略eosio特定语法的错误提示 settings.json
```
{
    "C_Cpp.errorSquiggles": "Disabled"
}
```

6. hello合约源码

hello.hpp
```
#include <eosio/eosio.hpp>
using namespace eosio;

CONTRACT hello : public contract {
   public:
      using contract::contract;

      ACTION hi( name nm );
      ACTION check( name nm );

      using hi_action = action_wrapper<"hi"_n, &hello::hi>;
      using check_action = action_wrapper<"check"_n, &hello::check>;
};

```

hello.cpp
```
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
```

7. 调用eosio-cpp来构建合约
```
eosio-cpp -abigen -I include -R ricardian -contract hello -o dist/hello.wasm src/hello.cpp
```


完成以上6个步骤基本就完成环境搭建了，完整代码可以[点击下载源码](https://github.com/blockdogcom/eos-contract-template "github") ,
运行 ./build.sh构建合约生成wasm和abi文件，运行./deploy.sh部署合约到测试网或主网。
