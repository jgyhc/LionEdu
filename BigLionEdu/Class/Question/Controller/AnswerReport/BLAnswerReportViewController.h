//
//  BLAnswerReportViewController.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTopicPaperModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BLAnswerReportViewController : UIViewController

@property (nonatomic, assign) NSInteger modelId;

@property (nonatomic, assign) NSInteger functionTypeId;

@property (nonatomic, assign) NSInteger setId;

@property (nonatomic, assign) NSInteger setRecId;

@property (nonatomic, copy) NSString *topicTitle;

@property (nonatomic, strong) BLTopicPaperModel * paperModel;
@end

NS_ASSUME_NONNULL_END
