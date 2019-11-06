//
//  BLTopicViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTopicViewController.h"
#import "BLTopicCollectionViewCell.h"
#import "BLTopicBaseViewController.h"
#import "JXCategoryListContainerView.h"
#import <Masonry.h>
#import <objc/runtime.h>
#import "BLGetQuestionListAPI.h"
#import "BLTopicModel.h"
#import <YYModel.h>
#import "BLQuestionAddCollectionAPI.h"
#import "MJDropDownMenuView.h"
#import "BHBDrawBoarderView.h"
#import "BLTextAlertViewController.h"
#import "BLCancelMyCollectionAPI.h"
#import "BLTopicSectionModel.h"
#import <NSArray+BlocksKit.h>
#import "BLAnswerSheetNavViewController.h"
#import "BLAnswerSheetViewController.h"
#import "BLAnswerReportViewController.h"
#import "BLSubmissionAnswerAPI.h"
#import "BLAnswerCardModel.h"
#import "BLFeedbackTableViewController.h"
#import "BLTopicFontManager.h"
#import "BLTopicPaperModel.h"

@interface BLTopicViewController ()<MJDropDownMenuViewDelegate, JXCategoryListContainerViewDelegate, JXCategoryViewDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource, BLTopicBaseViewControllerDelegate, BLAnswerSheetViewControllerDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryTitleView;
@property (weak, nonatomic) IBOutlet UIView *navView;

@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (nonatomic,strong) BHBDrawBoarderView * bv;
@property (nonatomic, strong) MJDropDownMenuView *dropDownMenuView;

@property (nonatomic, strong) JXCategoryListContainerView *categoryListContainerView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UIView *draftView;//草稿

@property (weak, nonatomic) IBOutlet UIView *answerSheetView;//答题卡

@property (weak, nonatomic) IBOutlet UIView *collectView;//收藏

@property (weak, nonatomic) IBOutlet UIButton *moreButton;//更多按钮

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;//倒计时

@property(nonatomic,strong) NSTimer *clockTimer;
@property (strong,nonatomic) dispatch_source_t sourceTimer;
@property(nonatomic,assign) NSInteger seconds;//答题时间

//@property (nonatomic, strong) NSArray *viewController;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) BLGetQuestionListAPI *getQuestionListAPI;

@property (nonatomic, strong) BLQuestionAddCollectionAPI * questionAddCollectionAPI;
@property (nonatomic, strong) BLCancelMyCollectionAPI * cancelMyCollectionAPI;

@property (nonatomic, strong) BLSubmissionAnswerAPI *submissionAnswerAPI;
@property (nonatomic, strong) NSArray * topicList;

@property (nonatomic, strong) BLTopicModel *currentModel;//当前正在回答的题

@property (nonatomic, strong) BLTopicModel *analysisModel;

@property (nonatomic, strong) BLTopicPaperModel * paperModel;//当前答题的试题实体

@end

@implementation BLTopicViewController

