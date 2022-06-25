//
//  AFSIManager.m
//  AFModule_Example
//
//  Created by 尼诺 on 2022/6/24.
//  Copyright © 2022 AFutureD. All rights reserved.
//

#import "AFObjA.h"
#import "AFProtocolA.h"
#import <objc/runtime.h>
#import "AFObjB.h"

@interface _AFProtocolA_Provider : AFModuleProvider

@end

@implementation _AFProtocolA_Provider

- (Protocol *)protocol {
    return @protocol(AFProtocolA);
}

- (void)initialize:(nonnull id<AFModule>)module {
    [self use:^id _Nullable(id<AFModule>  _Nonnull module) {
        return [AFObjA new];
    }];
    [super initialize:module];
}

- (NSInteger)priority {
    return 1;
}

@end

@interface AFModule (AFProtocolA)
@end

@implementation AFModule (AFProtocolA)

- (id<AFModuleProvider>)myServiceProvider {
    SEL key = @selector(myServiceProvider);
    id<AFModuleProvider> provider = objc_getAssociatedObject(self, key);
    if (provider == nil) {
        provider = [_AFProtocolA_Provider new];
        [self setMyServiceProvider:provider];
    }
    return provider;
}

- (void)setMyServiceProvider:(id<AFModuleProvider>)myServiceProvider {
    SEL key = @selector(myServiceProvider);
    objc_setAssociatedObject(self, key, myServiceProvider, OBJC_ASSOCIATION_RETAIN);
}

- (id<AFProtocolA>)myService {
    id<AFProtocolA> impl = [AFModule implForProtocol:@protocol(AFProtocolA)];
    Creater block = self.myServiceProvider.creater;
    if (impl == nil && block) {
        impl = block(self);
        [AFModule setImpl:impl protocol:@protocol(AFProtocolA)];
    }
    return impl;
}

@end

@implementation AFObjA

- (void)hello:(NSString *)name {
    NSLog(@"Hello, %@!", name);
}

- (void)prepareImpl {
    [[AFModule shareInstance].yourServiceProvider use:^id(id<AFModule>  _Nonnull module) {
        return [AFObjB new];
    }];
}

@end
