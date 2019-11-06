//
//  BLTopicBaseViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/6.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTopicBaseViewController.h"
#import <objc/runtime.h>
#import "UIColor+NTAdd.h"
#import "BLInsertDailyTipAPI.h"
#import "BLTopicMaterialImageTableViewCell.h"
#import <NSArray+BlocksKit.h>
#import <YYCache.h>
#import <YYModel.h>
#import "BLAnswerCardModel.h"
#import "BLTopicVideoModel.h"
#import <AVFoundation/AVFoundation.h>
#import "BLTopicAnalysisVoiceTableViewCell.h"
#import <SJVideoPlayer/SJVideoPlayer.h>
#import "BLTopicAnalysisVideoContentTableViewCell.h"
#import "BLTopicOptionTableViewCell.h"
#import "BLTopicAnalysisContentTableViewCell.h"
#import "AdaptScreenHelp.h"

@interface BLTopicBaseViewController ()<BLTopicDragDropViewDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource, BLTopicMaterialImageTableViewCellDelegate, UIGestureRecognizerDelegate, BLTopicAnalysisVoiceTableViewCellDelegate, BLTopicAnalysisVideoContentTableViewCellDelegate, BLTopicAnalysisContentTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewBottomSpace;

@property (nonatomic, strong) BLInsertDailyTipAPI * insertDailyTipAPI;//每日一练增加

@property (nonatomic, strong) ZLTableViewDelegateManager *manager;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (nonatomic, strong) YYCache *dailyCache;

@property (nonatomic, strong) AVPlayer *player;

@property (nonatomic, strong) AVPlayerItem *playerItem;

@property (nonatomic, strong) GKSliderView *sliderView;

@property (nonatomic, strong) BLTopicVoiceModel * voiceModel;

@property (nonatomic, strong, nullable) SJVideoPlayer *videoplayer;

@end

@implementation BLTopicBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, 50);
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:253/255.0 green:215/255.0 blue:98/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:249/255.0 green:120/255.0 blue:25/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    
    [self.sureButton.layer addSublayer:gl];
    [self.sureButton.layer insertSublayer:gl atIndex:0];
    [self.sureButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.manager reloadData];
    _bottomLabel.hidden = [_model.isDaily isEqualToString:@"Y"];
    _sureButton.hidden = YES;
    if (_model.isParsing) {
        _bottomLabel.hidden = YES;
    }
    if (_isLast) {
        [self setLeftSwipe];
    }
    
}

// 轻扫
- (void)setLeftSwipe {
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipe.delegate = self;
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.tableView addGestureRecognizer:swipe];
}

- (void)swipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(lastLeftSwipe)]) {
            [self.delegate lastLeftSwipe];
        }
    }else{
    }
}

//让自身这个手势事件响应优先级低于其它手势事件
//只是在对于比它响应优先级低的手势调用
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer  {
    return YES;
}

//让自身这个手势事件响应优先级高于其它手势事件
//只是在对于比它响应优先级高的手势调用
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer.view isEqual:self.tableView] && _isLast) {
        return NO;
    }
    return YES;
}

