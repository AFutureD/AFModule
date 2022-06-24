//
//  AFSIProtocol.h
//  ServiceHackerObjc_Example
//
//  Created by 尼诺 on 2022/6/24.
//  Copyright © 2022 AFutureD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFModule/AFServices.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AFSIProtocol <AFModuleProtocolIndicator>

- (void)hello:(NSString *)name;
- (void)prepareImpl;

@end

@interface AFModule (AFSIProtocol)

@property (nonatomic, strong) id<AFModuleProvider> spaceInfoProvider;
@property (nonatomic, strong) id<AFSIProtocol> spaceInfo;

@end


NS_ASSUME_NONNULL_END
