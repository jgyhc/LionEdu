//
//  BLVideoClassDetailViewController.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/4.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLVideoClassDetailViewController : UIViewController

@property (nonatomic, assign) NSInteger recId;
@property (nonatomic, assign) NSInteger type;

//从商品详情跳过来带上了goodsId
@property (nonatomic, assign) NSInteger goodsId;

@end

NS_ASSUME_NONNULL_END
