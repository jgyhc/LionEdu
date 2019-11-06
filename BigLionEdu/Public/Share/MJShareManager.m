//
//  ShareManager.m
//  ManJi
//
//  Created by Zgmanhui on 16/8/6.
//  Copyright © 2016年 Zgmanhui. All rights reserved.
//

#import "MJShareManager.h"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
//微信SDK头文件
#import <WXApi.h>
#import <MessageUI/MessageUI.h>

#import <CTMediator/CTMediator.h>
#import <YYModel/YYModel.h>
#import "MJShareGlobalModel.h"
#import "MJWeChatSDK.h"
#import <MJProgressHUD/LCProgressHUD.h>
#import "MJTencentSDK.h"
//#import <MJWeiboSDK/MJWeiboSDK.h>
#import "MJWeChatSDK.h"

@interface MJShareManager ()<MFMessageComposeViewControllerDelegate, MJShareUIViewDelegate, MJShareUIViewDataSource>

@property (nonatomic, strong) NSMutableArray * items;

@property (nonatomic, strong) MJShareGlobalModel * model;

@property (nonatomic, strong) MJShareUIView *shareView;

@property (nonatomic, strong) UIActivityViewController *activityViewController;

@end


@implementation MJShareManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static MJShareManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[MJShareManager alloc] init];
    });
    return instance;
}

- (void)showShareViewWithParams:(NSDictionary *)params {
    [self shareWithParams:params];
    [self showShareView];
}

- (void)showShareView {
    [self.shareView show];
}

- (void)hideShareView {
    [self.shareView hide];
}

- (void)shareWithParams:(NSDictionary *)params {
    MJShareGlobalModel *model = [MJShareGlobalModel yy_modelWithJSON:params];
    _model = model;
    NSMutableArray *items = [NSMutableArray array];
    if (!model.generalOptions) {
        NSLog(@"请传入通用模型");
        return;
    }else {
        NSArray *generalItems = @[@(ShareUIViewTypeWechatSession), @(ShareUIViewTypeWechatTimeline), @(ShareUIViewTypeQQ), @(ShareUIViewTypeQQZone), @(ShareUIViewTypeWeiBo)];
        [generalItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger type = [obj integerValue];
            ShareUIModel *model = [ShareUIModel new];
            model.type = type;
            [items addObject:model];
//            if (type == ShareUIViewTypeQQ && ([QQApiInterface isQQInstalled] || [QQApiInterface isTIMInstalled] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])) {
//                [items addObject:model];
//            }
//
//            if (type == ShareUIViewTypeQQZone && ([QQApiInterface isQQInstalled] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqzone://"]] || [QQApiInterface isTIMInstalled] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])) {
//                [items addObject:model];
//            }
//
//            if ((type == ShareUIViewTypeWechatSession || type == ShareUIViewTypeWechatTimeline) && ([WXApi isWXAppInstalled] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"Whatapp://"]]) ) {
//                [items addObject:model];
//            }
        }];
    }
    _items = items;
    [self.shareView reloadData];
}

- (void)setShareParams:(NSDictionary *)params {
    MJShareGlobalModel *model = [MJShareGlobalModel yy_modelWithJSON:params];
    _model = model;
}

#pragma mark -- MJShareUIViewDataSource method
- (NSArray *)numberItemInShareUIView:(MJShareUIView *)view {
    return _items;
}

#pragma mark -- MJShareUIViewDelegate method
- (void)shareUIView:(MJShareUIView *)view didSelectItem:(ShareUIViewType)itemType {
    switch (itemType) {
        case ShareUIViewTypeQQ:
        case ShareUIViewTypeWechatSession:
        case ShareUIViewTypeQQZone:
        case ShareUIViewTypeWechatTimeline: {
            [self generalShareWithType:itemType];
        }
            break;
        default:
            break;
    }
    [self getShareEventRequestWithType:itemType];
}

#pragma mark -- 上传统计信息
- (void)getShareEventRequestWithType:(ShareUIViewType)type {
    NSInteger interfaceType = 0;
    switch (type) {
        case ShareUIViewTypeQQZone:
            interfaceType = 4;
            break;
        case ShareUIViewTypeQQ:
            interfaceType = 3;
            break;
        case ShareUIViewTypeWechatSession:
            interfaceType = 1;
            break;
        case ShareUIViewTypeWechatTimeline:
            interfaceType = 2;
            break;
        default:
            interfaceType = 9;
            break;
    }
    NSString *shareTypeString = [NSString stringWithFormat:@"3%ld", interfaceType];
    if (!self.model.shareEventCallbackUrl && self.model.shareEventCallbackUrl.length == 0) {
        return;
    }
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?sid=%@&shareType=%@", self.model.shareEventCallbackUrl, self.model.sid, shareTypeString]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        }];
        [dataTask resume];
    });
}


#pragma mark -- 通用的分享
- (void)generalShareWithType:(ShareUIViewType)type {
    NSString *text = _model.generalOptions.describe;
    NSString *image = _model.generalOptions.img;
    NSArray *images = _model.generalOptions.images;
    
    NSString *title = _model.generalOptions.title;
    
    NSURL *URL = [NSURL URLWithString:_model.generalOptions.linkurl?_model.generalOptions.linkurl:@"www.baidu.com"];
    UIImage *imageObj;
    if (images.count > 0) {
        imageObj = [images firstObject];
    }
    if (type == ShareUIViewTypeQQZone) {
        [MJTencentSDK shareToQZoneWithUrl:URL title:title content:text image:image?image:imageObj];
        return;
    }else if (type == ShareUIViewTypeQQ) {
        [MJTencentSDK shareToQQWithUrl:URL title:title content:text image:image?image:imageObj];
        return;
    }else if (type == ShareUIViewTypeWechatSession) {
        id imageData = image ? image : imageObj;
        if (!text) {
            [[MJWeChatSDK shareInstance] shareWithParams:@{@"image":imageData?imageData:@""} shareType:MJWeChatSDKImageType way:MJWeChatSDKShareWeixinFriendWay];
        }else {
             NSString *url = _model.generalOptions.linkurl?_model.generalOptions.linkurl:@"www.--.com";
            [[MJWeChatSDK shareInstance] shareWithParams:@{@"title":title?title:@"", @"content":text?text:@"", @"image":imageData?imageData:@"", @"url": url?url:@""} shareType:MJWeChatSDKWebpageType way:MJWeChatSDKShareWeixinFriendWay];
        }
    }else if (type == ShareUIViewTypeWechatTimeline) {
        id imageData = image ? image : imageObj;
        
        if (!text) {
            [[MJWeChatSDK shareInstance] shareWithParams:@{@"image":imageData?imageData:@""} shareType:MJWeChatSDKImageType way:MJWeChatSDKShareTimelineWay];
        }else {
            NSString *url = _model.generalOptions.linkurl?_model.generalOptions.linkurl:@"www.--.com";
            [[MJWeChatSDK shareInstance] shareWithParams:@{@"title":title?title:@"", @"content":text?text:@"", @"image":imageData?imageData:@"", @"url": url?url:@""} shareType:MJWeChatSDKWebpageType way:MJWeChatSDKShareTimelineWay];
        }
    }
}

#pragma mark -- getter

- (MJShareUIView *)shareView {
    if (!_shareView) {
        _shareView = [[MJShareUIView alloc] init];
        _shareView.dataSource = self;
        _shareView.delegate = self;
    }
    return _shareView;
}


@end
