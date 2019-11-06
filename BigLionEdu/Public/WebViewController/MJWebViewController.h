//
//  MJWebViewController.h
//  MJWebViewKit_Example
//
//  Created by -- on 2019/2/17.
//  Copyright © 2019 jgyhc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "MJWebViewController.h"
#import "MJWebNavigationView.h"

NS_ASSUME_NONNULL_BEGIN

@class MJWebViewController;
@protocol MJWebViewControllerDelegate <NSObject>

- (NSDictionary *)injectionCookieWithWebViewController:(MJWebViewController *)webViewController;

@end

@interface MJWebViewController : UIViewController

@property (nonatomic, strong) WKWebView * webView;

@property (nonatomic, strong) NSURL * url;

@property (nonatomic, copy) NSString * htmlName;

@property (nonatomic, copy) NSString * htmlString;

@property (nonatomic, copy) NSString * titleString;

@property (nonatomic, strong) NSDictionary *shareInfo;

@property (nonatomic, copy) NSDictionary * (^injectionCookieBlock)(MJWebViewController *webViewController);

@property (nonatomic, weak) id <MJWebViewControllerDelegate> delegate;

/** 0正常导航栏  1隐藏导航栏 （默认有状态栏）2 没有导航栏*/
@property (nonatomic, assign) NSInteger navigationType;

- (void)goBack;
@end

NS_ASSUME_NONNULL_END
