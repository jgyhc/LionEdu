//
//  BLOfflineVideoEditViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/29.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLOfflineVideoEditViewController.h"
#import <ZLTableViewDelegateManager.h>

@interface BLOfflineVideoEditViewController ()<ZLTableViewDelegateManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *allSelectButton;
@property (weak, nonatomic) IBOutlet UIButton *sureButton;
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;

@end

@implementation BLOfflineVideoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0, 0,89.5,35);
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:255/255.0 green:185/255.0 blue:0/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    gl.cornerRadius = 17.5;

    
    [self.sureButton.layer addSublayer:gl];
    [self.sureButton.layer insertSublayer:gl atIndex:-1];
    [self.sureButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.manager reloadData];
    // Do any additional setup after loading the view.
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[({
        ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
        NSMutableArray *items = [NSMutableArray array];
        sectionModel.items = items;
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLOffilineVideoEditTableViewCell";
            rowModel.cellHeight = 66;
            rowModel;
        })];
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLOffilineVideoEditTableViewCell";
            rowModel.cellHeight = 66;
            rowModel;
        })];
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLOffilineVideoEditTableViewCell";
            rowModel.cellHeight = 66;
            rowModel;
        })];
        
        sectionModel;
    })];
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}

@end
