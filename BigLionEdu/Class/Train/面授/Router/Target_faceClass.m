//
//  Target_faceClass.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/10/26.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "Target_faceClass.h"
#import "BLFaceClassViewController.h"

@implementation Target_faceClass

- (id)Action_faceClassViewController:(NSDictionary *)params {
    BLFaceClassViewController *view = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLFaceClassViewController"];
    view.modelId = [[params objectForKey:@"modelId"] integerValue];
    view.functionTypeId = [[params objectForKey:@"functionTypeId"] integerValue];
    return view;
    
}

@end
