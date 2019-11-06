//
//  BLQuestionScreeningTopCollectionViewCell.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/18.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLAreaModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BLQuestionScreeningTopCollectionViewCellDelegate <NSObject>

- (void)didClickBackEvent;

@end

@interface BLQuestionScreeningTopCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) BLAreaModel * model;

@property (nonatomic, weak) id<BLQuestionScreeningTopCollectionViewCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
