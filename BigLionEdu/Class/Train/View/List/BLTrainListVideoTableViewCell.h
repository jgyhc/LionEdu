//
//  BLTrainListVideoTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/14.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLCurriculumModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol BLTrainListVideoTableViewCellDelegate <NSObject>

- (void)downLoadFile:(BLCurriculumModel *)model;

@end


@interface BLTrainListVideoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *tagImg;
@property (weak, nonatomic) IBOutlet UILabel *tagText;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *rightTag;
@property (weak, nonatomic) IBOutlet UIImageView *freeIcon;
@property (weak, nonatomic) IBOutlet UILabel *freeLab;
@property (weak, nonatomic) IBOutlet UIButton *downBtn;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIButton *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *saleNum;
@property (weak, nonatomic) IBOutlet UIView *shadow1;
@property (weak, nonatomic) IBOutlet UIView *shadow2;
@property (nonatomic, strong) BLCurriculumModel *model;

@end

NS_ASSUME_NONNULL_END
