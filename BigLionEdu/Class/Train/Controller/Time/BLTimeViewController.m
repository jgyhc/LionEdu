//
//  BLTimeViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/17.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTimeViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLTimeItemModel.h"

@interface BLTimeViewController ()<ZLTableViewDelegateManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;

@end

@implementation BLTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[
             ({
                 ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
                 sectionModel.items = @[
                                        ({
                                            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                                            rowModel.identifier = @"BLTimeItemTableViewCell";
                                            rowModel.cellHeight = 43;
                                            rowModel.data = ({
                                                BLTimeItemModel *model = [BLTimeItemModel new];
                                                model.title = @"0.75X";
                                                model.selected = NO;
                                                model;
                                            });
                                            rowModel;
                                        }),({
                                            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                                            rowModel.identifier = @"BLTimeItemTableViewCell";
                                            rowModel.cellHeight = 43;
                                            rowModel.data = ({
                                                BLTimeItemModel *model = [BLTimeItemModel new];
                                                model.title = @"1X";
                                                model.selected = NO;
                                                model;
                                            });
                                            rowModel;
                                        }),({
                                            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                                            rowModel.identifier = @"BLTimeItemTableViewCell";
                                            rowModel.cellHeight = 43;
                                            rowModel.data = ({
                                                BLTimeItemModel *model = [BLTimeItemModel new];
                                                model.title = @"1.25X";
                                                model.selected = NO;
                                                model;
                                            });
                                            rowModel;
                                        }),({
                                            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                                            rowModel.identifier = @"BLTimeItemTableViewCell";
                                            rowModel.cellHeight = 43;
                                            rowModel.data = ({
                                                BLTimeItemModel *model = [BLTimeItemModel new];
                                                model.title = @"1.5X";
                                                model.selected = NO;
                                                model;
                                            });
                                            rowModel;
                                        }),({
                                            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                                            rowModel.identifier = @"BLTimeItemTableViewCell";
                                            rowModel.cellHeight = 43;
                                            rowModel.data = ({
                                                BLTimeItemModel *model = [BLTimeItemModel new];
                                                model.title = @"2X";
                                                model.selected = NO;
                                                model;
                                            });
                                            rowModel;
                                        }),
                                        ({
                                            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                                            rowModel.identifier = @"BLTimeCancelTableViewCell";
                                            rowModel.cellHeight = 50;
                                            rowModel;
                                        })];
                 sectionModel;
                })
             ];
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
