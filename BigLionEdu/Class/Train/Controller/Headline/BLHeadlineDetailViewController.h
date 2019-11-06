//
//  BLHeadlineDetailViewController.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/3.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "MJWebViewController.h"
#import "MJWebNavigationView.h"

NS_ASSUME_NONNULL_BEGIN

@class BLHeadlineDetailViewController;
@protocol BLHeadlineDetailViewControllerDelegate <NSObject>

- (NSDictionary *)injectionCookieWithWebViewController:(BLHeadlineDetailViewController *)webViewController;

@end

@interface BLHeadlineDetailViewController : UIViewController

@property (nonatomic, assign) NSInteger newId;


@property (nonatomic, strong) WKWebView * webView;

@property (nonatomic, strong) NSURL * url;

@property (nonatomic, copy) NSString * htmlName;

@property (nonatomic, copy) NSString * htmlString;

@property (nonatomic, copy) NSString * titleString;

@property (nonatomic, strong) NSDictionary *shareInfo;

@property (nonatomic, copy) NSDictionary * (^injectionCookieBlock)(BLHeadlineDetailViewController *webViewController);

@property (nonatomic, weak) id <BLHeadlineDetailViewControllerDelegate> delegate;

/** 0正常导航栏  1隐藏导航栏 （默认有状态栏）2 没有导航栏*/
@property (nonatomic, assign) NSInteger navigationType;

- (void)goBack;
@end

NS_ASSUME_NONNULL_END
