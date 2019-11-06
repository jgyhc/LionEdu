//
//  BLMyInterestHeaderTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/24.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyInterestHeaderTableViewCell.h"
#import "AdaptScreenHelp.h"

@interface BLMyInterestHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;
@end

@implementation BLMyInterestHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(NSArray *)model {
    _model = model;
    [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [model enumerateObjectsUsingBlock:^( UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.containerView addSubview:obj];
    }];
}


@end
