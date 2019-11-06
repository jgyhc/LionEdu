//
//  UIImageView+BLOSSImageResize.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/22.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "UIImageView+BLOSSImageResize.h"
#import <objc/runtime.h>
#import <SDWebImage.h>
#import <YYWebImage.h>
#import <UIImageView+WebCache.h>

@implementation UIImageView (BLOSSImageResize)


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        //拿到系统方法
        SEL orignalSel3 = @selector(sd_setImageWithURL:placeholderImage:options:context:progress:completed:);
        Method orignalM3 = class_getInstanceMethod(class, orignalSel3);
        SEL swizzledSel3 = @selector(bl_sd_setImageWithURL:placeholderImage:options:context:progress:completed:);
        Method swizzledM3 = class_getInstanceMethod(class, swizzledSel3);
        BOOL didAddMethod3 = class_addMethod(class, orignalSel3, method_getImplementation(swizzledM3), method_getTypeEncoding(swizzledM3));
        if (didAddMethod3) {
            class_replaceMethod(class, swizzledSel3, method_getImplementation(orignalM3), method_getTypeEncoding(orignalM3));
        }else{
            method_exchangeImplementations(orignalM3, swizzledM3);
        }
        
        
        
        SEL orignalSel1 = @selector(yy_setImageWithURL:placeholder:options:manager:progress:transform:completion:);
        Method orignalM1 = class_getInstanceMethod(class, orignalSel1);
        SEL swizzledSel1 = @selector(bl_yy_setImageWithURL:placeholder:options:manager:progress:transform:completion:);
        Method swizzledM1 = class_getInstanceMethod(class, swizzledSel1);
        BOOL didAddMethod1 = class_addMethod(class, orignalSel1, method_getImplementation(swizzledM1), method_getTypeEncoding(swizzledM1));
        if (didAddMethod1) {
            class_replaceMethod(class, swizzledSel1, method_getImplementation(orignalM1), method_getTypeEncoding(orignalM1));
        }else{
            method_exchangeImplementations(orignalM1, swizzledM1);
        }
        
    });
}

- (void)bl_sd_setImageWithURL:(nullable NSURL *)url placeholderImage:(nullable UIImage *)placeholder options:(SDWebImageOptions)options context:(nullable SDWebImageContext *)context progress:(nullable SDImageLoaderProgressBlock)progressBlock completed:(nullable SDExternalCompletionBlock)completedBlock {
    NSString *urlString = url.absoluteString;
    NSInteger h = 200;
    NSInteger w = 200;
    if (!CGSizeEqualToSize(self.bounds.size, CGSizeZero)) {
        h = ceil(self.bounds.size.height);
        w = ceil(self.bounds.size.width);
    }
    urlString = [self resizeImageWithImgUrl:urlString h:h*2 w:w*2 m:@"fill" limit:1 color:nil];
    
    NSURL *imgUrl = [NSURL URLWithString:urlString];
    [self bl_sd_setImageWithURL:imgUrl placeholderImage:placeholder options:options context:context progress:progressBlock completed:completedBlock];
}

- (void)bl_yy_setImageWithURL:(NSURL *)imageURL placeholder:(UIImage *)placeholder options:(YYWebImageOptions)options manager:(YYWebImageManager *)manager progress:(YYWebImageProgressBlock)progress transform:(YYWebImageTransformBlock)transform completion:(YYWebImageCompletionBlock)completion {
    NSString *urlString = imageURL.absoluteString;
    NSInteger h = 200;
    NSInteger w = 200;
    if (!CGSizeEqualToSize(self.bounds.size, CGSizeZero)) {
        h = ceil(self.bounds.size.height);
        w = ceil(self.bounds.size.width);
    }
    urlString = [self resizeImageWithImgUrl:urlString h:h*2 w:w*2 m:@"fill" limit:1 color:nil];
    
    NSURL *imgUrl = [NSURL URLWithString:urlString];
    [self bl_yy_setImageWithURL:imgUrl placeholder:placeholder options:options manager:manager progress:progress transform:transform completion:completion];
}

- (NSString *)resizeImageWithImgUrl:(NSString *)imgUrl h:(NSInteger)h w:(NSInteger)w m:(NSString *)m limit:(NSInteger)limit color:(NSString *)color {
    if (!imgUrl || imgUrl.length == 0) {
        return imgUrl;
    }
    NSString *typeString = [NSString stringWithFormat:@"%@%@", imgUrl, @"?x-oss-process=image/resize"];
    
    NSMutableArray *strings = [NSMutableArray array];
    [strings addObject:typeString];
    
//    if (m.length > 0) {
//        [strings addObject:[NSString stringWithFormat:@"m_%@", m]];
//    }
//    if (h > 0 && h <= 4096) {
//        [strings addObject:[NSString stringWithFormat:@"h_%@", [@(h) stringValue]]];
//    }
    if (w > 0 && w <= 4096) {
        [strings addObject:[NSString stringWithFormat:@"w_%@", [@(w) stringValue]]];
    }
    if (color.length > 0) {
        [strings addObject:[NSString stringWithFormat:@"color_%@", [@(w) stringValue]]];
    }
    NSString *resizeUrl = [strings componentsJoinedByString:@","];
    return resizeUrl;
}

@end
