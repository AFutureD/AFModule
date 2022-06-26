//
//  AFModuleProvider.m
//  AFModule
//
//  Created by 尼诺 on 2022/6/26.
//

#import "AFModuleProvider.h"

@interface AFModuleProvider () {
    Creater _creater;
}

@property (nonatomic, copy) Creater commitedCreater;
@property (nonatomic, copy) CreaterCallback callback;
@property (nonatomic, assign) BOOL isCommited;

@end

@implementation AFModuleProvider

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isCommited = NO;
        _commitedCreater = nil;
        _callback = nil;
        _creater = nil;
    }
    return self;
}

- (void)initialize:(nonnull id<AFModule>)module {
    NSLog(@"Provider: Base Ini %@", NSStringFromClass(self.class));
    [self restCreater];
}

- (void)use:(nonnull Creater)block {
    self.commitedCreater = block;
    if (block) {
        self.isCommited = YES;
    }
    NSLog(@"Provider: Base Use %@", NSStringFromClass(self.class));
}

- (nonnull Protocol *)protocol {
    NSLog(@"Provider: ERROR! Protocol Not Found: %@", NSStringFromClass(self.class));
    return nil;
}

- (NSInteger)priority {
    return 1;
}

- (void)restCreater {
    Creater block = self.commitedCreater;
    if (self.isCommited && block) {
        [self setCreater:block];
        self.isCommited = NO;
        self.commitedCreater = nil;
        NSLog(@"Provider: reset creater %@", NSStringFromClass(self.class));
    }
}

- (void)setCreater:(Creater)creater {
    _creater = creater;
}

- (void)setCommitedCreater:(Creater)commitedCreater {
    _commitedCreater = commitedCreater;
    if (self.callback) {
        self.callback(self);
    }
}

- (Creater)creater {
    if (self.isCommited) {
        NSLog(@"Provider: Unused Commited Creater Exists.");
    }
    return _creater;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@(%@:%@)",
            NSStringFromClass(self.class),  // 类名
            @([self priority]),             // 优先级
            @(self.creater != nil)          // 是否有 creater
    ];
}

@end
