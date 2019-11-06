//
//  ZLUserInstance.m
//  ManJi
//
//  Created by manjiwang on 2018/12/18.
//  Copyright © 2018 Zgmanhui. All rights reserved.
//

#import "ZLUserInstance.h"
#import "YYCache.h"
#import "YYModel.h"
#import "BLAPPMyselfGetMemberInfoAPI.h"

NSString * const ZLUserInfoCacheKey = @"userInfoKey";
NSString * const ZLUserInfoCacheFirstnName = @"userInfo";

NSString *const ZLUserLoginNotificationKey = @"ZLUserLoginNotificationKey";
NSString *const ZLUserLoginOutNotificationKey = @"ZLUserLoginOutNotificationKey";
NSString *const ZLUserInfoUpdateNotificationKey = @"ZLUserInfoUpdateNotificationKey";


@interface ZLUserInstance ()<MJAPIBaseManagerDelegate, CTAPIManagerParamSource>

@property (nonatomic, strong) BLAPPMyselfGetMemberInfoAPI * getMemberInfoAPI;

@property (nonatomic, strong) YYCache *cache;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *userids;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *phone;

/** 当前是否登录 */
@property (nonatomic, assign) BOOL isLogin;
@end

@implementation ZLUserInstance

+ (instancetype)sharedInstance {
    static ZLUserInstance *user;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[ZLUserInstance alloc] init];
        id userInfo = [user.cache objectForKey:ZLUserInfoCacheKey];
        if (userInfo && [userInfo isKindOfClass:[NSDictionary class]]) {
            [user setValuesForKeysWithDictionary:userInfo];
        }
    });
    return user;
}

////YYModelh处理的黑名单
//+ (NSArray *)modelPropertyBlacklist {
//    return @[@"userExitLoginManager", @"cache"];
//}
- (void)setValue:(nullable id)value forUndefinedKey:(NSString *)key {
   
}

- (NSString *)isStringWithUserInfo:(NSDictionary *)userInfo key:(NSString *)key {
    id value = [userInfo objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    return @"";
}

- (void)setValue:(nullable id)value forKey:(NSString *)key {
    [super setValue:value forKey:key];
    if (!value) {
        return;
    }
    NSDictionary * userInfo = (NSDictionary *)[self.cache objectForKey:ZLUserInfoCacheKey];
    NSMutableDictionary *muUserInfo = userInfo.mutableCopy;
    [muUserInfo setObject:value forKey:key];
    [self.cache setObject:muUserInfo forKey:ZLUserInfoCacheKey];
}

- (void)loginWithToken:(NSString *)token {
    [self setValue:token?token:@"" forKey:@"token"];
    [self.getMemberInfoAPI loadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:ZLUserLoginNotificationKey object:nil];
}

- (void)loginWithUserInfo:(NSDictionary *)userInfo {
    [self updateUserInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:ZLUserLoginNotificationKey object:nil];
}

- (void)loginOutWithViewController:(UIViewController *)viewController {
    [self removeUserInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:ZLUserLoginOutNotificationKey object:nil];
}

- (void)updateUserInfo:(NSDictionary *)userInfo {
    if (!userInfo || ![userInfo isKindOfClass:[NSDictionary class]]) {
        userInfo = [NSDictionary dictionary];
    }
    
    NSMutableDictionary *muuserInfo = [userInfo mutableCopy];

    [muuserInfo setObject:_token?:@"" forKey:@"token"];
    [self.cache setObject:muuserInfo forKey:ZLUserInfoCacheKey];
    [self setValuesForKeysWithDictionary:muuserInfo];
}

- (void)separateUpdateUserInfo:(NSDictionary *)userInfo {
    [self updateUserInfo:userInfo];
}

- (void)removeUserInfo {
    [self setValue:@"" forKey:@"token"];
    [self setValuesForKeysWithDictionary:@{@"nickname":@"",
                                           @"photo":@"",
                                           @"phone":@"",
                                           @"userids":@"",
                                           @"mobile":@"",
                                           @"levelList":@[]
                                           }];
    [self.cache removeObjectForKey:ZLUserInfoCacheKey];
}

- (NSString *)token {
    if (!_token) {
        _token = @"";
    }
    return _token;
}

- (NSString *)getDocumentPathWithFirstName:(NSString *)firstName {
    NSArray *userPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [userPaths objectAtIndex:0];
    if (firstName) {
        return [NSString stringWithFormat:@"%@/%@", path, firstName];
    }
    return path;
}

- (YYCache *)cache {
    if (!_cache) {
        _cache = [[YYCache alloc] initWithPath:[self getDocumentPathWithFirstName:ZLUserInfoCacheFirstnName]];
    }
    return _cache;
}


- (NSString *)photo {
    if ([_photo hasPrefix:@"http"]) {
        return _photo;
    }
    return [NSString stringWithFormat:@"%@%@", IMG_URL, _photo];
}

#pragma mark -- other

- (BOOL)isLogin {
    return self.token.length > 0 ? YES : NO;
}


#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getMemberInfoAPI isEqual:manager]) {
        return @{};
    }
    return @{};
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getMemberInfoAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSMutableDictionary *userInfo = [[data objectForKey:@"data"] mutableCopy];
            [self setValuesForKeysWithDictionary:userInfo];
            [userInfo setObject:_token forKey:@"token"];
            [self.cache setObject:userInfo forKey:ZLUserInfoCacheKey];
            [[NSNotificationCenter defaultCenter] postNotificationName:ZLUserInfoUpdateNotificationKey object:nil];
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (BLAPPMyselfGetMemberInfoAPI *)getMemberInfoAPI {
    if (!_getMemberInfoAPI) {
        _getMemberInfoAPI = [[BLAPPMyselfGetMemberInfoAPI alloc] init];
        _getMemberInfoAPI.mj_delegate = self;
        _getMemberInfoAPI.paramSource = self;
    }
    return _getMemberInfoAPI;
}

@end
