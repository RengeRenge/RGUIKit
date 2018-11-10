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
#import "RGNavigationTestViewController.h"

typedef enum : NSUInteger {
    VCTestTypeEdgeCell,
    VCTestTypeCornerCell,
    VCTestTypeLabelCell,
    VCTestTypeInputCell,
    VCTestTypeDraw,
    VCTestTypeImageEdit,
    VCTestTypeCornerCellEnd,
    VCTestTypeCount,
} VCTestType;

@interface ViewController () <RGInputCellDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerClass:RGIconCell.class forCellReuseIdentifier:RGCellID];
    [self.tableView registerClass:RGInputTableViewCell.class forCellReuseIdentifier:RGInputTableViewCellID];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [RGIconCell setThemeColor:[UIColor blackColor]];
    
    [self rg_showBadgeWithValue:@"RGDot"];
    [self.tabBarController.tabBar rg_showBadgeWithType:RGUITabbarBadgeTypeNormal atIndex:1];
    [self.tabBarController.tabBar rg_showBadgeWithValue:@"!" atIndex:2];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"RGNavigation" style:UIBarButtonItemStylePlain target:self action:@selector(rgNavigation:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"RTL/LTR" style:UIBarButtonItemStylePlain target:self action:@selector(RTLSwitch:)];
}

- (void)rgNavigation:(id)sender {
    RGNavigationTestViewController *vc = [RGNavigationTestViewController new];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"dismiss" style:UIBarButtonItemStylePlain target:vc action:@selector(rg_dismiss)];
    RGNavigationController *navigation = [RGNavigationController navigationWithRoot:vc style:RGNavigationBackgroundStyleShadow];
    navigation.tintColor = [UIColor whiteColor];
    [self presentViewController:navigation animated:YES completion:nil];
}

