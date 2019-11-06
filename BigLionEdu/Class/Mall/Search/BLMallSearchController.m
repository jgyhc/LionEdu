//
//  BLMallSearchController.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLMallSearchController.h"
#import "NTCatergory.h"
#import <BlocksKit.h>
#import <YYModel.h>
#import "YZTagList.h"
#import "AdaptScreenHelp.h"
#import "BLSearchHistoryAPI.h"
#import "BLSearchHistoryDeleteAPI.h"
#import "BLSearchHistoryModel.h"
#import "BLMallSearchResultController.h"
#import "BLGetPopularRecommendAPI.h"
#import "BLTrainSearchResultViewController.h"
#import "BLTrainVideoSearchResultController.h"

@interface BLMallSearchController ()<MJAPIBaseManagerDelegate, CTAPIManagerParamSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *delBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (nonatomic, strong) YZTagList *searList;
@property (nonatomic, strong) YZTagList *hotList;
@property (nonatomic, strong) UILabel *hotTitleLab;
@property (nonatomic, strong) BLSearchHistoryAPI *searchHistoryAPI;
@property (nonatomic, strong) BLGetPopularRecommendAPI *popularRecommendAPI;
@property (nonatomic, strong) BLSearchHistoryDeleteAPI *searchHistoryDeleteAPI;

@property (nonatomic, strong) NSArray <NSString *> *tags;

@end

@implementation BLMallSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delBtn.externalTouchInset = UIEdgeInsetsMake(15, 15, 15, 15);
//    UIButton *icon = [UIButton buttonWithType:UIButtonTypeCustom];
//    [icon setImage:[UIImage imageNamed:@"sc_icon"] forState:UIControlStateNormal];
//    icon.frame = CGRectMake(9, 0, 30, 30);
//    icon.contentMode = UIViewContentModeScaleToFill;
//    self.searchTF.leftView = icon;
//    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
    self.searchTF.returnKeyType = UIReturnKeySearch;
    self.searchTF.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.searList = [[YZTagList alloc] initWithFrame:CGRectMake(7.5, NavigationHeight() + 30, NT_SCREEN_WIDTH - 22.5, 0)];
    self.searList.tagFont = [UIFont systemFontOfSize:14];
    self.searList.tagBackgroundColor = [UIColor nt_colorWithHexString:@"#F8F9FA"];
    self.searList.isFitTagListH = YES;
    self.searList.tagColor = [UIColor nt_colorWithHexString:@"#666666"];
    self.searList.tagCornerRadius = 15.0;
    self.searList.interitemSpacing = 7.5;
    [self.view addSubview:self.searList];
    __weak typeof(self) wself = self;
    /**
     * 去搜索
     */
    [self.searList setClickTagBlock:^(UIButton *button, NSString *tag) {
        [wself goSearchTag:tag];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searchHistoryAPI loadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.length > 0) {
        [self goSearchTag:textField.text];
    }
    return YES;
}

- (IBAction)le_cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)le_delete:(id)sender {
    [self.searchHistoryDeleteAPI loadData];
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.searchHistoryAPI isEqual:manager]) {
        return @{@"type": @(self.type==4?1:self.type)};
    } else if ([self.popularRecommendAPI isEqual:manager]) {
        return @{@"type": @(self.type),
                 @"functionTypeId": self.functionTypeId?:@""
        };
        return nil;
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.searchHistoryAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            for (int i = 0; i < self.tags.count; i ++) {
                [self.searList deleteTag:self.tags[i]];
            }
            NSArray <BLSearchHistoryModel *> *models = [NSArray yy_modelArrayWithClass:[BLSearchHistoryModel class] json:data[@"data"]];
            NSArray *tags = [models bk_map:^id(BLSearchHistoryModel *obj) {
                return obj.title;
            }];
            self.tags = tags;
            [self.searList addTags:tags];
        }
        [self.popularRecommendAPI loadData];
    } else if ([self.popularRecommendAPI isEqual:manager]) {
        [self bk_reloadHotList:data];
    } else  {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            for (int i = 0; i < self.tags.count; i ++) {
                [self.searList deleteTag:self.tags[i]];
            }
        }
        [self.popularRecommendAPI loadData];
    }
}

