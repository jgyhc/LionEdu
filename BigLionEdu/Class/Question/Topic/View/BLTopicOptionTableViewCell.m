//
//  BLTopicOptionTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/6.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTopicOptionTableViewCell.h"
#import "BLTopicFontManager.h"
#import "UIColor+NTAdd.h"
#import <YYLabel.h>
#import <YYText.h>
#import <YYAsyncLayer.h>

@interface BLTopicOptionTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

//@property (weak, nonatomic) IBOutlet UILabel *contenLabel;
@property (weak, nonatomic) IBOutlet YYLabel *valueLabel;

@end

@implementation BLTopicOptionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectButton.userInteractionEnabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fontDidChange) name:@"BLTopicFontDidChange" object:nil];
    _valueLabel.numberOfLines = 0;
    _valueLabel.preferredMaxLayoutWidth = [UIScreen mainScreen].bounds.size.width - 83;
}

- (void)fontDidChange {
    [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)contentsNeedUpdated {
    // do update
    [self.layer setNeedsDisplay];
}

- (void)setModel:(BLTopicOptionModel *)model {
    _model = model;
    if (model.valueString) {
        _valueLabel.attributedText = model.valueString;
    }else {
        [[YYTransaction transactionWithTarget:self selector:@selector(contentsNeedUpdated)] commit];
    }
    [_selectButton setTitle:model.moption forState:UIControlStateNormal];
    [_selectButton setImage:nil forState:UIControlStateNormal];
    _selectButton.selected = model.isSelect;
    if (model.isParsing) {
        [_selectButton setTitle:@"" forState:UIControlStateNormal];
        //✅、x代表正确答案,错误答案
        //背景颜色来表示选择状态：黄：选中正确，灰：选中错误，白：未选中
        //#FF6B00
//        #8686A0
        if (model.keyStatus == 1) {//0没有选  1选对了  2选错
            _selectButton.layer.borderWidth = 0;
            [_selectButton setBackgroundColor:[UIColor nt_colorWithHexString:@"#FF6B00"]];
            [_selectButton setTitle:@"" forState:UIControlStateNormal];
            [_selectButton setImage:[UIImage imageNamed:@"t_tmg"] forState:UIControlStateNormal];
//            [_selectButton setBackgroundImage:[UIImage imageNamed:@"t_d"] forState:UIControlStateNormal];
//            [_selectButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0]];
        }else if(model.keyStatus == 2) {
            _selectButton.layer.borderWidth = 0;
            [_selectButton setTitle:@"" forState:UIControlStateNormal];
            [_selectButton setImage:[UIImage imageNamed:@"t_tmcw"] forState:UIControlStateNormal];
//            [_selectButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0]];
//            [_selectButton setBackgroundImage:[UIImage imageNamed:@"t_c"] forState:UIControlStateNormal];
            [_selectButton setBackgroundColor:[UIColor nt_colorWithHexString:@"#8686A0"]];
        }else {
            _selectButton.layer.borderWidth = 1;
            [_selectButton setBackgroundColor:[UIColor whiteColor]];
//            [_selectButton setBackgroundImage:nil forState:UIControlStateNormal];
            [_selectButton setTitle:model.moption forState:UIControlStateNormal];
        }
    }else {
        if (model.isSelect) {
            [_selectButton setBackgroundColor:[UIColor colorWithRed:255/255.0 green:107/255.0 blue:0/255.0 alpha:1.0]];
            self.selectButton.layer.borderWidth = 0;
        }else {
            [_selectButton setBackgroundColor:[UIColor whiteColor]];
            self.selectButton.layer.borderWidth = 1;
        }
    }
    
    
}



#pragma mark - YYAsyncLayer

+ (Class)layerClass {
    return YYAsyncLayer.class;
}

- (YYAsyncLayerDisplayTask *)newAsyncDisplayTask {
    
    // capture current state to display task
    NSString *text = _model.value;
    UIFont *font =  [BLTopicFontManager sharedInstance].contentFont;
    __weak typeof(self) wself = self;
    YYAsyncLayerDisplayTask *task = [YYAsyncLayerDisplayTask new];
    task.willDisplay = ^(CALayer *layer) {
        //...
    };
    
    task.display = ^(CGContextRef context, CGSize size, BOOL(^isCancelled)(void)) {
        NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithData:[text?text:@"" dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil]];
        titleAttributedString.yy_font = font;
        titleAttributedString.yy_color = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        CGSize introSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 83, CGFLOAT_MAX);
        wself.model.valueString = titleAttributedString;
        dispatch_async(dispatch_get_main_queue(), ^{
            YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:introSize text:titleAttributedString];
            wself.valueLabel.textLayout = layout;
            CGFloat introHeight = layout.textBoundingSize.height;
            wself.valueLabel.attributedText = titleAttributedString;
            if (wself.delegate && [wself.delegate respondsToSelector:@selector(updateCellHeight:cell:)]) {
                [wself.delegate updateCellHeight:introHeight cell:wself];
            }
        });
    };
    
    task.didDisplay = ^(CALayer *layer, BOOL finished) {
        if (finished) {
            // finished
        } else {
            // cancelled
        }
    };
    
    return task;
}

@end