- (void)dealloc {
    _clockTimer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    _categoryTitleView = [JXCategoryTitleView new];
    _categoryTitleView.titleColorGradientEnabled = YES;
    _categoryTitleView.delegate = self;

    self.categoryListContainerView = [[JXCategoryListContainerView alloc] initWithDelegate:self];
    self.categoryListContainerView.didAppearPercent = 0.01;
    [self.view addSubview:self.categoryListContainerView];

    _timeLabel.hidden = YES;
    _timeLabel.text = @"";
 //滚动一点就触发加载
    self.categoryTitleView.contentScrollView = self.categoryListContainerView.scrollView;
    if (_analysisTopicList) {//解析模式
        [self.answerSheetView removeFromSuperview];
        [self.draftView removeFromSuperview];
        self.topicList = self.analysisTopicList;
        self.timeLabel.hidden = YES;
    }else if (_topicModel) {//每日一练
        _timeLabel.hidden = YES;
        [self.answerSheetView removeFromSuperview];
//        [self.stackView removeArrangedSubview:self.draftView];
        _topicModel.modelId = _modelId;
        _topicModel.functionTypeId = _functionTypeId;
        self.topicList = @[_topicModel];
        _topicModel.isDaily = @"Y";
        
        [self.categoryTitleView reloadData];
        [self.categoryListContainerView reloadData];
    }else if(_materialTopicModel) {
        _materialTopicModel.modelId = _modelId;
        _materialTopicModel.functionTypeId = _functionTypeId;
        if (_isError) {
            self.topicList = _materialTopicModel.errorQuestionList;
        }else {
            self.topicList = _materialTopicModel.questionList;
        }
        [self.categoryTitleView reloadData];
        [self.categoryListContainerView reloadData];
    }else if(_analysisParams) {
        
        _analysisModel = [BLTopicModel yy_modelWithJSON:_analysisParams];
        [self.answerSheetView removeFromSuperview];
        [self.draftView removeFromSuperview];
        [self.moreButton removeFromSuperview];
        _analysisModel.modelId = _modelId;
        _analysisModel.functionTypeId = _functionTypeId;
        _topicList = @[_analysisModel];
        _analysisModel.isParsing = YES;
        _analysisModel.isSingle = YES;
        [self.categoryTitleView reloadData];
        [self.categoryListContainerView reloadData];
    }else {
        _timeLabel.hidden = NO;
        [self.getQuestionListAPI loadData];
    }
    
    if (!_isSubController) {
        self.navView.hidden = NO;
        [self.categoryListContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.navView.mas_bottom);
            make.left.right.bottom.mas_equalTo(self.view);
        }];
    }else {
        self.navView.hidden = YES;
        [self.categoryListContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.mas_equalTo(self.view);
        }];
    }
}

- (void)setAnalysisTopicList:(NSArray *)analysisTopicList {
    _analysisTopicList = analysisTopicList;
    [_analysisTopicList enumerateObjectsUsingBlock:^(BLTopicModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isParsing = YES;
        if ([obj.materialType isEqualToString:@"1"]) {
            [obj.questionList enumerateObjectsUsingBlock:^(BLTopicModel * _Nonnull subObj, NSUInteger idx, BOOL * _Nonnull stop) {
                subObj.isParsing = YES;
            }];
        }
    }];
}

- (void)setTopicList:(NSArray *)topicList {
    _topicList = topicList;
    NSMutableArray *tempArray = [NSMutableArray array];
    [topicList enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         [tempArray addObject:@""];
    }];
    self.categoryTitleView.titles = tempArray;
    if (!_analysisTopicList && !_topicModel) {
        __block NSInteger currentSectionProgress = 0;
        [topicList enumerateObjectsUsingBlock:^(BLTopicModel *   _Nonnull topic, NSUInteger section, BOOL * _Nonnull stop) {
            NSString *memAnswer = topic.memAnswer;
            if (!memAnswer) {
                currentSectionProgress = section;
                *stop = YES;
            }
        }];
        if (currentSectionProgress != 0) {
            __weak typeof(self) wself = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [wself.categoryTitleView selectItemAtIndex:currentSectionProgress];
                [wself.categoryListContainerView didClickSelectedItemAtIndex:currentSectionProgress];
            });
        }
    }
    if (_analysisTopicList && _currentAnalysisModel) {
        __block NSInteger currentSectionProgress = 0;
       [topicList enumerateObjectsUsingBlock:^(BLTopicModel *   _Nonnull topic, NSUInteger section, BOOL * _Nonnull stop) {
           if ([topic.materialType isEqualToString:@"1"]) {
               [topic.questionList enumerateObjectsUsingBlock:^(BLTopicModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   if ([obj isEqual:_currentAnalysisModel]) {
                       currentSectionProgress = section;
                       *stop = YES;
                   }
               }];
           }else {
               if ([topic isEqual:_currentAnalysisModel]) {
                   currentSectionProgress = section;
               }
           }
       }];
       if (currentSectionProgress != 0) {
           __weak typeof(self) wself = self;
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [wself.categoryTitleView selectItemAtIndex:currentSectionProgress];
               [wself.categoryListContainerView didClickSelectedItemAtIndex:currentSectionProgress];
           });
       }
    }
    [self.categoryTitleView reloadData];
    [self.categoryListContainerView reloadData];
}

