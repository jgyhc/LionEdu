//
//  BLInterViewController.m
//  BigLionEdu
//
//  Created by Hwang on 2019/10/8.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLInterViewController.h"
#import "NTCatergory.h"
#import "AdaptScreenHelp.h"
#import "XWCatergoryView.h"
#import <BlocksKit.h>
#import <YYModel.h>
#import "BLGetCurriculumListAPI.h"
#import "BLInterViewContainerView.h"

@interface BLInterViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, XWCatergoryViewDelegate, MJAPIBaseManagerDelegate, CTAPIManagerParamSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) XWCatergoryView *catergoryView;
@property (nonatomic, strong) NSMutableArray <BLInterViewContainerView *> *views;

@end

@implementation BLInterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.views = [NSMutableArray array];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.view addSubview:self.catergoryView];
    self.catergoryView.titles = @[@"历年真题",@"历年真题",@"历年真题",@"历年真题",@"历年真题"];
    for (NSInteger i = 0; i < 5; i ++) {
        BLInterViewContainerView *view = [BLInterViewContainerView new];
        view.frame = CGRectMake(0, 0, NT_SCREEN_WIDTH, NT_SCREEN_HEIGHT - 88);
        [self.views addObject:view];
    }
    [self.catergoryView xw_realoadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [cell.contentView addSubview:self.views[indexPath.item]];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(NT_SCREEN_WIDTH, NT_SCREEN_HEIGHT - 88);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}


#pragma mark -- CTAPIManagerParamSource method
- (NSDictionary *_Nullable)paramsForApi:(CTAPIBaseManager *_Nonnull)manager {

    return nil;
}

#pragma mark -- MJAPIBaseManagerDelegate method
- (void)manager:(CTAPIBaseManager *)manager callBackData:(id)data {

}

- (void)failManager:(CTAPIBaseManager *)manager {
    
}


#pragma mark - get
- (XWCatergoryView *)catergoryView
{
    if (!_catergoryView) {
        _catergoryView = [[XWCatergoryView alloc]initWithFrame:CGRectMake(0, NavigationHeight(), NT_SCREEN_WIDTH, 44)];
        _catergoryView.titleColor = [UIColor nt_colorWithHexString:@"#666666"];
        _catergoryView.titleSelectColor = [UIColor nt_colorWithHexString:@"#FF6B00"];
        _catergoryView.backgroundColor = [UIColor nt_colorWithHexString:@"#FEEAE1"];
        _catergoryView.delegate = self;
        _catergoryView.scaleEnable = YES;
        _catergoryView.scaleFont = [UIFont boldSystemFontOfSize:15];
        _catergoryView.bottomLineEable = NO;
        _catergoryView.scrollView = self.collectionView;
    }
    return _catergoryView;
}

@end
