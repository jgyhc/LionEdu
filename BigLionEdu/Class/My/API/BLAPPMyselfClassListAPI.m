//
//  BLAPPMyClassListAPI.m
//  BigLionEdu
//
//  Created by mac on 2019/8/30.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAPPMyselfClassListAPI.h"

@implementation BLAPPMyselfClassListAPI
- (NSString *)methodName {
    return @"appMyself/getAppMyCurriculumInfo";
    
}

- (CTAPIManagerRequestType)requestType {
    return CTAPIManagerRequestTypeGet;
}
@end
