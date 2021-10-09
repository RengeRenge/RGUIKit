//
//  NSString+RGAttribute.m
//  XJCloud
//
//  Created by renge on 2020/11/17.
//  Copyright © 2020 ld. All rights reserved.
//

#import "NSString+RGAttribute.h"
#import "UIColor+RGColorGet.h"

@implementation NSString(RGAttribute)

- (NSMutableAttributedString *)rg_linkString {
    return [self rg_linkStringWithUnderline:NO];
}

- (NSMutableAttributedString *)rg_linkStringWithUnderline {
    return [self rg_linkStringWithUnderline:YES];
}

- (NSMutableAttributedString *)rg_linkStringWithUnderline:(BOOL)underLine {
    NSMutableString *privacyStr = self.mutableCopy;
    
    NSInteger s = 0, e = 0;
    NSMutableArray <NSValue *> *ranges = @[].mutableCopy;
    NSArray *label = @[@"[link]", @"[/link]"];
    
    int i = 0;
    NSRange range = [privacyStr rangeOfString:label[i%2]];
    while (range.location != NSNotFound) {
        [privacyStr replaceCharactersInRange:range withString:@""];
        if (i%2 == 0) {
            s = range.location;
        } else {
            e = range.location;
            [ranges addObject:[NSValue valueWithRange:NSMakeRange(s, e - s)]];
        }
        i++;
        range = [privacyStr rangeOfString:label[i%2]];
    }
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:privacyStr];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    if (underLine) {
        attributes[NSUnderlineStyleAttributeName] = @(NSUnderlineStyleSingle);
    }
    
    [ranges enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        attributes[NSLinkAttributeName] = [@"link-" stringByAppendingFormat:@"%d", (int)idx];
        
        [string addAttributes:attributes
                        range:obj.rangeValue];
    }];
    
    [attributes removeAllObjects];
    if (@available(iOS 13.0, *)) {
        attributes[NSForegroundColorAttributeName] = [UIColor labelColor];
    } else {
        attributes[NSForegroundColorAttributeName] = [UIColor whiteColor];
    }
    [string addAttributes:attributes range:NSMakeRange(0, string.length)];
    return string;
}

- (NSMutableAttributedString *)rg_colorStringWithDefaultColor:(UIColor *)defalutColor {
    __block NSMutableAttributedString *string = nil;
    [self rg_findLabel:@"color" count:0 result:^(NSMutableString * _Nonnull str, NSMutableArray<NSValue *> * _Nonnull ranges, NSMutableArray <NSString *> *attributes) {
        string = [[NSMutableAttributedString alloc] initWithString:str];
        [ranges enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *attr = attributes[idx];
            
            __block UIColor *color = nil;
            [[attr componentsSeparatedByString:@" "] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj hasPrefix:@"value="]) {
                    NSArray *keyValue = [obj componentsSeparatedByString:@"="];
                    if (keyValue.count > 1) {
                        NSString *value = keyValue[1];
                        if (value.length) {
                            color = [UIColor rg_colorWithRGBHexString:value];
                        }
                    }
                }
            }];
            if (!color) {
                color = defalutColor;
            }
            
            NSDictionary *att = @{
                NSForegroundColorAttributeName: color
            };
            [string addAttributes:att range:obj.rangeValue];
        }];
    }];
    return string;
}

- (void)rg_findLabel:(NSString *)label
               count:(NSUInteger)count
              result:(void(NS_NOESCAPE^)(NSMutableString *str, NSMutableArray <NSValue *> *ranges, NSMutableArray <NSString *> *attributes))result {
    NSMutableString *str = self.mutableCopy;
    
    NSString *endLabel = [NSString stringWithFormat:@"\\[\\/%@\\]", label];
    label = [NSString stringWithFormat:@"\\[%@[^\\]]*]", label];
    
    NSMutableArray <NSValue *> *ranges = @[].mutableCopy;
    NSMutableArray <NSNumber *> *indexStack = @[].mutableCopy;
    NSMutableArray <NSString *> *attributeStack = @[].mutableCopy;
    NSMutableArray <NSString *> *attributes = @[].mutableCopy;
    
    NSRange range = NSMakeRange(0, 0);
    
    do {
        NSRange leftRange = NSMakeRange(range.location, str.length - range.location);
        NSRange startRange = [str rangeOfRegex:label range:leftRange];
        NSRange endRange = [str rangeOfRegex:endLabel range:leftRange];
        if (endRange.location == NSNotFound) {
            break;
        }
        
        if (startRange.location < endRange.location) {
            range = startRange;
            
            NSString *attribute = [str substringWithRange:range];
            [str replaceCharactersInRange:range withString:@""];
            
            [indexStack addObject:@(range.location)];
            
            
            NSRange attRange = [attribute rangeOfRegex:@" .*\\]" range:NSMakeRange(0, attribute.length)];
            if (attRange.location != NSNotFound) {
                attRange.location += 1;
                attRange.length -= 2;
                attribute = [attribute substringWithRange:attRange];
                [attributeStack addObject:attribute];
            } else {
                [attributeStack addObject:@""];
            }
            
        } else {
            range = endRange;
            [str replaceCharactersInRange:range withString:@""];
            
            NSUInteger l = indexStack.lastObject.unsignedIntegerValue;
            [indexStack removeLastObject];
            
            NSString *attribute = attributeStack.lastObject;
            [attributeStack removeLastObject];
            
            NSUInteger r = range.location;
            NSValue *value = [NSValue valueWithRange:NSMakeRange(l, r - l)];
            [ranges insertObject:value atIndex:0];
            
            [attributes insertObject:attribute atIndex:0];
        }
    } while (range.location != NSNotFound && (count == 0 || ranges.count < count));
        
    result(str, ranges, attributes);
}

- (NSRange)rangeOfRegex:(NSString *)regexString range:(NSRange)range {
    return [self rangeOfString:regexString options:NSRegularExpressionSearch range:range];
}

@end