- (IBAction)sureEvent:(id)sender {
    _topicModel.isParsing = YES;
    [self.categoryListContainerView reloadData];
}

- (void)oneSecondPass {
    if (_duration > 0) {
        _seconds --;
        if (_seconds <= 0) {
            _timeLabel.text = [self timeFormatted:_seconds];
            [_clockTimer invalidate];
            __weak typeof(self) wself = self;
            BLTextAlertViewController *viewController =
            [[BLTextAlertViewController alloc] initWithTitle:@"大狮解小吼一声"
                                                     content:@"考试时间已到，您即将交卷"
                                                     buttons:@[@{BLAlertControllerButtonTitleKey: @"确定",
                                                                 BLAlertControllerButtonTextColorKey: [UIColor whiteColor],
                                                                 BLAlertControllerButtonBorderColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                                                                 BLAlertControllerButtonBorderColorKey: @1,
                                                                 BLAlertControllerButtonNormalBackgroundColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                                                                 BLAlertControllerButtonRoundedCornersKey:@14.5
                                                     },
                                                    
                                                               ] tapBlock:^(BLTextAlertViewController * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
                if ([title isEqualToString:@"确定"]) {
                    wself.submissionAnswerAPI.isFinish = YES;
                    [wself.submissionAnswerAPI loadData];
                }
                }];
            [self presentViewController:viewController animated:YES completion:nil];
            return;
        }
    }else {
        _seconds ++;
    }
    _timeLabel.text = [self timeFormatted:_seconds];
}

- (NSString *)timeFormatted:(NSInteger)totalSeconds {
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = totalSeconds / 60;
    return [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
}

#pragma mark -- MJDropDownMenuViewDelegate method
- (void)dropDownMenuView:(MJDropDownMenuView *)dropDownMenuView didSelectItem:(NSInteger)item  {
    if (item == 1) {
        BLFeedbackTableViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLFeedbackTableViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)didSelectFontIndex:(NSInteger)index {
    [BLTopicFontManager sharedInstance].fontSizeType = index - 1;
}

- (NSArray<MJDropDownMenuItem *> *)dataSourceDropDownMenuView:(MJDropDownMenuView *)dropDownMenuView {
    NSArray *title = @[@"分享", @"报错反馈"];
    NSArray *images = @[@"t_fk", @"t_fx"];
    NSMutableArray *items = [NSMutableArray array];
    [title enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MJDropDownMenuItem *item = [MJDropDownMenuItem new];
        item.title = obj;
        item.imageName = images[idx];
        [items addObject:item];
    }];
    [items addObject:@""];
    return items;
}

- (IBAction)tapDrawingBoardEvent:(id)sender {
    self.bv = [[BHBDrawBoarderView alloc] initWithFrame:CGRectZero];
    [self.bv show];
}

//更多
- (IBAction)tapMoreEvent:(id)sender {
    self.dropDownMenuView.idx = [BLTopicFontManager sharedInstance].fontSizeType + 1;
    [self.dropDownMenuView show];
}

//收藏
- (IBAction)collectionEvent:(id)sender {
    if (_currentModel.isCollection && [_currentModel.isCollection isEqualToString:@"1"]) {
        [self.cancelMyCollectionAPI loadData];
    }else {
        [self.questionAddCollectionAPI loadData];
    }
}

//答题卡
- (IBAction)answerEvent:(id)sender {
//    BLAnswerSheetNavViewController *viewCointroller = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLAnswerSheetNavViewController"];
//    if (viewCointroller.viewControllers.count > 0) {
//        BLAnswerSheetViewController *subViewController = viewCointroller.viewControllers[0];
//        subViewController.sectionTopicList = _paperModel.sectionTopicList;
//        subViewController.setId = _setId;
//        subViewController.modelId = _modelId;
//        subViewController.functionTypeId = _functionTypeId;
//        subViewController.delegate = self;
//        subViewController.paperModel = _paperModel;
//    }
//    [self presentViewController:viewCointroller animated:YES completion:nil];
//
    BLAnswerSheetViewController *subViewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLAnswerSheetViewController"];
    subViewController.sectionTopicList = _paperModel.sectionTopicList;
    subViewController.setId = _setId;
    subViewController.modelId = _modelId;
    subViewController.functionTypeId = _functionTypeId;
    subViewController.delegate = self;
    subViewController.paperModel = _paperModel;
    [self.navigationController pushViewController:subViewController animated:YES];
}

#pragma mark -- BLAnswerSheetViewControllerDelegate method
- (void)finishTestSetRecId:(NSInteger)setRecId {
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BLAnswerReportViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLAnswerReportViewController"];
        viewController.setId = wself.setId;
        viewController.modelId = wself.modelId;
        viewController.functionTypeId = wself.functionTypeId;
        viewController.paperModel = wself.paperModel;
        viewController.setRecId = setRecId;
        [self.navigationController pushViewController:viewController animated:YES];
    });
}

