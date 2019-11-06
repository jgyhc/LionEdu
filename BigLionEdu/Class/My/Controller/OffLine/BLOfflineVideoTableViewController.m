//
//  BLOfflineVideoViewController.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/9.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLOfflineVideoTableViewController.h"
#import "ZLTableViewDelegateManager.h"
#import <MJPlaceholder.h>
#import "BLClassScheduleItemModel.h"
#import <YYCache.h>
#import <YYModel.h>
#import "BLOffLineVideoHeaderView.h"
#import "BLOffLineVideoCell.h"
#import "BLTrainVideoViewController.h"
#import "FKDownloader.h"
#import "NTCatergory.h"
#import "BLOfflineVideoEditViewController.h"

@interface BLOfflineVideoTableViewController ()<ZLTableViewDelegateManagerDelegate, BLOffLineVideoHeaderViewDelegate, BLOffLineVideoCellDelegate, BLOfflineVideoEditViewControllerDelegate>

@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSMutableArray <BLClassScheduleItemModel *>*vdatasCaches;
@property (nonatomic, strong) ZLTableViewSectionModel *videoSection;
@property (nonatomic, strong) NSMutableArray <BLClassScheduleItemModel *>*mdatasCaches;
@property (nonatomic, strong) NSMutableArray *msDatas;
@property (nonatomic, assign) NSInteger index;

@end

@implementation BLOfflineVideoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _index = 1;
    YYCache *cache = [[YYCache alloc] initWithName:@"BL_DOWNLOADS"];
    NSArray <BLClassScheduleItemModel *>*caches = (NSArray *)[cache objectForKey:@"videos"];
    NSArray <BLClassScheduleItemModel *>*mcaches = (NSArray *)[cache objectForKey:@"m_videos"];
    self.vdatasCaches = [NSMutableArray arrayWithArray:caches];
    self.mdatasCaches = [NSMutableArray arrayWithArray:mcaches];
    self.title = @"下载的课程";
    [self.tableView registerClass:[BLOffLineVideoHeaderView class] forHeaderFooterViewReuseIdentifier:@"BLOffLineVideoHeaderView"];
    MJPlaceholderView *view = [[MJPlaceholderView alloc] init];
    view.noDataPlacehoderParam = @{
                                   @"title": @"暂时没有更多数据",
                                   @"image":[UIImage imageNamed:@"placeholder"]
                                   };
    self.tableView.placeholderView = view;
    [self initDatas];
    
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.titleLabel.font = [UIFont systemFontOfSize:14];
    [right setTitleColor:[UIColor nt_colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    [right setTitle:@"批量删除" forState:UIControlStateNormal];
    right.frame = CGRectMake(0, 0, 70, 25);
    [right addTarget:self action:@selector(bl_toDelete) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)bl_toDelete {
    BLOfflineVideoEditViewController *viewController = [[UIStoryboard storyboardWithName:@"My" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLOfflineVideoEditViewController"];
    viewController.datas = self.index == 1 ? self.vdatasCaches : self.mdatasCaches;
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)BLOfflineVideoEditViewControllerDidDelete {
    [self initDatas];
    if (self.index == 1) {
        YYCache *cache = [[YYCache alloc] initWithName:@"BL_DOWNLOADS"];
        [cache setObject:self.vdatasCaches.copy forKey:@"videos"];
    } else {
        YYCache *cache = [[YYCache alloc] initWithName:@"BL_DOWNLOADS"];
        [cache setObject:self.vdatasCaches.copy forKey:@"m_videos"];
    }
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[self.videoSection];
}

- (void)initDatas {
    [self.datas removeAllObjects];
    [self.msDatas removeAllObjects];
    ZLTableViewSectionModel *section = [ZLTableViewSectionModel new];
    section.headerIdentifier = @"BLOffLineVideoHeaderView";
    section.headerHeight = 44.0;
    section.headerBackgroundColor = [UIColor whiteColor];
    section.footerHeight = 0.01;
    section.headerDelegate = self;
    for (BLClassScheduleItemModel *obj in self.vdatasCaches) {
        ZLTableViewRowModel *model = [ZLTableViewRowModel new];
        model.identifier = @"BLOffLineVideoCell";
        model.cellHeight = 70.0;
        model.data = obj;
        model.delegate = self;
        [self.datas addObject:model];
    }
    section.items = self.datas;
    self.videoSection = section;
    [self.manager reloadData];
}

- (void)BLOffLineVideoHeaderViewDidChangeIndex:(NSInteger)index {
    self.index = index;
    if (index == 1) {
        self.videoSection.items = self.datas;
    } else {
        self.videoSection.items = self.msDatas;
    }
    [self.manager reloadData];
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {

}

- (void)BLOffLineVideoCellPush:(BLClassScheduleItemModel *)obj {
    BLTrainVideoViewController *viewController = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTrainVideoViewController"];
    FKTask *task = [[FKDownloadManager manager] acquire:[IMG_URL stringByAppendingString:obj.noteLocation?:@""]];
    obj.noteLocation = task.filePath;
    viewController.model = obj;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.tableView = self.tableView;
        _manager.delegate = self;
    }
    return _manager;
}


- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (NSMutableArray *)msDatas {
    if (!_msDatas) {
        _msDatas = [NSMutableArray array];
    }
    return _msDatas;
}

@end
