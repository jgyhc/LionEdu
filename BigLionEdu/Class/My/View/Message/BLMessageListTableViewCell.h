//
//  BLMessageListTableViewCell.h
//  BigLionEdu
//
//  Created by sunmaomao on 2019/9/9.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMyNewsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface BLMessageListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (nonatomic ,strong)BLMyNewsModel *model;
@end

NS_ASSUME_NONNULL_END