- (void)didsSelectIndexPath:(NSIndexPath *)indexPath model:(BLTopicModel *)model {
    __block NSInteger section = 0;
    __block NSInteger index = -1;
    __block BLTopicModel *sectionModel;
    [_topicList enumerateObjectsUsingBlock:^(BLTopicModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model isEqual:obj]) {
            section = idx;
            sectionModel = obj;
            *stop = YES;
        }
        if ([obj.materialType isEqualToString:@"1"]) {
            [obj.questionList enumerateObjectsUsingBlock:^(BLTopicModel * _Nonnull subObj, NSUInteger subIdx, BOOL * _Nonnull stop) {
                if ([model isEqual:subObj]) {
                    sectionModel = obj;
                    section = idx;
                    index = subIdx;
                    *stop = YES;
                }
            }];
        }
    }];
    [self.categoryTitleView selectItemAtIndex:section];
    [self.categoryListContainerView didClickSelectedItemAtIndex:section];
    if (index != -1) {
        BLTopicBaseViewController *topicViewController = (BLTopicBaseViewController *)[self.categoryListContainerView.validListDict objectForKey:@(section)];
        if (topicViewController) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [topicViewController.subTopicBaseViewController.categoryTitleView selectItemAtIndex:index];
                [topicViewController.subTopicBaseViewController.categoryListContainerView didClickSelectedItemAtIndex:index];
            });
        }
    }
//    [self.categoryListContainerView.scrollView setContentOffset:CGPointMake(index * [UIScreen mainScreen].bounds.size.width, 0) animated:YES];
//    [self.categoryListContainerView didClickSelectedItemAtIndex:index];
}

- (void)viewdidHide:(BLTopicModel *)model {
    
}

- (void)viewdidShow:(BLTopicModel *)model {
    if ((_paperModel || _materialTopicModel) && (![_currentModel isEqual:model] || !_currentModel)) {
        _currentModel.endSeconds = _seconds;
        _currentModel = model;
        _currentModel.startSeconds = _seconds;
    }
    _currentModel = model;
    if (_materialTopicModel) {
        return;
    }
    if (model.isCollection && [model.isCollection isEqualToString:@"1"]) {
        self.imageView.image = [UIImage imageNamed:@"t_ysc"];
    }else {
        self.imageView.image = [UIImage imageNamed:@"t_sc"];
    }
}

- (void)radilDidFinishWithModel:(BLTopicModel *)model {
    NSInteger index = self.categoryTitleView.selectedIndex;
    if (index == self.topicList.count - 1 && _materialTopicModel) {
        if (_didFinishHandler) {
            _didFinishHandler(index, model);
        }
    }
    __weak typeof(self) wself = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wself.categoryTitleView selectItemAtIndex:index + 1];
        [wself.categoryListContainerView didClickSelectedItemAtIndex:index + 1];
    });

}

- (void)didChangeWithModel:(BLTopicModel *)model {
//    model.endSeconds = self.seconds;
}

- (void)lastLeftSwipe {
    BLAnswerSheetViewController *subViewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLAnswerSheetViewController"];
    subViewController.sectionTopicList = _paperModel.sectionTopicList;
    subViewController.setId = _setId;
    subViewController.modelId = _modelId;
    subViewController.functionTypeId = _functionTypeId;
    subViewController.delegate = self;
    subViewController.paperModel = _paperModel;
    [self.navigationController pushViewController:subViewController animated:YES];
}


