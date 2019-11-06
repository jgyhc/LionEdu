//
//  BLMallSearchResultController.m
//  BigLionEdu
//
//  Created by Hwang on 2019/9/10.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLMallSearchResultController.h"
#import "NTCatergory.h"
#import <BlocksKit.h>
#import <YYModel.h>
#import "AdaptScreenHelp.h"
#import "XWCatergoryView.h"
#import "BLMallIndexCollectionViewCell.h"
#import "BLGetGoodsTypeAPI.h"
#import "BLGetCartNumAPI.h"
#import "BLMailSearchContentView.h"
#import "BLGetGoodsListAPI.h"
#import "ZLUserInstance.h"

@interface BLMallSearchResultController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, XWCatergoryViewDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *nav;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *topBtn;
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;
@property (weak, nonatomic) IBOutlet UILabel *cartNumLab;

@property (nonatomic, strong) XWCatergoryView *catergoryView;
@property (nonatomic, strong) BLGetGoodsTypeAPI * getGoodsTypeAPI;
@property (nonatomic, strong) BLGetCartNumAPI *getCartNumAPI;
@property (nonatomic, strong) BLGetGoodsListAPI * getGoodsListAPI;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *views;

@property (nonatomic, strong) BLMailSearchContentView *currentView;

@end

@implementation BLMallSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backBtn.externalTouchInset = UIEdgeInsetsMake(15, 15, 15, 15);
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:self.catergoryView];
    self.views = [NSMutableArray array];
    self.nav.backgroundColor = [UIColor nt_colorWithHexString:@"#FEEAE1"];
    [self.view insertSubview:self.topBtn atIndex:1001];
    [self.view insertSubview:self.cartBtn atIndex:1002];
    [self.view insertSubview:self.cartNumLab atIndex:1003];
    [self.getGoodsTypeAPI loadData];
    self.searchTF.text = self.searchStr;
    self.searchTF.returnKeyType = UIReturnKeySearch;
    self.searchTF.delegate = self;
    [self.cartBtn addTarget:self action:@selector(bl_toShoppingCart:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBtn addTarget:self action:@selector(bl_toTop:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *icon = [UIButton buttonWithType:UIButtonTypeCustom];
    [icon setImage:[UIImage imageNamed:@"sc_icon"] forState:UIControlStateNormal];
    icon.frame = CGRectMake(0, 0, 30, 30);
    icon.contentMode = UIViewContentModeScaleToFill;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftView addSubview:icon];
    self.cartNumLab.text = @"0";
    self.cartNumLab.hidden = YES;
    self.searchTF.leftView = leftView;
    self.searchTF.leftViewMode = UITextFieldViewModeAlways;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.getCartNumAPI loadData];
}

- (IBAction)lb_back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bl_toTop:(id)sender {
    [_currentView.collectionView setContentOffset:CGPointZero];
}

- (void)bl_toShoppingCart:(id)sender {
    if (![ZLUserInstance sharedInstance].isLogin) {
        [[CTMediator sharedInstance] performTarget:@"login" action:@"pushLogin" params:nil shouldCacheTarget:YES];
        return;
    }
    UIViewController *controller = [[UIStoryboard storyboardWithName:@"Mall" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"BLShoppingCartViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    self.searchStr = textField.text;
    _currentView.title = self.searchStr;
    [_currentView bl_search];
    return YES;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview) withObject:nil];
    BLMailSearchContentView *view = self.views[indexPath.item];
    view.title = self.searchStr;
    _currentView = view;
    [cell.contentView addSubview:view];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(NT_SCREEN_WIDTH, NT_SCREEN_HEIGHT - NavigationHeight() - 50);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)catergoryView:(XWCatergoryView *)catergoryView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    BLMailSearchContentView *view = self.views[indexPath.row];
    _currentView = view;
    _currentView.title = self.searchStr;
    [view bl_refresh];
}

- (void)catergoryView:(XWCatergoryView *)catergoryView scrollToItem:(NSInteger)index {
    BLMailSearchContentView *view = self.views[index];
    _currentView = view;
    _currentView.title = self.searchStr;
    [view bl_refresh];
}


#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {
    if ([self.getGoodsTypeAPI isEqual:manager]) {
        return nil;
    }
    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {
    if ([self.getGoodsTypeAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSArray *list = [data objectForKey:@"data"];
            _titles = list;
            NSMutableArray *titles = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [titles addObject:[obj objectForKey:@"title"]];
            }];
            self.catergoryView.titles = titles;
            
            for (NSInteger i = 0; i < list.count; i ++) {
                BLMailSearchContentView *view = [BLMailSearchContentView new];
                view.frame = CGRectMake(0, 0, NT_SCREEN_WIDTH, (NT_SCREEN_HEIGHT - NavigationHeight() - 50));
                view.modelId = list[i][@"id"];
                if (i == 0) {
                    view.title = self.searchStr;
                    [view bl_refresh];
                    _currentView = view;
                }
                [self.views addObject:view];
            }
            [self.catergoryView xw_realoadData];
            [self.collectionView reloadData];
        }
    } else if ([self.getCartNumAPI isEqual:manager]) {
        NSInteger code = [[data objectForKey:@"code"] integerValue];
        if (code == 200) {
            NSInteger number = [data[@"data"] integerValue];
            if (number <= 0) {
                self.cartNumLab.hidden = YES;
            } else {
                self.cartNumLab.hidden = NO;
                self.cartNumLab.text = [NSString stringWithFormat:@"%ld", (long)number];
            }
        }
    }
}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}

- (BLGetGoodsTypeAPI *)getGoodsTypeAPI {
    if (!_getGoodsTypeAPI) {
        _getGoodsTypeAPI = [[BLGetGoodsTypeAPI alloc] init];
        _getGoodsTypeAPI.mj_delegate = self;
        _getGoodsTypeAPI.paramSource = self;
    }
    return _getGoodsTypeAPI;
}

#pragma mark - get
- (XWCatergoryView *)catergoryView
{
    if (!_catergoryView) {
        _catergoryView = [[XWCatergoryView alloc]initWithFrame:CGRectMake(0, NavigationHeight(), NT_SCREEN_WIDTH, 50)];
        _catergoryView.titleColor = [UIColor nt_colorWithHexString:@"#666666"];
        _catergoryView.titleSelectColor = [UIColor nt_colorWithHexString:@"#FF6B00"];
        _catergoryView.backgroundColor = [UIColor nt_colorWithHexString:@"#FEEAE1"];
        _catergoryView.delegate = self;
        _catergoryView.scaleEnable = YES;
        _catergoryView.scaleFont = [UIFont boldSystemFontOfSize:15];
        _catergoryView.bottomLineEable = YES;
        _catergoryView.bottomLineColor = [UIColor nt_colorWithHexString:@"#FF6B00"];
        _catergoryView.bottomLineWidth = 2;
        _catergoryView.scrollView = self.collectionView;
    }
    return _catergoryView;
}

- (BLGetCartNumAPI *)getCartNumAPI {
    if (!_getCartNumAPI) {
        _getCartNumAPI = [[BLGetCartNumAPI alloc] init];
        _getCartNumAPI.mj_delegate = self;
        _getCartNumAPI.paramSource = self;
    }
    return _getCartNumAPI;
}


@end
