//
//  main.m
//  Demo
//
//  Created by jasonphd on 2021/8/26.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSLog(@"====>>>start %lld",recordTime);

    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
