//
//  NSString+BLXmlDecomposition.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/10/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "NSString+BLXmlDecomposition.h"


@implementation NSString (BLXmlDecomposition)

- (NSArray *)getImageurlFromHtml
{
    NSMutableArray * imageurlArray = @[].mutableCopy;
    
    //标签匹配iframe
    NSString *parten = @"(<div>[^<]*[^d]*[^p]*[^i]*[^v]*[^>]*</div>)|(<img(.*?)>)|(<iframe(.*?)>)|(<source(.*?)>)|(<p>(.*?)</p>)";
    NSError* error = NULL;
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:parten options:0 error:&error];
    
    NSArray* match = [reg matchesInString:self options:0 range:NSMakeRange(0, [self length])];
    
    for (NSTextCheckingResult * result in match) {
        //过去数组中的标签
        NSRange range = [result range];
        NSString * subString = [self substringWithRange:range];
        
        if ([subString containsString:@"<iframe"] || [subString containsString:@"<source"]) {//视频和音频
            NSRegularExpression *subReg = [NSRegularExpression regularExpressionWithPattern:@"http://(.*?)\"" options:0 error:NULL];
            NSArray* match = [subReg matchesInString:subString options:0 range:NSMakeRange(0, [subString length] - 1)];
            if (match.count > 0) {
                NSTextCheckingResult * subRes = match[0];
                NSRange subRange = [subRes range];
                subRange.length = subRange.length - 1;
                NSString * imagekUrl = [subString substringWithRange:subRange];
                if ([imagekUrl containsString:@"mp3"]) {
                    [imageurlArray addObject:@{@"type":@2,
                                               @"content":imagekUrl?imagekUrl:@""
                                                }];
                }else {
                    [imageurlArray addObject:@{@"type":@3,
                                               @"content":imagekUrl?imagekUrl:@""
                                            }];
                }
            }
            
        }else if ([subString containsString:@"<img"]) {
            NSRegularExpression *subReg = [NSRegularExpression regularExpressionWithPattern:@"http://(.*?)\"" options:0 error:NULL];
            NSArray* match = [subReg matchesInString:subString options:0 range:NSMakeRange(0, [subString length] - 1)];
            if (match.count > 0) {
                NSTextCheckingResult * subRes = match[0];
                NSRange subRange = [subRes range];
                subRange.length = subRange.length - 1;
                NSString * imagekUrl = [subString substringWithRange:subRange];
                imagekUrl = [imagekUrl stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                [imageurlArray addObject:@{@"type":@1,
                                           @"content":imagekUrl?imagekUrl:@""
                                           }];
            }
        }else {
            NSRegularExpression *regularExpretion = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*>|\n" options:0  error:nil];
            NSString *string = [regularExpretion stringByReplacingMatchesInString:subString options:NSMatchingReportProgress range:NSMakeRange(0, subString.length) withTemplate:@""];
            
            string = [string stringByReplacingOccurrencesOfString:@"&rdquo;" withString:@"”"];
            string = [string stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"”"];
            string = [string stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"—"];
            string = [string stringByReplacingOccurrencesOfString:@"&lsaquo;" withString:@"？"];
            string = [string stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
            [imageurlArray addObject:@{@"type":@0,
                                       @"content":string?string:@""
                                       }];
        }
    }
    return imageurlArray;
}

- (NSString *)stringDealWithUrl:(NSString *)url {
    NSMutableString *responseString = [NSMutableString stringWithString:url];
    NSString *character = nil;
    for (int i = 0; i < responseString.length; i ++) {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"\\"])
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
    }
    return responseString;
}

@end
