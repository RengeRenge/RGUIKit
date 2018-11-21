//
//  NSNull+Safe.m
//  RGUIKit
//
//  Created by renge on 2018/11/21.
//  Copyright © 2018 ld. All rights reserved.
//

#import "NSNull+RGSafe.h"

@implementation NSNull(RGSafe)

- (id)objectForKeyedSubscript:(id)key {
    return nil;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return nil;
}

@end
