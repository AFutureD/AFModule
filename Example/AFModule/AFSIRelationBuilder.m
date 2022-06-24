//
//  AFSIRelationBuilder.m
//  ServiceHackerObjc_Example
//
//  Created by 尼诺 on 2022/6/24.
//  Copyright © 2022 AFutureD. All rights reserved.
//

#import "AFSIRelationBuilder.h"
#import <objc/runtime.h>

RegistProtocol(1, relationBuilder, AFSIRelataionBuilderProtocol,^id(id<AFModule>  _Nonnull module) {
    return nil;
})

@implementation AFSIRelationBuilder

- (void)say:(NSString *)name {
    NSLog(@"Say, %@.", name);
}

@end
