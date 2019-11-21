//
//  ViewController.m
//  RGUIKitDemo
//
//  Created by renge on 2018/11/7.
//  Copyright © 2018 ld. All rights reserved.
//

#import "ViewController.h"
#import <RGUIKit/RGUIKit.h>
#import "RGNavigationTestViewController.h"

typedef enum : NSUInteger {
    VCTestTypeEdgeCell,
    VCTestTypeCornerCell,
    VCTestTypeIconCell,
    VCTestTypeLabelCell,
    VCTestTypeInputCell,
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
    [self.tableView registerClass:RGLabelTableViewCell.class forCellReuseIdentifier:RGLabelTableViewCellID];
    [self.tableView registerClass:RGEdgeTableViewCell.class forCellReuseIdentifier:RGEdgeTableViewCellID];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    [RGIconCell setThemeColor:[UIColor rg_randomColor]];
    
    [self rg_showBadgeWithValue:@"Loading"];
    [self.tabBarController.tabBar rg_showBadgeWithType:RGUITabbarBadgeTypeNormal atIndex:1];
    [self.tabBarController.tabBar rg_showBadgeWithValue:@"!" atIndex:2];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [NSTimer rg_timerWithTimeInterval:3 repeats:NO block:^(NSTimer * _Nonnull timer) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self rg_showBadgeWithValue:@"RGDot"];
            });
        }];
    });
    self.title = @"Cell Display";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"RGNavigation" style:UIBarButtonItemStylePlain target:self action:@selector(rgNavigation:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"RTL/LTR" style:UIBarButtonItemStylePlain target:self action:@selector(RTLSwitch:)];
}

- (void)rgNavigation:(id)sender {
    RGNavigationTestViewController *vc = [RGNavigationTestViewController new];
    vc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"dismiss" style:UIBarButtonItemStylePlain target:vc action:@selector(rg_dismiss)];
    RGNavigationController *navigation = [RGNavigationController navigationWithRoot:vc style:RGNavigationBackgroundStyleShadow];
    navigation.tintColor = [UIColor whiteColor];
    navigation.modalPresentationStyle = UIModalPresentationFullScreen;
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
    RGTableViewCell *cell;
    switch (indexPath.row) {
        case VCTestTypeIconCell:{
            cell = [tableView dequeueReusableCellWithIdentifier:RGCellID forIndexPath:indexPath];
            RGIconCell <UIButton *> *iconCell = (RGIconCell *)cell;
            iconCell.textLabel.text = @"RGIconCell";
            [iconCell setIconCorner:UIRectCornerTopRight cornerRadius:12];
            [iconCell configCustomIcon:^UIButton * _Nullable(UIButton * _Nullable icon) {
                if (!icon) {
                    icon = [UIButton buttonWithType:UIButtonTypeSystem];
                    icon.tintColor = UIColor.whiteColor;
                }
                [icon setBackgroundColor:UIColor.blackColor];
                [icon setTitle:@"Custom\nIcon" forState:UIControlStateNormal];
                icon.titleLabel.font = [UIFont systemFontOfSize:10];
                icon.titleLabel.numberOfLines = 0;
                return icon;
            }];
            break;
        }
        case VCTestTypeCornerCell:
        case VCTestTypeCornerCellEnd: {
            cell = [RGCornerTableViewCell dequeueCellWithIdentifier:RGCornerTableViewCellID style:UITableViewCellStyleSubtitle tableView:tableView];
            cell.textLabel.text = @"RGCornerTableViewCell";
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
            cell.textEdge = UIEdgeInsetsMake(10, 20, 10, 10);
            cell.maskEdge = UIEdgeInsetsMake(10, 20, 10, 10);
            cell.textEdgeMask.backgroundColor = [UIColor blackColor];
            cell.label.textColor = [UIColor whiteColor];
            cell.selectedBlock = ^(RGTableViewCell *cell, BOOL selected, BOOL animated) {
                if (selected) {
                    [(RGLabelTableViewCell *)cell setText:@"RGLabelTableViewCell selected"];
                    [RGToastView showWithInfo:@"This is a RGLabelTableViewCell!\nlayout at center" duration:3 percentY:0.8];
                } else {
                    [(RGLabelTableViewCell *)cell setText:@"RGLabelTableViewCell"];
                }
            };
            return cell;
        }
        case VCTestTypeInputCell: {
            RGInputTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RGInputTableViewCellID forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDetailButton;
            cell.textField.placeholder = @"RGInputTableViewCell";
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
            edgeCell.textLabel.text = @"RGEdgeTableViewCell longggggggggggggggggggggg long long long long long long long long long long long long";
            edgeCell.textLabel.numberOfLines = 0;
            edgeCell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
            edgeCell.rightLabel.text = @"rightLabel";
            edgeCell.rightLabel.textColor = UIColor.blackColor;

            edgeCell.contentView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            edgeCell.showdowLayer.hidden = NO;
            edgeCell.contentCorner = UIRectCornerAllCorners;
            edgeCell.contentCornerRadius = 10.f;
            edgeCell.customSeparatorStyle = RGEdgeCellSeparatorStyleDefault;
            edgeCell.customSeparatorView.backgroundColor = [UIColor blackColor];
            edgeCell.customSeparatorEdge = UIEdgeInsetsMake(-2, 0, 2, edgeCell.cornerRadius/2.f);
            edgeCell.highlightedEnable = YES;
            edgeCell.cornerRadius = 10.f;
            edgeCell.corner = UIRectCornerAllCorners;
            edgeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            edgeCell.imageView.backgroundColor = UIColor.blackColor;
            [edgeCell configCustomIcon:^id _Nullable(id  _Nullable icon) {
                if (!icon) {
                    icon = [UIView new];
//                    [icon setBackgroundColor:UIColor.rg_randomColor];
                    [icon rg_setBackgroundGradientColors:@[UIColor.rg_randomColor, UIColor.rg_randomColor] locations:nil drawType:RGDrawTypeCircleFit];
                }
                return icon;
            }];
            [edgeCell setIconCorner:UIRectCornerBottomLeft cornerRadius:12];
            break;
        }
        default:
            cell.textLabel.text = @(indexPath.row).stringValue;
            break;
    }
    
    cell.detailTextLabel.text = NSStringFromClass(cell.class);
    cell.applyThemeColor = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case VCTestTypeLabelCell:{
            break;
        }
        default:
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
    }
}

#pragma mark - RGInputCellDelegate

- (void)rg_inputCellTextDidChange:(RGInputTableViewCell *)cell text:(NSString *)text {
    NSLog(@"%@", cell.inputText);
}

@end
