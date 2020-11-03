## 一些想法

如果你对terraform配置好奇，请不要错过这个demo的演示。

所有的内容都可以提供给初学者帮助。

请仔细查看每一个配置和细节，按照步骤操作一下,可能有更深刻的体会。

所有设计都可以参考Terraform与Azure官方文档。


## 实践步骤

基本设想样：
1. 首先，整个历程构建一个完成的可以正常运行的虚拟机
2. `root module`部分负责仅仅构建VM部分，其他，如磁盘和网卡由其他的module负责
3. `moduleDisk`负责提供磁盘资源
4. `moduleNet`负责提供网络资源
5. `moduleRemote`负责提供github远程模块的能力，包含公网IP和网卡
6. 所有的模块均通过`output`和`variable`来输出和输入，这也是`terraform`的标准设计
7. 所有命名引用的前缀统一为`hibro`


## 不经过修改不能无脑运行的理由

这是一个开源项目，很多关于AzureCloud等涉及安全的内容，请自行修改成符合自己需求的配置。

## Azure CloudShell 运行步骤

1. 上传或克隆本开源项目到`Azure Cloud`，并切换到项目根目录
2. `terraform init`
3. `terraform plan -out a.plan && terraform apply a.plan`
4. 一点terraform命令的调试功能提示：`terraform output && terraform show`
5. 获得虚拟机的主机IP：`az vm show --resource-group hibro-RG --name hibro-VM -d --query [publicIps] -o tsv`
6. `ssh hibro@<hostip>` 登录上面那条指令获得的主机，默认使用`SSH Key`登录，如果要用密码，请修改配置
7. 虚拟机启动log追踪位置：由`azurerm_storage_account.sa`资源生成的存储账户中
8. `terraform plan -destroy -out d.plan && terraform apply d.plan`，验证完相应的功能后释放资源

## 直观的观赏体验

本项目中已经集成了由script脚本记录的中断会话，如果初学者想要了解它的运行轨迹，那就这样：
```shell
scriptreplay demo-steps/timing.steps demo-steps/demo.session
```

## 官方文档

[<传送门>](https://prexerx.github.io/2020/11/03/terraform-azure-demo-doc)
