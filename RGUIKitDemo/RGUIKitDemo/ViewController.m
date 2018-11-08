//
//  ViewController.m
//  RGUIKitDemo
//
//  Created by renge on 2018/11/7.
//  Copyright © 2018 ld. All rights reserved.
//

#import "ViewController.h"
#import <RGUIKit/RGUIKit.h>

#import "PopTestViewController.h"
#import "DrawViewController.h"

typedef enum : NSUInteger {
    VCTestTypeDraw,
    VCTestTypeImageEdit,
} VCTestType;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:RGIconCell.class forCellReuseIdentifier:RGIconCellID];
    [RGIconCell setThemeColor:[UIColor blackColor]];
    
    [self rg_showBadgeWithValue:@"RGDot"];
    [self.tabBarController.tabBar rg_showBadgeWithType:RGUITabbarBadgeTypeWarning atIndex:1];
    [self.tabBarController.tabBar rg_showBadgeWithValue:@"!" atIndex:2];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"RGNavigation" style:UIBarButtonItemStylePlain target:self action:@selector(rgNavigation:)];
}

- (void)rgNavigation:(id)sender {
    UIViewController *vc = [UIViewController new];
    vc.view.backgroundColor = [UIColor blueColor];
    vc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"dismiss" style:UIBarButtonItemStylePlain target:vc action:@selector(rg_dismiss)];
    RGNavigationController *navigation = [RGNavigationController navigationWithRoot:vc style:RGNavigationBackgroundStyleShadow];
    [self presentViewController:navigation animated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RGIconCell <UIButton *> *cell = [tableView dequeueReusableCellWithIdentifier:RGIconCellID forIndexPath:indexPath];

    cell.applyThemeColor = YES;
    
    [cell configCustomIcon:^UIButton * _Nullable(UIButton * _Nullable icon) {
        if (!icon) {
            icon = [UIButton buttonWithType:UIButtonTypeSystem];
        }
        [icon setTitle:@"按钮" forState:UIControlStateNormal];
        return icon;
    }];
    
    switch (indexPath.row) {
            case VCTestTypeDraw:
            cell.textLabel.text = @"VCTestTypeDrawAndLayout";
            break;
            case VCTestTypeImageEdit:
            cell.textLabel.text = @"VCTestTypeImageEdit";
            break;
        default:
            cell.textLabel.text = @(indexPath.row).stringValue;
            break;
    }
    cell.detailTextLabel.text = @"RGIconCell";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    switch (indexPath.row) {
            case VCTestTypeDraw:{
                DrawViewController *vc = [[DrawViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case VCTestTypeImageEdit:{
                CGSize size = cell.frame.size;
                
                UIImage *image = [UIImage rg_convertViewToImage:cell];
                
                image = [image rg_appendImage:[UIImage rg_coloredImage:UIColor.purpleColor size:CGSizeMake(size.width, 10)]];
                image = [image rg_coveredWithImage:[UIImage rg_coloredImage:UIColor.blueColor size:CGSizeMake(50, 50)] rect:CGRectMake(image.size.width / 4.f - 5, size.height, 10, 10)];
                
                UIImage *cropImage = [UIImage rg_convertViewToImage:cell size:CGSizeMake(size.width, 20)];
                image = [image rg_appendImage:cropImage];
                
                image = [image rg_appendImage:[UIImage rg_coloredImage:UIColor.purpleColor size:CGSizeMake(size.width, 10)]];
                
                image = [image rg_appendImage:[UIImage rg_coloredImage:UIColor.redColor size:CGSizeMake(size.width, 30)]];
                image = [image rg_appendImage:[UIImage rg_coloredImage:UIColor.yellowColor size:CGSizeMake(size.width, 30)]];
                image = [image rg_appendImage:[UIImage rg_coloredImage:UIColor.blueColor size:CGSizeMake(size.width, 30)]];
                image = [image rg_appendImage:[UIImage rg_coloredImage:UIColor.blackColor size:CGSizeMake(size.width, cell.imageView.frame.size.height)]];
                
                
                cropImage = [UIImage rg_convertViewToImage:cell rect:cell.imageView.frame];
                CGSize pixSize = image.rg_pixSize;
                CGRect pixRect = CGRectMake(
                                            (pixSize.width - cropImage.rg_pixSize.width) / 2.f,
                                            pixSize.height - cropImage.rg_pixSize.height,
                                            cropImage.rg_pixSize.width,
                                            cropImage.rg_pixSize.height
                                            );
                
                image = [image rg_coveredWithImage:cropImage pixRect:pixRect];
                image = [[image rg_cropInRect:CGRectMake(0, 0, image.size.width / 2.f, image.size.height)] rg_imageWithScreenScale];
                
                //    image = [[image rg_cropInPixRect:CGRectMake(0, 0, image.rg_pixSize.width / 2.f, image.rg_pixSize.height)] imageWithScale:[UIScreen mainScreen].scale];
                
                PopTestViewController *vc = [[PopTestViewController alloc] init];
                vc.image = image;
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
        default:
            break;
    }
}

@end
