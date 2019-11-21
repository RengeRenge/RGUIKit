//
//  NSTimer+Block.m
//  HuSheng
//
//  Created by renge on 2018/11/5.
//  Copyright © 2018 ld. All rights reserved.
//

#import "NSTimer+RGBlock.h"
#import <objc/runtime.h>

static char *rg_timer_tag_key = "rg_timer_tag_key";
static char *rg_timer_id_key = "rg_timer_id_key";
static char *rg_timer_block_key = "rg_timer_block_key";

static NSPointerArray *rg_block_timers = nil;

@implementation NSTimer (Block)

- (void)setRg_identifier:(NSString *)rg_identifier {
    objc_setAssociatedObject(self, rg_timer_id_key, rg_identifier, OBJC_ASSOCIATION_COPY);
}

- (NSString *)rg_identifier {
    return objc_getAssociatedObject(self, rg_timer_id_key);
}

- (void)setRg_tag:(NSInteger)rg_tag {
    objc_setAssociatedObject(self, rg_timer_tag_key, @(rg_tag), OBJC_ASSOCIATION_COPY);
}

- (NSInteger)rg_tag {
    return [objc_getAssociatedObject(self, rg_timer_tag_key) integerValue];
}

- (void)setBlock:(void (^)(NSTimer * _Nonnull))block {
    objc_setAssociatedObject(self, rg_timer_block_key, block, OBJC_ASSOCIATION_COPY);
}

- (void (^)(NSTimer * _Nonnull))block {
    return objc_getAssociatedObject(self, rg_timer_block_key);
}

+ (NSTimer *)rg_timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeat block:(void (^)(NSTimer * _Nonnull))block {
    NSTimer *timer = [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(support_blockInvoke:) userInfo:nil repeats:repeat];
    timer.block = block;
    
    void(^arrayConfig)(void) = ^{
        if (!rg_block_timers) {
            rg_block_timers = [NSPointerArray weakObjectsPointerArray];
        }
        if (rg_block_timers.count > 10) {
            NSArray *array = [rg_block_timers allObjects];
            if (array.count <= 10) {
                rg_block_timers = [NSPointerArray weakObjectsPointerArray];
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [rg_block_timers addPointer:(__bridge void * _Nullable)(obj)];
                }];
            }
        }
        [rg_block_timers addPointer:(__bridge void * _Nullable)(timer)];
    };
    
    if ([NSThread isMainThread]) {
        arrayConfig();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            arrayConfig();
        });
        [[NSRunLoop currentRunLoop] run];
    }
    return timer;
}

+ (void)support_blockInvoke:(NSTimer *)timer {
    if (timer.block) {
        timer.block(timer);
    }
}

+ (NSTimer *)rg_timerWithIdentifier:(NSString *)identifier {
    return [self _rg_timerWithTag:-1 identifier:identifier];
}

+ (NSTimer *)rg_timerWithTag:(NSInteger)tag {
    return [self _rg_timerWithTag:tag identifier:nil];
}

+ (NSTimer *)_rg_timerWithTag:(NSInteger)tag identifier:(NSString *)identifier {
    NSTimer *(^getTimer)(void) = ^(void) {
        NSArray <NSTimer *> *array = [rg_block_timers allObjects];
        NSInteger index = [array indexOfObjectPassingTest:^BOOL(NSTimer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (identifier) {
                if ([obj.rg_identifier isEqualToString:identifier]) {
                    return YES;
                }
            } else if (obj.rg_tag == tag) {
                return YES;
            }
            return NO;
        }];
        NSTimer *timer = nil;
        if (index != NSNotFound) {
            timer = array[index];
        }
        return timer;
    };
    
    __block NSTimer *timer = nil;
    
    if ([NSThread isMainThread]) {
        timer = getTimer();
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            timer = getTimer();
        });
    }
    return timer;
}

@end
