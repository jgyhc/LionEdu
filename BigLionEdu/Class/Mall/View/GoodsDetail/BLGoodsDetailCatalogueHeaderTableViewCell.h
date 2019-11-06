//
//  BLGoodsDetailCatalogueHeaderTableViewCell.h
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/1.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLGoodsDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface BLGoodsDetailCatalogueHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (nonatomic, strong) NSMutableAttributedString *model;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

NS_ASSUME_NONNULL_END
