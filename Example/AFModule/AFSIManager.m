//
//  AFSIManager.m
//  ServiceHackerObjc_Example
//
//  Created by 尼诺 on 2022/6/24.
//  Copyright © 2022 AFutureD. All rights reserved.
//

#import "AFSIManager.h"
#import "AFSIProtocol.h"
#import <objc/runtime.h>
#import "AFSIRelationBuilder.h"

@interface _AFSIProtocol_Provider : AFModuleProvider

@end

@implementation _AFSIProtocol_Provider

- (Protocol *)protocol {
    return @protocol(AFSIProtocol);
}

- (void)initialize:(nonnull id<AFModule>)module {
    [super initialize:module];
    [self setCreater:^id(id<AFModule>  _Nonnull module) {
        return [AFSIManager new];
    }];
}

- (NSInteger)priority {
    return 1;
}

@end

@interface AFModule (AFSIProtocol)
@end

@implementation AFModule (AFSIProtocol)

- (id<AFModuleProvider>)spaceInfoProvider {
    SEL key = @selector(spaceInfoProvider);
    id<AFModuleProvider> provider = objc_getAssociatedObject(self, key);
    if (provider == nil) {
        provider = [_AFSIProtocol_Provider new];
        [self setSpaceInfoProvider:provider];
    }
    return provider;
}

- (void)setSpaceInfoProvider:(id<AFModuleProvider>)spaceInfoProvider {
    SEL key = @selector(spaceInfoProvider);
    objc_setAssociatedObject(self, key, spaceInfoProvider, OBJC_ASSOCIATION_RETAIN);
}

- (id<AFSIProtocol>)spaceInfo {
    id<AFSIProtocol> impl = [AFModule implForProtocol:@protocol(AFSIProtocol)];
    if (impl == nil && self.spaceInfoProvider.creater) {
        impl = self.spaceInfoProvider.creater(self);
        [AFModule setImpl:impl protocol:@protocol(AFSIProtocol)];
    }
    return impl;
}

@end

@implementation AFSIManager

- (void)hello:(NSString *)name {
    NSLog(@"Hello, %@!", name);
}

- (void)prepareImpl {
    [[AFModule shareInstance].relationBuilderProvider use:^id(id<AFModule>  _Nonnull module) {
        return [AFSIRelationBuilder new];
    }];
}

@end
