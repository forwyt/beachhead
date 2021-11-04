//
//  BHViewController.m
//  beach
//
//  Created by jasonphd on 08/30/2021.
//  Copyright (c) 2021 jasonphd. All rights reserved.
//

#import "BHViewController.h"
#import <beach/BeachAnalyze.h>

@interface BHViewController ()

@end

@implementation BHViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)otherFucntionBeforTargetFuction1{
    NSLog(@"just for test1");
}
-(void)otherFucntionBeforTargetFuction2{
    NSLog(@"just for test2");
}
- (IBAction)createOrderClick:(id)sender {
    NSLog(@"createOrderClick");
    [BeachAnalyze version];
    
    [self otherFucntionBeforTargetFuction2];
    [self otherFucntionBeforTargetFuction1];
    
    [BeachAnalyze getOrderFile];
}



@end
