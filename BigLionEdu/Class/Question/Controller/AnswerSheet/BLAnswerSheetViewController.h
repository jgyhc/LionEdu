//
//  BLAnswerSheetViewController.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTopicSectionModel.h"
#import "BLTopicPaperModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BLAnswerSheetViewControllerDelegate <NSObject>

- (void)finishTestSetRecId:(NSInteger)setRecId;

- (void)didsSelectIndexPath:(NSIndexPath *)indexPath model:(BLTopicModel *)model ;

@end

@interface BLAnswerSheetViewController : UIViewController

@property (nonatomic, strong) NSArray<BLTopicSectionModel *> * sectionTopicList;

@property (nonatomic, weak) id<BLAnswerSheetViewControllerDelegate> delegate;

@property (nonatomic, assign) NSInteger modelId;

@property (nonatomic, assign) NSInteger functionTypeId;

@property (nonatomic, assign) NSInteger setId;

@property (nonatomic, assign) BOOL isFinish;//是否已经答题完成  完成显示对错  未完成显示是否作答

@property (nonatomic, copy) NSString *topicTitle;

@property (nonatomic, strong) BLTopicPaperModel * paperModel;
@end

NS_ASSUME_NONNULL_END
