//
//  BLOfflineVideoEditViewController.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/15.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLOfflineVideoEditViewController.h"
#import "ZLTableViewDelegateManager.h"
#import <MJPlaceholder.h>
#import "BLOffLineVideoEditCell.h"
#import <NSArray+BlocksKit.h>
#import <YYCache.h>
#import "FKDownloader.h"
#import <MJPlaceholder.h>

@interface BLOfflineVideoEditViewController ()<ZLTableViewDelegateManagerDelegate, BLOffLineVideoEditCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *selectNumLab;
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic, strong) ZLTableViewSectionModel *videoSection;
@property (nonatomic, strong) NSMutableArray *arr;

@end

@implementation BLOfflineVideoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectNumLab.text = @"已选择0条";
    self.title = @"批量删除";
    MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
    view.noDataPlacehoderParam = @{
                                   @"title": @"暂时没有更多数据",
                                   @"image":[UIImage imageNamed:@"placeholder"]
                                   };
    self.tableView.placeholderView = view;
    self.tableView.tableFooterView = [UIView new];
    [self.selectAllBtn addTarget:self action:@selector(bl_selectAll) forControlEvents:UIControlEventTouchUpInside];
    [self.sureBtn addTarget:self action:@selector(bl_delete) forControlEvents:UIControlEventTouchUpInside];
    [self initData];
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[self.videoSection];
}

- (void)setDatas:(NSMutableArray<BLClassScheduleItemModel *> *)datas {
    _datas = datas;
}

- (void)initData {
    self.arr = [NSMutableArray array];
    for (BLClassScheduleItemModel *obj in self.datas) {
        ZLTableViewRowModel *model = [ZLTableViewRowModel new];
        model.identifier = @"BLOffLineVideoEditCell";
        model.cellHeight = 70.0;
        model.data = obj;
        model.delegate = self;
        [self.arr addObject:model];
    }
    self.videoSection.items = self.arr;
    [self.manager reloadData];
}

- (void)BLOffLineVideoEditCellDidChange {
    NSArray *selects = [self.datas bk_select:^BOOL(BLClassScheduleItemModel *obj) {
        return obj.isSelected;
    }];
    self.selectNumLab.text = [NSString stringWithFormat:@"已选择%ld条", selects.count];
    if (selects.count == self.datas.count) {
        self.selectAllBtn.selected = YES;
    } else {
        self.selectAllBtn.selected  = NO;
    }
}

- (void)bl_selectAll {
    self.selectAllBtn.selected = !self.selectAllBtn.selected;
    if (self.selectAllBtn.selected) {
        for (BLClassScheduleItemModel *obj in self.datas) {
            obj.isSelected = YES;
        }
        self.selectNumLab.text = [NSString stringWithFormat:@"已选择%ld条", self.datas.count];
    } else {
        for (BLClassScheduleItemModel *obj in self.datas) {
            obj.isSelected = NO;
        }
        self.selectNumLab.text = [NSString stringWithFormat:@"已选择0条"];
    }
    [self.manager reloadData];
}

- (void)bl_delete {
    NSArray <BLClassScheduleItemModel *>*selects = [self.datas bk_select:^BOOL(BLClassScheduleItemModel *obj) {
        return obj.isSelected;
    }];
    for (BLClassScheduleItemModel *obj in selects) {
        FKTask *task = [[FKDownloadManager manager] acquire:[IMG_URL stringByAppendingString:obj.noteLocation?:@""]];
        if (task) {
            [task cancel];
        }
    }
    self.selectAllBtn.selected = NO;
    self.selectNumLab.text = @"已选择0条";
    [self.datas removeObjectsInArray:selects];
    [self initData];
    [self.delegate BLOfflineVideoEditViewControllerDidDelete];
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.tableView = self.tableView;
        _manager.delegate = self;
    }
    return _manager;
}

- (ZLTableViewSectionModel *)videoSection {
    if (!_videoSection) {
        ZLTableViewSectionModel *section = [ZLTableViewSectionModel new];
        section.headerHeight = 0.01;
        section.headerBackgroundColor = [UIColor whiteColor];
        section.footerHeight = 0.01;
        section.headerDelegate = self;
        _videoSection = section;
    }
    return _videoSection;
}

@end
