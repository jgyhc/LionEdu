//
//  BLMealBuyTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/13.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMyMealModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BLMealBuyTableViewCellDelegate <NSObject>

- (void)cell:(UITableViewCell *)cell buyPackageBtnDidClickWithModel:(BLMyAllMealModel *)model;

@end

@interface BLMealBuyTableViewCell : UITableViewCell
@property (nonatomic, strong)BLMyAllMealModel *model;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *titLab;

@property (nonatomic, weak) id<BLMealBuyTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
