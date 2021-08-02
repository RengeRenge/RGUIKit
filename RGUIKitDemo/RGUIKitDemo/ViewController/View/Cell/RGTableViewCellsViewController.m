//
//  ViewController.m
//  RGUIKitDemo
//
//  Created by renge on 2018/11/7.
//  Copyright © 2018 ld. All rights reserved.
//

#import "RGTableViewCellsViewController.h"
#import <RGUIKit/RGUIKit.h>
#import "WrapperCellDisplayTableViewController.h"

typedef enum : NSUInteger {
    VCTestTypeWrapperCell,
    VCTestTypeCornerCell,
    VCTestTypeIconCell,
    VCTestTypeLabelCell,
    VCTestTypeInputCell,
    VCTestTypeCornerCellEnd,
    VCTestTypeCount,
} VCTestType;

@interface RGTableViewCellsViewController () <RGInputCellDelegate>

@end

@implementation RGTableViewCellsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerClass:RGIconCell.class forCellReuseIdentifier:RGCellID];
    [self.tableView registerClass:RGInputTableViewCell.class forCellReuseIdentifier:RGInputTableViewCellID];
    [self.tableView registerClass:RGLabelTableViewCell.class forCellReuseIdentifier:RGLabelTableViewCellID];
    [self.tableView registerClass:RGTableViewWrapperCell.class forCellReuseIdentifier:RGTableViewWrapperCellID];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.title = @"Cell Display";
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
                    [RGToastView showWithInfo:@"This is a RGLabelTableViewCell!\nlayout at center" duration:3 percentY:0.8 viewController:self];
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
        case VCTestTypeWrapperCell: {
            RGTableViewWrapperCell *wrapper = [RGTableViewWrapperCell dequeueCellWithIdentifier:RGTableViewWrapperCellID style:UITableViewCellStyleSubtitle tableView:tableView];
            wrapper.edge = UIEdgeInsetsMake(30, 30, 30, 30);
            wrapper.shadowLayer.hidden = NO;
            wrapper.shadowLayer.shadowRadius = 8;
            wrapper.shadowLayer.shadowOpacity = 0.6;

            wrapper.customSeparatorStyle = RGTableViewWrapperSeparatorStyleContentFull;
            
            wrapper.contentCornerRadius = 10.f;
            wrapper.contentCorner = UIRectCornerAllCorners;
            
            wrapper.highlightArea = RGTableViewHighlightAreaContent;
            cell = wrapper;
            
            RGTableViewCell *contentCell = wrapper.contentCell;
            contentCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            contentCell.applyThemeColor = YES;
            
            contentCell.imageView.image = [UIImage rg_coloredImage:UIColor.clearColor size:CGSizeMake(30, 30)];
            contentCell.imageView.layer.cornerRadius = 15;
            contentCell.imageView.layer.masksToBounds = YES;
            [contentCell.imageView rg_setBackgroundGradientColors:@[UIColor.rg_randomColor, UIColor.rg_randomColor] locations:nil drawType:RGDrawTypeCircleFit];
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
        case VCTestTypeWrapperCell: {
            WrapperCellDisplayTableViewController *vc = [[WrapperCellDisplayTableViewController alloc] initWithStyle:UITableViewStylePlain];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
        default:
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case VCTestTypeWrapperCell:
            return 160;
        default:
            return UITableViewAutomaticDimension;
    }
}

#pragma mark - RGInputCellDelegate

- (void)rg_inputCellTextDidChange:(RGInputTableViewCell *)cell text:(NSString *)text {
    NSLog(@"%@", cell.inputText);
}

@end
