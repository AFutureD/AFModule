//
//  AFModule.h
//  Pods-ServiceHackerObjc_Example
//
//  Created by 尼诺 on 2022/6/24.
//

#import <Foundation/Foundation.h>
#import "AFModuleService.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFModule : NSObject<AFModule>

+ (instancetype)shareInstance;

- (void)start;
- (void)reload;

@end

NS_ASSUME_NONNULL_END
