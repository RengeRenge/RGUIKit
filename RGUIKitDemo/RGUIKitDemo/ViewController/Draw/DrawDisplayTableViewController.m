//
//  DrawDisplayTableViewController.m
//  RGUIKitDemo
//
//  Created by renge on 2019/11/25.
//  Copyright © 2019 ld. All rights reserved.
//

#import "DrawDisplayTableViewController.h"
#import "DrawViewController.h"
#import "PopTestViewController.h"
#import <RGUIKit/RGUIKit.h>

typedef enum : NSUInteger {
    DrawTypeBersize,
    DrawTypeImageEdit,
    DrawTypeCount,
} DrawType;

@interface DrawDisplayTableViewController ()

@end

@implementation DrawDisplayTableViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title = @"Draw Display";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Draw Display";
    [self.tableView registerClass:RGIconCell.class forCellReuseIdentifier:RGCellIDValue1];
    self.tableView.backgroundView = [UIView new];
    [self.tableView.backgroundView rg_setBackgroundGradientColors:@[UIColor.whiteColor, UIColor.blackColor] locations:nil drawType:RGDrawTypeCircleFill];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return DrawTypeCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RGIconCell *cell = [tableView dequeueReusableCellWithIdentifier:RGCellIDValue1 forIndexPath:indexPath];
    cell.backgroundColor = UIColor.clearColor;
    switch (indexPath.row) {
        case DrawTypeBersize:
            cell.textLabel.text = @"DrawAndLayout";
            break;
        case DrawTypeImageEdit:
            cell.textLabel.text = @"ImageEdit";
            break;
    }
    cell.imageView.image = [UIImage rg_circleImageWithColor:UIColor.rg_randomColor size:cell.iconSize radius:12];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case DrawTypeBersize:{
            DrawViewController *vc = [[DrawViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        case DrawTypeImageEdit:{
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            CGSize size = cell.frame.size;
            
            UIImage *image = [cell rg_convertToImage];
            
            image = [image rg_appendImage:[UIImage rg_coloredImage:UIColor.purpleColor size:CGSizeMake(size.width, 10)]];
            image = [image rg_coveredWithImage:[UIImage rg_coloredImage:UIColor.blueColor size:CGSizeMake(50, 50)] rect:CGRectMake(image.size.width / 4.f - 5, size.height, 10, 10)];
            
            UIImage *cropImage = [cell rg_convertToImageWithSize:CGSizeMake(size.width, 20)];
            image = [image rg_appendImage:cropImage];
            
            image = [image rg_appendImage:[UIImage rg_coloredImage:[UIColor rg_colorWithRGBA:100.f,150.f,200.f,1.f] size:CGSizeMake(size.width, 10)]];
            
            image = [image rg_appendImage:[UIImage rg_coloredImage:UIColor.redColor size:CGSizeMake(size.width, 30)]];
            image = [image rg_appendImage:[UIImage rg_coloredImage:UIColor.yellowColor size:CGSizeMake(size.width, 30)]];
            image = [image rg_appendImage:[UIImage rg_coloredImage:UIColor.blueColor size:CGSizeMake(size.width, 30)]];
            image = [image rg_appendImage:[UIImage rg_coloredImage:UIColor.blackColor size:CGSizeMake(size.width, cell.imageView.frame.size.height)]];
            
            cropImage = [cell rg_convertToImageInRect:cell.imageView.frame];
            CGSize pixSize = image.rg_pixSize;
            CGRect pixRect = CGRectMake(
                                        (pixSize.width - cropImage.rg_pixSize.width) / 2.f,
                                        pixSize.height - cropImage.rg_pixSize.height,
                                        cropImage.rg_pixSize.width,
                                        cropImage.rg_pixSize.height
                                        );
            
            image = [image rg_coveredWithImage:cropImage pixRect:pixRect];
//            image = [[image rg_cropInRect:CGRectMake(0, 0, image.size.width / 2.f, image.size.height)] ];
            
            image = [image rg_coveredWithText:@"rg_coveredWithText" attributes:@{NSForegroundColorAttributeName:UIColor.whiteColor} boundingSize:CGSizeMake(image.size.width, CGFLOAT_MAX) rect:^CGRect(CGSize textSize, CGSize imageSize) {
                return CGRectMake(imageSize.width - textSize.width - 5, imageSize.height - textSize.height - 5, textSize.width, textSize.height);
            }];
            //    image = [[image rg_cropInPixRect:CGRectMake(0, 0, image.rg_pixSize.width / 2.f, image.rg_pixSize.height)] imageWithScale:[UIScreen mainScreen].scale];
            
            PopTestViewController *vc = [[PopTestViewController alloc] init];
            vc.image = image;
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
    }
}

@end
