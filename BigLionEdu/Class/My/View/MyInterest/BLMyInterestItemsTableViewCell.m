//
//  BLMyInterestItemsTableViewCell.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/7/24.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLMyInterestItemsTableViewCell.h"
#import "BLInterestItemView.h"
#import <Masonry.h>

@interface BLMyInterestItemsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *itemView;

@property (nonatomic, strong) NSMutableArray *views;

//@property (nonatomic, strong) NSMutableArray *tagViews;

//@property (nonatomic ,strong) NSMutableArray <BLInterestInfoModel *>*selectModels;
@end

@implementation BLMyInterestItemsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.itemView.layer.shadowColor = [UIColor blackColor].CGColor;
    // 设置阴影偏移量
    self.itemView.layer.shadowOffset = CGSizeMake(0, 2);
    // 设置阴影透明度
    self.itemView.layer.shadowOpacity = 0.1;
    // 设置阴影半径
    self.itemView.layer.shadowRadius = 2;
    
    self.itemView.layer.cornerRadius = 5;
}

-(void)setModel:(BLMyInterestItemModel *)model{
    self.views = [NSMutableArray new];
    [model.baseModels enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(15, 23.5+(57.5*idx), self.itemView.frame.size.width-30, 34)];
                
//        backView.backgroundColor = [UIColor redColor];
        BLInterestItemView *newItemView = (BLInterestItemView *)[[[NSBundle mainBundle] loadNibNamed:@"BLInterestItemView" owner:self options:nil] firstObject];
//        newItemView.frame = CGRectMake(0, 0, backView.frame.size.width, backView.frame.size.height);
        [backView addSubview:newItemView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapEvent:)];
        [newItemView addGestureRecognizer:tap];
        newItemView.model = ({
            BLInterestInfoModel *baseModel = (BLInterestInfoModel *)obj;
            baseModel;
        });
        [self.views addObject:newItemView];
        [self.itemView addSubview:backView];
        
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(15);
            make.right.mas_offset(-15);
            make.top.mas_offset(23.5+(57.5*idx));
            make.height.mas_offset(34);
        }];
        
        [newItemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_offset(0);
        }];
        
    }];
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//
//    [self.views enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        obj.frame = CGRectMake(15, 23.5+(57.5*idx), self.itemView.frame.size.width-30, 34);
////        obj.frame = obj.superview.bounds;
//    }];
//}

- (void)handleTapEvent:(UITapGestureRecognizer *)tap {
    BLInterestItemView *view = (BLInterestItemView *)tap.view;
    view.model.isSelected = !view.model.isSelected;
    [view reloadData];
    
//    if (view.model.isSelected == YES) {
////        [self.tagViews addObject:view.tagLabel];
//        [self.selectModels addObject:view.model];
//    }else{
//        static NSUInteger index = 0;
//        [self.tagViews enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            UILabel *tagLab = (UILabel *)obj;
//            if ([tagLab.text isEqualToString:view.tagLabel.text]) {
//                index = idx;
//            }
//        }];
//        [self.tagViews removeObjectAtIndex:index];
//        [self.selectModels removeObjectAtIndex:index];
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(updateTableViewWithModel:)]) {
//        [self.delegate updateTableViewWithTags:self.tagViews andWithModes:self.selectModels];
        [self.delegate updateTableViewWithModel:view.model];
    }
//    [self updateTagView];
}

//- (void)updateTagView {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(updateTableViewWithModel:)]) {
//        [self.delegate updateTableViewWithTags:self.tagViews andWithModes:self.selectModels];
//    }
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


//- (NSMutableArray *)tagViews {
//    if (!_tagViews) {
//        _tagViews = [NSMutableArray array];
//    }
//    return _tagViews;
//}
//
//- (NSMutableArray *)selectModels {
//    if (!_selectModels) {
//        _selectModels = [NSMutableArray array];
//    }
//    return _selectModels;
//}

@end
