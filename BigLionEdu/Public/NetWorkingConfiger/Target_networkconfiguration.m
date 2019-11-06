//
//  Target_networkconfiguration.m
//  MJNetWorkKit_Example
//
//  Created by -- on 2018/12/28.
//  Copyright © 2018 刘聪. All rights reserved.
//

#import "Target_networkconfiguration.h"
#import "ZLUserInstance.h"
#import "UIViewController+ORAdd.h"

@implementation Target_networkconfiguration

- (id)Action_apiBaseUrl:(NSDictionary *)params {
//    return @"http://shuoyeah.com:8484";
    return @"http://39.98.129.96";
}

- (id)Action_gatewayKey:(NSDictionary *)params {
    return @"kylin/sys/app";
}

- (id)Action_publicKey:(NSDictionary *)params {
    return @"";
}

- (id)Action_privateKey:(NSDictionary *)params {
    return @"";
}

- (id)Action_extraParmas:(NSDictionary *)params {
    return @"";
}

- (id)Action_extraHttpHeadParmas:(NSDictionary *)params {
    NSString *token = [ZLUserInstance sharedInstance].token;
//    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    NSString *device = [Hardwaremodel platformString];
//    NSString *appVersion = [InterfaceConfiguration shareInterfaceConfiguration].app_version;
//    NSString *sysVersion = [InterfaceConfiguration shareInterfaceConfiguration].sys_version;
//    NSString *apiVersion = [InterfaceConfiguration shareInterfaceConfiguration].api_version;
    NSMutableDictionary *httpHeadParmas = [NSMutableDictionary dictionary];
    if (token) {
        [httpHeadParmas setObject:token forKey:@"user"];
    }
//
//    if (uuid) {
//        [httpHeadParmas setObject:uuid forKey:@"deviceid"];
//    }
//    if (device) {
//        [httpHeadParmas setObject:device forKey:@"device"];
//    }
//
//    [httpHeadParmas setObject:@"--_iOS" forKey:@"clientKey"];
//    if (appVersion) {
//        [httpHeadParmas setObject:appVersion forKey:@"appVersion"];
//    }
//
//    if (apiVersion) {
//        [httpHeadParmas setObject:apiVersion forKey:@"apiVersion"];
//    }
//    if (sysVersion) {
//        [httpHeadParmas setObject:sysVersion forKey:@"sysVersion"];
//    }
//    [httpHeadParmas setObject:@"App_IOS" forKey:@"loginType"];
//    if ([CTNetworkingConfigurationManager sharedInstance].shouldSetParamsInHTTPBodyButGET) {
//        [self.httpHeadParmas setObject:@"application/json" forKey:@"Content-Type"];
//        [self.httpHeadParmas setObject:@"application/json" forKey:@"Accept"];
//    }
    [httpHeadParmas setObject:@"application/json" forKey:@"Content-Type"];
    [httpHeadParmas setObject:@"application/json" forKey:@"Accept"];

//    return self.httpHeadParmas;

    return httpHeadParmas;
}

- (id)Action_loginFailureCode:(NSDictionary *)params {
    return @401;
}

- (id)Action_codeString:(NSDictionary *)params {
    return @"code";
}

- (id)Action_messageString:(NSDictionary *)params {
    return @"msg";
}

- (id)Action_dataString:(NSDictionary *)params {
    return @"data";
}

- (id)Action_normalResultsCode:(NSDictionary *)params {
    return @200;
}

- (id)Action_resetLogin:(NSDictionary *)params {
    if (![ZLUserInstance sharedInstance].isLogin) {
        [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
        return @(NO);
    }
    return @(NO);
}

- (id)Action_otherFailure:(NSDictionary *)params {
    return @(YES);
}

@end
