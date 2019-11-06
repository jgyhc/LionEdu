//
//  BLClassWebTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/4.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol BLClassWebTableViewCellDelegate <NSObject>

- (void)updateCellHeight:(CGFloat)height indexPath:(NSIndexPath *)indexPath;

@end
@interface BLClassWebTableViewCell : UITableViewCell

@property (nonatomic, weak) id<BLClassWebTableViewCellDelegate> delegate;

@property (nonatomic, copy) NSString * model;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

NS_ASSUME_NONNULL_END
