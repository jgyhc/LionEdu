//
//  Target_MJTencentSDK.h
//  MJTencentSDK
//
//  Created by -- on 2019/3/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_MJTencentSDK : NSObject

- (id)Action_QQInit:(NSDictionary *)params;

- (id)Action_QQLogin:(NSDictionary *)params;

- (id)Action_iphoneQQInstalled:(NSDictionary *)params;

- (id)Action_iphoneTIMInstalled:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
