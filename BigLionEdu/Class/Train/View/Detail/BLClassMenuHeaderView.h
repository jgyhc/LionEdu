//
//  BLClassMenuHeaderView.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/10/5.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol BLClassMenuHeaderViewDelegate <NSObject>

- (void)updateButtonClick:(NSInteger)index;

@end
@interface BLClassMenuHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<BLClassMenuHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
