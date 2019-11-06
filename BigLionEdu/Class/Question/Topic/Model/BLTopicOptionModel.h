//
//  BLTopicOptionModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/20.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLTopicOptionModel : NSObject
@property (nonatomic, assign) NSInteger questionId;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy)   NSString *value;

@property (nonatomic, strong) NSMutableAttributedString *valueString;
@property (nonatomic, strong) NSString *score;
@property (nonatomic, copy)   NSString *moption;

@property (nonatomic, copy) NSString *isDsj;

@property (nonatomic, assign) BOOL isSelect;

@property (nonatomic, assign) BOOL isParsing;

@property (nonatomic, assign) NSInteger keyStatus;//0没有选  1选对了  2选错

@property (nonatomic, assign) BOOL isRight;//是否是正确答案

@end

NS_ASSUME_NONNULL_END
