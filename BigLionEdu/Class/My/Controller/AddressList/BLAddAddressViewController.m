//
//  BLAddAddressViewController.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/8/27.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLAddAddressViewController.h"
#import "ZLTableViewDelegateManager.h"
#import "BLAddressModel.h"
#import <YYModel.h>
#import "BLInsertAddresAPI.h"
#import "ZLUserInstance.h"
#import <LCProgressHUD.h>
#import "AddressPickerView.h"
#import "BLUpdateAddresAPI.h"

@interface BLAddAddressViewController ()<ZLTableViewDelegateManagerDelegate, CTAPIManagerParamSource, MJAPIBaseManagerDelegate, AddressPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ZLTableViewDelegateManager * manager;
@property (nonatomic, strong) BLAddressModel * model;
@property (nonatomic, strong) BLInsertAddresAPI *insertAddresAPI;
@property (nonatomic, strong) BLUpdateAddresAPI * updateAddresAPI;
@property (nonatomic, strong) AddressPickerView *addressPickerView;
@property (nonatomic, assign) BOOL isEdit;

@end

@implementation BLAddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!_model) {
        _model = [[BLAddressModel alloc] init];
    }
    [self.manager reloadData];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.addressPickerView];
//    [self.view addSubview:self.addressPickerView];
    
}

- (void)setAddress:(NSDictionary *)address {
    _address = address;
    _isEdit = YES;
    _model = [BLAddressModel yy_modelWithJSON:address];
}

- (NSArray<ZLTableViewSectionModel *> *)dataSource:(ZLTableViewDelegateManager *)manager {
    return @[
             ({
                 ZLTableViewSectionModel *sectionModel = [ZLTableViewSectionModel new];
                 sectionModel.items = @[
                                        ({
                                            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                                            rowModel.cellHeight = 48;
                                            rowModel.identifier = @"BLAddressDetailNameTableViewCell";
                                            rowModel.data = _model;
                                            rowModel;
                                        }),
                                        ({
                                            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                                            rowModel.cellHeight = 48;
                                            rowModel.identifier = @"BLAddressDetailMobileTableViewCell";
                                            rowModel.data = _model;
                                            rowModel;
                                        }),
                                        ({
                                            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                                            rowModel.cellHeight = 48;
                                            rowModel.identifier = @"BLAddressDetailAreaTableViewCell";
                                            rowModel.data = _model;
                                            rowModel;
                                        }),
                                        ({
                                            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                                            rowModel.cellHeight = 69;
                                            rowModel.identifier = @"BLAddressDetailAddressTableViewCell";
                                            rowModel.data = _model;
                                            rowModel;
                                        }),
                                        ({
                                            ZLTableViewRowModel *rowModel = [ZLTableViewRowModel new];
                                            rowModel.cellHeight = 48;
                                            rowModel.identifier = @"BLAddressDetailDefaultTableViewCell";
                                            rowModel.data = _model;
                                            rowModel;
                                        })
                                        ];
                 sectionModel;
             })
             ];
}

- (void)didSelectRowAtModel:(ZLTableViewRowModel *)model manager:(ZLTableViewDelegateManager *)manager indexPath:(NSIndexPath *)indexPath {
    if ([model.identifier isEqualToString:@"BLAddressDetailAreaTableViewCell"]) {
        [self.view endEditing:YES];
        [self.addressPickerView show];
    }
    if ([model.identifier isEqualToString:@"BLAddressDetailDefaultTableViewCell"]) {
        if ([self.model.isDefault isEqualToString:@"1"]) {
            self.model.isDefault = @"0";
        }else {
            self.model.isDefault = @"1";
        }
        [self.tableView reloadData];
    }
}

#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.insertAddresAPI isEqual:manager] || [self.updateAddresAPI isEqual:manager]) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params addEntriesFromDictionary:[_model yy_modelToJSONObject]];
        [params setObject: @([ZLUserInstance sharedInstance].Id) forKey:@"memberId"];
        return params;
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.insertAddresAPI isEqual:manager] || [self.updateAddresAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

/** 取消按钮点击事件*/
- (void)cancelBtnClick {
    
}

/**
 *  完成按钮点击事件
 *
 *  @param province 当前选中的省份
 *  @param city     当前选中的市
 *  @param area     当前选中的区
 */
- (void)sureBtnClickReturnProvince:(NSString *)province
                              City:(NSString *)city
                              Area:(NSString *)area {
    self.model.province = province;
    self.model.city = city;
    self.model.district = area;
    [self.tableView reloadData];
    
}

- (IBAction)saveEvent:(id)sender {
    if (self.model.name.length == 0) {
        [LCProgressHUD show:@"请输入收货人手机号"];
        return;
    }
    if (self.model.mobile.length != 11) {
        [LCProgressHUD show:@"请输入正确格式的手机号"];
        return;
    }
    if (self.model.name.length == 0) {
        [LCProgressHUD show:@"请输入收货人姓名"];
        return;
    }
    if (self.model.mobile.length == 0) {
        [LCProgressHUD show:@"请输入收货人手机号码"];
        return;
    }
    if (self.model.detail.length == 0) {
        [LCProgressHUD show:@"请输入详细地址"];
        return;
    }
    if (self.model.province.length == 0) {
        [LCProgressHUD show:@"请设置省市区信息"];
        return;
    }
    if (_isEdit) {
        [self.updateAddresAPI loadData];
    }else {
        [self.insertAddresAPI loadData];
    }
}

- (ZLTableViewDelegateManager *)manager {
    if (!_manager) {
        _manager = [[ZLTableViewDelegateManager alloc] init];
        _manager.tableView = self.tableView;
        _manager.delegate = self;
    }
    return _manager;
}

- (BLInsertAddresAPI *)insertAddresAPI {
    if (!_insertAddresAPI) {
        _insertAddresAPI = [[BLInsertAddresAPI alloc] init];
        _insertAddresAPI.mj_delegate = self;
        _insertAddresAPI.paramSource = self;
    }
    return _insertAddresAPI;
}


- (BLUpdateAddresAPI *)updateAddresAPI {
    if (!_updateAddresAPI) {
        _updateAddresAPI = [[BLUpdateAddresAPI alloc] init];
        _updateAddresAPI.mj_delegate = self;
        _updateAddresAPI.paramSource = self;
    }
    return _updateAddresAPI;
}
- (AddressPickerView *)addressPickerView {
    if (!_addressPickerView) {
        _addressPickerView = [[AddressPickerView alloc] init];
        _addressPickerView.delegate = self;
        [_addressPickerView setTitleHeight:50 pickerViewHeight:165];
    }
    return _addressPickerView;
}
@end
