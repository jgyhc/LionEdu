//
//  BLVideoShareInfoManager.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/23.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLVideoShareInfoManager : NSObject


@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, copy) NSString *onlinenumber;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *avatar;

+ (instancetype)shared;

@end

NS_ASSUME_NONNULL_END
