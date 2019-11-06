//
//  BLHLDViewController.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/22.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLHLDViewController.h"
#import <Masonry/Masonry.h>
#import <CTMediator/CTMediator.h>
#import "BLGetAppNewsByIdAPI.h"
#import "NTCatergory.h"
#import "FKDownloader.h"
#import <LCProgressHUD.h>
#import "AdaptScreenHelp.h"

@interface BLHLDViewController ()<MJAPIBaseManagerDelegate, CTAPIManagerParamSource, UIWebViewDelegate>

@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) BLGetAppNewsByIdAPI *api;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *timeIcon;
@property (nonatomic, strong) UILabel *timeLab;

@end

@implementation BLHLDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationView = [UIView new];
    [self.view addSubview:self.navigationView];
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        make.height.mas_equalTo(NavigationHeight());
    }];
    
    self.titleLab = [UILabel new];
    self.titleLab.textColor = [UIColor nt_colorWithHexString:@"#333333"];
    self.titleLab.font = [UIFont systemFontOfSize:15];
    self.titleLab.numberOfLines = 0;
    self.titleLab.text = @"山西2008年度考试录用公务员公告";
    [self.view addSubview:self.titleLab];
    [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom).offset(15);
        make.left.offset(15);
        make.right.offset(-15);
    }];
    
    self.timeIcon = [UIImageView new];
    [self.timeIcon setImage:[UIImage imageNamed:@"my_wdkc_sj"]];
    [self.view addSubview:self.timeIcon];
    [self.timeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.equalTo(self.titleLab.mas_bottom).offset(15);
    }];
    
    self.timeLab = [UILabel new];
    self.timeLab.textColor = [UIColor nt_colorWithHexString:@"#878C97"];
    self.timeLab.font = [UIFont systemFontOfSize:12];
    self.timeLab.numberOfLines = 0;
    self.timeLab.text = @"2019.06.01-2019.06.30";
    [self.view addSubview:self.timeLab];
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeIcon);
        make.left.equalTo(self.timeIcon.mas_right).offset(10);
    }];
    
    self.webView = [UIWebView new];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    self.webView.backgroundColor = [UIColor whiteColor];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(NavigationHeight(), 0, 0, 0));
    }];
    [self.api loadData];
}


#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.api isEqual:manager]) {
        return @{@"newId":@(_newId)};
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.api isEqual:manager]) {
        NSDictionary *dic = [data objectForKey:@"data"];
        if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            self.titleLab.text = dic[@"title"];
            if (![dic[@"updateTime"] isKindOfClass:[NSNull class]]) {
                self.timeLab.text = dic[@"updateTime"];
            } else {
                
            }
            NSString *width = [NSString stringWithFormat:@"<img style=\"max-width:%fpx;height:auto;\"", NT_SCREEN_WIDTH - 20];
            NSString *content = [[dic objectForKey:@"content"] stringByReplacingOccurrencesOfString:@"<img" withString:width];
            NSString *htmlStr = [NSString stringWithFormat:@"<html lang=\"zh-CN\"><head><meta charset=\"utf-8\"><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"><meta name=\"viewport\" content=\"width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0\"></head><body>%@</body></html>", content];
            [self.webView loadHTMLString:htmlStr baseURL:nil];
//            self.htmlString = htmlStr;
//            self.fileNameLab.text = self.dict[@"oldPath"];
//            NSString *path = dic[@"oldPath"];
//            if (path && path.length > 0) {
//                [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.right.mas_equalTo(self.view);
//                    make.bottom.equalTo(self.view.mas_bottom).offset(-50);
//                    make.top.mas_equalTo(self.timeLab.mas_bottom).offset(15);
//                }];
//                self.downLoadPath = [IMG_URL stringByAppendingString:path?:@""];
//                FKTask *task = [[FKDownloadManager manager] acquire:self.downLoadPath];
//                if (task && task.status == TaskStatusFinish) {
//                    [self.downBtn setTitle:@"查看文件" forState:UIControlStateNormal];
//                }
//            } else {
//                self.bottomView.hidden = YES;
//            }
        }
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView  stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '130%'"];
}

- (BLGetAppNewsByIdAPI *)api {
    if (!_api) {
        _api = [BLGetAppNewsByIdAPI new];
        _api.mj_delegate = self;
        _api.paramSource = self;
    }
    return _api;
}

@end
