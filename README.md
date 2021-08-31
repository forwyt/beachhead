
# BeachHead

名称来自战争术语 抢滩登陆 (beach head)

目的是更快的将iOS的application启动提速. 让用户更快的打开app !

### 原理
![](http://pic.jasonphd.com/upload/2021/08/612dd3e9a955e.png)
page1 与 page2 都需要从无到有加载到物理内存中，从而触发两次 Page Fault。
二进制重排 的做法就是将 function1  与 function2 放到一个内存页中，
那么启动时则只需要加载一次 page 即可，也就是只触发一次 Page Fault

以Demo为例:(路径在`$(TARGET_TEMP_DIR)/$(PRODUCT_NAME)-LinkMap-$(CURRENT_VARIANT)-$(CURRENT_ARCH).txt`)

```
0x1000020F0    0x000000A0    [  2] -[BHAppDelegate application:didFinishLaunchingWithOptions:]
0x100002190    0x00000070    [  2] -[BHAppDelegate applicationWillResignActive:]
0x100002200    0x00000070    [  2] -[BHAppDelegate applicationDidEnterBackground:]
0x100002270    0x00000070    [  2] -[BHAppDelegate applicationWillEnterForeground:]
0x1000022E0    0x00000070    [  2] -[BHAppDelegate applicationDidBecomeActive:]
0x100002350    0x00000070    [  2] -[BHAppDelegate applicationWillTerminate:]
0x1000023C0    0x00000050    [  2] -[BHAppDelegate window]
0x100002410    0x00000060    [  2] -[BHAppDelegate setWindow:]
0x100002470    0x00000050    [  2] -[BHAppDelegate .cxx_destruct]
0x1000024C0    0x0000001C    [  2] _sancov.module_ctor_trace_pc_guard
0x1000024E0    0x00000060    [  3] -[BHViewController viewDidLoad]
0x100002540    0x00000060    [  3] -[BHViewController didReceiveMemoryWarning]
0x1000025A0    0x00000050    [  3] -[BHViewController otherFucntionBeforTargetFuction1]
0x1000025F0    0x00000050    [  3] -[BHViewController otherFucntionBeforTargetFuction2]
0x100002640    0x000000D0    [  3] -[BHViewController createOrderClick:]
0x100002710    0x0000001C    [  3] _sancov.module_ctor_trace_pc_guard
0x100002730    0x000000B0    [  4] _main
```
可以关注此处代码 即使在执行时优先级 function2 > funtion1 但是在ld时 是按照定义的顺序来插入即 funtion 1 > function2. 明白这个原理之后我们可以通过clang-插装的原理理清楚程序执行的真实循序来给二进制文件做排序.
尽可能多的将函数调用顺序相近的function排列在同一张Page里面.减少page faut 触发的页断次数.从而达到减少
启动时间.
```
-(void)otherFucntionBeforTargetFuction1{
    NSLog(@"just for test");
}

-(void)otherFucntionBeforTargetFuction2{
    NSLog(@"just for test");
}

- (IBAction)createOrderClick:(id)sender {
    NSLog(@"create order click");
    [BeachAnalyze version];
    [self otherFucntionBeforTargetFuction2];
    [self otherFucntionBeforTargetFuction1];
}
```

修改之后顺序

```

_main
-[BHAppDelegate setWindow:]
-[BHAppDelegate application:didFinishLaunchingWithOptions:]
-[BHViewController viewDidLoad]
-[BHAppDelegate applicationDidBecomeActive:]
-[BHAppDelegate window]
-[BHViewController createOrderClick:]
-[BHViewController otherFucntionBeforTargetFuction2]
-[BHViewController otherFucntionBeforTargetFuction1]

```
### 操作流程

1. 集成SDK
`pod 'beachhead', :git => 'https://github.com/forwyt/beachhead.git',:tag => '0.1.0'` 

2. 修改other c flag
在 工程的 taget -> build setting -> other c flag 插人下列参数`-fsanitize-coverage=func,trace-pc-guard`

3. 调用api 
仅需一行代码 在您想结束启动时间统计的业务中插入, 类似在MainViewController 中 viewDidAppear
为结束时间点.
` [BeachAnalyze getOrderFile];`

4. 观察打印的日志
` 重排之后的执行顺序 🚀 : /xx/xx/xx/data/Containers/Data/Application/93BDE7B1-28AF-4203-A43C-DA5D71709D38/tmp/BeachHead.order`

5. 将重新排列之后的order利用
将路径对应的文件copy到项目根目录
然后将 工程的 taget -> build setting -> linking -> order file 写入刚才的路径 即可以完成二进制重排

🎉🎉🎉🎉🎉🎉

### Tips

- Page Fault，开销在 0.6 ~ 0.8ms。
当进程在进行一些计算时，CPU 会请求内存中存储的数据。在这个请求过程中，CPU 发出的地址是逻辑地址（虚拟地址），然后交由 CPU 当中的 MMU 单元进行内存寻址，找到实际物理内存上的内容。若是目标虚存空间中的内存页（因为某种原因），在物理内存中没有对应的页帧，那么 CPU 就无法获取数据。这种情况下，CPU 是无法进行计算的，于是它就会报告一个缺页错误（Page Fault）。因为 CPU 无法继续进行进程请求的计算，并报告了缺页错误，用户进程必然就中断了。这样的中断称之为缺页中断。在报告 Page Fault 之后，进程会从用户态切换到系统态，交由操作系统内核的 Page Fault Handler 处理缺页错误。

- 灵感来源

 + 基于抖音二进制重排优化一文 
 + clang 插桩




