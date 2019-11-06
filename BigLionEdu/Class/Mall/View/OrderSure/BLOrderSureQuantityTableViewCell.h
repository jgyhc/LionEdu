//
//  BLOrderSureQuantityTableViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMallOrderSureNumberView.h"
#import "BLGoodsSureModel.h"

@protocol BLOrderSureQuantityTableViewCellDelegate <NSObject>

- (void)buyNumberDidChange:(NSInteger )num;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BLOrderSureQuantityTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet BLMallOrderSureNumberView *numView;
@property (nonatomic, weak) id <BLOrderSureQuantityTableViewCellDelegate> delegate;
@property (nonatomic, strong) BLGoodsSureModel *model;

@end

NS_ASSUME_NONNULL_END
