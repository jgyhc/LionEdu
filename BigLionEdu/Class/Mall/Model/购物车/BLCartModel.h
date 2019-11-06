//
//  BLCartModel.h
//  BigLionEdu
//
//  Created by Hwang on 2019/9/10.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLCartModel : NSObject

/*
"cartPrice": 0,
"coverImg": "string",
"goodsId": 0,
"goodsNum": 0,
"id": 0,
"title": "string"
 */

@property (nonatomic, copy) NSString *Id;
@property (nonatomic, strong) NSNumber *cartPrice;
@property (nonatomic, copy) NSString *coverImg;
@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *modelId;
@property (nonatomic, assign) NSInteger goodsNum;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) NSInteger type;
//0：书籍1：试卷2：直播3：套卷(套卷都不显示）4:录播

@end

NS_ASSUME_NONNULL_END