- (void)bk_reloadHotList:(id)data {
    [self.hotTitleLab removeFromSuperview];
    [self.hotList removeFromSuperview];
    self.hotTitleLab = nil;
    self.hotList = nil;
    NSArray <BLSearchHistoryModel *> *models = [NSArray yy_modelArrayWithClass:[BLSearchHistoryModel class] json:data[@"data"]];
    NSArray <NSString *>*tags = [models bk_map:^id(BLSearchHistoryModel *obj) {
        return obj.title;
    }];
    UILabel *hotTitleLab = [[UILabel alloc] initWithFrame:CGRectMake(15, NavigationHeight() + 30 + self.searList.nt_height + 10, NT_SCREEN_WIDTH, 16)];
    hotTitleLab.textColor = [UIColor nt_colorWithHexString:@"#333333"];
    hotTitleLab.font = [UIFont systemFontOfSize:15];
    hotTitleLab.text = @"热门搜索";
    self.hotTitleLab = hotTitleLab;
    [self.view addSubview:hotTitleLab];
    self.hotList = [[YZTagList alloc] initWithFrame:CGRectMake(7.5, NavigationHeight() + 30 + self.searList.nt_height + 25, NT_SCREEN_WIDTH - 22.5, 0)];
    self.hotList.tagFont = [UIFont systemFontOfSize:14];
    self.hotList.tagBackgroundColor = [UIColor nt_colorWithHexString:@"#F8F9FA"];
    self.hotList.isFitTagListH = YES;
    self.hotList.tagColor = [UIColor nt_colorWithHexString:@"#666666"];
    self.hotList.tagCornerRadius = 15.0;
    self.hotList.interitemSpacing = 7.5;
    [self.view addSubview:self.hotList];
    [self.hotList addTags:tags];
    __weak typeof(self) wself = self;
    [self.hotList setClickTagBlock:^(UIButton *button, NSString *tag) {
        [wself goSearchTag:tag];
    }];
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (void)goSearchTag:(NSString *)searchTag {
    if (_type == 1) {
        BLTrainSearchResultViewController *viewController = [[UIStoryboard storyboardWithName:@"Train" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLTrainSearchResultViewController"];
        viewController.key = searchTag;
        viewController.modelId = _modelId;
//        viewController.functionType = [_functionTypeId integerValue];
        [self.navigationController pushViewController:viewController animated:YES];
        return;
    } else if (_type == 4) {
        BLTrainVideoSearchResultController *controller = [BLTrainVideoSearchResultController new];
        controller.searchStr = searchTag;
        controller.modelId = self.modelId;
        controller.functionTypeId = self.functionTypeId.integerValue;
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    BLMallSearchResultController *controller = [BLMallSearchResultController new];
    controller.searchStr = searchTag;
    [self.navigationController pushViewController:controller animated:YES];
}

- (BLSearchHistoryAPI *)searchHistoryAPI {
    if (!_searchHistoryAPI) {
        BLSearchHistoryAPI *api = [BLSearchHistoryAPI new];
        api.mj_delegate = self;
        api.paramSource = self;
        _searchHistoryAPI = api;
    }
    return _searchHistoryAPI;
}

- (BLSearchHistoryDeleteAPI *)searchHistoryDeleteAPI {
    if (!_searchHistoryDeleteAPI) {
        BLSearchHistoryDeleteAPI *api = [BLSearchHistoryDeleteAPI new];
        api.mj_delegate = self;
        api.paramSource = self;
        _searchHistoryDeleteAPI = api;
    }
    return _searchHistoryDeleteAPI;
}

- (BLGetPopularRecommendAPI *)popularRecommendAPI {
    if (!_popularRecommendAPI) {
        BLGetPopularRecommendAPI *api = [BLGetPopularRecommendAPI new];
        api.mj_delegate = self;
        api.paramSource = self;
        _popularRecommendAPI = api;
    }
    return _popularRecommendAPI;
}

@end
