//
//  BLTopicBaseViewController.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/6.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLTableViewDelegateManager.h"
#import <JXCategoryView.h>
#import <JXCategoryListContainerView.h>
#import "BLTopicModel.h"
#import "BLTopicViewController.h"
#import "BLTopicDragDropView.h"
#import "BLTopicTextModel.h"
#import "BLTopicImageModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BLTopicBaseViewControllerDelegate <NSObject>

- (void)viewdidShow:(BLTopicModel *)model;
- (void)viewdidHide:(BLTopicModel *)model; 

//单选题和填空题答题完成
- (void)radilDidFinishWithModel:(BLTopicModel *)model;

//对答案进行填充、更改都会走一下
- (void)didChangeWithModel:(BLTopicModel *)model;

- (void)lastLeftSwipe;
@end

@interface BLTopicBaseViewController : UIViewController<ZLTableViewDelegateManagerDelegate, JXCategoryListContentViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) BLTopicModel * model;

@property (nonatomic, strong) ZLTableViewSectionModel * sectionModel;

@property (nonatomic, weak) id<BLTopicBaseViewControllerDelegate> delegate;

@property (nonatomic, strong, nullable) ZLTableViewSectionModel *answerSectionModel;

@property (nonatomic, strong, nullable) NSArray * topicTitleArray;

@property (nonatomic, strong, nullable) NSMutableArray *datas;

@property (nonatomic, assign) NSInteger isLast;//是否是最后一道题了

- (void)viewDataInit:(BLTopicModel *)model;

- (void)subCellDidSelectWithModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath;
#pragma mark 阅读题
@property (nonatomic, strong) BLTopicDragDropView *topicDragDropView;

@property (nonatomic, strong) BLTopicViewController * subTopicBaseViewController;

- (void)sureButtonHide:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
