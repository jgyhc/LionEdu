//
//  BLResponseDailyQuestionModel.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/9/1.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEveryDayDailyTipModel.h"
#import "BLTopicModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLResponseDailyQuestionModel : NSObject

@property (nonatomic, strong) BLEveryDayDailyTipModel *dailyTip;

@property (nonatomic, strong) BLTopicModel *question;

@end

NS_ASSUME_NONNULL_END