#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getQuestionListAPI isEqual:manager]) {
        return @{@"functionTypeId":@(_functionTypeId),
                 @"modelId":@(_modelId),
                 @"setId": @(_setId)
                 };
    }
    if ([self.questionAddCollectionAPI isEqual:manager]) {
        return  @{
                    @"functionTypeId":@(_functionTypeId),
                    @"isMaterial":@2,
                    @"modelId":@(_modelId),
                    @"setId": @(_setId),
                    @"questionId": @(_currentModel.Id),
                    @"type":@2
                };
    }
    if ([self.cancelMyCollectionAPI isEqual:manager]) {
        return @{
            @"memberQuestionId": @(_currentModel.memberQuestionId)
        };
    }
    if ([self.submissionAnswerAPI isEqual:manager]) {
        NSMutableArray *list = [NSMutableArray array];
        __block double allScore = 0.0;
        [_topicList enumerateObjectsUsingBlock:^(BLTopicModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger questionId = obj.Id;
            NSMutableArray *mapList = [NSMutableArray array];
            __block double sectionScore = 0.0;//大题总得分
            if ([obj.materialType isEqualToString:@"1"]) {
                questionId = obj.materialId;
                [obj.questionList enumerateObjectsUsingBlock:^(BLTopicModel * _Nonnull topic, NSUInteger idx, BOOL * _Nonnull stop) {
                    sectionScore = sectionScore + topic.score;
                    if (topic.submitAnswer || [topic.isManual isEqualToString:@"1"]) {
                        [mapList addObject:@{
                                             @"functionTypeId": @(topic.functionTypeId),
                                             @"isManual": topic.isManual?topic.isManual:@"",
                                             @"isMaterial": topic.materialType?topic.materialType:@"",
                                             @"mapList": @[],
                                             @"memAnswer": [topic.submitAnswer yy_modelToJSONString],
                                             @"modelId": @(topic.modelId),
                                             @"questionId": @(topic.Id),
                                             @"setId": @(topic.setId),
                                             @"type": topic.type?topic.type:@"",
                                             @"isCorrect": obj.isCorrect?obj.isCorrect:@"",
                                             @"score": obj.score?@(obj.score):@0,
                                             @"usedTime": @(topic.timeInterval)
                                           }];
                    }
                }];
            }else {
                sectionScore = obj.score;//不是材料题的话 就是该题本身的得分
            }
            allScore = allScore + sectionScore;
            if (mapList.count > 0 || obj.submitAnswer || [obj.isManual isEqualToString:@"1"]) {
                [list addObject:@{
                  @"functionTypeId": @(obj.functionTypeId),
                  @"isManual": obj.isManual?obj.isManual:@"",
                  @"isMaterial": obj.materialType?obj.materialType:@"",
                  @"mapList": mapList,
                  @"memAnswer": obj.submitAnswer? [obj.submitAnswer yy_modelToJSONString] : @"",
                  @"modelId": @(obj.modelId),
                  @"questionId": @(questionId),
                  @"setId": @(obj.setId),
                  @"type": obj.type?obj.type:@"",
                  @"isCorrect": obj.isCorrect?obj.isCorrect:@"",
                  @"score": obj.score?@(obj.score):@0,
                  @"usedTime": @(obj.timeInterval)
                }];
            }
        }];
        return @{
            @"allScore": @(allScore),
            @"questionAnswerDTOList": list,
            @"functionTypeId": @(_functionTypeId),
            @"isFinish": self.submissionAnswerAPI.isFinish ? @"1" : @"0",
            @"modelId": @(_modelId),
            @"setRecId": @(_paperModel.setRecId),
            @"setId": @(_setId)
        };
    }
    return nil;
}

