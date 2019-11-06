//
//  BLHelpViewController.m
//  BigLionEdu
//
//  Created by sunmaomao on 2019/9/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLHelpViewController.h"
#import "BLSetModuleAPI.h"

@interface BLHelpViewController ()<MJAPIBaseManagerDelegate, CTAPIManagerParamSource>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) BLSetModuleHelpAPI *api;

@end

@implementation BLHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    self.title = self.type.intValue == 1 ? @"帮助" : @"关于我们";
    
    [self.api loadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    return @{@"id" : self.type};
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    NSInteger code = [[data objectForKey:@"code"] integerValue];
    if (code == 200) {
//        [LCProgressHUD show:@"修改成功，请重新登录"];
        [self.webView loadHTMLString:data[@"data"][@"content"] baseURL:nil];
       
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (BLSetModuleHelpAPI *)api {
    if (!_api) {
        _api = [[BLSetModuleHelpAPI alloc] init];
        _api.mj_delegate = self;
        _api.paramSource = self;
    }
    return _api;
}



@end
