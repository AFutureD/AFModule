//
//  AFViewController.m
//  ServiceHackerObjc
//
//  Created by AFutureD on 06/24/2022.
//  Copyright (c) 2022 AFutureD. All rights reserved.
//

#import "AFViewController.h"
#import <AFModule/AFServices.h>
#import "AFSIManager.h"
#import "AFSIProtocol.h"
#import "AFSIRelataionBuilderProtocol.h"

@interface AFViewController ()

@end

@implementation AFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AFModule shareInstance] start];
    
    [[AFModule shareInstance].spaceInfo hello:@"world"];
    
    [[AFModule shareInstance].relationBuilder say:@"hello. Once"];
    NSAssert([AFModule shareInstance].relationBuilder == nil, @"");
    
    [[AFModule shareInstance].spaceInfo prepareImpl];
    [[AFModule shareInstance].relationBuilder say:@"hello. Twice"];
}

@end
