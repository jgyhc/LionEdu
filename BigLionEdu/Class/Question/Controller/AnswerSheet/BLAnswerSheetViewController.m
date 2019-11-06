//
//  BLAnswerSheetViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAnswerSheetViewController.h"
#import "ZLCollectionViewDelegateManager.h"
#import "BLSubmissionAnswerAPI.h"
#import <YYModel.h>
#import "BLAnswerReportViewController.h"
#import "BLTextAlertViewController.h"
#import "BLAnswerReportViewController.h"
#import "BLTopicViewController.h"

@interface BLAnswerSheetViewController ()<ZLCollectionViewDelegateManagerDelegate, CTAPIManagerParamSource, MJAPIBaseManagerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (nonatomic, strong) ZLCollectionViewDelegateManager *manager;

@property (nonatomic, strong) NSArray * list;

@property (nonatomic, strong) BLSubmissionAnswerAPI *submissionAnswerAPI;
@end

@implementation BLAnswerSheetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,[UIScreen mainScreen].bounds.size.width, 50);
    gl.startPoint = CGPointMake(0, 0.5);
    gl.endPoint = CGPointMake(1, 0.5);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:253/255.0 green:215/255.0 blue:98/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:249/255.0 green:120/255.0 blue:25/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0.0),@(1.0)];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.sureButton.layer addSublayer:gl];
    [self.sureButton.layer insertSublayer:gl atIndex:0];
    [self.sureButton setTitle:@"交卷并查看结果" forState:UIControlStateNormal];
    [self initData];
    self.sureButton.hidden = _isFinish;
    [self.collectionView registerNib:[UINib nibWithNibName:@"BLAnswerSheetHeaderFinishCollectionReusableView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BLAnswerSheetHeaderFinishCollectionReusableView"];
}

- (void)initData {
    NSMutableArray *list = [NSMutableArray array];
    NSMutableArray *items = [NSMutableArray array];
    [list addObject:({
        ZLCollectionViewSectionModel *sectionModel = [ZLCollectionViewSectionModel new];
        sectionModel.headerIdentifier = self.isFinish ? @"BLAnswerSheetHeaderFinishCollectionReusableView" : @"BLAnswerSheetHeaderCollectionReusableView";
        sectionModel.headerSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 42);
        sectionModel.headerData = _topicTitle;
        sectionModel.items = items;
        sectionModel;
    })];
    [_sectionTopicList enumerateObjectsUsingBlock:^(BLTopicSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.topicList enumerateObjectsUsingBlock:^(BLTopicModel * _Nonnull topic, NSUInteger idx, BOOL * _Nonnull stop) {
            topic.isParsing = _isFinish;
            if ([topic.materialType isEqualToString:@"1"]) {
                [topic.questionList enumerateObjectsUsingBlock:^(BLTopicModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    obj.isParsing = _isFinish;
                    [items addObject:({
                        ZLCollectionViewRowModel *rowModel = [ZLCollectionViewRowModel new];
                        rowModel.identifier = @"BLAnswerSheetItemCollectionViewCell";
                        CGFloat width = [UIScreen mainScreen].bounds.size.width / 6.0;
                        rowModel.cellSize = CGSizeMake(width, width);
                        rowModel.data = obj;
                        rowModel;
                    })];
                }];
            }else {
                [items addObject:({
                    ZLCollectionViewRowModel *rowModel = [ZLCollectionViewRowModel new];
                    rowModel.identifier = @"BLAnswerSheetItemCollectionViewCell";
                    CGFloat width = [UIScreen mainScreen].bounds.size.width / 6.0;
                    rowModel.cellSize = CGSizeMake(width, width);
                    rowModel.data = topic;
                    rowModel;
                })];
            }
            
        }];
        
        
    }];
    _list = list;
    [self.manager reloadData];
}

- (void)closeViewController {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)sureEvent:(id)sender {
    if (!_paperModel.isAllFinish) {
        __weak typeof(self) wself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            BLTextAlertViewController *viewController =
            [[BLTextAlertViewController alloc] initWithTitle:@"大狮解小吼一声"
                                                     content:@"你还有题目未做完，确定交卷吗？"
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
                    [wself.submissionAnswerAPI loadData];
                    
                }
                }];
            [self presentViewController:viewController animated:YES completion:nil];
        });
        
        return;
    }
    [self.submissionAnswerAPI loadData];
}

- (IBAction)closeEvent:(id)sender {
    [self closeViewController];
}

- (NSArray<ZLCollectionViewSectionModel *> *)dataSource:(ZLCollectionViewDelegateManager *)manager {
    return self.list;
}

#pragma mark -- CTAPIManagerParamSource method
- (id _Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.submissionAnswerAPI isEqual:manager]) {
        NSMutableArray *list = [NSMutableArray array];
        __block double allScore = 0.0;
        [_sectionTopicList enumerateObjectsUsingBlock:^(BLTopicSectionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.topicList enumerateObjectsUsingBlock:^(BLTopicModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
        }];
        return @{
            @"allScore": @(allScore),
            @"questionAnswerDTOList": list,
            @"functionTypeId": @(_functionTypeId),
            @"isFinish": @"1",
            @"modelId": @(_modelId),
            @"setId": @(_setId),
            @"setRecId": @(_paperModel.setRecId),
            @"allTime": _paperModel.duration == 0 ? @-1 : @(_paperModel.duration)
        };
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.submissionAnswerAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
//            if (self.delegate && [self.delegate respondsToSelector:@selector(finishTestSetRecId:)]) {
//                [self.delegate finishTestSetRecId:[[data objectForKey:@"data"] integerValue]];
//            }
//            [self closeViewController];
            NSInteger setRecId = [[data objectForKey:@"data"] integerValue];
            BLAnswerReportViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLAnswerReportViewController"];
            viewController.setId = self.setId;
            viewController.modelId = self.modelId;
            viewController.functionTypeId = self.functionTypeId;
            viewController.paperModel = self.paperModel;
            viewController.setRecId = setRecId;
            [self.navigationController pushViewController:viewController animated:YES];
        }
//        if (self.delegate && [self.delegate respondsToSelector:@selector(finishTest)]) {
//            [self.delegate finishTest];
//        }
//        [self closeViewController];
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}


- (void)didSelectRowAtModel:(ZLCollectionViewRowModel *)model manager:(ZLCollectionViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    if (!_isFinish) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(didsSelectIndexPath:model:)]) {
            [self.delegate didsSelectIndexPath:indexPath model:model.data];
            [self closeViewController];
        }
    }else {
        BLTopicViewController *viewController = [[UIStoryboard storyboardWithName:@"Question" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTopicViewController"];
        viewController.setId = _setId;
        viewController.modelId = _modelId;
        viewController.functionTypeId = _functionTypeId;
        viewController.analysisTopicList = _paperModel.questionDTOS;
        viewController.currentAnalysisModel = model.data;
        [self.navigationController pushViewController:viewController animated:YES];
    }

}

- (ZLCollectionViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLCollectionViewDelegateManager alloc] init];
        _manager.collectionView = self.collectionView;
        _manager.delegate = self;
    }
    return _manager;
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
