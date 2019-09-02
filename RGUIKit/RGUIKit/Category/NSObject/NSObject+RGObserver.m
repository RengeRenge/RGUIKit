//
//  NSObject+RGObserver.m
//  RGUIKit
//
//  Created by renge on 2019/8/31.
//

#import "NSObject+RGObserver.h"
#import "NSObject+RGRunTime.h"

static NSMutableArray *rg_keyCache;
static NSMutableDictionary *rg_keyCountMap;

@interface _RGConcubine: NSObject

@property (nonatomic, unsafe_unretained, nullable) id target;
@property (nonatomic, unsafe_unretained, nullable) id observer;
@property (nonatomic, copy, nullable) NSString *keyPath;
@property (nonatomic, copy, nullable) NSString *key;

@property (nonatomic, weak, nullable) _RGConcubine *obj;

@end

@implementation _RGConcubine

- (void)clearInfo {
    self.target = nil;
    self.observer = nil;
    self.keyPath = nil;
    self.obj = nil;
}

- (void)dealloc {
    if (_obj || (_target && _target == _observer)) {
        [_target rg_releaseDynamicKeyIfNeed:self.key];
        @try {
            [_target removeObserver:_observer forKeyPath:_keyPath];
        } @catch (NSException *exception) {
//            NSLog(@"%@", exception.description);
        } @finally {
            [self clearInfo];
        }
    }
//    NSLog(@"dealloc");
}

@end

@implementation NSObject(RGObserver)

- (void)rg_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context {
    if ( !observer || !keyPath ) return;
    
    NSString *key = [self rg_keyWithObserver:observer forKeyPath:keyPath];
    
    BOOL exist;
    _RGConcubine *concubine = [self concubineWithKey:key Observer:observer forKeyPath:keyPath exist:&exist];
    
    if (observer != self) {
        _RGConcubine *obConcubine = [observer concubineWithKey:key Observer:observer forKeyPath:keyPath exist:nil];
        
        concubine.obj = obConcubine;
        obConcubine.obj = concubine;
    }
    if (!exist) {
        [self addObserver:observer forKeyPath:keyPath options:options context:context];
    }
}

- (void)rg_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    if ( !observer || !keyPath ) return;
    NSString *key = [self rg_keyWithObserver:observer forKeyPath:keyPath];
    __block BOOL exist = NO;
    void(^clear)(NSObject *obj) = ^(NSObject *obj){
        _RGConcubine *concubine = [obj rg_valueForKey:key];
        if (concubine) {
            exist = YES;
            [concubine clearInfo];
            [self rg_setValue:nil forDynamicKey:key retain:NO];
        }
    };
    
    clear(self);
    if (self != observer) {clear(observer);}
    
    if (!exist) {
        return;
    }
    @try {
        [self removeObserver:observer forKeyPath:keyPath];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.description);
    } @finally {
        
    }
}

- (_RGConcubine *)concubineWithKey:(NSString *)key Observer:(NSObject *)observer forKeyPath:(NSString *)keyPath exist:(BOOL *)exist {
    _RGConcubine *concubine = [self rg_valueForKey:key];
    if (exist) {
        *exist = YES;
    }
    if (!concubine) {
        if (exist) {
            *exist = NO;
        }
        concubine = [_RGConcubine new];
        [self rg_setValue:concubine forDynamicKey:key retain:YES];
    }
    concubine.target = self;
    concubine.observer = observer;
    concubine.keyPath = keyPath;
    concubine.key = key;
    return concubine;
}

- (NSString *)rg_keyWithObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    NSString *key = [NSString stringWithFormat:@"%@-%@", @([observer hash]+[self hash]).stringValue, keyPath];
    return key;
}

@end
