//
//  BLClassWebTableViewCell.m
//  Duoqio
//
//  Created by 刘聪 on 2019/7/9.
//  Copyright © 2019 manjiwang. All rights reserved.
//

#import "BLClassWebTableViewCell.h"
#import <WebKit/WebKit.h>
#import <Masonry.h>
#import "NTCatergory.h"

@interface BLClassWebTableViewCell ()<UIWebViewDelegate, UIScrollViewDelegate, WKNavigationDelegate, WKUIDelegate>

//@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) BOOL isLoaded;

@property (nonatomic, strong) WKWebViewConfiguration * config;

@property (nonatomic, assign) CGFloat height;

@end

@implementation BLClassWebTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    _webView.scrollView.scrollEnabled = NO;
//    //这个属性不加,webview会显示很大.
//    _webView.opaque = NO;
//    _webView.scalesPageToFit = YES;
//    _webView.delegate = self;
//    _webView.scrollView.delegate = self;
    [self.contentView addSubview:self.webView];
//    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
//    }];
//    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:(NSKeyValueObservingOptionNew) context:nil];
}

- (void)removeWebViewObserver {
    [self.webView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation  {
    self.height = self.webView.frame.size.height;
    //获取内容实际高度（像素）@"document.getElementById(\"content\").offsetHeight;"
    [self.webView evaluateJavaScript:@"document.body.scrollHeight" completionHandler:^(id _Nullable result,NSError * _Nullable error) {
        // 此处js字符串采用scrollHeight而不是offsetHeight是因为后者并获取不到高度，看参考资料说是对于加载html字符串的情况下使用后者可以，但如果是和我一样直接加载原站内容使用前者更合适
        CGRect frame = webView.frame;
        frame.size.height = webView.scrollView.contentSize.height;
        webView.frame = frame;
        self.webView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, webView.frame.size.height);
        //获取页面高度，并重置webview的frame
//        webViewHeight = [result doubleValue];
        NSLog(@"%f",webView.frame.size.height);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateCellHeight:indexPath:)]) {
                [self.delegate updateCellHeight:webView.frame.size.height + 50 indexPath:self.indexPath];
            }
        });
    }];
}

#pragma mark-监听的处理1、监听tableview偏移（控制导航的透明度）2、监听webView.scrollView的contentSize的变化
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {

    if ([keyPath isEqualToString:@"contentSize"]) {
//        CGSize contentSize = [self.webView sizeThatFits:CGSizeZero];
//        self.webView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
         CGSize webFrame = self.webView.scrollView.contentSize;
        NSLog(@"______");
        if (!self.isLoaded) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateCellHeight:indexPath:)]) {
                [self.delegate updateCellHeight:webFrame.height indexPath:_indexPath];
            }
        }
    }
    
    
}

- (void)setModel:(NSString *)model {
    if (!_model) {
        _model = model;
        NSString *width = [NSString stringWithFormat:@"<img style=\"max-width:%fpx; height:auto;\"", NT_SCREEN_WIDTH - 20];
        _model = [model stringByReplacingOccurrencesOfString:@"<img" withString:width];
        NSString *htmlStr = [NSString stringWithFormat:@"<html lang=\"zh-CN\"><head><meta charset=\"utf-8\"><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"><meta name=\"viewport\" content=\"width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0\"><link rel=\"stylesheet\" type=\"text/css\" href=\"iPhone.css\"><style type=\"text/css\">body{display:flex;color:#333333;}</style></head><body><div id=\"content\">%@</div></body></html>", _model];
        NSURL *font = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"iPhone" ofType:@"css"]];
        [self.webView loadHTMLString:htmlStr baseURL:font];
    }
    
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}

- (WKWebViewConfiguration *)config {
    if(_config == nil) {
        _config = [[WKWebViewConfiguration alloc] init];
        _config.userContentController = [[WKUserContentController alloc] init];
        // 创建WKWebView
        WKPreferences *preferences = [WKPreferences new];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;//很重要，如果没有设置这个则不会回调createWebViewWithConfiguration方法，也不会回应window.open()方法
        preferences.minimumFontSize = 0.0;

    }
    return _config;
}

- (WKWebView *)webView {
    if (!_webView) {
        // js代码
//        NSString *js = @"   var count = document.images.length;for (var i = 0; i < count; i++) {var image = document.images[i];image.style.width=320;};window.alert('找到' + count + '张图');";
//        // 根据JS字符串初始化WKUserScript对象
//        WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//        // 根据生成的WKUserScript对象，初始化WKWebViewConfiguration
//        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
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
        _webView.scrollView.scrollEnabled = NO;
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        UIScrollView *tempView=(UIScrollView *)[_webView.subviews objectAtIndex:0];
        tempView.scrollEnabled=NO;
    }
    return _webView;
}
@end
