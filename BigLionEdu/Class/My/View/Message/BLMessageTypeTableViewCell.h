//
//  BLMessageTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/18.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLMyNewsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLMessageTypeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *inconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *bg;

@property (weak, nonatomic) IBOutlet UILabel *titLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (nonatomic, strong) UILabel *numberLab;
@property (nonatomic ,strong)BLMyNewsTypeModel *model;
@end

NS_ASSUME_NONNULL_END
