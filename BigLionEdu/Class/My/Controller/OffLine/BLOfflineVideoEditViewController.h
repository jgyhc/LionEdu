//
//  BLOfflineVideoEditViewController.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/15.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLClassScheduleItemModel.h"

@protocol BLOfflineVideoEditViewControllerDelegate <NSObject>

- (void)BLOfflineVideoEditViewControllerDidDelete;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BLOfflineVideoEditViewController : UIViewController

@property (nonatomic, strong) NSMutableArray <BLClassScheduleItemModel *> *datas;
@property (nonatomic, weak) id <BLOfflineVideoEditViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
