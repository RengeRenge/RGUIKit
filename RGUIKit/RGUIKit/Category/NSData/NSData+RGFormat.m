//
//  NSData+RGFormat.m
//  RGUIKit
//
//  Created by renge on 2021/6/1.
//

#import "NSData+RGFormat.h"

@implementation NSData(RGFormat)

- (BOOL)rg_toBool {
    BOOL value = NO;
    [self getBytes:&value length:1];
    return value;
}

- (SInt8)rg_toInt8 {
    SInt8 value = 0;
    [self getBytes:&value length:1];
    return value;
}

- (UInt8)rg_toUInt8 {
    UInt8 value = 0;
    [self getBytes:&value length:1];
    return value;
}

- (SInt16)rg_toInt16 {
    SInt16 value = 0;
    [self getBytes:&value length:2];
    return value;
}

- (SInt16)rg_littleEndianToInt16 {
    SInt16 value = self.rg_toInt16;
    uint16_t *temp = (uint16_t *)&value;
    *temp = CFSwapInt16LittleToHost(*temp);
    memcpy(&value, temp, sizeof(*temp));
    return value;
}

- (UInt16)rg_toUInt16 {
    UInt16 value = 0;
    [self getBytes:&value length:2];
    return value;
}

- (UInt16)rg_littleEndianToUInt16 {
    return CFSwapInt16LittleToHost(self.rg_toUInt16);
}

- (SInt32)rg_toInt32 {
    SInt32 value = 0;
    [self getBytes:&value length:4];
    return value;
}

- (SInt32)rg_littleEndianToInt32 {
    SInt32 value = self.rg_toInt32;
    uint32_t *temp = (uint32_t *)&value;
    *temp = CFSwapInt32LittleToHost(*temp);
    memcpy(&value, temp, sizeof(*temp));
    return value;
}

- (UInt32)rg_toUInt32 {
    UInt32 value = 0;
    [self getBytes:&value length:4];
    return value;
}

- (UInt32)rg_littleEndianToUInt32 {
    return CFSwapInt32LittleToHost(self.rg_toUInt32);
}

- (Float32)rg_toFloat32 {
    Float32 value = 0;
    [self getBytes:&value length:4];
    return value;
}

- (Float32)rg_littleEndianToFloat32 {
    Float32 value = self.rg_toFloat32;
    uint32_t *temp = (uint32_t *)&value;
    *temp = CFSwapInt32LittleToHost(*temp);
    memcpy(&value, temp, sizeof(*temp));
    return value;
}

- (SInt64)rg_toInt64 {
    SInt64 value = 0;
    [self getBytes:&value length:8];
    return value;
}

- (SInt64)rg_littleEndianToInt64 {
    SInt64 value = self.rg_toInt64;
    uint64_t *temp = (uint64_t *)&value;
    *temp = CFSwapInt64LittleToHost(*temp);
    memcpy(&value, temp, sizeof(*temp));
    return value;
}

- (UInt64)rg_toUInt64 {
    UInt64 value = 0;
    [self getBytes:&value length:8];
    return value;
}

- (UInt64)rg_littleEndianToUInt64 {
    return CFSwapInt64LittleToHost(self.rg_toUInt64);
}

- (Float64)rg_toFloat64 {
    Float64 value = 0;
    [self getBytes:&value length:8];
    return value;
}

- (Float64)rg_littleEndianToFloat64 {
    Float64 value = self.rg_toFloat64;
    uint64_t *temp = (uint64_t *)&value;
    *temp = CFSwapInt64LittleToHost(*temp);
    memcpy(&value, temp, sizeof(*temp));
    return value;
}

- (NSString *)rg_toHex {
    if (!self.length) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:self.length];
    
    [self enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%02X", (dataBytes[i]) & 0xff];
            [string appendString:hexStr];
        }
    }];
    return string;
}

- (NSString *)rg_toHexWithSep:(NSString *)sep {
    if (!self.length) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:self.length];
    
    [self enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%02X%@", (dataBytes[i]) & 0xff, i < byteRange.length - 1 ? sep : @""];
            [string appendString:hexStr];
        }
    }];
    return string;
}

- (NSString *)rg_littleEndianToHex {
    if (!self.length) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:self.length];
    // NSData 的排序必定大端顺序，16进制字符串输出也必须为大端模式，所以当确定数据是小端模式时，可以直接逆序输出
    [self enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%02X", (dataBytes[i]) & 0xff];
            [string insertString:hexStr atIndex:0];
        }
    }];
    return string;
}

- (NSString *)rg_littleEndianToHexWithSep:(NSString *)sep {
    if (!self.length) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:self.length];
    
    [self enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%02X%@", (dataBytes[i]) & 0xff, i > 0 ? sep : @""];
            [string insertString:hexStr atIndex:0];
        }
    }];
    return string;
}

BOOL rg_isLittleEndian(void) {
    return NSHostByteOrder() == CFByteOrderLittleEndian;
//    UInt32 i = 0x12345678;
//    char *c = (char *)&i;
//    return ((c[0] == 0x78) && (c[1] == 0x56) && (c[2] == 0x34) && (c[3] == 0x12));
}

+ (NSData *)rg_dataWithUInt8:(UInt8)value {
    return [NSData dataWithBytes:&value length:1];
}

+ (NSData *)rg_littleEndianDataWithInt16:(SInt16)value {
    SInt16 *temp = &value;
    *temp = CFSwapInt16HostToLittle(*temp);
    return [NSData dataWithBytes:temp length:2];
}

+ (NSData *)rg_littleEndianDataWithUInt16:(UInt16)value {
    value = CFSwapInt16HostToLittle(value);
    return [NSData dataWithBytes:&value length:2];
}

+ (NSData *)rg_littleEndianDataWithInt32:(SInt32)value {
    SInt32 *temp = &value;
    *temp = CFSwapInt32HostToLittle(*temp);
    return [NSData dataWithBytes:temp length:4];
}

+ (NSData *)rg_littleEndianDataWithUInt32:(UInt32)value {
    value = CFSwapInt32HostToLittle(value);
    return [NSData dataWithBytes:&value length:4];
}

+ (NSData *)rg_littleEndianDataWithInt64:(SInt64)value {
    uint64_t *temp = (uint64_t *)&value;
    *temp = CFSwapInt64HostToLittle(*temp);
    return [NSData dataWithBytes:temp length:8];
}

+ (NSData *)rg_littleEndianDataWithUInt64:(UInt64)value {
    uint64_t *temp = (uint64_t *)&value;
    *temp = CFSwapInt64HostToLittle(*temp);
    return [NSData dataWithBytes:temp length:8];
}

+ (NSData *)rg_littleEndianDataWithFloat32:(Float32)value {
    uint32_t *temp = (uint32_t *)&value;
    *temp = CFSwapInt32HostToLittle(*temp);
    return [NSData dataWithBytes:temp length:4];
}

+ (NSData *)rg_littleEndianDataWithFloat64:(Float64)value {
    uint64_t *temp = (uint64_t *)&value;
    *temp = CFSwapInt64HostToLittle(*temp);
    return [NSData dataWithBytes:temp length:8];
}

@end

@implementation NSString (RGFormat)

- (NSMutableData *)rg_hexStringToData {
    NSString *command = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableData *commandToSend= [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [command length]/2; i++) {
        byte_chars[0] = [command characterAtIndex:i*2];
        byte_chars[1] = [command characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [commandToSend appendBytes:&whole_byte length:1];
    }
    return commandToSend;
}

@end
