//
//  EdgeCellTableViewController.m
//  RGUIKitDemo
//
//  Created by renge on 2021/4/25.
//  Copyright © 2021 ld. All rights reserved.
//

#import "WrapperCellDisplayTableViewController.h"
#import <RGUIKit/RGUIKit.h>

@interface WrapperCellDisplayTableViewController () <RGTableViewWrapperCellDelegate>

@end

@implementation WrapperCellDisplayTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"RTL/LTR" style:UIBarButtonItemStylePlain target:self action:@selector(RTLSwitch:)];
    [self.tableView registerClass:RGTableViewWrapperCell.class forCellReuseIdentifier:RGCellID];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 64;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (RGTableViewWrapperSeparatorStyleWrapperFull + 1 ) * 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RGTableViewWrapperCell <RGIconCell *> *wrapper = [tableView dequeueReusableCellWithIdentifier:RGCellID forIndexPath:indexPath];
    
    // Configure the cell...
    wrapper.edge = UIEdgeInsetsMake(5, 30, 5, 30);
    wrapper.customSeparatorStyle = indexPath.row % (RGTableViewWrapperSeparatorStyleWrapperFull + 1);
    wrapper.shadowLayer.hidden = NO;
    wrapper.contentCorner = UIRectCornerAllCorners;
    wrapper.contentCornerRadius = 25;
    wrapper.highlightArea = RGTableViewHighlightAreaContent;
    wrapper.delegate = self;
    wrapper.accessoryType = indexPath.row > RGTableViewWrapperSeparatorStyleWrapperFull ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    RGIconCell *cell = [wrapper contentCellWithClass:RGIconCell.class style:UITableViewCellStyleSubtitle];
    
    cell.imageView.image = [UIImage rg_coloredImage:UIColor.rg_randomColor size:CGSizeMake(10, 10)];
    cell.imageView.layer.cornerRadius = cell.iconSize.height / 2;
    cell.textLabel.text = @(indexPath.row).stringValue;
    cell.detailTextLabel.text = @"456";
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    view.layer.cornerRadius = 15;
    view.backgroundColor = UIColor.rg_randomColor;
    cell.accessoryView = view;
    cell.backgroundColor = UIColor.groupTableViewBackgroundColor;
    
    return wrapper;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [RGToastView showWithInfo:@(indexPath.row).stringValue duration:1 percentY:0.6 inView:self.view];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row % 2 <= 0;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @[
        [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
            
        }]
    ];
}

#pragma mark - RGTableViewWrapperCellDelegate

- (BOOL)tableView:(UITableView *)tableView wrapperCell:(RGTableViewWrapperCell *)cell canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row % 2 > 0;
}

- (NSArray<RGTableViewWrapperCellRowAction *> *)tableView:(UITableView *)tableView wrapperCell:(RGTableViewWrapperCell *)cell editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @[
        RGTableViewWrapperCellRowAction.action.title(@"Delete").style(UITableViewRowActionStyleDestructive).handler(^(UITableViewRowAction *action, NSIndexPath *indexPath) {
            UIAlertController
            .rg_newAlert(@(indexPath.section).stringValue, @(indexPath.row).stringValue, UIAlertControllerStyleAlert)
            .rg_addAction(@"OK", UIAlertActionStyleDestructive, ^(UIAlertAction * _Nonnull action) {
                
            })
            .rg_presentedBy(self);
        })
    ];;
}

@end
