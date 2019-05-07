//
//  NSNull+Safe.h
//  RGUIKit
//
//  Created by renge on 2018/11/21.
//  Copyright © 2018 ld. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSNull(RGSafe)

- (id)objectAtIndexedSubscript:(NSUInteger)idx;
- (id)objectForKeyedSubscript:(id)key;
- (BOOL)isEqualToString:(NSString *)aString;
- (NSUInteger)count;
- (NSUInteger)length;

@end

NS_ASSUME_NONNULL_END
