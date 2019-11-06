//
//  BLQuestionScreeningTimeCollectionViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/19.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BLQuestionScreeningTimeCollectionViewCellDelegate <NSObject>

- (void)startTimeEvent:(NSString *)currentYear;

- (void)endTimeEvent:(NSString *)currentYear;

@end

@interface BLQuestionScreeningTimeCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<BLQuestionScreeningTimeCollectionViewCellDelegate> delegate;

@property (nonatomic, strong) NSDictionary * model;

@end

NS_ASSUME_NONNULL_END
