//
//  AFProtocolB.h
//  AFModule
//
//  Created by 尼诺 on 2022/6/24.
//  Copyright © 2022 AFutureD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFModule/AFServices.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AFProtocolB <AFModuleProtocolIndicator>
- (void)say:(NSString *)name;
@end

DeclareProtocol(yourService, AFProtocolB)

NS_ASSUME_NONNULL_END
