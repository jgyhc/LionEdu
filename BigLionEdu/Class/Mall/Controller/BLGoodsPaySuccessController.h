//
//  BLGoodsPaySuccessController.h
//  BigLionEdu
//
//  Created by Hwang on 2019/9/22.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLGoodsPaySuccessController : UIViewController

@property (nonatomic, strong) NSNumber *groupType;
@property (nonatomic, copy) NSString *groupId;

@property (nonatomic, copy) NSString *backToController;

@end

NS_ASSUME_NONNULL_END
