//
//  AFModuleService.m
//  ServiceHackerObjc
//
//  Created by 尼诺 on 2022/6/24.
//

#import "AFModuleService.h"

@implementation AFModuleService

@end

@interface AFModuleProvider ()

@property (nonatomic, copy) Creater creater;
@property (nonatomic, copy) CreaterCallback callback;

@end

@implementation AFModuleProvider

- (void)initialize:(nonnull id<AFModule>)module {
    NSLog(@"Provider Base Ini: %@", NSStringFromClass(self.class));
}

- (void)use:(nonnull Creater)block {
    NSLog(@"Provider Base Use: %@", NSStringFromClass(self.class));
    [self setCreater:block];
}

- (nonnull Protocol *)protocol {
    NSLog(@"ERROR! Protocol Not Found: %@", NSStringFromClass(self.class));
    return nil;
}

- (NSInteger)priority {
    return 1;
}

- (void)setCreater:(Creater)creater {
    _creater = creater;
    if (self.callback) {
        self.callback(self);
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@(%@:%@)",
        NSStringFromClass(self.class),  // 类名
        @([self priority]),             // 优先级
        @(self.creater != nil)          // 是否有 creater
    ];
}

@end
