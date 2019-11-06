//
//  BLMailSearchContentView.h
//  BigLionEdu
//
//  Created by Hwang on 2019/9/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLMailSearchContentView : UIView

//搜索
//0：书籍1：试卷2：直播3：套卷(套卷都不显示）4:录播
//labelId 折扣类型
//modelId 模块id
@property (nonatomic, copy) NSString *modelId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *labelId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UICollectionView *collectionView;

- (void)bl_refresh;
- (void)bl_search;

@end

NS_ASSUME_NONNULL_END
