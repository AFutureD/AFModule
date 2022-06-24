//
//  AFModuleDefine.h
//  ServiceHackerObjc
//
//  Created by 尼诺 on 2022/6/24.
//

#define RegistProtocol(_PRIORITY, _PROPERTY_NAME, PROTOCOL, INITBLOCK) \
\
@interface _ ## PROTOCOL ## _Provider : AFModuleProvider \
\
@end \
\
@implementation _ ## PROTOCOL ## _Provider \
\
- (Protocol *)protocol {\
    return @protocol(PROTOCOL); \
} \
\
- (void)initialize:(nonnull id<AFModule>)module { \
    [super initialize:module]; \
    [self setCreater:INITBLOCK];\
} \
\
- (NSInteger)priority { \
    return _PRIORITY; \
} \
\
@end\
\
\
@interface AFModule (PROTOCOL) \
@end \
\
@implementation AFModule (PROTOCOL) \
\
- (id<AFModuleProvider>)_PROPERTY_NAME ## Provider { \
    SEL key = @selector(_PROPERTY_NAME ## Provider); \
    id<AFModuleProvider> provider = objc_getAssociatedObject(self, key); \
    if (provider == nil) { \
        provider = [_ ## PROTOCOL ## _Provider new]; \
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
- (id<PROTOCOL>)_PROPERTY_NAME { \
    id<PROTOCOL> impl = [AFModule implForProtocol:@protocol(PROTOCOL)]; \
    if (impl == nil && self._PROPERTY_NAME ## Provider.creater) { \
        impl = self._PROPERTY_NAME ## Provider.creater(self); \
        [AFModule setImpl:impl protocol:@protocol(PROTOCOL)]; \
    } \
    return impl; \
} \
\
@end \
