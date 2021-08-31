//
//  ViewController.m
//  Demo
//
//  Created by jasonphd on 2021/8/26.
//

#import "ViewController.h"
#import <beachhead/BeachAnalyze.h>

@interface ViewController ()

@end

@implementation ViewController


-(void)test1{
    NSLog(@"----test1----");
}

-(void)test2{
    NSLog(@"----test2----");
}

-(void)newTest1{
    NSLog(@"----newTest1----");
}

-(void)newTest2{
    NSLog(@"----newTest2----");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self newTest2];
    [self newTest1];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self test1];
    [self test2];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [BeachAnalyze getOrderFile];
}
@end

/**
 Demo-LinkMap-normal-x86_64.txt
 
 0x100001C30    0x00000030    [  2] -[ViewController test1]
 0x100001C60    0x00000030    [  2] -[ViewController test2]
 0x100001C90    0x00000030    [  2] -[ViewController newTest1]
 0x100001CC0    0x00000030    [  2] -[ViewController newTest2]
 0x100001CF0    0x00000070    [  2] -[ViewController viewDidLoad]
 0x100001D60    0x00000070    [  2] -[ViewController viewDidAppear:]
 0x100001DD0    0x00000080    [  3] -[AppDelegate application:didFinishLaunchingWithOptions:]
 0x100001E50    0x00000120    [  3] -[AppDelegate application:configurationForConnectingSceneSession:options:]
 0x100001F70    0x00000070    [  3] -[AppDelegate application:didDiscardSceneSessions:]
 
 
 
 _main
 -[AppDelegate application:didFinishLaunchingWithOptions:]
 -[SceneDelegate setWindow:]
 -[SceneDelegate scene:willConnectToSession:options:]
 -[SceneDelegate window]
 -[ViewController viewDidLoad]
 -[ViewController newTest2]
 -[ViewController newTest1]
 -[SceneDelegate sceneWillEnterForeground:]
 -[SceneDelegate sceneDidBecomeActive:]
 -[ViewController viewDidAppear:]
 -[ViewController test1]
 -[ViewController test2]
 -[ViewController touchesBegan:withEvent:]
 */
