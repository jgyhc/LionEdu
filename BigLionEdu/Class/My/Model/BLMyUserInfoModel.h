//
//  BLMyUserInfoModel.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/27.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLMyUserInfoModel : NSObject


@property (nonatomic, copy)   NSString *mobile;
@property (nonatomic, copy)   NSString *password;
@property (nonatomic, copy)   NSString *status;
@property (nonatomic, assign) NSInteger modelid;
@property (nonatomic, copy)   NSString *nickname;
@property (nonatomic, copy)   NSString *delFlag;
@property (nonatomic, copy)   NSString *level;
@property (nonatomic, copy)   NSString *photo;
@property (nonatomic, copy)   NSString *icon;
@end

NS_ASSUME_NONNULL_END
