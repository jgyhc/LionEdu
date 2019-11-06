//
//  BLAnswerSheetNavViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/24.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLAnswerSheetNavViewController.h"
#import "BLAnswerSheetViewController.h"

@interface BLAnswerSheetNavViewController ()

@end

@implementation BLAnswerSheetNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    if (self.viewControllers.count > 0) {
//        BLAnswerSheetViewController *viewController = [self.viewControllers firstObject];
//        viewController.sectionTopicList = _list;
//        viewController.modelId = _modelId;
//        viewController.setId = _setId;
//        viewController.functionTypeId = _functionTypeId;
//    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (UIUserInterfaceStyle)overrideUserInterfaceStyle {
    return UIUserInterfaceStyleLight;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
