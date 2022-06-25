//
//  AFSIRelationBuilder.m
//  AFModule_Example
//
//  Created by 尼诺 on 2022/6/24.
//  Copyright © 2022 AFutureD. All rights reserved.
//

#import "AFObjB.h"
#import <objc/runtime.h>

RegistProtocol(1, yourService, AFProtocolB, ^id(id<AFModule>  _Nonnull module) {
    return nil;
})

@implementation AFObjB

- (void)say:(NSString *)name {
    NSLog(@"Say, %@.", name);
}

@end
