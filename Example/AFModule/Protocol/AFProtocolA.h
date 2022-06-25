//
//  AFProtocolA.h
//  AFModule_Example
//
//  Created by 尼诺 on 2022/6/24.
//  Copyright © 2022 AFutureD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFModule/AFServices.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AFProtocolA <AFModuleProtocolIndicator>

- (void)hello:(NSString *)name;
- (void)prepareImpl;

@end

@interface AFModule (AFProtocolA)

@property (nonatomic, strong, readonly) id<AFModuleProvider> myServiceProvider;
@property (nonatomic, strong) id<AFProtocolA> myService;

@end


NS_ASSUME_NONNULL_END
