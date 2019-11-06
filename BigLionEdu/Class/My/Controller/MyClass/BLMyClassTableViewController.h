//
//  BLMyClassTableViewController.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView.h>
#import <JXCategoryListContainerView.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum  {
    live  = 0,
    video,
    interview
} ClassType;
@interface BLMyClassTableViewController : UITableViewController<JXCategoryListContentViewDelegate>

@property(nonatomic ,assign)ClassType classType;
@end

NS_ASSUME_NONNULL_END
