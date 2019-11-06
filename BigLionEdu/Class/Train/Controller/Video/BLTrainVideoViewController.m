//
//  BLTrainVideoViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/6.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTrainVideoViewController.h"
#import "BLZFTableHeaderView.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "NTCatergory.h"
#import <CTMediator.h>
#import "BLTrainVideoInfoTableViewCell.h"
#import "FKDownloader.h"
#import <YYCache.h>
#import <LCProgressHUD.h>
#import "BLVideoShareInfoManager.h"
#import "BLGetCurriculumDetailAPI.h"
#import <YYModel.h>
#import "BLPaperBuyAlertViewController.h"
#import "BLMallOrderSureViewController.h"
#import <SDWebImage.h>

@interface BLTrainVideoViewController ()<UITableViewDelegate, UITableViewDataSource, CTAPIManagerParamSource, MJAPIBaseManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (nonatomic, strong) BLGetCurriculumDetailAPI *getCurriculumDetailAPI;

@property (nonatomic, strong) BLZFTableHeaderView *headerView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFPlayerControlView *controlView;

@property (nonatomic, assign) BOOL didStop;

@end

@implementation BLTrainVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.title = self.model.liveRecCourseTitle;
    self.tableView.estimatedRowHeight = 100.0;
    [self initVideo];
    if (self.model.isDdownload == 1) {
        self.downloadButton.hidden = NO;
        [self.downloadButton addTarget:self action:@selector(bl_beginDownLoad) forControlEvents:UIControlEventTouchUpInside];
    } else {
        self.bottomSpace.constant = 0;
        self.downloadButton.hidden = YES;
    }
    if (self.didDownLoad == YES) {
        self.downloadButton.hidden = YES;
        self.bottomSpace.constant = 0;
    }
    [self.getCurriculumDetailAPI loadData];
}

- (void)initVideo {
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width*9/16);
     [self playTheIndex:0];
    
    /// playerManager
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    /// player的tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerView:self.headerView.coverImageView];
//    self.player.currentPlayerManager.shouldAutoPlay = NO;
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
    
    [self.player setPlayerPlayStateChanged:^(id<ZFPlayerMediaPlayback>  _Nonnull asset, ZFPlayerPlaybackState playState) {
        @strongify(self)
        if (playState == ZFPlayerPlayStatePlaying) {
            if (self.player.currentTime >= 5*60 && ([self.detailModel.isFree isEqualToString:@"1"] && self.detailModel.price.floatValue > 0)) {
                [self.player setPauseByEvent:YES];
                if (self.player.isFullScreen) {
                    [self.controlView.landScapeControlView backBtnClickAction:nil];
                }
                [self buy];
                return ;
            }
        }
    }];
    [self.player setPlayerPlayTimeChanged:^(id<ZFPlayerMediaPlayback>  _Nonnull asset, NSTimeInterval currentTime, NSTimeInterval duration) {
        @strongify(self)
        if (currentTime >= 5*60 && ([self.detailModel.isFree isEqualToString:@"1"] && self.detailModel.price.floatValue > 0)) {
            self.didStop = YES;
            [self.player setPauseByEvent:YES];
            if (self.player.isFullScreen) {
                [self.controlView.landScapeControlView backBtnClickAction:nil];
            }
            [self buy];
        }
    }];
}

