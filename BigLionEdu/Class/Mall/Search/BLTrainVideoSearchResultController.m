//
//  BLMallSearchResultController.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTrainVideoSearchResultController.h"
#import "NTCatergory.h"
#import <BlocksKit.h>
#import <YYModel.h>
#import "AdaptScreenHelp.h"
#import "XWCatergoryView.h"
#import "BLMallIndexCollectionViewCell.h"
#import "BLGetGoodsTypeAPI.h"
#import "BLGetCurriculumListAPI.h"
#import "BLMailSearchContentView.h"
#import "BLGetGoodsListAPI.h"
#import "ZLUserInstance.h"
#import "BLTrainRecordedViewController.h"

@interface BLTrainVideoSearchResultController ()<XWCatergoryViewDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *nav;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) BLGetCurriculumListAPI * getCurriculumListAPI;
@property (nonatomic, strong) BLTrainRecordedViewController *controller;

@end

@implementation BLTrainVideoSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.searchTF.text = self.searchStr;
    self.searchTF.returnKeyType = UIReturnKeySearch;
    self.searchTF.delegate = self;
    UIButton *icon = [UIButton buttonWithType:UIButtonTypeCustom];
    [icon setImage:[UIImage imageNamed:@"sc_icon"] forState:UIControlStateNormal];
    icon.frame = CGRectMake(0, 0, 30, 30);
    icon.contentMode = UIViewContentModeScaleToFill;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftView addSubview:icon];
    self.searchTF.leftView = leftView;
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    self.nav.backgroundColor = [UIColor nt_colorWithHexString:@"#FEEAE1"];
    BLTrainRecordedViewController *vc = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTrainRecordedViewController"];
    _controller = vc;
    vc.functionTypeId = self.functionTypeId;
    vc.categoryTitleViewBackgroundColor = [UIColor nt_colorWithHexString:@"#FEEAE1"];
    vc.modelId = self.modelId;
    vc.superViewController = self;
    vc.searchStr = self.searchStr;
    UIView *view = vc.view;
    view.frame = CGRectMake(0, NavigationHeight(), self.view.nt_width, self.view.nt_height);
    [self addChildViewController:vc];
    [self.view addSubview:view];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRAIN_VIDEO_SEARCH_NOTIFICATION" object:textField.text?:@""];
    _controller.searchStr = textField.text;
    return YES;
}


- (IBAction)lb_back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {

    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
  
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}


- (BLGetCurriculumListAPI *)getCurriculumListAPI {
    if (!_getCurriculumListAPI) {
        _getCurriculumListAPI = [[BLGetCurriculumListAPI alloc] init];
        _getCurriculumListAPI.mj_delegate = self;
        _getCurriculumListAPI.paramSource = self;
    }
    return _getCurriculumListAPI;
}


@end
