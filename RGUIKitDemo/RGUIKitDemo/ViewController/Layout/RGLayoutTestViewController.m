//
//  RGLayoutTestViewController.m
//  RGUIKitDemo
//
//  Created by renge on 2020/12/2.
//  Copyright © 2020 ld. All rights reserved.
//

#import "RGLayoutTestViewController.h"
#import <RGUIKit/RGUIKit.h>
#import "RGLayoutTestView.h"

@interface RGLayoutTestViewController ()

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIView *yellowView;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) UIView *blueView;
@property (nonatomic, strong) RGLayoutTestView *pinkView;


@property (nonatomic, strong) NSArray <UIView *> *viewList;

@end

@implementation RGLayoutTestViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.title = @"RGLayout";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _label = [UILabel new];
    
    _yellowView = [UIView new];
    _blueView = [UIView new];
    _bgView = [UIView new];
    _whiteView = [UIView new];
    _pinkView = [RGLayoutTestView new];
    
    _yellowView.backgroundColor = UIColor.yellowColor;
    _blueView.backgroundColor = UIColor.blueColor;
    _bgView.backgroundColor = UIColor.redColor;
    _pinkView.backgroundColor = UIColor.purpleColor;
    _whiteView.backgroundColor = UIColor.rg_systemBackgroundColor;
    
    _label.text = @"Label sadjkasdjashdjashdjash";
    _label.numberOfLines = 0;
    _label.backgroundColor = UIColor.purpleColor;
    
    [self.view addSubview:_bgView];
    [self.view addSubview:_whiteView];
    [self.view addSubview:_yellowView];
    [self.view addSubview:_blueView];
    [self.view addSubview:_pinkView];
    [self.view addSubview:_label];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"RTL/LTR" style:UIBarButtonItemStylePlain target:self action:@selector(RTLSwitch:)];
    
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i < 20; i++) {
        [list addObject:[self createView]];
    }
    self.viewList = list;
}

- (UIView *)createView {
    UIView *view = [UIView new];
    view.backgroundColor = UIColor.rg_randomColor;
    [self.view addSubview:view];
    return view;
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

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGRect bounds = self.view.bounds;
    
    [RGLayout shared]
    
    .inFrame(bounds)
    
    .target(_bgView).sizeMake(bounds.size.width * 0.5, 120).centerIn(bounds).apply()
    
    .inFrame(_bgView.frame)
    
    .target(_yellowView).sizeMake(20, 20).center(_bgView.rg_leadingForBounds, 0).apply()
    
    .target(_whiteView)
    .size(_bgView.rg_size)
    .sizeInsets(UIEdgeInsetsMake(10, 10, 10, 10))
    .centerIn(_bgView.bounds)
    .apply()
    
    .target(_label)
    .sizeFitsWidth(_whiteView.rg_width - 20)
    .width(_whiteView.rg_width - 20)
    .centerIn(_bgView.bounds)
    .apply()
    
    .target(_blueView).sizeMake(20, 20).trailing(5).top(0).apply()
    
    .targetNext(_pinkView, bounds)
    .sizeFontString(_label.text, _whiteView.rg_width - 20, _label.font)
    .width(_label.rg_width)
    .top(_bgView.rg_bottom + 40)
    .trailing(60)
    .apply();
    
    NSLog(@"%@", NSStringFromCGSize(_label.rg_size));
    NSLog(@"%@", NSStringFromCGSize(_pinkView.rg_size));
    
    [self.viewList enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [RGLayout shared].targetNext(obj, bounds).sizeMake(30, 30).top(idx*40);
        
        if (idx % 2) {
            [RGLayout shared].leading(0);
        } else {
            [RGLayout shared].trailing(0);
        }
        
        [RGLayout shared].apply();
    }];
}

@end