- (void)buy {
    NSArray *buttons = @[@{BLPaperBuyAlertControllerButtonTitleKey: @"立即购买",
                BLPaperBuyAlertControllerButtonTextColorKey: [UIColor whiteColor],
                BLPaperBuyAlertControllerButtonBorderColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                BLPaperBuyAlertControllerButtonBorderColorKey: @1,
                BLPaperBuyAlertControllerButtonNormalBackgroundColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                BLPaperBuyAlertControllerButtonRoundedCornersKey:@14.5
    },
        @{BLPaperBuyAlertControllerButtonTitleKey: @"取消",
                BLPaperBuyAlertControllerButtonTextColorKey: [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                BLPaperBuyAlertControllerButtonBorderColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                BLPaperBuyAlertControllerButtonBorderWidthKey: @1,
                BLPaperBuyAlertControllerButtonNormalBackgroundColorKey:[UIColor whiteColor],
                BLPaperBuyAlertControllerButtonRoundedCornersKey:@14.5
    }
    ];
    BLPaperBuyAlertViewController *viewController =
       [[BLPaperBuyAlertViewController alloc] initWithTitle:@"大狮解小吼一声"
                                                content:@"立即购买全部课程"
                                                buttons:buttons tapBlock:^(BLPaperBuyAlertViewController * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
           if ([title isEqualToString:@"立即购买"]) {
               BLMallOrderSureViewController *viewController = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMallOrderSureViewController"];
               BLPaperModel *pModel = [BLPaperModel new];
               pModel.goodsId = self.detailModel.Id;
               pModel.price = self.detailModel.price;
               pModel.coverImg = self.detailModel.coverImg;
               pModel.title = self.detailModel.title;
               viewController.paperModel = pModel;
               viewController.backToController = @"BLVideoClassDetailViewController";
               [self.navigationController pushViewController:viewController animated:YES];
           }
           }];
    viewController.textAlignment = NSTextAlignmentCenter;
    viewController.priceString = [NSString stringWithFormat:@"￥%0.2f/套", [self.detailModel.price doubleValue]];
    viewController.modalPresentationStyle = 0;
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)bl_beginDownLoad {
    YYCache *cache = [[YYCache alloc] initWithName:@"BL_DOWNLOADS"];
    NSArray <BLClassScheduleItemModel *>*caches = (NSArray *)[cache objectForKey:@"videos"];
    if (!cache) {
        [cache setObject:@[self.model] forKey:@"videos"];
        [[FKDownloadManager manager] addTasksWithArray:@[@{FKTaskInfoURL: [IMG_URL stringByAppendingString:self.model.noteLocation?:@""],
                                                           FKTaskInfoTags: @[@"group_task_01"]}]];
        [[FKDownloadManager manager] start:[IMG_URL stringByAppendingString:self.model.noteLocation?:@""]];
        [LCProgressHUD show:@"开始下载"];
    } else {
        BOOL didDownLoad = NO;
        for (BLClassScheduleItemModel *obj in caches) {
            if ([obj.noteLocation isEqualToString:self.model.noteLocation]) {
                didDownLoad = YES;
                break;
            }
        }
        if (!didDownLoad) {
            FKTask *task = [[FKDownloadManager manager] acquire:[IMG_URL stringByAppendingString:self.model.noteLocation?:@""]];
            if (task && task.status == TaskStatusFinish) {
                [LCProgressHUD show:@"该视频已下载"];
            } else if (task && task.status == TaskStatusSuspend) {
                // 恢复任务
                [[FKDownloadManager manager] resume:[IMG_URL stringByAppendingString:self.model.noteLocation?:@""]];
                [LCProgressHUD show:@"恢复下载任务"];
            } else if (task && task.status == TaskStatusExecuting) {
                [LCProgressHUD show:@"该视频正在下载中"];
            } else if (!task) {
                NSMutableArray *arr = [NSMutableArray arrayWithArray:caches];
                [arr addObject:self.model];
                [cache setObject:arr forKey:@"videos"];
                [[FKDownloadManager manager] addTasksWithArray:@[@{FKTaskInfoURL: [IMG_URL stringByAppendingString:self.model.noteLocation?:@""],
                                                                   FKTaskInfoTags: @[@"group_task_01"]}]];
                [[FKDownloadManager manager] start:[IMG_URL stringByAppendingString:self.model.noteLocation?:@""]];
                [LCProgressHUD show:@"开始下载"];
                
                [[FKDownloadManager manager] acquire:[IMG_URL stringByAppendingString:self.model.noteLocation?:@""]].progressBlock = ^(FKTask *task) {
                    NSLog(@"下载进度 %lf", task.progress.fractionCompleted);
                };
            }
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BLTrainVideoInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BLTrainVideoInfoTableViewCell"];
    cell.titleLabel.text = self.model.liveRecCourseTitle;
    cell.subTitleLabel.text = [NSString stringWithFormat:@"时长：%ld分钟", (long)self.model.hours];
    cell.infoLabel.text = @"";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0;
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

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getCurriculumDetailAPI isEqual:manager]) {
        return @{@"recId": @(self.model.liveRecId)};
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getCurriculumDetailAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            _detailModel = [BLClassDetailModel yy_modelWithJSON:[data objectForKey:@"data"]];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

#pragma mark - private

- (void)playTheIndex:(NSInteger)index {
    /// 在这里判断能否播放。。。
    self.player.currentPlayerManager.assetURL = [NSURL URLWithString:[IMG_URL stringByAppendingString:self.model.noteLocation?:@""]];
    [self.controlView showTitle:self.model.liveRecCourseTitle coverURLString:[IMG_URL stringByAppendingString:self.detailModel.coverImg?:@""] fullScreenMode:ZFFullScreenModeLandscape];
    [self.headerView.coverImageView sd_setImageWithURL:[NSURL URLWithString:[IMG_URL stringByAppendingString:self.detailModel.coverImg?:@""]] placeholderImage:[UIImage imageNamed:@"b_placeholder"]];
    if (self.tableView.contentOffset.y > self.headerView.frame.size.height) {
        [self.player addPlayerViewToKeyWindow];
    } else {
        [self.player addPlayerViewToContainerView:self.headerView.coverImageView];
    }
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

- (BLGetCurriculumDetailAPI *)getCurriculumDetailAPI {
    if (!_getCurriculumDetailAPI) {
        _getCurriculumDetailAPI = [[BLGetCurriculumDetailAPI alloc] init];
        _getCurriculumDetailAPI.mj_delegate = self;
        _getCurriculumDetailAPI.paramSource = self;
    }
    return _getCurriculumDetailAPI;
}


@end
