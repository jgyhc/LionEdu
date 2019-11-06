//
//  ZLNetTool.m
//  ZhenLearnDriving_Coach
//
//  Created by 欧阳荣 on 2019/4/16.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "ZLNetTool.h"
#import <AFNetworking.h>
#import "NTCatergory.h"
#import "ZLUserInstance.h"
#import <CommonCrypto/CommonCrypto.h>

static NSString *updateUrl = @"http://39.98.129.96/kylin/sys/app/appModuleType/appUpload";
static NSString *muUpdateUrl = @"http://39.98.129.96/kylin/sys/app/appModuleType/appBatchUpload";

@implementation ZLNetTool

+ (void)zl_upLoadWithImage:(UIImage *)image success:(ZLSuccessConfig)success failure:(NTFailureConfig)failure {
    
    NSError* error = NULL;
    
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [self returnLetterAndNumber]];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:updateUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.8) name:@"file" fileName:fileName mimeType:@"multipart/form-data"];
        
    } error:&error];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html",@"text/javascript", nil];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ZLUserInstance sharedInstance].token forHTTPHeaderField:@"user"];
    
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            NT_BLOCK(failure, error);
        }else {
            NT_BLOCK(success, responseObject);
        }
    }];
    [uploadTask resume];
}

+ (void)zl_upLoadWithImages:(NSArray<UIImage *> *)images success:(ZLSuccessConfig)success failure:(NTFailureConfig)failure {
    
    NSError* error = NULL;

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:muUpdateUrl parameters:nil  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (NSInteger i = 0; i < images.count; i++) {
            
            NSString *fileName = [NSString stringWithFormat:@"%@%zd.jpg", [self returnLetterAndNumber], i+1];
            
            NSData* imageData = UIImageJPEGRepresentation(images[i], 0.9);
            
//            NSString *name = [NSString stringWithFormat:@"file%zd", i];
            [formData appendPartWithFileData:imageData name:@"files" fileName:fileName mimeType:@"multipart/form-data"];
        }
        
    } error:&error];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html",@"text/javascript", nil];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ZLUserInstance sharedInstance].token forHTTPHeaderField:@"user"];
    
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            NT_BLOCK(failure, error);
        }else {
            NT_BLOCK(success, responseObject);
        }
    }];
    
    [uploadTask resume];
}

+ (void)zl_upLoadWithData:(NSData *)data suffx:(NSString *)suffx success:(ZLSuccessConfig)success failure:(NTFailureConfig)failure {
    
    NSError* error = NULL;
    
    NSString *fileName = [NSString stringWithFormat:@"%@.%@", [self returnLetterAndNumber], suffx];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:updateUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"multipart/form-data"];
        
    } error:&error];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",@"text/html",@"text/javascript", nil];
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ZLUserInstance sharedInstance].token forHTTPHeaderField:@"user"];
    
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            NT_BLOCK(failure, error);
        }else {
            NT_BLOCK(success, responseObject);
        }
    }];
    [uploadTask resume];

}

+ (void)st_uploadToUrl:(NSString *)url
                params:(NSDictionary *)params
                images:(NSArray *)images
            isOriginal:(BOOL)isOriginal
              progress:(void (^)(NSProgress *))progress
               success:(ZLSuccessConfig)successConfig
               failure:(NTFailureConfig)failureConfig {


    //name
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateStr = [formatter stringFromDate:date];

    NSError* error = NULL;

    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:params  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        for (NSInteger i = 0; i < images.count; i++) {

            NSString *fileName = [NSString stringWithFormat:@"%@%zd.jpg", dateStr,i + 1];

            NSData* imageData = isOriginal ? UIImagePNGRepresentation(images[i]) : UIImageJPEGRepresentation(images[i], 1);

            NSString *name = [NSString stringWithFormat:@"file%zd", i];
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"multipart/form-data"];
        }

    } error:&error];


    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:[ZLUserInstance sharedInstance].token forHTTPHeaderField:@"token"];


    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:progress completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        if (error) {
            NT_BLOCK(failureConfig, error);
        }else {
            NT_BLOCK(successConfig, responseObject);
        }
    }];

    [uploadTask resume];

}

+ (NSString *)returnLetterAndNumber {
    //定义一个包含数字，大小写字母的字符串
    NSString * strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    //定义一个结果
    NSString * result = [[NSMutableString alloc]initWithCapacity:16];
    for (int i = 0; i < 8; i++) {
        //获取随机数
        NSInteger index = arc4random() % (strAll.length-1);
        char tempStr = [strAll characterAtIndex:index];
        result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
    }
    return [NSString stringWithFormat:@"%@%@", [self getCurrentTimes], result];
}

+ (NSString*)getCurrentTimes {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
}


@end
