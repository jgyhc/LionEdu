//  更改用户头像
//  BLAPPMyselfupdatePhoto.m
//  BigLionEdu
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAPPMyselfupdatePhoto.h"

@implementation BLAPPMyselfupdatePhoto
#pragma mark - CTAPIManager

- (NSString *)methodName {
    return @"appMyself/updatePhoto";
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypePost;
}
@end
