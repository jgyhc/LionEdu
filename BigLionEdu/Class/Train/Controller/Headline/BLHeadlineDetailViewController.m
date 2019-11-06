//
//  BLHeadlineDetailViewController.m
//  MJWebViewKit_Example
//
//  Created by -- on 2019/2/17.
//  Copyright © 2019 jgyhc. All rights reserved.
//

#import "BLHeadlineDetailViewController.h"
#import <Masonry/Masonry.h>
#import <CTMediator/CTMediator.h>
#import "BLGetAppNewsByIdAPI.h"
#import "NTCatergory.h"
#import "FKDownloader.h"
#import <LCProgressHUD.h>

#define MJWebe_UICOLOR_HEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
typedef void (^completionBlock)(NSDictionary *info);
@interface BLHeadlineDetailViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler, CTAPIManagerParamSource, MJAPIBaseManagerDelegate, FKTaskDelegate>

@property (nonatomic, strong) WKWebViewConfiguration * config;

// The main and only UIProgressView
@property (nonatomic, strong) UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIView *navigationView;
@property (nonatomic, strong) BLGetAppNewsByIdAPI *getAppNewsByIdAPI;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIImageView *timeIcon;
@property (nonatomic, strong) UILabel *timeLab;

@property (weak, nonatomic) IBOutlet UIButton *big;
@property (weak, nonatomic) IBOutlet UIButton *mid;
@property (weak, nonatomic) IBOutlet UIButton *small;


@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIImageView *fileIcon;
@property (weak, nonatomic) IBOutlet UILabel *fileNameLab;

@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) FKTask *task;
@property (nonatomic, copy) NSString *downLoadPath;


@end

@implementation BLHeadlineDetailViewController

static inline CGFloat mjWebSafeAreaInsetsTop() {
    if (@available(iOS 11.0, *)) {
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
        CGFloat topSafeInset = keyWindow.safeAreaInsets.top;
        return topSafeInset == 0 ? 20.0 : topSafeInset;
    }
    return 20.0;
}

- (void)dealloc {
    [self.webView setNavigationDelegate:nil];
    [self.webView setUIDelegate:nil];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (IBAction)backEvent:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
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
    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.navigationView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.top.mas_equalTo(self.timeLab.mas_bottom).offset(15);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navigationView.mas_bottom);
    }];
    [self.getAppNewsByIdAPI loadData];
    [self.downBtn addTarget:self action:@selector(bl_downButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setHtmlString:(NSString *)htmlString {
    _htmlString = htmlString;
    NSURL *font = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"iPhone" ofType:@"css"]];
    [self.webView loadHTMLString:htmlString baseURL:font];
}

