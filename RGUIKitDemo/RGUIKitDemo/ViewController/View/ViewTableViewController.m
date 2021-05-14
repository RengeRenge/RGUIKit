//
//  ViewTableViewController.m
//  RGUIKitDemo
//
//  Created by renge on 2021/5/14.
//  Copyright © 2021 ld. All rights reserved.
//

#import "ViewTableViewController.h"
#import <RGUIKit/RGUIKit.h>

#import "RGTableViewCellsViewController.h"
#import "RGNavigationTestViewController.h"
#import "RGBluuurViewDisplayViewController.h"

typedef enum : NSUInteger {
    ViewTypeRGCells,
    ViewTypeRGBluuurView,
    ViewTypeCount,
} ViewType;

@interface ViewTableViewController ()

@end

@implementation ViewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Views";
    
    [self.tableView registerClass:RGTableViewCell.class forCellReuseIdentifier:RGCellIDDefault];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"RGNavigation" style:UIBarButtonItemStylePlain target:self action:@selector(rgNavigation:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"RTL/LTR" style:UIBarButtonItemStylePlain target:self action:@selector(RTLSwitch:)];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ViewTypeCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RGCellIDDefault forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.row) {
        case ViewTypeRGCells:
            cell.textLabel.text = @"RGTableViewCell";
            break;
        case ViewTypeRGBluuurView:
            cell.textLabel.text = @"RGBluuurView";
            break;
        default:
            cell.textLabel.text = nil;
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case ViewTypeRGCells:
            [[RGTableViewCellsViewController alloc] initWithStyle:UITableViewStyleGrouped]
            .rg_hidesBottomBarWhenPushed().rg_pushedBy(self);
            break;
        case ViewTypeRGBluuurView:
            RGBluuurViewDisplayViewController.new
            .rg_hidesBottomBarWhenPushed().rg_pushedBy(self);
            break;
        default:
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            break;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
