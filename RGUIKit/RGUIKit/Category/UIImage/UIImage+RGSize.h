//
//  RGSize.h
//  RGUIKit
//
//  Created by renge on 2019/5/7.
//  Copyright © 2019 ld. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface  UIImage(RGSize)

/**
 image size aspect fit size
 
 @param logicSize iOS view's size (ignore UIScreen.scale)
 @param stretch scale will not > 1 if NO
 */
- (CGSize)rg_sizeThatFits:(CGSize)logicSize stretch:(BOOL)stretch;


/**
 image size aspect fill size
 
 @param logicSize iOS view's size (ignore UIScreen.scale)
 */
- (CGSize)rg_sizeThatFill:(CGSize)logicSize;


/**
 iOS view's size (follow UIScreen.scale)
 
 @note if UIScreen.scale == self.scale, return self.size;
 */
- (CGSize)rg_logicSize;


/**
 true size
 */
- (CGSize)rg_pixSize;

/**
 relative size
 */
- (CGSize)rg_sizeWithScale:(CGFloat)scale;


/**
 if imageOrientation is UIImageOrientationLeft or UIImageOrientationRight, width and height will exchange
 */
- (CGSize)rg_straightSize;


@end

NS_ASSUME_NONNULL_END
