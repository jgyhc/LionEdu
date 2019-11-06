//
//  BLMallSearchController.h
//  BigLionEdu
//
//  Created by Hwang on 2019/9/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLMallSearchController : UIViewController


/** 类型：0：书籍 1：试卷 2：直播  3：套卷(分类）4:录播 */
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, copy) NSString *functionTypeId;

@property (nonatomic, assign) NSInteger modelId;

// 录播搜索用的
@property (nonatomic, assign) NSInteger searchType;

@end

NS_ASSUME_NONNULL_END
