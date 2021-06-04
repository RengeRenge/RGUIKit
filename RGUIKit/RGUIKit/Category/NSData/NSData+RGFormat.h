//
//  NSData+RGFormat.h
//  RGUIKit
//
//  Created by renge on 2021/6/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData(RGFormat)

- (BOOL)rg_toBool;

- (SInt8)rg_toInt8;

- (UInt8)rg_toUInt8;

- (SInt16)rg_toInt16;
- (SInt16)rg_littleEndianToInt16;

- (UInt16)rg_toUInt16;
- (UInt16)rg_littleEndianToUInt16;

- (SInt32)rg_toInt32;
- (SInt32)rg_littleEndianToInt32;

- (UInt32)rg_toUInt32;
- (UInt32)rg_littleEndianToUInt32;

- (Float32)rg_toFloat32;
- (Float32)rg_littleEndianToFloat32;

- (SInt64)rg_toInt64;
- (SInt64)rg_littleEndianToInt64;

- (UInt64)rg_toUInt64;
- (UInt64)rg_littleEndianToUInt64;

- (Float64)rg_toFloat64;
- (Float64)rg_littleEndianToFloat64;

- (NSString *)rg_toHex;
- (NSString *)rg_littleEndianToHex;

/// like mac address: E4:F4:C6:B7:10:DC
- (NSString *)rg_toHexWithSep:(NSString *)sep;
- (NSString *)rg_littleEndianToHexWithSep:(NSString *)sep;


+ (NSData *)rg_dataWithUInt8:(UInt8)value;

+ (NSData *)rg_littleEndianDataWithInt16:(SInt16)value;
+ (NSData *)rg_littleEndianDataWithUInt16:(UInt16)value;

+ (NSData *)rg_littleEndianDataWithInt32:(SInt32)value;
+ (NSData *)rg_littleEndianDataWithUInt32:(UInt32)value;

+ (NSData *)rg_littleEndianDataWithInt64:(SInt64)value;
+ (NSData *)rg_littleEndianDataWithUInt64:(UInt64)value;

+ (NSData *)rg_littleEndianDataWithFloat32:(Float32)value;
+ (NSData *)rg_littleEndianDataWithFloat64:(Float64)value;

BOOL rg_isLittleEndian(void);

@end

@interface NSString (RGFormat)

- (NSMutableData *)rg_hexStringToData;

@end

NS_ASSUME_NONNULL_END