- (IBAction)bl_fontSize_Big:(UIButton *)sender {
    sender.selected = YES;
    self.small.selected = NO;
    self.mid.selected = NO;
    // 适当增大字体大小
    [self.webView  evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '130%'" completionHandler:nil];
    self.titleLab.font = [UIFont systemFontOfSize:18];
    self.timeLab.font = [UIFont systemFontOfSize:14];
}

- (IBAction)bl_fontSize_middle:(UIButton *)sender {
    sender.selected = YES;
    self.small.selected = NO;
    self.big.selected = NO;
    // 适当增大字体大小
    [self.webView  evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '110%'" completionHandler:nil];
    self.titleLab.font = [UIFont systemFontOfSize:16];
    self.timeLab.font = [UIFont systemFontOfSize:13];
}

- (IBAction)bl_fontSize_small:(UIButton *)sender {
    sender.selected = YES;
    self.big.selected = NO;
    self.mid.selected = NO;
    // 适当增大字体大小
    [self.webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'" completionHandler:nil];
    self.titleLab.font = [UIFont systemFontOfSize:15];
    self.timeLab.font = [UIFont systemFontOfSize:12];
}


#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getAppNewsByIdAPI isEqual:manager]) {
        return @{@"newId":@(_newId)};
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getAppNewsByIdAPI isEqual:manager]) {
        NSDictionary *dic = [data objectForKey:@"data"];
        if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            _dict = dic;
            self.titleLab.text = dic[@"title"];
            if (![dic[@"updateTime"] isKindOfClass:[NSNull class]]) {
                self.timeLab.text = dic[@"updateTime"];
            } else {
                self.timeLab.text = @"---- --:--:--";
            }
            NSString *width = [NSString stringWithFormat:@"<img style=\"max-width:%fpx;height:auto;\"", NT_SCREEN_WIDTH - 20];
            NSString *content = [[dic objectForKey:@"content"] stringByReplacingOccurrencesOfString:@"<img" withString:width];
            NSString *htmlStr = [NSString stringWithFormat:@"<html lang=\"zh-CN\"><head><meta charset=\"utf-8\"><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"><meta name=\"viewport\" content=\"width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0\"><link rel=\"stylesheet\" type=\"text/css\" href=\"iPhone.css\"><style>body,p,span {font-family: \"TsangerJinKai03-W03\";}</style></head><body>%@</body></html>", content];
            self.htmlString = htmlStr;
            if (![self.dict[@"oldPath"] isKindOfClass:[NSNull class]]) {
                self.fileNameLab.text = self.dict[@"oldPath"];
            } else {
                self.fileNameLab.text = @"";
            }
            
            NSString *path = dic[@"oldPath"];
            if (![path isKindOfClass:[NSNull class]] && path && path.length > 0) {
                [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.mas_equalTo(self.view);
                    make.bottom.equalTo(self.view.mas_bottom).offset(-50);
                    make.top.mas_equalTo(self.timeLab.mas_bottom).offset(15);
                }];
                self.downLoadPath = [IMG_URL stringByAppendingString:path?:@""];
                FKTask *task = [[FKDownloadManager manager] acquire:self.downLoadPath];
                if (task && task.status == TaskStatusFinish) {
                    [self.downBtn setTitle:@"查看文件" forState:UIControlStateNormal];
                }
            } else {
                self.bottomView.hidden = YES;
            }
        }
    }
}

