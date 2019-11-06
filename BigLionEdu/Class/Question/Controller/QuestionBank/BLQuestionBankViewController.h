//
//  BLQuestionBankViewController.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/25.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLQuestionBankViewController : UIViewController
@property (nonatomic, assign) NSInteger modelId;

// 1转到模考 列表
@property (nonatomic, assign) NSInteger type;
@end

NS_ASSUME_NONNULL_END
