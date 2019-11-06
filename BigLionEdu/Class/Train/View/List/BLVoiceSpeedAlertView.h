//
//  BLVoiceSpeedAlertView.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/13.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLVoiceSpeedAlertView : UIView

@property (nonatomic, strong) UIView *mask;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) void(^didSelectHandler)(NSInteger index);
@property (nonatomic, assign) NSInteger current;

@property (nonatomic, assign) BOOL isLand;

- (void)show;

- (void)dismiss;

- (void)updateLayout;

@end

@protocol BLVoiceSpeedAlertViewCellDelegate <NSObject>

- (void)didSelectHandler:(NSIndexPath *)indexPath;
- (void)cancelHandler;

@end

@interface BLVoiceSpeedAlertViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *speedLab;
@property (nonatomic, strong) UIButton *checkBtn;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIButton *cancelLab;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id <BLVoiceSpeedAlertViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
