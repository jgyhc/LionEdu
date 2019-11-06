//
//  Target_web.h
//  ZhenLearnDriving_Coach
//
//  Created by 刘聪 on 2019/4/14.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_web : NSObject


- (id)Action_webViewController:(NSDictionary *)params;

- (id)Action_posterShare:(NSDictionary *)params;

- (id)Action_posterSave:(NSDictionary *)params;
@end

NS_ASSUME_NONNULL_END
