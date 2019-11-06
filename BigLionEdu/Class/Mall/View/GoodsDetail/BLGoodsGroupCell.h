//
//  BLGoodsGroupCell.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/5.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLGoodsDetailModel.h"

@protocol BLGoodsGroupCellDelegate <NSObject>

- (void)BLGoodsGroupCellJoinGroup:(BLGoodsDetailGroupModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BLGoodsGroupCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;
@property (weak, nonatomic) IBOutlet UIButton *joinBtn;
@property (nonatomic, strong) BLGoodsDetailGroupModel *model;
@property (nonatomic, weak) id <BLGoodsGroupCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