#pragma mark -- BLTopicOptionTableViewCell method
- (void)updateCellHeight:(CGFloat)cellHeight cell:(BLTopicOptionTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath) {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

- (void)sureButtonHide:(BOOL)hidden {
    if ([_model.isDaily isEqualToString:@"Y"]) {
        self.sureButton.hidden = hidden;
    }
}

- (IBAction)backEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sureEvent:(id)sender {
    _sureButton.hidden = YES;
    _model.isParsing = YES;
    [self.insertDailyTipAPI loadData];
    
    NSInteger questionId = self.model.Id;
    
    __block double sectionScore = 0.0;//大题总得分
    if ([self.model.materialType isEqualToString:@"1"]) {
        NSMutableArray *mapList = [NSMutableArray array];
        questionId = self.model.materialId;
        [self.model.questionList enumerateObjectsUsingBlock:^(BLTopicModel * _Nonnull topic, NSUInteger idx, BOOL * _Nonnull stop) {
            sectionScore = sectionScore + topic.score;
            if (topic.submitAnswer || [topic.isManual isEqualToString:@"1"]) {
                [mapList addObject:@{
                                     @"functionTypeId": @(topic.functionTypeId),
                                     @"isManual": topic.isManual?topic.isManual:@"",
                                     @"isMaterial": topic.materialType?topic.materialType:@"",
                                     @"mapList": @[],
                                     @"memAnswer": [self.model.submitAnswer yy_modelToJSONString],
                                     @"modelId": @(topic.modelId),
                                     @"questionId": @(topic.Id),
                                     @"setId": @(topic.setId),
                                     @"type": topic.type?topic.type:@"",
                                     @"isCorrect": self.model.isCorrect?self.model.isCorrect:@"",
                                     @"score": self.model.score?@(self.model.score):@0,
                                     @"usedTime": @(topic.timeInterval)
                                   }];
            }
        }];
        [self.dailyCache setObject:mapList forKey:[@(self.model.Id) stringValue]];
    }else {
        if (self.model.submitAnswer || [self.model.isManual isEqualToString:@"1"]) {
                NSDictionary *info = @{
                  @"functionTypeId": @(self.model.functionTypeId),
                  @"isManual": self.model.isManual?self.model.isManual:@"",
                  @"isMaterial": self.model.materialType?self.model.materialType:@"",
        //          @"mapList": mapList,
                  @"memAnswer": self.model.submitAnswer? [self.model.submitAnswer yy_modelToJSONString] : @"",
                  @"modelId": @(self.model.modelId),
                  @"questionId": @(questionId),
                  @"setId": @(self.model.setId),
                  @"type": self.model.type?self.model.type:@"",
                  @"isCorrect": self.model.isCorrect?self.model.isCorrect:@"",
                  @"score": self.model.score?@(self.model.score):@0,
                  @"usedTime": @(self.model.timeInterval)
                };
                [self.dailyCache setObject:@[info] forKey:[@(self.model.Id) stringValue]];
            }
    }
    if (!_answerSectionModel) {
        [self.datas addObject:self.answerSectionModel];
    }
    [self.manager reloadData];
}

- (void)pausePlayer:(BLTopicVoiceModel *)model sliderView:(GKSliderView *)sliderView {
    [self.player pause];
}

- (void)sliderProgress:(CGFloat)value model:(BLTopicVoiceModel *)model sliderView:(GKSliderView *)sliderView {
    //根据值计算时间
    float time = value * CMTimeGetSeconds(self.player.currentItem.duration);
    //跳转到当前指定时间
    [self.player seekToTime:CMTimeMake(time, 1)];
}

- (void)startPlayer:(BLTopicVoiceModel *)model sliderView:(GKSliderView *)sliderView {
    [self.videoplayer pause];
    if ([self.voiceModel isEqual:model]) {
        [self.player play];
        return;
    }
    _voiceModel = model;
    _sliderView = sliderView;
    self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:model.url]];
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem ];;
    [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    [self.player.currentItem addObserver:self
                              forKeyPath:@"loadedTimeRanges"
                                 options:NSKeyValueObservingOptionNew
                                 context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playFinished:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:_player.currentItem];
    [self.player play];
    
//    __weak typeof(self) weakSelf = self;
    __weak typeof(self) wself = self;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        //当前播放的时间
        float current = CMTimeGetSeconds(time);
        NSLog(@"%lf", current);
        //总时间
        float total = CMTimeGetSeconds(wself.playerItem.duration);
        if (current) {
            if (wself.sliderView.draging) {
                return;
            }
            float progress = current / total;
            //更新播放进度条
            sliderView.value = progress;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"BLTopicVoiceProgressNotificationKey" object:model userInfo:@{@"value": @(current),
                                                                                                                       @"total": @(total)}];
        }
    }];
}

- (void)playFinished:(NSNotification *)notification {
    NSLog(@"播放完成了");
    _sliderView.value = 0.0;
    _voiceModel = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BLTopicVoiceDidEndNotificationKey" object:_voiceModel userInfo:nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
            {
                NSLog(@"未知转态");
            }
                break;
            case AVPlayerStatusReadyToPlay:
            {
                NSLog(@"准备播放");
            }
                break;
            case AVPlayerStatusFailed:
            {
                NSLog(@"加载失败");
            }
                break;

            default:
                break;
        }

    }
    if ([keyPath isEqualToString:@"loadedTimeRanges"]) {

        NSArray * timeRanges = self.player.currentItem.loadedTimeRanges;
        //本次缓冲的时间范围
        CMTimeRange timeRange = [timeRanges.firstObject CMTimeRangeValue];
        //缓冲总长度
        NSTimeInterval totalLoadTime = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
        //音乐的总时间
        NSTimeInterval duration = CMTimeGetSeconds(self.player.currentItem.duration);
        //计算缓冲百分比例
        NSTimeInterval scale = totalLoadTime/duration;
        //更新缓冲进度条
        self.sliderView.bufferValue = scale;
    }
}

