//
//  BLMallOrderSureViewController.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLPaperModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BLMallOrderSureViewController : UIViewController

//请求确认订单需要的参数
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, strong) NSNumber *groupType;
@property (nonatomic, strong) NSString *groupId;

//购买试卷
@property (nonatomic, strong) BLPaperModel *paperModel;
@property (nonatomic, copy) NSString *backToController;

@end

NS_ASSUME_NONNULL_END
