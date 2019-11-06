//
//  BLTrainShareDetailController.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/12.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTrainShareDetailController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLGetCurriculumDetailAPI.h"
#import "BLTrainCurriculumDetailModel.h"
#import <YYModel.h>
#import "BLZFTableHeaderView.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "NTCatergory.h"
#import <CTMediator.h>
#import "BLTrainAudioHeaderView.h"

@interface BLTrainShareDetailController ()<ZLTableViewDelegateManagerDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) BLGetCurriculumDetailAPI *getCurriculumDetailAPI;
@property (nonatomic, strong) BLTrainCurriculumDetailModel *model;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (nonatomic, strong) BLZFTableHeaderView *headerView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@property (nonatomic, strong) BLTrainAudioHeaderView *audioHeader;


@end

@implementation BLTrainShareDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = [NSMutableArray array];
    [self initVidoe];
    [self.manager reloadData];
    [self.getCurriculumDetailAPI loadData];
    
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"g_fx"] style:UIBarButtonItemStylePlain target:self action:@selector(bl_share)];
    self.navigationItem.rightBarButtonItem = shareItem;
}

- (void)bl_share {
    [[CTMediator sharedInstance] performTarget:@"share" action:@"mjshare" params:@{
    @"sid":@"",
    @"shareEventCallbackUrl":@"",
    @"generalOptions": @{
            @"describe": @"别身在福中不知福 ​​​​",
            @"img": @"https://wx3.sinaimg.cn/mw690/67dd74e0gy1g5lpdxwtz5j20u00u0ajl.jpg",
            @"linkurl": @"https://weibo.com/u/3223229794/home?wvr=5#1564759631081",
            @"title": @"别身在福中不知福 ​​​​"
            }
    } shouldCacheTarget:YES];
}

- (void)initVidoe {
    /// playerManager
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// player的tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerView:self.headerView.coverImageView];
    self.player.playerDisapperaPercent = 1.0;
    self.player.playerApperaPercent = 0.0;
    self.player.stopWhileNotVisible = NO;
    CGFloat margin = 20;
    CGFloat w = NT_SCREEN_WIDTH/2;
    CGFloat h = w * 9/16;
    CGFloat x = NT_SCREEN_WIDTH - w - margin;
    CGFloat y = NT_SCREEN_WIDTH - h - margin;
    self.player.smallFloatView.frame = CGRectMake(x, y, w, h);
    self.player.controlView = self.controlView;
    
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
        [UIViewController attemptRotationToDeviceOrientation];
        self.tableView.scrollsToTop = !isFullScreen;
    };
    
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player stopCurrentPlayingCell];
    };
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return self.datas;
}

- (id)paramsForApi:(CTAPIBaseManager *)manager {
    return @{@"recId": @(self.Id)};
}

- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    [self.datas removeAllObjects];
    self.model = [BLTrainCurriculumDetailModel yy_modelWithJSON:data[@"data"]];
    self.title = self.model.title;
    if (self.model.isVideo) {
        self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*9/16);
        [self.view addSubview:self.headerView];
        self.topConstraint.constant = self.view.frame.size.width*9/16;
         [self playTheIndex:0];
    } else if (self.model.lionFilePath.length > 0){
        self.audioHeader = [BLTrainAudioHeaderView new];
        self.audioHeader.frame = CGRectMake(0, 0, self.view.frame.size.width, 375*9/16);
        self.audioHeader.model = self.model;
        [self.view addSubview:self.audioHeader];
        self.topConstraint.constant = 375*9/16;
    }
    
    ZLTableViewSectionModel *teacherSection = [ZLTableViewSectionModel new];
    if (self.model.lionFilePath.length > 0) {
        teacherSection.headerHeight = 10.0;
    }
    teacherSection.headerBackgroundColor = [UIColor nt_colorWithHexString:@"#F8F9FA"];
    teacherSection.footerHeight = 0.0;
    NSMutableArray *items = [NSMutableArray array];
    
    for (BLTrainShareDetailTutorModel *obj in self.model.tutorDTOS) {
        ZLTableViewRowModel *introRow = [ZLTableViewRowModel new];
        introRow.cellHeight = -1;
        introRow.identifier = @"BLTrainShareTeacherInfoCell";
        introRow.data = obj;
        [items addObject:introRow];
    }
    teacherSection.items = items.copy;
    
    ZLTableViewSectionModel *introSection = [ZLTableViewSectionModel new];
    introSection.headerHeight = 10.0;
    introSection.headerBackgroundColor = [UIColor nt_colorWithHexString:@"#F8F9FA"];
    introSection.footerHeight = 0.0;
    
    ZLTableViewRowModel *detailRow = [ZLTableViewRowModel new];
    detailRow.cellHeight = -1;
    detailRow.identifier = @"BLTrainShareDetailCell";
    detailRow.data = self.model;
    introSection.items = @[detailRow];
    
    [self.datas addObject:teacherSection];
    [self.datas addObject:introSection];
    
    [self.manager reloadData];
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    CGFloat y = CGRectGetMaxY(self.navigationController.navigationBar.frame);
    CGFloat h = CGRectGetMaxY(self.view.frame);
    self.tableView.frame = CGRectMake(0, y, self.view.frame.size.width, h-y);
}

- (BOOL)shouldAutorotate {
    /// 如果只是支持iOS9+ 那直接return NO即可，这里为了适配iOS8
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - private

- (void)playTheIndex:(NSInteger)index {
    /// 在这里判断能否播放。。。
    self.player.currentPlayerManager.assetURL = [NSURL URLWithString:[IMG_URL stringByAppendingString:self.model.lionFilePath?:@""]];
    [self.controlView showTitle:self.model.title coverURLString:[IMG_URL stringByAppendingString:self.model.coverImg?:@""] fullScreenMode:ZFFullScreenModeLandscape];
    
    if (self.tableView.contentOffset.y > self.headerView.frame.size.height) {
        [self.player addPlayerViewToKeyWindow];
    } else {
        [self.player addPlayerViewToContainerView:self.headerView.coverImageView];
    }
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}

- (BLGetCurriculumDetailAPI *)getCurriculumDetailAPI {
    if (!_getCurriculumDetailAPI) {
        _getCurriculumDetailAPI = [BLGetCurriculumDetailAPI new];
        _getCurriculumDetailAPI.paramSource = self;
        _getCurriculumDetailAPI.mj_delegate = self;
    }
    return _getCurriculumDetailAPI;
}

- (BLZFTableHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[BLZFTableHeaderView alloc] init];
        @weakify(self)
        _headerView.playCallback = ^{
            @strongify(self)
            [self playTheIndex:0];
        };
    }
    return _headerView;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        _controlView.fastViewAnimated = YES;
        _controlView.prepareShowLoading = YES;
    }
    return _controlView;
}

@end
