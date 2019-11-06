//
//  BLBingdingTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/9/15.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BLBingdingTableViewCellDelegate <NSObject>

- (void)dissMissViewController;

- (void)backViewController;

@end
@interface BLBingdingTableViewCell : UITableViewCell
@property (nonatomic, assign) id<BLBingdingTableViewCellDelegate> delegate;

@property (nonatomic, copy) NSString *model;
@end

NS_ASSUME_NONNULL_END
