//
//  BLClassMenuTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/4.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BLClassMenuTableViewCellDelegate <NSObject>

- (void)updateButtonClick:(NSInteger)index;

@end
@interface BLClassMenuTableViewCell : UITableViewCell

@property (nonatomic, weak) id<BLClassMenuTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