- (void)setModel:(BLTopicModel *)model {
    _model = model;
    if ([model.isDaily isEqualToString:@"1"]) {
       id obj = [self.dailyCache objectForKey:[@(self.model.Id) stringValue]];
       if (obj) {
           if ([model.materialType isEqualToString:@"1"]) {
               NSArray<BLAnswerCardModel *> *list = [NSArray yy_modelArrayWithClass:[BLAnswerCardModel class] json:obj];
               [model.questionList enumerateObjectsUsingBlock:^(BLTopicModel * _Nonnull topic, NSUInteger idx, BOOL * _Nonnull stop) {
                   [list enumerateObjectsUsingBlock:^(BLAnswerCardModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                       if (obj.questionId == topic.Id) {
                           topic.memAnswer = obj.memAnswer;
                       }
                   }];
               }];
           }else {
               NSArray<BLAnswerCardModel *> *list = [NSArray yy_modelArrayWithClass:[BLAnswerCardModel class] json:obj];
               BLAnswerCardModel *answer = [list firstObject];
               if (self.model.Id == answer.questionId) {
                   self.model.memAnswer = answer.memAnswer;
               }
           }
           _model.isParsing = YES;
       }
       
       if ([model.materialType isEqualToString:@"1"]) {
           [model.questionList enumerateObjectsUsingBlock:^(BLTopicModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
               
           }];
       }
    }
    [self viewDataInit:model];
    if (![model.materialType isEqualToString:@"1"] && model.isParsing && !_answerSectionModel) {
        [self.datas addObject:self.answerSectionModel];
    }
}

- (void)viewDataInit:(BLTopicModel *)model {
    
}

- (void)updateCellHeightWithCell:(UITableViewCell *)tableViewCell model:(BLTopicImageModel *)model cellHeight:(CGFloat)cellHeight {
    ZLTableViewRowModel *rowModel = [self.answerSectionModel.items bk_match:^BOOL(ZLTableViewRowModel * obj) {
        return [obj.data isEqual:model];
    }];
    if (rowModel) {
        rowModel.cellHeight = cellHeight;
        [self.tableView reloadData];
    }
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.insertDailyTipAPI isEqual:manager]) {
        return @{
          @"functionTypeId": @(_model.functionTypeId),
          @"modelId": @(_model.modelId),
          @"questionId": @(_model.Id)
        };
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.insertDailyTipAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

#pragma mark -- BLTopicDragDropViewDelegate method
- (UIScrollView *)bottomScrollView {
    return self.tableView;
}

- (void)updateBottomScrollViewWithY:(CGFloat)y {
    self.tableViewBottomSpace.constant = [UIScreen mainScreen].bounds.size.height - y - 100 - BottomSpace();
    [self.view layoutIfNeeded];
}


- (void)listDidAppear {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewdidShow:)]) {
        [self.delegate viewdidShow:_model];
    }
}

- (void)listDidDisappear {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewdidHide:)]) {
        [self.delegate viewdidHide:_model];
    }
    if (self.videoplayer) {
        [self.videoplayer pause];
    }
    if (self.player) {
        [self.player pause];
    }
}

- (UIView *)contentView {
    return self.view;
}

- (UIView *)listView {
    return self.view;
}

- (UIView *)subView {
    return self.subTopicBaseViewController.view;
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return self.datas;
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
//    if ([model.identifier isEqualToString:@"BLTopicHelpTableViewCell"]) {
//        _model.isSelectHelp = !_model.isSelectHelp;
//        [self.tableView reloadData];
//        return;
////        if ([_model.isDaily isEqualToString:@"1"]) {
////            if (!_answerSectionModel) {
////                [self.datas addObject:self.answerSectionModel];
////                [self.manager reloadData];
////            }
////        }
//    }
    
    [self cellDidSelectWithModel:model manager:manager indexPath:indexPath];
}

- (void)cellDidSelectWithModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    if ([model.identifier isEqualToString:@"BLTopicAnalysisVideoContentTableViewCell"]) {
        
       
    }
    [self subCellDidSelectWithModel:model manager:manager indexPath:indexPath];
}

- (void)subCellDidSelectWithModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    
}

