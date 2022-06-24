//
//  AFSIRelataionBuilderProtocol.h
//  ServiceHackerObjc
//
//  Created by 尼诺 on 2022/6/24.
//  Copyright © 2022 AFutureD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFModule/AFServices.h>

NS_ASSUME_NONNULL_BEGIN


//
//@interface AFModule (AFSIRelataionBuilderProtocol)
//
//@property (nonatomic, strong) AFModuleProvider * relationBuilder;
//
//@end
//
//@interface AFModuleProvider (AFSIRelataionBuilderProtocol)
//
//@property (nonatomic, strong) id<AFSIRelataionBuilderProtocol> impl;
//
//@end

@protocol AFSIRelataionBuilderProtocol <AFModuleProtocolIndicator>
- (void)say:(NSString *)name;
@end


@interface AFModule (AFSIRelataionBuilderProtocol)

@property (nonatomic, strong) id<AFModuleProvider> relationBuilderProvider;
@property (nonatomic, strong) id<AFSIRelataionBuilderProtocol> relationBuilder;

@end

NS_ASSUME_NONNULL_END
