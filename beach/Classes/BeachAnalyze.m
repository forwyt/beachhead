//
//  BeachAnalyze.m
//  beach
//
//  Created by jasonphd on 2021/8/30.
//

#import "BeachAnalyze.h"
#import <dlfcn.h>
#import <libkern/OSAtomic.h>


@implementation BeachAnalyze
/**
 * 获取version
 */
+(void)version{
    NSLog(@"beach tool version 0.1.0");
}

/**
 *获取到order file 文件
 */
+(void)getOrderFile{
    NSLog(@"--- get order file begin ---");
    NSMutableArray<NSString *> * symbolNames = [NSMutableArray array];
       while (YES) {
           //offsetof 就是针对某个结构体找到某个属性相对这个结构体的偏移量
           SymbolNode * node = OSAtomicDequeue(&symbolList, offsetof(SymbolNode, next));
           if (node == NULL) break;
           Dl_info info;
           dladdr(node->pc, &info);
           
           NSString * name = @(info.dli_sname);
           
           // 添加 _
           BOOL isObjc = [name hasPrefix:@"+["] || [name hasPrefix:@"-["];
           NSString * symbolName = isObjc ? name : [@"_" stringByAppendingString:name];
           
           //去重
           if (![symbolNames containsObject:symbolName]) {
               [symbolNames addObject:symbolName];
           }
       }

       //取反 FILO 先进后出所以需要倒序
       NSArray * symbolAry = [[symbolNames reverseObjectEnumerator] allObjects];
       NSLog(@"%@",symbolAry);
       
       //将结果写入到文件
       NSString * funcString = [symbolAry componentsJoinedByString:@"\n"];
       NSString * filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"BeachHead.order"];
       NSData * fileContents = [funcString dataUsingEncoding:NSUTF8StringEncoding];
       BOOL result = [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileContents attributes:nil];
       if (result) {
           NSLog(@"重排之后的执行顺序 🚀 : %@",filePath);
       }else{
           NSLog(@"文件写入出错");
       }
       
}


static OSQueueHead symbolList = OS_ATOMIC_QUEUE_INIT;
//定义符号结构体
typedef struct{
   void * pc;
   void * next;
}SymbolNode;


#pragma mark - 静态插桩代码

void __sanitizer_cov_trace_pc_guard_init(uint32_t *start,
                                        uint32_t *stop) {
   static uint64_t N;  // Counter for the guards.
   if (start == stop || *start) return;  // Initialize only once.
   printf("INIT: %p %p\n", start, stop);
   for (uint32_t *x = start; x < stop; x++)
       *x = ++N;  // Guards should start from 1.
}

void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {
   //if (!*guard) return;  // Duplicate the guard check.
   
   void *PC = __builtin_return_address(0);
   
   SymbolNode * node = malloc(sizeof(SymbolNode));
   *node = (SymbolNode){PC,NULL};
   
   //入队
   // offsetof 用在这里是为了入队添加下一个节点找到 前一个节点next指针的位置
   OSAtomicEnqueue(&symbolList, node, offsetof(SymbolNode, next));
}




@end
