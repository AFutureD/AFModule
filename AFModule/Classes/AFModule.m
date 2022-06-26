//
//  AFModule.m
//  Pods-AFModule_Example
//
//  Created by 尼诺 on 2022/6/24.
//

#import "AFModule.h"
#import <YYModel/YYModel.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import "AFModuleProvider.h"

@interface AFModule ()  {
    dispatch_semaphore_t _providerLock;
    dispatch_semaphore_t _implLock;
}

@property (nonatomic, strong) NSMapTable<id, id> * protToProvider;
@property (nonatomic, strong) NSMapTable<id, id> * protToImpl;

@end

@implementation AFModule

#pragma mark - shareInstance

+ (instancetype)shareInstance {
    static AFModule * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [AFModule shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [AFModule shareInstance];
}

#pragma mark - init

- (instancetype)init {
    self = [super init];
    if (self) {
        _providerLock = dispatch_semaphore_create(1);
        _implLock = dispatch_semaphore_create(1);
        _protToImpl = [NSMapTable weakToStrongObjectsMapTable];
        _protToProvider = [NSMapTable weakToStrongObjectsMapTable];
    }
    return self;
}

#pragma mark - Public Methods

+ (id)implForProtocol:(nonnull Protocol *)protocol {
    return [[self shareInstance] implForProtocol:protocol];
}

+ (void)setImpl:(nullable id)impl protocol:(nonnull Protocol *)protocol {
    [[self shareInstance] setImpl:impl protocol:protocol];
}

+ (void)start {
    [[self shareInstance] initialize];
}

+ (void)reload {
    [[self shareInstance] reload];
}

#pragma mark - Map Operater

- (id)implForProtocol:(nonnull Protocol *)protocol {
    dispatch_semaphore_wait(self->_implLock, DISPATCH_TIME_FOREVER);
    id impl = [self.protToImpl objectForKey:protocol];
    dispatch_semaphore_signal(self->_implLock);
    id<AFModuleProvider> provider = [self providerForProtocol:protocol];
    Creater block = [provider creater];
    if (impl == nil && block) {
        impl = block(self);
        [self setImpl:impl protocol:protocol];
    }
    return impl;
}

- (void)setImpl:(nullable id)impl protocol:(nonnull Protocol *)protocol {
    dispatch_semaphore_wait(self->_implLock, DISPATCH_TIME_FOREVER);
    id old = [self.protToImpl objectForKey:protocol];
    dispatch_semaphore_signal(self->_implLock);
    if (!old && !impl) {
        // Nothing should happend.
        return;
    } else if (old && !impl) {
        dispatch_semaphore_wait(self->_implLock, DISPATCH_TIME_FOREVER);
        [self.protToImpl removeObjectForKey:protocol];
        dispatch_semaphore_signal(self->_implLock);
        NSLog(@"Module impl map -: remove %@", NSStringFromProtocol(protocol));
        return;
    }
        
    dispatch_semaphore_wait(self->_implLock, DISPATCH_TIME_FOREVER);
    [self.protToImpl setObject:impl forKey:protocol];
    dispatch_semaphore_signal(self->_implLock);
    NSLog(@"Module impl map +: set %@", NSStringFromProtocol(protocol));
}

- (id<AFModuleProvider>)providerForProtocol:(nonnull Protocol *)protocol {
    dispatch_semaphore_wait(self->_providerLock, DISPATCH_TIME_FOREVER);
    id<AFModuleProvider> provider = [self.protToProvider objectForKey:protocol];
    dispatch_semaphore_signal(self->_providerLock);
    return provider;
}

- (void)setProvider:(nullable id<AFModuleProvider>)provider protocol:(nonnull Protocol *)protocol {
    id<AFModuleProvider> old = [self providerForProtocol:protocol];
    if (!old && !provider) {
        // Nothing should happend.
        return;
    } else if (old && !provider) {
        dispatch_semaphore_wait(self->_providerLock, DISPATCH_TIME_FOREVER);
        [self.protToProvider removeObjectForKey:protocol];
        dispatch_semaphore_signal(self->_providerLock);
        NSLog(@"Module Provider -: remove success. %@", NSStringFromProtocol(protocol));
        return;
    }
    
    if (old && old.priority >= provider.priority) {
        NSLog(@"Module Provider &: reset faliure due to lower priority.");
        return;
    } else if (old && old.priority < provider.priority){
        NSLog(@"Module Provider &: reset success. %@", NSStringFromProtocol(protocol));
    } else {
        NSLog(@"Module Provider +: add success %@", NSStringFromProtocol(protocol));
    }
    dispatch_semaphore_wait(self->_providerLock, DISPATCH_TIME_FOREVER);
    [self.protToProvider setObject:provider forKey:protocol];
    dispatch_semaphore_signal(self->_providerLock);
}

- (NSArray<Protocol *> *)protocolsForProviders {
    return NSAllMapTableKeys(self.protToProvider);
}

#pragma mark - Private Methods

- (void)initialize {
    [self prepareProvider];
    [self initProvider];
    [self setProviderCallback];
}

- (void)reload {
    NSArray<Protocol *> * protocols = [self protocolsForProviders];
    for (Protocol * protocol in protocols) {
        id<AFModuleProvider> provider = [self providerForProtocol:protocol];
        [provider restCreater];
    }
}

- (void)prepareProvider {
    NSDictionary<NSString *, YYClassPropertyInfo *> * propertyInfos = [self metaInfos].propertyInfos;
    for (YYClassPropertyInfo *propertyInfo in propertyInfos.allValues) {
        if (!propertyInfo.name) continue;
        
        NSString * typeClass =  [NSString stringWithUTF8String:propertyInfo.typeEncoding.UTF8String];
        NSString * propertyName = [NSString stringWithUTF8String:property_getName(propertyInfo.property)];
        
        if ((propertyInfo.type & YYEncodingTypeMask) != YYEncodingTypeObject) {
            continue;
        }
        
        if (![typeClass isEqualToString:[NSString stringWithFormat:@"@\"<%@>\"",
                                         NSStringFromProtocol(@protocol(AFModuleProvider))]]) {
            continue;
        }
        
        NSLog(@"Module Prob Found: %@", propertyName);
        
        id v = ((id (*)(id, SEL))(void *) objc_msgSend)((id)self, propertyInfo.getter);
        if (![v conformsToProtocol:@protocol(AFModuleProvider)]) {
            NSLog(@"Provider do not conforms to AFModuleProvider: %@", propertyName);
            continue;
        }
        id<AFModuleProvider> provider = (id<AFModuleProvider>)v;
        [self setProvider:provider protocol:[provider protocol]];
    }
    NSLog(@"Module Provider =: Prepare Finish.");
    NSLog(@"Module Provider @: map - %@", self.protToProvider);
}

- (void)initProvider {
    NSArray<Protocol *> * protocols = [self protocolsForProviders];
    for (Protocol * protocol in protocols) {
        id<AFModuleProvider> provider = [self providerForProtocol:protocol];
        [provider initialize:self];
    }
}

- (void)setProviderCallback {
    NSArray<Protocol *> * protocols = [self protocolsForProviders];
    for (Protocol * protocol in protocols) {
        id<AFModuleProvider> provider = [self providerForProtocol:protocol];
        __weak __typeof(self)weakSelf = self;
        [provider setCallback:^(id<AFModuleProvider>  _Nonnull provider) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
//            [strongSelf setProvider:nil protocol:protocol];
//            [strongSelf setImpl:nil protocol:protocol]
            NSLog(@"Module Provider @: create commited - %@", provider);
        }];
    }
}

#pragma mark - Objc Runtime

- (id)handleMissIMPL:(SEL)aSelector {
    NSLog(@"Module Performing: ERROR! Unimplement method - %@", NSStringFromSelector(aSelector));
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL sel = invocation.selector;                  // get failed method
    [invocation setSelector:@selector(handleMissIMPL:)];  // set fallback method
    [invocation setTarget:self];                    // set receiver
    [invocation setArgument:&sel atIndex:2];        // set arguement
    [invocation invoke];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *methodSignature = [super methodSignatureForSelector:aSelector];
    if (!methodSignature) {
        // Fallback unimplement method to `handleMissIMPL:`
        methodSignature = [self methodSignatureForSelector:@selector(handleMissIMPL:)];
    }
    return methodSignature;
}

#pragma mark - Utils

- (YYClassInfo *)metaInfos {
    return [YYClassInfo classInfoWithClass:self.class];
}

@end
