//
//  NSTimer+Block.h
//  HuSheng
//
//  Created by renge on 2018/11/5.
//  Copyright © 2018 ld. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (Block)

@property (nonatomic, assign) NSInteger rg_tag;

@property (nonatomic, copy) void(^block)(NSTimer *timer);

+ (NSTimer *)rg_timerWithTimeInterval:(NSTimeInterval)interval
                              repeats:(BOOL)repeat
                                block:(void(^)(NSTimer *timer))block;

+ (NSTimer *)rg_timerWithTag:(NSInteger)tag;

@end

NS_ASSUME_NONNULL_END
