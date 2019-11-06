//
//  Target_MJWeChatSDK.h
//  MJWechatSDK
//
//  Created by -- on 2019/3/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_MJWeChatSDK : NSObject

- (id)Action_WeChatInit:(NSDictionary *)params;

- (id)Action_WeChatLogin:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
