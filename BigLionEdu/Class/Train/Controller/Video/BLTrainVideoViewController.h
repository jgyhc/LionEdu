//
//  BLTrainVideoViewController.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/6.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLClassScheduleItemModel.h"
#import "BLClassDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BLTrainVideoViewController : UIViewController

@property (nonatomic, strong) BLClassScheduleItemModel *model;
@property (nonatomic, strong) BLClassDetailModel *detailModel;
@property (nonatomic, assign) BOOL didDownLoad;

@end

NS_ASSUME_NONNULL_END