- (void)tappedCoverOnTheTableViewCell:(BLTopicAnalysisVideoContentTableViewCell *)cell model:(BLTopicVideoModel *)model {
    if ( _videoplayer == nil ) {
       _videoplayer = [SJVideoPlayer player];
       _videoplayer.fastForwardViewController.enabled = YES;
       _videoplayer.allowHorizontalTriggeringOfPanGesturesInCells = YES;
       [self _observePlayerViewAppearState];
   }
    [self.player pause];
    NSIndexPath *indexPath = [_tableView indexPathForCell:cell];
    SJPlayModel *cellModel = [SJPlayModel UITableViewCellPlayModelWithPlayerSuperviewTag:1001 atIndexPath:indexPath tableView:_tableView];
    _videoplayer.URLAsset = [[SJVideoPlayerURLAsset alloc] initWithURL:[NSURL URLWithString:model.url] playModel:cellModel];
}


- (void)_observePlayerViewAppearState {
    _videoplayer.playerViewWillAppearExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull videoPlayer) {
#ifdef DEBUG
        NSLog(@"- playerViewWillAppear -");
#endif
    };
    
    _videoplayer.playerViewWillDisappearExeBlock = ^(__kindof SJBaseVideoPlayer * _Nonnull videoPlayer) {
#ifdef DEBUG
        NSLog(@"- playerViewWillDisappear -");
#endif
    };
}
//
//- (void)_addTestEdgeItemsToPlayer {
//    SJEdgeControlButtonItem *pushItem = [[SJEdgeControlButtonItem alloc] initWithTitle:[NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
////        make.append(@"Push");
////        make.textColor([UIColor greenColor]);
////        make.font([UIFont boldSystemFontOfSize:20]);
//    }] target:self action:@selector(testPushAction:) tag:1000];
//
//    [_videoplayer.defaultEdgeControlLayer.rightAdapter addItem:pushItem];
//
//    SJEdgeControlButtonItem *alertItem = [[SJEdgeControlButtonItem alloc] initWithTitle:[NSAttributedString sj_UIKitText:^(id<SJUIKitTextMakerProtocol>  _Nonnull make) {
////        make.append(@"Alert");
////        make.textColor([UIColor greenColor]);
////        make.font([UIFont boldSystemFontOfSize:20]);
//    }] target:self action:@selector(testAlertItem:) tag:1001];
//    alertItem.insets = SJEdgeInsetsMake(12, 0);
//    [_videoplayer.defaultEdgeControlLayer.rightAdapter addItem:alertItem];
//
//    [_videoplayer.defaultEdgeControlLayer.rightAdapter reload];
//}


- (ZLTableViewSectionModel *)sectionModel {
    if (!_sectionModel) {
        _sectionModel = [ZLTableViewSectionModel new];
    }
    return _sectionModel;
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}


- (BLTopicDragDropView *)topicDragDropView {
    if (!_topicDragDropView) {
        _topicDragDropView = [[BLTopicDragDropView alloc] init];
        _topicDragDropView.delegate = self;
    }
    return _topicDragDropView;
}

- (BLTopicViewController *)subTopicBaseViewController {
    if (!_subTopicBaseViewController) {
        _subTopicBaseViewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicViewController"];
//        object_setClass(_subTopicBaseViewController, NSClassFromString(@"BLMultipleChoiceTopicViewController"));
        _subTopicBaseViewController.isSubController = YES;
        __weak typeof(self) wself = self;
        [_subTopicBaseViewController setDidFinishHandler:^(NSInteger index, BLTopicModel * _Nonnull model) {
            if (wself.delegate && [wself.delegate respondsToSelector:@selector(radilDidFinishWithModel:)]) {
                [wself.delegate radilDidFinishWithModel:model];
            }
        }];
    }
    return _subTopicBaseViewController;
}

