//
//  BLInterestItemView.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/23.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMyInterestItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLInterestItemView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (nonatomic, strong) BLInterestInfoModel *model;
@property (nonatomic ,strong)UILabel *tagLabel;
- (void)reloadData;
@end

NS_ASSUME_NONNULL_END