#pragma mark MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getQuestionListAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSDictionary *info = [data objectForKey:@"data"];
            BLTopicPaperModel *paperModelCopy = [BLTopicPaperModel yy_modelWithJSON:info];
            _paperModel = paperModelCopy;
            paperModelCopy.setId = _setId;
            paperModelCopy.modelId = _modelId;
            paperModelCopy.functionTypeId = _functionTypeId;
            paperModelCopy.topicTitle = _topicTitle;
            [paperModelCopy dataProcessing];
            if (_duration > 0) {
                _seconds = _duration *  60 - paperModelCopy.startTime;
            } else {
                _seconds = paperModelCopy.startTime;
            }
            self.topicList = paperModelCopy.questionDTOS;
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            [self createDispatch_source_t];
//            _clockTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(oneSecondPass) userInfo:nil repeats:YES];
//            [[NSRunLoop mainRunLoop] addTimer:_clockTimer forMode:NSDefaultRunLoopMode];
        }
    }
    if ([self.questionAddCollectionAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            _currentModel.isCollection = @"1";
            _currentModel.memberQuestionId = [[data objectForKey:@"questionId"] integerValue];
            self.imageView.image = [UIImage imageNamed:@"t_ysc"];
        }
    }
    if ([self.cancelMyCollectionAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            _currentModel.isCollection = @"0";
            self.imageView.image = [UIImage imageNamed:@"t_sc"];
        }
    }
    if ([self.submissionAnswerAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSInteger setRecId = [[data objectForKey:@"data"] integerValue];
            BLAnswerReportViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLAnswerReportViewController"];
            viewController.setId = self.setId;
            viewController.modelId = self.modelId;
            viewController.functionTypeId = self.functionTypeId;
            viewController.paperModel = self.paperModel;
            viewController.setRecId = setRecId;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }
}

- (NSArray *)getTenData:(NSArray *)datas {
    return [datas subarrayWithRange:NSMakeRange(0, datas.count > 6 ? 6 : datas.count - 1)];
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (IBAction)CloseEvent:(id)sender {
    if (_topicModel || _analysisModel || _analysisTopicList) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    __weak typeof(self) wself = self;
    BLTextAlertViewController *viewController =
    [[BLTextAlertViewController alloc] initWithTitle:@"大狮解小吼一声"
                                             content:@"退出后，到“我的”的答题记录继续作答^_^"
                                             buttons:@[@{BLAlertControllerButtonTitleKey: @"确定",
                                                         BLAlertControllerButtonTextColorKey: [UIColor whiteColor],
                                                         BLAlertControllerButtonBorderColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                                                         BLAlertControllerButtonBorderColorKey: @1,
                                                         BLAlertControllerButtonNormalBackgroundColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                                                         BLAlertControllerButtonRoundedCornersKey:@14.5
                                             },
                                                 @{BLAlertControllerButtonTitleKey: @"取消",
                                                         BLAlertControllerButtonTextColorKey: [UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                                                         BLAlertControllerButtonBorderColorKey:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0.0/255.0 alpha:1.0],
                                                         BLAlertControllerButtonBorderWidthKey: @1,
                                                         BLAlertControllerButtonNormalBackgroundColorKey:[UIColor whiteColor],
                                                         BLAlertControllerButtonRoundedCornersKey:@14.5
                                             }
                                                       ] tapBlock:^(BLTextAlertViewController * _Nonnull controller, NSString * _Nonnull title, NSInteger buttonIndex) {
        if ([title isEqualToString:@"确定"]) {
            wself.currentModel.endSeconds = wself.seconds;
            [wself.submissionAnswerAPI loadData];
            [wself.navigationController popViewControllerAnimated:YES];
        }
        }];
    [self presentViewController:viewController animated:YES completion:nil];
}

//dispatch_source_t
- (void)createDispatch_source_t { //创建全局队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0); //使用全局队列创建计时器
    _sourceTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue); //定时器延迟时间
    NSTimeInterval delayTime = 1.0f; //定时器间隔时间
    NSTimeInterval timeInterval = 1.0f; //设置开始时间
    dispatch_time_t startDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)); //设置计时器
    dispatch_source_set_timer(_sourceTimer, startDelayTime, timeInterval*NSEC_PER_SEC,0.1*NSEC_PER_SEC); //执行事件
    __weak typeof(self) wself = self;
    dispatch_source_set_event_handler(_sourceTimer,^{ //销毁定时器 //dispatch_source_cancel(_myTimer);
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself oneSecondPass];
        });
    }); //启动计时器
    dispatch_resume(_sourceTimer);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_paperModel && !_materialTopicModel) {
        self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryListContainerView.scrollView.contentOffset.x == 0);
    }else {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

#pragma mark - JXCategoryViewDelegate

- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    //侧滑手势处理
    NSLog(@"%@", NSStringFromSelector(_cmd));
    if (!_paperModel && !_materialTopicModel) {
        self.navigationController.interactivePopGestureRecognizer.enabled = (self.categoryListContainerView.scrollView.contentOffset.x == 0);
    }else {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }

}

- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [self.categoryListContainerView didClickSelectedItemAtIndex:index];
}

- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    [self.categoryListContainerView scrollingFromLeftIndex:leftIndex toRightIndex:rightIndex ratio:ratio selectedIndex:categoryView.selectedIndex];
}

- (id<JXCategoryListContentViewDelegate>)preferredListAtIndex:(NSInteger)index {
    BLTopicModel * model = _topicList[index];
    BLTopicBaseViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicBaseViewController"];
    if ([model.type isEqualToString:@"单选"]) {
        object_setClass(viewController, NSClassFromString(@"BLRadioViewController"));
    }
    if ([model.type isEqualToString:@"填空"] || [model.type isEqualToString:@"简答"]) {
        object_setClass(viewController, NSClassFromString(@"BLGapFillingViewController"));
    }
    if ([model.type isEqualToString:@"多选"]) {
        object_setClass(viewController, NSClassFromString(@"BLMultipleChoiceTopicViewController"));
    }
    if ([model.type isEqualToString:@"判断"]) {
        object_setClass(viewController, NSClassFromString(@"BLTopicJudgeViewController"));
    }
    if ([model.type isEqualToString:@"阅读"] || [model.materialType isEqualToString:@"1"]) {
        object_setClass(viewController, NSClassFromString(@"BLTopicReadingViewController"));
    }
    if (index == _topicList.count - 1 && !_materialTopicModel && !_topicModel && !_analysisParams && !_analysisTopicList) {
        viewController.isLast = YES;
    }

    viewController.delegate = self;
    viewController.model = model;
    return viewController;
}

#pragma mark - JXCategoryListContainerViewDelegate

- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    id<JXCategoryListContentViewDelegate> list = [self preferredListAtIndex:index];
    return list;
}

- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.topicList.count;
}

- (BLGetQuestionListAPI *)getQuestionListAPI {
    if (!_getQuestionListAPI) {
        _getQuestionListAPI = [[BLGetQuestionListAPI alloc] init];
        _getQuestionListAPI.mj_delegate = self;
        _getQuestionListAPI.paramSource = self;
    }
    return _getQuestionListAPI;
}

- (BLQuestionAddCollectionAPI *)questionAddCollectionAPI {
    if (!_questionAddCollectionAPI) {
        _questionAddCollectionAPI = [[BLQuestionAddCollectionAPI alloc] init];
        _questionAddCollectionAPI.mj_delegate = self;
        _questionAddCollectionAPI.paramSource = self;
    }
    return _questionAddCollectionAPI;
}

- (MJDropDownMenuView *)dropDownMenuView {
    if (!_dropDownMenuView) {
        _dropDownMenuView = [[MJDropDownMenuView alloc] init];
        _dropDownMenuView.delegate = self;
    }
    return _dropDownMenuView;
}

- (BLCancelMyCollectionAPI *)cancelMyCollectionAPI {
    if (!_cancelMyCollectionAPI) {
        _cancelMyCollectionAPI = [[BLCancelMyCollectionAPI alloc] init];
        _cancelMyCollectionAPI.mj_delegate = self;
        _cancelMyCollectionAPI.paramSource = self;
    }
    return _cancelMyCollectionAPI;
}

- (BLSubmissionAnswerAPI *)submissionAnswerAPI {
    if (!_submissionAnswerAPI) {
        _submissionAnswerAPI = [[BLSubmissionAnswerAPI alloc] init];
        _submissionAnswerAPI.mj_delegate = self;
        _submissionAnswerAPI.paramSource = self;
    }
    return _submissionAnswerAPI;
}



@end