- (void)bl_downButtonClick {
    if (!_task) {
        _task = [[FKDownloadManager manager] acquire:self.downLoadPath];
    }
    if (_task) {
        _task.delegate = self;
        if (_task.status == TaskStatusSuspend) {
            [[FKDownloadManager manager] resume:self.downLoadPath];
        } else if (_task.status == TaskStatusExecuting) {
            [LCProgressHUD show:@"正在下载"];
        } else if (_task.status == TaskStatusFinish) {
            [LCProgressHUD show:@"下载完成"];
        } else {
            [[FKDownloadManager manager] start:self.downLoadPath];
        }
    } else {
        [[FKDownloadManager manager] addTasksWithArray:@[@{FKTaskInfoURL: self.downLoadPath,
                                                           FKTaskInfoTags: @[@"group_task_01"]}]];
        [[FKDownloadManager manager] start:self.downLoadPath];
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (void)handleCloseAction:(id)sender {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setUrl:(NSURL *)url {
    _url = url;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)reloadWebView {
    [self.webView loadRequest:[NSURLRequest requestWithURL:_url]];//重载
}

- (void)goBack {
    [self.webView goBack];
}

- (void)setHtmlName:(NSString *)htmlName {
    _htmlName = htmlName;
    NSString *indexPath = [[NSBundle mainBundle] pathForResource:htmlName ofType:@"html"];
    NSString *appHtml = [NSString stringWithContentsOfFile:indexPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseUrl = [NSURL fileURLWithPath:indexPath];
    [self.webView loadHTMLString:appHtml baseURL:baseUrl];
}


- (void)shareEvent:(id)sender {
    [[CTMediator sharedInstance] performTarget:@"web" action:@"share" params:_shareInfo shouldCacheTarget:YES];
}

#pragma mark -- WKScriptMessageHandler method
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"Native"]) {
        NSDictionary *param = [self dictionaryWithJsonString:message.body];
        NSString *action = [param objectForKey:@"action"];
        if (![action isKindOfClass:[NSString class]] && ![action isKindOfClass:NSClassFromString(@"NSTaggedPointerString")]) {
            NSLog(@"action参数错误");
            return;
        }
        if (action) {
            id data = [param objectForKey:@"data"];
            if ([data isKindOfClass:[NSString class]]) {
                data = [self dictionaryWithJsonString:data];
            }
            [[CTMediator sharedInstance] performTarget:@"web" action:action params:data shouldCacheTarget:YES];
        }
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    // 获取完整url并进行UTF-8转码
    NSString *strRequest = [navigationAction.request.URL.absoluteString stringByRemovingPercentEncoding];
    if ([strRequest hasPrefix:@"native://"]) {
        // 拦截点击链接
        [self handleCustomStrRequest:strRequest url:navigationAction.request.URL];
        // 不允许跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        // 允许跳转
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)handleCustomStrRequest:(NSString *)strRequest url:(NSURL *)url {
    if ([strRequest isEqualToString:@"native://type=back"]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    NSDictionary *params = [self parameterWithURL:url];
    NSString *action = [params objectForKey:@"host"];
    [[CTMediator sharedInstance] performTarget:@"web" action:action params:params shouldCacheTarget:YES];
}

/**
 获取url的所有参数
 @param url 需要提取参数的url
 @return NSDictionary
 */
- (NSDictionary *)parameterWithURL:(NSURL *) url {
    
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
    
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
    NSString *host = urlComponents.host;
    
    if ([host containsString:@"="]) {
        host = [[host componentsSeparatedByString:@"="] lastObject];
    }
    [parm setObject:host forKey:@"host"];
    return parm;
}

- (NSDictionary *)dictionaryWithJsonString:(id)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = jsonString;
    NSError *err;
    NSDictionary *dic = nil;
    if ([jsonString isKindOfClass:[NSString class]]) {
        jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                              options:NSJSONReadingMutableContainers
                                                error:&err];
        
    }
    if ([jsonString isKindOfClass:[NSData class]]) {
        dic = [NSJSONSerialization JSONObjectWithData:jsonString
                                              options:NSJSONReadingMutableContainers
                                                error:&err];
    }
    if ([jsonString isKindOfClass:[NSDictionary class]]) {
        dic = jsonString;
    }
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

#pragma mark - WKNavigationDelegate method

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {

}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {

}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSString *title = self.webView.title;
    if (title.length == 0) {
        title = _titleString;
    }
    // 适当增大字体大小
    [webView evaluateJavaScript:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'" completionHandler:nil];
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {

}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.webView.estimatedProgress animated:animated];
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)injectionCookieWithValue:(id)value key:(NSString *)key {
    NSMutableString *cookie = @"".mutableCopy;
    [cookie appendFormat:@"document.cookie = '%@=%@';\n",key, value];
    WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookie injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
    [self.config.userContentController addUserScript:cookieScript];
}


#pragma mark - FKTaskDelegate
- (void)downloader:(FKDownloadManager *)downloader prepareTask:(FKTask *)task {
    NSLog(@"预处理: %@", task.url);
    // 在这里可以最后一次处理任务信息
}

- (void)downloader:(FKDownloadManager *)downloader willExecuteTask:(FKTask *)task {
    NSLog(@"准备开始: %@", task.url);
//    self.nameLable.text = [NSURL URLWithString:task.url].lastPathComponent;
}

- (void)downloader:(FKDownloadManager *)downloader didExecuteTask:(FKTask *)task {
    NSLog(@"已开始: %@", task.url);
//    [self.operationButton setTitle:@"暂停" forState:UIControlStateNormal];
}

- (void)downloader:(FKDownloadManager *)downloader didIdleTask:(FKTask *)task {
    NSLog(@"开始等待: %@", task.url);
//    [self.operationButton setTitle:@"等待中" forState:UIControlStateNormal];
}

- (void)downloader:(FKDownloadManager *)downloader progressingTask:(FKTask *)task {
    NSLog(@"%lf", task.progress.fractionCompleted);
}

- (void)downloader:(FKDownloadManager *)downloader didFinishTask:(FKTask *)task {
    NSLog(@"已完成: %@", task.url);
    self.timeLab.text = [NSString stringWithFormat:@"%@   已完成下载", self.dict[@"oldPath"]];
    [LCProgressHUD show:@"下载完成"];
}

- (void)downloader:(FKDownloadManager *)downloader willSuspendTask:(FKTask *)task {
    NSLog(@"将暂停: %@", task.url);
}

- (void)downloader:(FKDownloadManager *)downloader didSuspendTask:(FKTask *)task {
    NSLog(@"已暂停: %@", task.url);
//    [self.operationButton setTitle:@"继续" forState:UIControlStateNormal];
    self.timeLab.text = [NSString stringWithFormat:@"%@   已暂停下载", self.dict[@"oldPath"]];
}

- (void)downloader:(FKDownloadManager *)downloader willCanceldTask:(FKTask *)task {
    NSLog(@"将取消: %@", task.url);
}

- (void)downloader:(FKDownloadManager *)downloader didCancelldTask:(FKTask *)task {
    NSLog(@"已取消: %@", task.url);
}

- (void)downloader:(FKDownloadManager *)downloader willChecksumTask:(FKTask *)task {
    NSLog(@"开始校验文件");
}

- (void)downloader:(FKDownloadManager *)downloader didChecksumTask:(FKTask *)task {
    NSLog(@"校验文件结束: %d", task.isPassChecksum);
}

- (void)downloader:(FKDownloadManager *)downloader errorTask:(FKTask *)task {
    NSLog(@"下载出错: %@", task.error);
    self.fileNameLab.text = [NSString stringWithFormat:@"%@    下载出错", self.dict[@"oldPath"]];
    [LCProgressHUD show:@"下载出错"];
}

- (void)downloader:(FKDownloadManager *)downloader speedInfo:(FKTask *)task {
    
//    NSString *speedAddRemianing = [NSString stringWithFormat:@"%@  剩余：%@", [task bytesPerSecondSpeedDescription], [task estimatedTimeRemainingDescription]];
//
//     self.fileNameLab.text = [NSString stringWithFormat:@"%@    %@", self.dict[@"oldPath"], speedAddRemianing];
}

- (WKWebViewConfiguration *)config {
    if(_config == nil) {
        _config = [[WKWebViewConfiguration alloc] init];
        _config.userContentController = [[WKUserContentController alloc] init];
        // 创建WKWebView
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;//很重要，如果没有设置这个则不会回调createWebViewWithConfiguration方法，也不会回应window.open()方法
        preferences.minimumFontSize = 0.0;
        _config.preferences = preferences;
        [_config.userContentController addScriptMessageHandler:self name:@"Native"];
        NSDictionary *dic;
        if (self.delegate && [self.delegate respondsToSelector:@selector(injectionCookieWithWebViewController:)]) {
            dic = [self.delegate injectionCookieWithWebViewController:self];
            
        }else if (self.injectionCookieBlock) {
            dic = self.injectionCookieBlock(self);
        }
        for (NSString *key in dic.allKeys) {
            [self injectionCookieWithValue:dic[key] key:key];
        }
    }
    return _config;
}

- (WKWebView *)webView {
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.config];
        [_webView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
        [_webView setNavigationDelegate:self];
        _webView.UIDelegate = self;
        [_webView setMultipleTouchEnabled:YES];
        [_webView setAutoresizesSubviews:YES];
        [_webView setUserInteractionEnabled:YES];
        [_webView.scrollView setAlwaysBounceVertical:YES];
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _webView.opaque = YES;
        _webView.scrollView.bounces = YES;
        
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _webView;
}


- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [_progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
        _progressView.tintColor = MJWebe_UICOLOR_HEX(0x4ec7ef);
    }
    return _progressView;
}

- (BLGetAppNewsByIdAPI *)getAppNewsByIdAPI {
    if (!_getAppNewsByIdAPI) {
        _getAppNewsByIdAPI = [[BLGetAppNewsByIdAPI alloc] init];
        _getAppNewsByIdAPI.paramSource = self;
        _getAppNewsByIdAPI.mj_delegate = self;
    }
    return _getAppNewsByIdAPI;
}

@end
