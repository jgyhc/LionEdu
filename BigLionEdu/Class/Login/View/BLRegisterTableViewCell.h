//
//  BLRegisterTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/23.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN

@protocol BLRegisterTableViewCellDelegate <NSObject>

- (void)dissMissViewController;

- (void)backViewController;

@end

@interface BLRegisterTableViewCell : UITableViewCell

@property (nonatomic, assign) id<BLRegisterTableViewCellDelegate> delegate;

@property (nonatomic, copy) NSString *model; // openID

@end

NS_ASSUME_NONNULL_END
