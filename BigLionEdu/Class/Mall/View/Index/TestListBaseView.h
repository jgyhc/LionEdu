//
//  TestListBaseView.h
//  JXCategoryView
//
//  Created by jiaxin on 2018/8/27.
//  Copyright © 2018年 jiaxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"

@interface TestListBaseView : UIView <JXPagerViewListViewDelegate>

@property (nonatomic, strong) UIViewController *viewController;
@property (nonatomic, strong) UICollectionView *collectionView;

//搜索
//0：书籍1：试卷2：直播3：套卷(套卷都不显示）4:录播
//labelId 折扣类型
//modelId 模块id
@property (nonatomic, copy) NSString *modelId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *labelId;
@property (nonatomic, copy) NSString *title;

- (void)bl_refresh;

@end
