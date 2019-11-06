//
//  NTCircleClockCell.h
//  NTStartget
//
//  Created by jiang on 2018/9/29.
//  Copyright © 2018年 NineTonTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTCircleClockModel.h"

@interface NTCircleClockCell : UICollectionViewCell

@property (nonatomic, copy) void(^deleteConfig)(NSIndexPath *aIndexPath);

@property (nonatomic, assign) BOOL shouldDelete;

@property (nonatomic, strong) NTCircleClockModel *model;

@property (nonatomic, strong) NSIndexPath *indexPath;


@end
