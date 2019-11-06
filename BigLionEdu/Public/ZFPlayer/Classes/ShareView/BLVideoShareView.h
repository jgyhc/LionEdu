//
//  BLVideoShareView.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/22.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BLVideoSharePosterView;
NS_ASSUME_NONNULL_BEGIN

@interface BLVideoShareView : UIView

@property (nonatomic, strong) UIView *shareButtonsView;
@property (nonatomic, strong) UIImageView *screenImgView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) BLVideoSharePosterView *posterView;

@end

@interface BLVideoSharePosterView : UIView

@property (nonatomic, strong) UIImageView *screenImgView;
@property (nonatomic, strong) UILabel *courseNameLab;
@property (nonatomic, strong) UILabel *onlineNumberLab;
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *descLab;
@property (nonatomic, strong) UIImageView *codeImgView;

@end

NS_ASSUME_NONNULL_END
