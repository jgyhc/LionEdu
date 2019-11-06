//
//  BLTopicCollectionViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol BLTopicCollectionViewCellDeleagte <NSObject>

- (UIView *)subView;

@end

@interface BLTopicCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id<BLTopicCollectionViewCellDeleagte> delegate;

@end

NS_ASSUME_NONNULL_END
