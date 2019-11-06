//
//  Target_login.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/10/18.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "Target_login.h"
#import "UIViewController+ORAdd.h"

@interface Target_login ()

@property (nonatomic, assign) BOOL isPush;
@end

@implementation Target_login

- (id)Action_loginViewController:(NSDictionary *)params {
    return [[UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
}

- (id)Action_pushLogin:(NSDictionary *)params {
    if (_isPush) {
        return nil;
    }
    UIViewController *controller = [self Action_loginViewController:params];
    controller.modalPresentationStyle = UIModalPresentationFullScreen;
    [[UIViewController currentViewController] presentViewController:controller animated:YES completion:nil];
    _isPush = YES;
    return nil;
}

- (id)Action_resetStatus:(NSDictionary *)params {
    _isPush = NO;
    return nil;
}
@end
