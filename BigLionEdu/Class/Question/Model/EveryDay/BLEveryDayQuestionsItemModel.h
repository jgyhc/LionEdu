//
//  BLEveryDayQuestionsItemModel.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/9/1.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLEveryDayQuestionsItemModel : NSObject
/** id (integer, optional),
 moption (string, optional): 选项名称 ,
 questionId (integer, optional): 题目id ,
 score (number, optional): 分数 ,
 updateBy (integer, optional),
 updateTime (string, optional),
 value (string, optional): 选择内容 */
@property (nonatomic, assign) float score;
@property (nonatomic, assign) NSInteger createBy;
@property (nonatomic, copy)   NSString *delFlag;
@property (nonatomic, assign) NSInteger Id;
@property (nonatomic, copy)   NSString *updateTime;
@property (nonatomic, assign) NSInteger updateBy;
@property (nonatomic, copy)   NSString *value;
@property (nonatomic, assign) NSInteger questionId;
@property (nonatomic, copy)   NSString *moption;
@property (nonatomic, copy)   NSString *createTime;

@end

NS_ASSUME_NONNULL_END
