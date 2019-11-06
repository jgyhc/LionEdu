//
//  BLShoppingCartViewController.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/2.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLShoppingCartViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLCartModel.h"
#import <YYModel.h>
#import "BLShoppingCartTableViewCell.h"
#import "NTCatergory.h"
#import "BLCartListAPI.h"
#import "BLDeleteGoodsCartAPI.h"
#import <LCProgressHUD.h>
#import "BLGoodsCartPriceAPI.h"
#import "BLGetCartNumAPI.h"
#import "BLUpdateGoodsCartNmAPI.h"

@interface BLShoppingCartViewController ()<ZLTableViewDelegateManagerDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource, BLShoppingCartTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ZLTableViewDelegateManager *manager;
@property (nonatomic, strong) BLCartListAPI *cartListAPI;
@property (nonatomic, strong) BLDeleteGoodsCartAPI *deleteGoodsCartAPI;
@property (nonatomic, strong) BLGoodsCartPriceAPI *goodsCartPriceAPI;
@property (nonatomic, strong) BLGetCartNumAPI *getCartNumAPI;
@property (nonatomic, strong) BLUpdateGoodsCartNmAPI *updateGoodsCartNmAPI;

@property (nonatomic, strong) NSMutableArray *datas;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;
@property (nonatomic, assign) NSInteger selectNum;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *managerBtn;
@property (nonatomic, assign) BOOL isManager;
@property (weak, nonatomic) IBOutlet UILabel *totalLab;
@property (weak, nonatomic) IBOutlet UILabel *RMBLab;
@property (nonatomic, copy) NSString *ids;
@property (nonatomic, strong) NSArray *getPriceParams;
@property (weak, nonatomic) IBOutlet UILabel *fullReduceLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceBtmConstraint;

//更新商品数量
@property (nonatomic, strong) NSDictionary *updateCartParams;

@end

@implementation BLShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.datas = [NSMutableArray array];
    [self.manager reloadData];
    [self.cartListAPI loadData];
    self.selectNum = 0;
    self.fullReduceLab.text = @"";
    self.priceBtmConstraint.constant = 8;
    [self.submitBtn setTitle:@"结算" forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.getCartNumAPI loadData];
}

