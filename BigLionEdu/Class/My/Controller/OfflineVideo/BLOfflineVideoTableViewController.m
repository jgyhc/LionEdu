//
//  BLMyClassTableViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLOfflineVideoTableViewController.h"
#import <ZLTableViewDelegateManager.h>


@interface BLOfflineVideoTableViewController ()<ZLTableViewDelegateManagerDelegate>
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@end

@implementation BLOfflineVideoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.manager reloadData];
}

- (UIView *)listView {
    return self.view;
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[({
        ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
        NSMutableArray *items = [NSMutableArray array];
        sectionModel.items = items;
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLOfflineVideoTableViewCell";
            rowModel.cellHeight = 66;
            rowModel;
        })];
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLOfflineVideoTableViewCell";
            rowModel.cellHeight = 66;
            rowModel;
        })];
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLOfflineVideoTableViewCell";
            rowModel.cellHeight = 66;
            rowModel;
        })];
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLOfflineVideoTableViewCell";
            rowModel.cellHeight = 66;
            rowModel;
        })];
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLOfflineVideoTableViewCell";
            rowModel.cellHeight = 66;
            rowModel;
        })];
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLOfflineVideoTableViewCell";
            rowModel.cellHeight = 66;
            rowModel;
        })];
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLOfflineVideoTableViewCell";
            rowModel.cellHeight = 66;
            rowModel;
        })];
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLOfflineVideoTableViewCell";
            rowModel.cellHeight = 66;
            rowModel;
        })];
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLOfflineVideoTableViewCell";
            rowModel.cellHeight = 66;
            rowModel;
        })];
        [items addObject:({
            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
            rowModel.identifier = @"BLOfflineVideoTableViewCell";
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
