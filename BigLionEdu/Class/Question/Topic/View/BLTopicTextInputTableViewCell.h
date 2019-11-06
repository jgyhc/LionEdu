//
//  BLTopicTextInputTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/6.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLFillTopicKeyModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BLTopicTextInputTableViewCellDelegate <NSObject>

- (void)didImageInput:(nullable UIImage *)image model:(BLFillTopicKeyModel *)model;

- (void)textDidInput:(NSString *)string model:(BLFillTopicKeyModel *)model;

@end


@interface BLTopicTextInputTableViewCell : UITableViewCell

@property (nonatomic, weak) id<BLTopicTextInputTableViewCellDelegate> delegate;

@property (nonatomic, strong) BLFillTopicKeyModel * model;

@end

NS_ASSUME_NONNULL_END
