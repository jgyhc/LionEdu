//
//  ZLPicSelectView.h
//  ZhenLearnDriving_Coach
//
//  Created by OrangesAL on 2019/5/1.
//  Copyright © 2019年 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZLPicSelectView : UIView


//数据中包含的UIImage
@property (nonatomic, readonly) NSArray <UIImage *> * imgDatas;


@property (nonatomic, assign) NSInteger dataMaxCount;

@property (nonatomic, readonly) NSURL *videoUrl;

@property (nonatomic, readonly) CGFloat viewHeight;

@property (nonatomic, copy) dispatch_block_t viewHeightUpdate;

@property (nonatomic, assign) BOOL canPicVideo; //只能选一个视频，且和图片冲突


//设置图片 urlStr， 返回数据中包含的urlStr
@property (nonatomic, strong) NSArray *pictures;

@end

NS_ASSUME_NONNULL_END
