//
//  BLSearchHistoryModel.h
//  BigLionEdu
//
//  Created by Hwang on 2019/9/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLSearchHistoryModel : NSObject

/*
 "data": [
 {
 "id": 0,
 "memberId": 0,
 "title": "string"
 }
 ],
 */
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSString *memberId;
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
