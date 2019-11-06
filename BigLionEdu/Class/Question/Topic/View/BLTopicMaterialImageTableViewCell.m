//
//  BLTopicMaterialImageTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/10/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTopicMaterialImageTableViewCell.h"
#import <YYWebImage.h>

@interface BLTopicMaterialImageTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;


@end

@implementation BLTopicMaterialImageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(BLTopicImageModel *)model {
    _model = model;
    NSString *url = model.url;
    if (_model.image) {
        self.contentImageView.image = model.image;
    }else {
        __weak typeof(self) wself = self;
        [_contentImageView yy_setImageWithURL:[NSURL URLWithString:url] placeholder:nil options:YYWebImageOptionShowNetworkActivity completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (image) {
                    wself.model.image = wself.contentImageView.image;
                    CGFloat width = [UIScreen mainScreen].bounds.size.width - 20;
                    CGFloat height  = wself.contentImageView.image.size.height / wself.contentImageView.image.size.width * width;
                    wself.model.cellHeight = height;
                    if (wself.delegate && [wself.delegate respondsToSelector:@selector(updateCellHeightWithCell:model:cellHeight:)]) {
                        [wself.delegate updateCellHeightWithCell:wself model:wself.model cellHeight:height];
                    }
                }
            });
            
        }];
    }
}

@end
