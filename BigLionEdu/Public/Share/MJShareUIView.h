//
//  ShareUIView.h
//  ManJi
//
//  Created by Zgmanhui on 2017/8/14.
//  Copyright © 2017年 Zgmanhui. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShareUIViewType) {
    ShareUIViewTypeQQZone    = 0,
    ShareUIViewTypeQQ   = 1,
    ShareUIViewTypeWechatSession = 2,//微信好友
    ShareUIViewTypeWechatTimeline,//微信朋友圈
    ShareUIViewTypeWeiBo,
    ShareUIViewTypeOther
};

@class MJShareUIView, ShareUIModel, ShareUICell;
@protocol MJShareUIViewDelegate <NSObject>

- (void)shareUIView:(MJShareUIView *)view didSelectItem:(ShareUIViewType)itemType;

@end

@protocol MJShareUIViewDataSource <NSObject>

- (NSArray *)numberItemInShareUIView:(MJShareUIView *)view;

@end

@interface MJShareUIView : UIView

@property (nonatomic, weak) id<MJShareUIViewDataSource> dataSource;

@property (nonatomic, weak) id<MJShareUIViewDelegate> delegate;

- (void)reloadData;

- (void)show;

- (void)hide;

@end

@interface ShareUICell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UIButton *label;

@property (nonatomic, strong) ShareUIModel *model;
@end

@interface ShareUIModel : NSObject

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) ShareUIViewType type;

@end