- (ZLTableViewSectionModel *)answerSectionModel {
    if (!_answerSectionModel) {
        _answerSectionModel = ({
            ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
            sectionModel.headerHeight = 10;
            sectionModel.headerBackgroundColor = [UIColor nt_colorWithHexString:@"#F8F9FA"];
            NSMutableArray *items = [NSMutableArray array];
            sectionModel.items = items;
            [items addObject:({
                ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                rowModel.identifier = @"BLTopicAnalysisTextTableViewCell";
                rowModel.data = _model;
                rowModel.cellHeight = 50;
                rowModel;
            })];
            [items addObject:({
                ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                rowModel.identifier = @"BLTopicAnalysisTitleTableViewCell";
                rowModel.data = _model;
                rowModel.cellHeight = 40;
                rowModel;
            })];
            
            [self.model.analysisArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([obj isKindOfClass:[BLTopicTextModel class]]) {
                    [items addObject:({
                        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                        rowModel.identifier = @"BLTopicAnalysisContentTableViewCell";
                        rowModel.data = obj;
                        rowModel.cellHeight = -1;
                        rowModel.delegate = self;
                        rowModel;
                    })];
                }
                if ([obj isKindOfClass:[BLTopicImageModel class]]) {
                    [items addObject:(({
                        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                        rowModel.identifier = @"BLTopicMaterialImageTableViewCell";
                        rowModel.cellHeight = 100;
                        rowModel.delegate = self;
                        rowModel.data = obj;
                        rowModel;
                    }))];
                }
                if ([obj isKindOfClass:[BLTopicVoiceModel class]]) {
                    
                    [items addObject:(({
                        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                        rowModel.identifier = @"BLTopicAnalysisVoiceTableViewCell";
                        rowModel.cellHeight = 80;
                        rowModel.delegate = self;
                        rowModel.data = obj;
                        rowModel;
                    }))];
                }
                if ([obj isKindOfClass:[BLTopicVideoModel class]]) {
                    [items addObject:(({
                        ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                        rowModel.identifier = @"BLTopicAnalysisVideoContentTableViewCell";
                        rowModel.cellHeight = 164;
                        rowModel.delegate = self;
                        rowModel.data = obj;
                        rowModel;
                    }))];
                }
            }];
            
            
            sectionModel;
        });
    }
    return _answerSectionModel;
}

- (NSArray *)topicTitleArray {
    if (!_topicTitleArray) {
        NSMutableArray *array = [NSMutableArray array];
        if (![self.model.isDaily isEqualToString:@"Y"] && !_model.isSingle) {
             [array addObject:({
                    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                    rowModel.identifier = @"BLTopicTitleTableViewCell";
                    rowModel.cellHeight = -1;
                    rowModel.data = _model;
                    rowModel;
                })];
         }
        
        [self.model.titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[BLTopicTextModel class]]) {
                [array addObject:({
                    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                    rowModel.identifier = @"BLTopicAnalysisContentTableViewCell";
                    rowModel.data = obj;
                    rowModel.cellHeight = -1;
                    rowModel.delegate = self;
                    rowModel;
                })];
            }
            if ([obj isKindOfClass:[BLTopicImageModel class]]) {
                [array addObject:(({
                    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                    rowModel.identifier = @"BLTopicMaterialImageTableViewCell";
                    rowModel.cellHeight = 100;
                    rowModel.delegate = self;
                    rowModel.data = obj;
                    rowModel;
                }))];
            }
            if ([obj isKindOfClass:[BLTopicVoiceModel class]]) {
                
                [array addObject:(({
                    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                    rowModel.identifier = @"BLTopicAnalysisVoiceTableViewCell";
                    rowModel.cellHeight = 80;
                    rowModel.delegate = self;
                    rowModel.data = obj;
                    rowModel;
                }))];
            }
            if ([obj isKindOfClass:[BLTopicVideoModel class]]) {
                [array addObject:(({
                    ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                    rowModel.identifier = @"BLTopicAnalysisVideoContentTableViewCell";
                    rowModel.cellHeight = 164;
                    rowModel.delegate = self;
                    rowModel.data = obj;
                    rowModel;
                }))];
            }
        }];
//         [array addObject:({
//             ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
//             rowModel.identifier = @"BLTopicSubjectTableViewCell";
//             rowModel.cellHeight = -1;
//             rowModel.data = _model;
//             rowModel;
//         })];
        _topicTitleArray = array;
    }
    return _topicTitleArray;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (BLInsertDailyTipAPI *)insertDailyTipAPI {
    if (!_insertDailyTipAPI) {
        _insertDailyTipAPI = [[BLInsertDailyTipAPI alloc] init];
        _insertDailyTipAPI.mj_delegate = self;
        _insertDailyTipAPI.paramSource = self;
    }
    return _insertDailyTipAPI;
}

- (YYCache *)dailyCache {
    if (!_dailyCache) {
        _dailyCache = [[YYCache alloc] initWithName:@"dailyQuestion"];
    }
    return _dailyCache;
}

@end