- (void)RTLSwitch:(id)sender {
    if (@available(iOS 9.0, *)) {
        UISemanticContentAttribute att = [UIView appearance].semanticContentAttribute;
        if (att == UISemanticContentAttributeForceRightToLeft) {
            [UIView rg_setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        } else {
            [UIView rg_setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return VCTestTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RGIconCell <UIButton *> *cell;
    
    if (indexPath.row == 0 || indexPath.row == [tableView numberOfRowsInSection:0] - 1) {
        cell = [RGCornerTableViewCell dequeueCellWithIdentifier:RGCornerTableViewCellID style:UITableViewCellStyleSubtitle tableView:tableView];
        
        RGCornerTableViewCell *cornerCell = (RGCornerTableViewCell *)cell;
        
        if (indexPath.row == 0) {
            cornerCell.corner = UIRectCornerTopLeft | UIRectCornerTopRight;
        } else {
            cornerCell.corner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        }
        cornerCell.cornerRadius = 10.f;
    } else {
        
    }
    
    switch (indexPath.row) {
            case VCTestTypeDraw:
            cell = [tableView dequeueReusableCellWithIdentifier:RGCellID forIndexPath:indexPath];
            cell.textLabel.text = @"VCTestTypeDrawAndLayout";
            break;
            case VCTestTypeImageEdit:
            cell = [tableView dequeueReusableCellWithIdentifier:RGCellID forIndexPath:indexPath];
            cell.textLabel.text = @"VCTestTypeImageEdit";
            break;
        case VCTestTypeCornerCell:
        case VCTestTypeCornerCellEnd: {
            cell = [RGCornerTableViewCell dequeueCellWithIdentifier:RGCornerTableViewCellID style:UITableViewCellStyleSubtitle tableView:tableView];
            cell.textLabel.text = @"【CornerCell】";
            RGCornerTableViewCell *cornerCell = (RGCornerTableViewCell *)cell;
            cornerCell.cornerRadius = 10.f;
            if (indexPath.row == VCTestTypeCornerCell) {
                cornerCell.corner = UIRectCornerTopLeft | UIRectCornerTopRight;
            } else {
                cornerCell.corner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            }
            break;
        }
        case VCTestTypeLabelCell: {
            RGLabelTableViewCell *cell = [RGLabelTableViewCell dequeueCellWithIdentifier:RGLabelTableViewCellID style:UITableViewCellStyleDefault tableView:tableView];
            cell.textEdge = UIEdgeInsetsMake(10, 10, 10, 10);
            cell.maskEdge = UIEdgeInsetsMake(10, 10, 10, 10);
            cell.textEdgeMask.backgroundColor = [UIColor groupTableViewBackgroundColor];
            cell.label.text = @"【LabelCell】";
            cell.label.textColor = [UIColor purpleColor];
            return cell;
        }
        case VCTestTypeInputCell: {
            RGInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RGInputTableViewCellID forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDetailButton;
            cell.textField.placeholder = @"InputCell";
            cell.textFieldEdge = UIEdgeInsetsMake(5, 20, 5, 0); // 左边偏移5
            cell.rightViewEdge = UIEdgeInsetsMake(0, 5, 0, 10); // 右边偏移5， 和 textField 相距 10
            cell.lineEdge = UIEdgeInsetsMake(-5, 0, 5, 0); // 上升5个像素
            
            cell.textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
            cell.textField.leftViewMode = UITextFieldViewModeAlways;
            cell.textField.clearButtonMode = UITextFieldViewModeAlways;
            
            UILabel *rightView = [[UILabel alloc] init];
            rightView.text = @"rightView";
            [rightView sizeToFit];
            
            cell.rightView = rightView;
            
            cell.lineColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
            
            cell.textField.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.3];
            rightView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.3];
            
            cell.contentView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.15];
            
            cell.delegate = self;
            return cell;
        }
        case VCTestTypeEdgeCell: {
            cell = [RGEdgeTableViewCell dequeueCellWithIdentifier:RGEdgeTableViewCellID style:UITableViewCellStyleSubtitle tableView:tableView];
            
            RGEdgeTableViewCell *edgeCell = (RGEdgeTableViewCell *)cell;
            edgeCell.edge = UIEdgeInsetsMake(7, 50, 7, 10);
            edgeCell.textLabel.text = @"【EdgeCell】 longggggggggggggggggggggg long long long long long long long long long long long long";
            edgeCell.textLabel.numberOfLines = 0;
            edgeCell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            edgeCell.rightLabel.text = @"【rightLabel】";

            edgeCell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            edgeCell.showdowLayer.hidden = NO;
            edgeCell.corner = UIRectCornerAllCorners;
            edgeCell.cornerRadius = 10.f;
            edgeCell.customSeparatorStyle = RGEdgeCellSeparatorStyleDefault;
            edgeCell.customSeparatorView.backgroundColor = [UIColor blackColor];
            edgeCell.customSeparatorEdge = UIEdgeInsetsMake(-2, 0, 2, edgeCell.cornerRadius/2.f);
            edgeCell.highlightedEnable = YES;
            edgeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        }
        default:
            cell.textLabel.text = @(indexPath.row).stringValue;
            break;
    }
    
    cell.detailTextLabel.text = @"RGIconCell";
    cell.applyThemeColor = YES;
    
    [cell configCustomIcon:^UIButton * _Nullable(UIButton * _Nullable icon) {
        if (!icon) {
            icon = [UIButton buttonWithType:UIButtonTypeSystem];
        }
        [icon setTitle:@"按钮" forState:UIControlStateNormal];
        return icon;
    }];
    
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
                
                image = [image rg_appendImage:[UIImage rg_coloredImage:[UIColor rg_colorWithRGBA:100.f,150.f,200.f,1.f] size:CGSizeMake(size.width, 10)]];
                
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
        case VCTestTypeCornerCell:
        case VCTestTypeCornerCellEnd:
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        case VCTestTypeEdgeCell:
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark - RGInputCellDelegate

- (void)rg_inputCellTextDidChange:(RGInputTableViewCell *)cell text:(NSString *)text {
    NSLog(@"%@", cell.inputText);
}

@end
