//
//  BLTopicAnalysisVoiceTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLTopicVoiceModel.h"
#import "GKSliderView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BLTopicAnalysisVoiceTableViewCellDelegate <NSObject>

- (void)startPlayer:(BLTopicVoiceModel *)model sliderView:(GKSliderView *)sliderView;


- (void)pausePlayer:(BLTopicVoiceModel *)model sliderView:(GKSliderView *)sliderView;

- (void)sliderProgress:(CGFloat)value model:(BLTopicVoiceModel *)model sliderView:(GKSliderView *)sliderView;

@end

@interface BLTopicAnalysisVoiceTableViewCell : UITableViewCell

@property (nonatomic, strong) BLTopicVoiceModel *model;

@property (nonatomic, assign) id<BLTopicAnalysisVoiceTableViewCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
