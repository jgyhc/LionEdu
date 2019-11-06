//
//  MJWebViewController.m
//  MJWebViewKit_Example
//
//  Created by -- on 2019/2/17.
//  Copyright © 2019 jgyhc. All rights reserved.
//

#import "MJWebViewController.h"
#import <Masonry/Masonry.h>
#import <CTMediator/CTMediator.h>

#define MJWebe_UICOLOR_HEX(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
typedef void (^completionBlock)(NSDictionary *info);
@interface MJWebViewController ()<WKUIDelegate, WKNavigationDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebViewConfiguration * config;

// The main and only UIProgressView
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) MJWebNavigationView * navigationView;
@end

@implementation MJWebViewController

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


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [self.view addSubview:self.navigationView];
    [self updateNavigationType:_navigationType];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navigationView.mas_bottom);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.navigationView.mas_bottom);
    }];
    
    if (_shareInfo) {
        [self.navigationView addRightButtonWithImageName:@"miniweb_share_info_icon" target:self action:@selector(shareEvent:)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setHtmlString:(NSString *)htmlString {
    _htmlString = htmlString;
    [self.webView loadHTMLString:htmlString baseURL:nil];
}

- (void)handleBackEvent:(id)sender {
    if (self.webView.canGoBack) {
        [self.webView goBack];
        return;
    }
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)handleCloseAction:(id)sender {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
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

- (void)updateNavigationType:(NSInteger)type {
    _navigationType = type;
    self.navigationView.type = type;
    switch (type) {
        case 0: {
            [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(self.view);
                make.height.mas_equalTo(mjWebSafeAreaInsetsTop() + 44);
            }];
        }
            break;
        case 1: {
            [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(self.view);
                make.height.mas_equalTo(mjWebSafeAreaInsetsTop());
            }];
        }
            break;
        case 2: {
            [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(self.view);
                make.height.mas_equalTo(0);
            }];
        }
            break;
        default:
            break;
    }
    [self.view layoutIfNeeded];
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
    }else {
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
    if (self.webView.canGoBack) {
        self.navigationView.closeButton.hidden = NO;
    }else {
        self.navigationView.closeButton.hidden = YES;
    }
    NSString *title = self.webView.title;
    if (title.length == 0) {
        title = _titleString;
    }
    self.navigationView.title = title;
}

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {

}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {

}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    if (self.webView.canGoBack) {
        self.navigationView.closeButton.hidden = NO;
    }else {
        self.navigationView.closeButton.hidden = YES;
    }
    NSString *title = self.webView.title;
    if (title.length == 0) {
        title = _titleString;
    }
    self.navigationView.title = title;
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

- (MJWebNavigationView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[MJWebNavigationView alloc] init];
        [_navigationView addBackAndCloseButtonWithTarget:self backAction:@selector(handleBackEvent:) closeAction:@selector(handleCloseAction:)];
    }
    return _navigationView;
}

- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        [_progressView setTrackTintColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
        _progressView.tintColor = MJWebe_UICOLOR_HEX(0x4ec7ef);
    }
    return _progressView;
}


@end
