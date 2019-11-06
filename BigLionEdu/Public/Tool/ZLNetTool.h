//
//  ZLNetTool.h
//  ZhenLearnDriving_Coach
//
//  Created by 欧阳荣 on 2019/4/16.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^NTFailureConfig)(NSError * _Nullable error);
typedef void(^ZLSuccessConfig)(id _Nullable obj);


NS_ASSUME_NONNULL_BEGIN

@interface ZLNetTool : NSObject



+ (void)zl_upLoadWithImage:(UIImage *)image success:(ZLSuccessConfig _Nullable)success failure:(NTFailureConfig _Nullable)failure;

+ (void)zl_upLoadWithImages:(NSArray <UIImage *> *)images success:(ZLSuccessConfig _Nullable)success failure:(NTFailureConfig _Nullable)failure;

+ (void)zl_upLoadWithData:(NSData *)data suffx:(NSString *)suffx success:(ZLSuccessConfig _Nullable)success failure:(NTFailureConfig _Nullable)failure;


@end

NS_ASSUME_NONNULL_END
