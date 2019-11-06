//
//  BLOffLineVideoHeaderView.h
//  BigLionEdu
//
//  Created by Hwang on 2019/10/15.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BLOffLineVideoHeaderViewDelegate <NSObject>

- (void)BLOffLineVideoHeaderViewDidChangeIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_BEGIN

@interface BLOffLineVideoHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id <BLOffLineVideoHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
