//
//  AFProtocolC.h
//  AFModule
//
//  Created by 尼诺 on 2022/6/26.
//  Copyright © 2022 AFutureD. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFModule/AFServices.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AFProtocolC <AFModuleProtocolIndicator>
- (void)callOnce;
@end

DeclareProtocol(missingService, AFProtocolC)

NS_ASSUME_NONNULL_END