- (IBAction)bl_submit:(id)sender {
    if (self.selectNum <= 0) {
        [LCProgressHUD show:@"您还未选择商品！"];
        return;
    }
    if (self.isManager) {
        [self.deleteGoodsCartAPI loadData];
    } else {
        NSMutableArray *ids = [NSMutableArray array];
        for (NSInteger i = 0; i < self.datas.count; i ++) {
            ZLTableViewSectionModel *section = self.datas[i];
            BLCartModel *model = section.items[0].data;
            if (model.isSelect){
                [ids addObject:model.goodsId];
            }
        }
        UIViewController *controller = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLMallOrderSureViewController"];
        [controller setValue:@0 forKey:@"groupType"];
        [controller setValue:@"" forKey:@"groupId"];
        NSString *idsString = [ids componentsJoinedByString:@","];
        [controller setValue:idsString  forKey:@"goodsId"];
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (IBAction)bl_selectAll:(UIButton *)sender {
    sender.selected = !sender.selected;
    for (NSInteger i = 0; i < self.datas.count; i ++) {
        ZLTableViewSectionModel *section = self.datas[i];
        BLCartModel *model = section.items[0].data;
        model.isSelect = sender.selected;
    }
    [self bl_ShoppingCartSelectItem:nil];
    [self.manager reloadData];
}

- (IBAction)bl_manager:(UIBarButtonItem *)sender {
    self.isManager = !self.isManager;
    if (self.isManager) {
        [sender setTitle:@"取消"];
        [self.submitBtn setBackgroundImage:nil forState:UIControlStateNormal];
        self.submitBtn.layer.borderColor = [UIColor nt_colorWithHexString:@"#E63535"].CGColor;
        self.submitBtn.layer.borderWidth = 0.6;
        [self.submitBtn setTitleColor:[UIColor nt_colorWithHexString:@"#E63535"] forState:UIControlStateNormal];
    } else {
        [sender setTitle:@"管理"];
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"cart_sbg"] forState:UIControlStateNormal];
        self.submitBtn.layer.borderColor = [UIColor clearColor].CGColor;
        self.submitBtn.layer.borderWidth = 0;
        [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [self bl_ShoppingCartSelectItem:nil];
}

- (void)bl_ShoppingCartSelectItem:(BLCartModel *)model {
    if (model) {
        self.updateCartParams = @{@"id": model.Id, @"goodsNum": @(model.goodsNum)};
        [self.updateGoodsCartNmAPI loadData];
    }
    BOOL isSelectAll = YES;
    CGFloat price = 0.0;
    NSInteger num = 0;
    NSMutableArray *ids = [NSMutableArray array];
    NSMutableArray *jsons = [NSMutableArray array];
    for (NSInteger i = 0; i < self.datas.count; i ++) {
        ZLTableViewSectionModel *section = self.datas[i];
        BLCartModel *model = section.items[0].data;
        if (model.isSelect == NO) {
            isSelectAll = NO;
        } else {
            num += model.goodsNum;
            price += model.goodsNum * model.cartPrice.floatValue;
            [ids addObject:model.Id];
            NSDictionary *dic = @{@"id": model.Id?:@"",
                                  @"modelId": model.modelId?:@"",
                                  @"price": model.cartPrice?:@"",
                                  @"number": @(model.goodsNum?:0)
            };
            [jsons addObject:dic];
        }
    }
    if (jsons.count > 0) {
        self.getPriceParams = jsons.copy;
        [self.goodsCartPriceAPI loadData];
    }
    self.ids = [ids componentsJoinedByString:@","];
    self.selectNum = num;
    if (self.isManager) {
        [self.submitBtn setTitle:[NSString stringWithFormat:@"删除(%ld)", num] forState:UIControlStateNormal];
        self.moneyLab.hidden = self.numLab.hidden = self.totalLab.hidden = self.RMBLab.hidden = YES;
    } else {
        self.moneyLab.hidden = self.numLab.hidden = self.totalLab.hidden = self.RMBLab.hidden = NO;
        self.numLab.text = [NSString stringWithFormat:@"共%ld件", num];
        [self.submitBtn setTitle:[NSString stringWithFormat:@"结算(%ld)", num] forState:UIControlStateNormal];
        self.moneyLab.text = [NSString stringWithFormat:@"%.2lf", price];
    }
    self.selectAllBtn.selected = isSelectAll;
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return self.datas;
}

- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    NSInteger code = [data[@"code"] integerValue];
    if (code == 200) {
        if ([manager isEqual:self.cartListAPI]) {
            NSArray <BLCartModel *> *list = [NSArray yy_modelArrayWithClass:[BLCartModel class] json:data[@"data"]];
            for (NSInteger i = 0; i < list.count; i ++) {
                ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
                sectionModel.headerHeight = 10;
                sectionModel.headerBackgroundColor = [UIColor colorWithRed:248/255.00 green:249/255.00 blue:250/255.00 alpha:1];
                ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                rowModel.identifier = @"BLShoppingCartTableViewCell";
                rowModel.cellHeight = 96;
                rowModel.data = list[i];
                rowModel.delegate = self;
                sectionModel.items = @[rowModel];
                [self.datas addObject:sectionModel];
            }
            [self.manager reloadData];
            [self.getCartNumAPI loadData];
        } else if ([self.deleteGoodsCartAPI isEqual:manager]) {
            [self.datas removeAllObjects];
            [self.submitBtn setTitle:@"删除(0)" forState:UIControlStateNormal];
            [self.cartListAPI loadData];
        } else if ([self.goodsCartPriceAPI isEqual:manager]) {
            CGFloat nowPrice = [data[@"data"][@"nowPrice"] floatValue];
            CGFloat salePricw = [data[@"data"][@"salePricw"] floatValue];
            self.moneyLab.text = [NSString stringWithFormat:@"%.2lf", nowPrice];
            if (salePricw > 0.0) {
                self.fullReduceLab.text = [NSString stringWithFormat:@"满减：￥%.2lf", salePricw];
                self.fullReduceLab.hidden = NO;
                self.priceBtmConstraint.constant = 4;
            } else {
                self.fullReduceLab.hidden = YES;
                self.priceBtmConstraint.constant = 8;
            }
        } else if ([self.getCartNumAPI isEqual:manager]) {
            NSInteger number = [data[@"data"] integerValue];
            self.title = [NSString stringWithFormat:@"购物车(%ld)", number];
        } else if ([self.updateGoodsCartNmAPI isEqual:manager]) {
            self.updateCartParams = nil;
        }
    }
}

- (id)paramsForApi:(CTAPIBaseManager *)manager {
    if ([manager isEqual:self.deleteGoodsCartAPI]) {
        return @{@"ids": self.ids};
    }
    if ([manager isEqual:self.goodsCartPriceAPI]) {
        return self.getPriceParams;
    }
    if ([manager isEqual:self.updateGoodsCartNmAPI]) {
        return self.updateCartParams;
    }
    return nil;
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.delegate = self;
        _manager.tableView = self.tableView;
    }
    return _manager;
}

- (BLCartListAPI *)cartListAPI {
    if (!_cartListAPI) {
        _cartListAPI = [BLCartListAPI new];
        _cartListAPI.mj_delegate = self;
        _cartListAPI.paramSource = self;
    }
    return _cartListAPI;
}

- (BLDeleteGoodsCartAPI *)deleteGoodsCartAPI {
    if (!_deleteGoodsCartAPI) {
        _deleteGoodsCartAPI = [BLDeleteGoodsCartAPI new];
        _deleteGoodsCartAPI.mj_delegate = self;
        _deleteGoodsCartAPI.paramSource = self;
    }
    return _deleteGoodsCartAPI;
}

- (BLGoodsCartPriceAPI *)goodsCartPriceAPI {
    if (!_goodsCartPriceAPI) {
        _goodsCartPriceAPI = [BLGoodsCartPriceAPI new];
        _goodsCartPriceAPI.mj_delegate = self;
        _goodsCartPriceAPI.paramSource = self;
    }
    return _goodsCartPriceAPI;
}

- (BLGetCartNumAPI *)getCartNumAPI {
    if (!_getCartNumAPI) {
        _getCartNumAPI = [[BLGetCartNumAPI alloc] init];
        _getCartNumAPI.mj_delegate = self;
        _getCartNumAPI.paramSource = self;
    }
    return _getCartNumAPI;
}

- (BLUpdateGoodsCartNmAPI *)updateGoodsCartNmAPI {
    if (!_updateGoodsCartNmAPI) {
        _updateGoodsCartNmAPI = [[BLUpdateGoodsCartNmAPI alloc] init];
        _updateGoodsCartNmAPI.mj_delegate = self;
        _updateGoodsCartNmAPI.paramSource = self;
    }
    return _updateGoodsCartNmAPI;
}


@end
