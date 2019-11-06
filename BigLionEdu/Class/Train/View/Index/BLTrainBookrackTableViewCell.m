//
//  BLTrainBookrackTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/3.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTrainBookrackTableViewCell.h"
#import <YYWebImage.h>

@interface BLTrainBookrackTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;

@property (weak, nonatomic) IBOutlet UIView *subView0;
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView0;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle0;
@property (weak, nonatomic) IBOutlet UILabel *bookPriceLabel;

@property (weak, nonatomic) IBOutlet UIView *subView1;
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView1;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle1;
@property (weak, nonatomic) IBOutlet UILabel *bookPriceLabel1;


@property (weak, nonatomic) IBOutlet UIView *subView2;
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView2;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle2;
@property (weak, nonatomic) IBOutlet UILabel *bookPriceLabe2;


@end

@implementation BLTrainBookrackTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _stackView.alignment = UIStackViewAlignmentLeading;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerTapEvent0)];
    [self.subView0 addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerTapEvent1)];
    [self.subView1 addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlerTapEvent2)];
    [self.subView2 addGestureRecognizer:tap2];
}

- (void)handlerTapEvent0 {
    if (self.model.kylinCoreDoodsList.count > 0) {
        BLTrainCoreDoodsListModel *book = [self.model.kylinCoreDoodsList firstObject];
        if (self.delegate && [self.delegate respondsToSelector:@selector(handlerBookrackDetail:)]) {
            [self.delegate handlerBookrackDetail:book];
        }
    }
}

- (void)handlerTapEvent1 {
    if (self.model.kylinCoreDoodsList.count > 1) {
        BLTrainCoreDoodsListModel *book = [self.model.kylinCoreDoodsList objectAtIndex:1];
        if (self.delegate && [self.delegate respondsToSelector:@selector(handlerBookrackDetail:)]) {
            [self.delegate handlerBookrackDetail:book];
        }
    }
}

- (void)handlerTapEvent2 {
    if (self.model.kylinCoreDoodsList.count > 2) {
        BLTrainCoreDoodsListModel *book = [self.model.kylinCoreDoodsList objectAtIndex:2];
        if (self.delegate && [self.delegate respondsToSelector:@selector(handlerBookrackDetail:)]) {
            [self.delegate handlerBookrackDetail:book];
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)inBookrackEvent:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(handlerJumpShelfDetails)]) {
        [self.delegate handlerJumpShelfDetails];
    }
}

- (void)setModel:(BLRecommendBookModel *)model {
    _model = model;
     _titleLabel.text = model.title;
      if (model.kylinCoreDoodsList.count > 0) {
          BLTrainCoreDoodsListModel *book = [model.kylinCoreDoodsList firstObject];
          [_bookImageView0 yy_setImageWithURL:[NSURL URLWithString:book.coverImg] placeholder:[UIImage imageNamed:@"b_placeholder"]];
          _bookTitle0.text = book.title;
          _bookPriceLabel.text = [NSString stringWithFormat:@"￥%0.2f", [book.price doubleValue]];
          _bookImageView0.hidden = NO;
          _bookTitle0.hidden = NO;
          _bookPriceLabel.hidden = NO;
      }else {
          _bookImageView0.hidden = YES;
          _bookTitle0.hidden = YES;
          _bookPriceLabel.hidden = YES;
      }
      
      if (model.kylinCoreDoodsList.count > 1) {
          BLTrainCoreDoodsListModel *book = [model.kylinCoreDoodsList objectAtIndex:1];
          [_bookImageView1 yy_setImageWithURL:[NSURL URLWithString:book.coverImg] placeholder:[UIImage imageNamed:@"b_placeholder"]];
          _bookTitle1.text = book.title;
          _bookPriceLabel1.text = [NSString stringWithFormat:@"￥%0.2f", [book.price doubleValue]];
          _bookImageView1.hidden = NO;
          _bookTitle1.hidden = NO;
          _bookPriceLabel1.hidden = NO;
      }else {
          _bookImageView1.hidden = YES;
          _bookTitle1.hidden = YES;
          _bookPriceLabel1.hidden = YES;
      }
      
      if (model.kylinCoreDoodsList.count > 2) {
          BLTrainCoreDoodsListModel *book = [model.kylinCoreDoodsList objectAtIndex:2];
          [_bookImageView2 yy_setImageWithURL:[NSURL URLWithString:book.coverImg] placeholder:[UIImage imageNamed:@"b_placeholder"]];
          _bookTitle2.text = book.title;
          _bookPriceLabe2.text = [NSString stringWithFormat:@"￥%0.2f", [book.price doubleValue]];
          _bookImageView2.hidden = NO;
          _bookTitle2.hidden = NO;
          _bookPriceLabe2.hidden = NO;
      }else {
          _bookImageView2.hidden = YES;
          _bookTitle2.hidden = YES;
          _bookPriceLabe2.hidden = YES;
      }
}


@end
