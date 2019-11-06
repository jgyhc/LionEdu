//
//  BLShoppingCartTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLCartModel.h"
#import "BLMallOrderSureNumberView.h"

@protocol BLShoppingCartTableViewCellDelegate <NSObject>

- (void)bl_ShoppingCartSelectItem:(BLCartModel *)model;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BLShoppingCartTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet BLMallOrderSureNumberView *numberView;

@property (nonatomic, strong) BLCartModel *model;
@property (nonatomic, weak) id <BLShoppingCartTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
