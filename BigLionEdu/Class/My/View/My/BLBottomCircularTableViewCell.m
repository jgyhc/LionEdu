//
//  BLBottomCircularTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/7/22.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLBottomCircularTableViewCell.h"

@interface BLBottomCircularTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@end

@implementation BLBottomCircularTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [self setupRoundedCornersWithView:self.containerView cutCorners: UIRectCornerBottomLeft | UIRectCornerBottomRight borderColor:[UIColor whiteColor] borderWidth:10 viewColor:[UIColor whiteColor]];
    [self.contentView layoutIfNeeded];
//    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:self.containerView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
//    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
//    [shape setPath:rounded.CGPath];
//
//    self.containerView.layer.mask = shape;
    
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds), 10) byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
    //创建 layer
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.containerView.bounds), 10);
    //赋值
    maskLayer.path = maskPath.CGPath;
    self.containerView.layer.mask = maskLayer;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(id)model {
    _model = model;
	
}


/**
 按钮的圆角设置
 
 @param view view类控件
 @param rectCorner UIRectCorner要切除的圆角
 @param borderColor 边框颜色
 @param borderWidth 边框宽度
 @param viewColor view类控件颜色
 */
- (void)setupRoundedCornersWithView:(UIView *)view cutCorners:(UIRectCorner)rectCorner borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth viewColor:(UIColor *)viewColor{
    
    CAShapeLayer *mask=[CAShapeLayer layer];
    UIBezierPath * path= [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(15,10)];
    mask.path=path.CGPath;
    mask.frame=view.bounds;
    
    
    CAShapeLayer *borderLayer=[CAShapeLayer layer];
    borderLayer.path=path.CGPath;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = borderColor.CGColor;
    borderLayer.lineWidth = borderWidth;
    borderLayer.frame = view.bounds;
    view.layer.mask = mask;
    [view.layer addSublayer:borderLayer];
}

- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect {
    
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    self.containerView.layer.mask = shape;
}
@end
