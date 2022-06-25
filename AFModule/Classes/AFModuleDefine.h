//
//  AFModuleDefine.h
//  AFModule
//
//  Created by 尼诺 on 2022/6/24.
//
#ifndef AFMODULEDEFINE_H
#define AFMODULEDEFINE_H

#define DeclareProtocol(_PROPERTY_NAME, _PROTOCOL) \
\
@interface AFModule (_PROTOCOL) \
\
@property (nonatomic, strong, readonly) id<AFModuleProvider> _PROPERTY_NAME ## Provider; \
@property (nonatomic, strong, readonly) id<_PROTOCOL> _PROPERTY_NAME; \
\
@end \


//

#define RegistProtocol(_PRIORITY, _PROPERTY_NAME, _PROTOCOL, INITBLOCK) \
\
@interface _ ## _PROTOCOL ## _Provider : AFModuleProvider \
\
@end \
\
@implementation _ ## _PROTOCOL ## _Provider \
\
- (Protocol *)protocol { \
    return @protocol(_PROTOCOL); \
} \
\
- (void)initialize:(nonnull id<AFModule>)module { \
    [self use:INITBLOCK]; \
    [super initialize:module]; \
} \
\
- (NSInteger)priority { \
    return _PRIORITY; \
} \
\
@end \
ExtendAFModule(_PROPERTY_NAME, _PROTOCOL)

//

#define ExtendAFModule(_PROPERTY_NAME, _PROTOCOL) \
\
@interface AFModule (_PROTOCOL) \
@end \
\
@implementation AFModule (_PROTOCOL) \
\
- (id<AFModuleProvider>)_PROPERTY_NAME ## Provider { \
    SEL key = @selector(_PROPERTY_NAME ## Provider); \
    id<AFModuleProvider> provider = objc_getAssociatedObject(self, key); \
    if (provider == nil) { \
        provider = [_ ## _PROTOCOL ## _Provider new]; \
        [self set ## _PROPERTY_NAME##Provider:provider]; \
    } \
    return provider; \
} \
\
- (void)set ##_PROPERTY_NAME ## Provider:(id<AFModuleProvider>)_PROPERTY_NAME ## Provider { \
    SEL key = @selector(_PROPERTY_NAME##Provider); \
    objc_setAssociatedObject(self, key, _PROPERTY_NAME ## Provider, OBJC_ASSOCIATION_RETAIN); \
} \
\
- (id<_PROTOCOL>)_PROPERTY_NAME { \
    id<_PROTOCOL> impl = [AFModule implForProtocol:@protocol(_PROTOCOL)]; \
    return impl; \
} \
\
@end \

#endif
