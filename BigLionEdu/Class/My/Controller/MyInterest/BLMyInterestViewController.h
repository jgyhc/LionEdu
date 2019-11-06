//
//  BLMyInterestViewController.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/24.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLMyInterestViewController : UIViewController

@property (nonatomic, assign) BOOL needPop;

@property (nonatomic, copy) dispatch_block_t saveBlock;

@end

NS_ASSUME_NONNULL_END
