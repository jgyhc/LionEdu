//
//  BLAnswerCardModel.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/9.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLAnswerCardModel : NSObject

@property (nonatomic, assign) NSInteger parentId;

/** d用户输入的答案 */
@property (nonatomic, copy)   NSString *memAnswer;

/** 成绩 */
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger Id;

@property (nonatomic, assign) NSInteger setRecId;

/** 是否正确 */
@property (nonatomic, copy)   NSString *isCorrect;


@property (nonatomic, copy)   NSString *usedTime;
@property (nonatomic, assign) NSInteger questionId;
@property (nonatomic, copy)   NSString *isMaterial;

@end

NS_ASSUME_NONNULL_END
