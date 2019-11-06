//  更改用户昵称
//  BLAPPMyselfupdateNickNameAPI.m
//  BigLionEdu
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAPPMyselfupdateNickNameAPI.h"

@implementation BLAPPMyselfupdateNickNameAPI

#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appMyself/updateNickName";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePost;
}
@end
