//
//  BLAnswerReportModel.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/25.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class BLAnswerReportCassfierModel;

@interface BLAnswerReportModel : NSObject
@property (nonatomic, assign) NSInteger duration;//秒数
@property (nonatomic, strong) NSNumber * score;
@property (nonatomic, copy)   NSString *title;
@property (nonatomic, copy)   NSString *accuracy;
@property (nonatomic, strong) NSArray<BLAnswerReportCassfierModel *> *cassfierDTOList;

@property (nonatomic, copy) NSString * isManual;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *submissionTime;

@property (nonatomic, copy) NSString *submissionTimeStr;
@end

@interface BLAnswerReportCassfierModel : NSObject

@property (nonatomic, assign) NSInteger usedTime;
@property (nonatomic, copy)   NSString *cassfierTitle;
@property (nonatomic, strong) NSString *accuracy;

@property (nonatomic, copy) NSString *time;

@end


NS_ASSUME_NONNULL_END
