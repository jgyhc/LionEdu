//
//  Target_apiHelp.m
//  MJNetWorkKit_Example
//
//  Created by -- on 2019/1/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "Target_apiHelp.h"
#import <YYCache/YYCache.h>
#import <MJProgressHUD/LCProgressHUD.h>
#import <CommonCrypto/CommonCrypto.h>
//#import "MJRSAEncryptor.h"

@implementation Target_apiHelp

- (id)Action_fieldPublicKey:(NSDictionary *)params {
//    return [[InterfaceConfiguration shareInterfaceConfiguration] publicKey];
    return @"";
}

- (id)Action_RSAEncryptor:(NSDictionary *)params {
    NSString *value = [params objectForKey:@"value"];
//    NSString *publicKey = [params objectForKey:@"publicKey"];
//    return [MJRSAEncryptor encryptString:value publicKey:publicKey];
    //这里只是用MD5
    
    
    return [self md5:value];
}

- (id)Action_encryptorFields:(NSDictionary *)params {
    return @[@"userPwd"];
}

- (id)Action_cacheData:(NSDictionary *)params {
    id data = [params objectForKey:@"data"];
    NSString *dataString = [params objectForKey:@"dataString"];
    YYCache *cache = [params objectForKey:@"cache"];
    if (!cache) {
        BOOL isCachePath = [[params objectForKey:@"isCachePath"] boolValue];
        if (isCachePath) {
            NSString *cachePath = [params objectForKey:@"cachePath"];
            cache = [[YYCache alloc] initWithPath:cachePath];
        }else {
            NSString *cacheName = [params objectForKey:@"cacheName"];
            cache = [[YYCache alloc] initWithName:cacheName?cacheName:@"Base"];
        }
    }
    if ([data isKindOfClass:[NSDictionary class]]) {
        id value = [data objectForKey:dataString];
        [cache setObject:value forKey:dataString];
    }else {
        [cache setObject:data forKey:dataString];
    }
    return cache;
}

- (id)Action_progress:(NSDictionary *)params {
    return [[LCProgressHUD alloc] init];
}


- (id)Action_progressHide:(NSDictionary *)params {
    LCProgressHUD *progress = [params objectForKey:@"progress"];
    [progress hide];
    return nil;
}

- (id)Action_progressShow:(NSDictionary *)params {
    LCProgressHUD *progress = [params objectForKey:@"progress"];
    if (!progress) {
        progress = [[LCProgressHUD alloc] init];
    }
    UIView *view = [params objectForKey:@"view"];
    if (!view) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    NSString *content = [params objectForKey:@"content"];
    if (content) {
        [progress showWithView:view content:content];
    }
    return progress;
}

- (id)Action_progressLoadingShow:(NSDictionary *)params {
    LCProgressHUD *progress = [params objectForKey:@"progress"];
    if (!progress) {
        progress = [[LCProgressHUD alloc] init];
    }
    UIView *view = [params objectForKey:@"view"];
    if (!view) {
        view = [[UIApplication sharedApplication] keyWindow];
    }
    NSString *content = [params objectForKey:@"content"];
    [progress showLoadingWithView:view content:content];
    return progress;
}

- (nullable NSString *)md5:(nullable NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

@end
