//
//  BLPaperViewController.h
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/4.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BLPaperViewController : UIViewController

@property (nonatomic, assign) NSInteger modelId;

@property (nonatomic, assign) NSInteger setId;

@property (nonatomic, strong) NSDictionary *paperParams;

@end

NS_ASSUME_NONNULL_END
