//
//  BLScreenHeaderCollectionReusableView.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/31.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLScreenHeaderCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (nonatomic, copy) NSString *model;

@end

NS_ASSUME_NONNULL_END
