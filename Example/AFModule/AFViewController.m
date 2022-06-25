//
//  AFViewController.m
//  AFModule
//
//  Created by AFutureD on 06/24/2022.
//  Copyright (c) 2022 AFutureD. All rights reserved.
//

#import "AFViewController.h"
#import <AFModule/AFServices.h>
#import "AFObjA.h"
#import "AFProtocolA.h"
#import "AFProtocolB.h"

@interface AFViewController ()

@end

@implementation AFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AFModule shareInstance] start];
    
    [[AFModule shareInstance].myService hello:@"world"];
    
    [[AFModule shareInstance].yourService say:@"hello. Once"];
    NSAssert([AFModule shareInstance].yourService == nil, @"");
    
    [[AFModule shareInstance].myService prepareImpl];
    [[AFModule shareInstance].yourServiceProvider restCreater];
    [[AFModule shareInstance].yourService say:@"hello. Twice"];
}

@end
