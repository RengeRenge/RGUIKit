//
//  DrawViewController.m
//  RGUIKitDemo
//
//  Created by renge on 2018/11/8.
//  Copyright © 2018 ld. All rights reserved.
//

#import "DrawViewController.h"
#import "DrawLineCustomViewController.h"

#import <RGUIKit/RGUIKit.h>

@interface DrawViewController ()

@property (nonatomic, strong) UIImageView *image1;
@property (nonatomic, strong) UIImageView *image2;
@property (nonatomic, strong) UIImageView *image3;
@property (nonatomic, strong) UIImageView *image4;
@property (nonatomic, strong) UIImageView *image5;
@property (nonatomic, strong) UIImageView *image6;

@end

@implementation DrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:@"DrawLineCustom" style:UIBarButtonItemStylePlain target:self action:@selector(switchType)];
    self.navigationItem.rightBarButtonItem = bar;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.image1 = [self createImageView];
    self.image2 = [self createImageView];
    self.image3 = [self createImageView];
    self.image4 = [self createImageView];
    self.image5 = [self createImageView];
    self.image6 = [self createImageView];
    
    [self.view rg_setBackgroundGradientColors:@[UIColor.whiteColor, UIColor.blackColor] locations:nil drawType:RGDrawTypeTopToBottom];
}

- (void)switchType {
    [self.navigationController pushViewController:DrawLineCustomViewController.new animated:YES];
}

- (UIImageView *)createImageView {
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:imageView];
    return imageView;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect bounds = self.rg_safeAreaBounds;
    
    NSArray *colors = @[
        [UIColor redColor],
        [UIColor whiteColor],
        [UIColor yellowColor],
    ];
    
    CGSize size = CGSizeMake(bounds.size.width/2, bounds.size.height/3);
    
    [@[self.image1, self.image2, self.image3, self.image4, self.image5, self.image6] enumerateObjectsUsingBlock:^(UIImageView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.frame = CGRectMake(
                               (idx % 2) * size.width + bounds.origin.x,
                               idx / 2 * size.height + bounds.origin.y,
                               size.width,
                               size.height);
//        if (self.image5 == obj) {
//            obj.frame = CGRectMake(
//                                   (bounds.size.width - size.width*1.5)/2.f,
//                                   (bounds.size.height - size.height*1.5)/2.f,
//                                   size.width*1.5,
//                                   size.height*1.5);
//        }
        
        CGRect rect = CGRectInset(obj.bounds, 10, 10);
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.height/2];
        obj.image = [self test:idx colors:colors bounds:obj.bounds path:path];
    }];
}

- (UIImage *)test:(RGDrawType)type colors:(NSArray *)colors bounds:(CGRect)bounds path:(UIBezierPath *)path {
    //创建CGContextRef
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, [UIScreen mainScreen].scale);
    
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
//    [path rg_drawLinearGradient:gc colors:colors locations:nil drawRad:type*30.f/180*M_PI];
    [path rg_drawGradient:gc colors:colors locations:nil drawType:type];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *dic = @{
        NSFontAttributeName:[UIFont systemFontOfSize:10],
        NSForegroundColorAttributeName:[UIColor blackColor],
        NSParagraphStyleAttributeName: style,
    };
    NSString *text = nil;
    switch (type) {
        case RGDrawTypeTopToBottom:
            text = @"TopToBottom";
            break;
        case RGDrawTypeLeftToRight:
            text = @"LeftToRight";
            break;
        case RGDrawTypeDiagonalTopRightToBottomLeft:
            text = @"Diagonal\nTopRightToBottomLeft";
            break;
        case RGDrawTypeDiagonalTopLeftToBottomRight:
            text = @"Diagonal\nTopLeftToBottomRight";
            break;
        case RGDrawTypeCircleFill:
            text = @"CircleFill";
            break;
        case RGDrawTypeCircleFit:
            text = @"CircleFit";
            break;
        default:
            break;
    }
    CGSize size = [text boundingRectWithSize:bounds.size options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    bounds.origin = CGPointMake((bounds.size.width - size.width)/2, (bounds.size.height - size.height)/2);
    bounds.size = size;
    
    [text drawInRect:bounds withAttributes:dic];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

@end
