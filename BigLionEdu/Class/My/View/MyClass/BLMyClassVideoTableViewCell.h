//
//  BLMyClassVideoTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/26.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMyClassListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BLMyClassVideoTableViewCell : UITableViewCell
@property (nonatomic ,strong) BLMyClassListModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UIView *nameBackView;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@end

NS_ASSUME_NONNULL_END
