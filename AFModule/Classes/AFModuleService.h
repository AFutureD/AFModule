//
//  AFModuleService.h
//  ServiceHackerObjc
//
//  Created by 尼诺 on 2022/6/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AFModule;
@protocol AFModuleProvider;
@protocol AFModuleProtocolIndicator;

@protocol AFModule <NSObject>

+ (void)setImpl:(id _Nullable)impl protocol:(Protocol *)protocol;
+ (id)implForProtocol:(Protocol *)protocol;

@end

@protocol AFModuleProtocolIndicator <NSObject>
@end

typedef id _Nullable (^Creater)(id<AFModule> module);
typedef void(^CreaterCallback)(id<AFModuleProvider> provider);

@protocol AFModuleProvider <NSObject>

- (Protocol *)protocol;
- (void)initialize:(id<AFModule>)module;
- (void)use:(Creater)block;

- (Creater)creater;
- (void)setCreater:(Creater)creater;
- (void)setCallback:(CreaterCallback)callback;

- (NSInteger)priority;

@end

@interface AFModuleProvider : NSObject<AFModuleProvider>
@end

@interface AFModuleService : NSObject
@end

NS_ASSUME_NONNULL_END
