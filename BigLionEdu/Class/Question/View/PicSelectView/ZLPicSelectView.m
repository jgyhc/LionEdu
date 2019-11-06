//
//  ZLPicSelectView.m
//  ZhenLearnDriving_Coach
//
//  Created by OrangesAL on 2019/5/1.
//  Copyright © 2019年 刘聪. All rights reserved.
//

#import "ZLPicSelectView.h"
#import "NTCircleClockModel.h"

#import "XWDragCellCollectionView.h"
#import "NTCircleClockCell.h"

#import "SDPhotoBrowser.h"

#import "NTCatergory.h"
#import "UIViewController+ORAdd.h"
#import "TZImagePickerController.h"
//#import "ZLOfficalModel.h"
#import <LCProgressHUD.h>
#import <Masonry.h>
#import "SDPhotoBrowser.h"

static CGFloat const per_row = 4.0;

@interface ZLPicSelectView()<XWDragCellCollectionViewDelegate,XWDragCellCollectionViewDataSource, SDPhotoBrowserDelegate>

@property (nonatomic,strong)XWDragCellCollectionView * collectionView;
@property (nonatomic, strong) NSIndexPath *movingIndexPath;

@property (nonatomic, strong) NSMutableArray <NTCircleClockModel *>*datas;
@property (nonatomic, strong) NTCircleClockModel *addImage;
@property (nonatomic, strong) NTCircleClockModel *addVideo;
@property (nonatomic, strong) NSURL *videoUrl;

@end

@implementation ZLPicSelectView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self _or_initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _or_initUI];
    }
    return self;
}


- (void)_or_initUI {
    
    _dataMaxCount = 9;
    _addImage = [NTCircleClockModel modelWithImg:NTImage(@"zl_selct")];
    
    [self.datas addObject:_addImage];
    
    
    UICollectionViewFlowLayout * flowLayout = [UICollectionViewFlowLayout new];
    
    flowLayout.itemSize = NTSizeMake(77, 77);
    
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    CGFloat space = ([UIScreen mainScreen].bounds.size.width - 31 - NTWidthRatio(77) * per_row) / (per_row - 1);
    
    flowLayout.minimumLineSpacing = space;
    flowLayout.minimumInteritemSpacing = space;
    
    XWDragCellCollectionView * collectionView = [[XWDragCellCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsVerticalScrollIndicator = NO;
    [collectionView registerClass:[NTCircleClockCell class] forCellWithReuseIdentifier:@"NTCircleClockCell"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass([UICollectionReusableView class])];
    
    _collectionView = collectionView;
    collectionView.minimumPressDuration = 0.3;
    collectionView.shakeLevel = 1;
    [self addSubview:collectionView];
    //    [self.view sendSubviewToBack:collectionView];
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    collectionView.delegate = self;
    collectionView.dataSource = self;

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.datas.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NTCircleClockCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NTCircleClockCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.model = self.datas[indexPath.item];
    
    
    NT_WEAKIFY(self);
    [cell setDeleteConfig:^(NSIndexPath *aIndexPath){
        NT_STRONGIFY(self);
        [self.datas removeObjectAtIndex:aIndexPath.item];
        
        if (self.videoUrl) {
            self.videoUrl = nil;
        }
        
        if (self.datas.count < self.dataMaxCount && ![self.datas containsObject:self.addImage] && !self.videoUrl) {
            [self.datas addObject:self.addImage];
        }
        
        if (self.canPicVideo && self.datas.count == 1 && [self.datas.firstObject isEqual:self.addImage]) {
            [self.datas addObject:self.addVideo];
        }
        
        [self.collectionView reloadData];
        NT_BLOCK(self.viewHeightUpdate);
    }];
    
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    [self endEditing:YES];
    
    NTCircleClockModel *data1 = self.datas[indexPath.item];
    NT_WEAKIFY(self);

    if ([_addImage isEqual:data1]) {
        
        TZImagePickerController *picker = [[TZImagePickerController alloc] init];
        NSInteger inset = (_canPicVideo && self.datas.count == 2) ? 2 : 1;
        picker.maxImagesCount = self.dataMaxCount - self.datas.count + inset;
        picker.showSelectBtn = YES;
        picker.allowPickingVideo = NO;
        picker.allowPickingGif = NO;
        picker.allowPickingOriginalPhoto = YES;
        picker.previewBtnTitleStr = @"";
        picker.autoDismiss = YES;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [[UIViewController currentViewController] presentViewController:picker animated:YES completion:nil];
        
        [picker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            NT_STRONGIFY(self);
            
            NSMutableArray *ara = [NSMutableArray array];
            [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [ara addObject:[NTCircleClockModel imageModelWithImg:obj]];
            }];
            
            [self.datas removeObject:self.addImage];
            [self.datas removeObject:self.addVideo];

            [self.datas addObjectsFromArray:ara];
            if (self.datas.count < self.dataMaxCount) {
                [self.datas addObject:self.addImage];
            }
            [self.collectionView reloadData];
            NT_BLOCK(self.viewHeightUpdate);
        }];
        
        
    }else if ([self.addVideo isEqual:data1]) {
        
        TZImagePickerController *picker = [[TZImagePickerController alloc] init];
       
        
        picker = [[TZImagePickerController alloc] init];
        picker.allowPickingVideo = YES;
        picker.allowPickingMultipleVideo = NO;
        //            picker.maxImagesCount = 1;
        picker.showSelectBtn = NO;
        picker.allowPickingGif = NO;
        picker.allowPickingOriginalPhoto = NO;
        picker.allowTakePicture = NO;
        picker.allowTakePicture = NO;
        picker.allowPickingImage = NO;
        picker.previewBtnTitleStr = @"";
        picker.autoDismiss = YES;
        picker.videoMaximumDuration = 180;
        picker.modalPresentationStyle = UIModalPresentationFullScreen;
        [[UIViewController currentViewController] presentViewController:picker animated:YES completion:nil];

        
        NT_WEAKIFY(self);
        [picker setDidFinishPickingVideoHandle:^(UIImage *coverImage, id asset) {
            NT_STRONGIFY(self);
            
            if (asset) {
                [self.datas removeAllObjects];
                [self.datas addObject:[NTCircleClockModel videoModelWithImg:coverImage]];
                
                [self getVideoOutputPathWithAsset:asset completion:^(NSURL *outputPath) {
                    NT_STRONGIFY(self);
                    self.videoUrl = outputPath;
                }];
                [self.collectionView reloadData];
            }
        }];
        
        
    }else {
        SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
        browser.currentImageIndex = indexPath.item;
        browser.sourceImagesContainerView = self.collectionView;
        browser.imageCount = self.datas.count - 1;
        browser.delegate = self;
        [browser show];
    }
    
    

//    NSMutableArray *imgArray = self.datas.mutableCopy;
//    if ([self.datas containsObject:_addImage]) {
//        [imgArray removeLastObject];
//    }
//
//    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
//    browser.currentImageIndex = indexPath.item;
//    browser.sourceImagesContainerView = self.collectionView;
//    browser.imageCount = imgArray.count;
//    browser.delegate = self;
//    browser.isShow = YES;
//    [browser show];
    
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    NTCircleClockModel *data1 = self.datas[index];
    return data1.contentImg;
}

- (NSArray *)dataSourceArrayOfCollectionView:(XWDragCellCollectionView *)collectionView {
    return self.datas;
}

-(void)dragCellCollectionView:(XWDragCellCollectionView *)collectionView newDataArrayAfterMove:(NSArray *)newDataArray{
    
    
    [self.datas removeAllObjects];
    [self.datas addObjectsFromArray:newDataArray];
    
    //    [self reUpLoadData:self.datas];
}

- (void)dragCellCollectionView:(XWDragCellCollectionView *)collectionView cellWillBeginMoveAtIndexPath:(NSIndexPath *)indexPath {
    _movingIndexPath = indexPath;
}
-(NSArray<NSIndexPath *> *)excludeIndexPathsWhenMoveDragCellCollectionView:(XWDragCellCollectionView *)collectionView{
    
    NSInteger picindex=-1;
    NSInteger vedioindex=-1;

    if ([self.datas containsObject:_addImage]) {
        picindex = [self.datas indexOfObject:_addImage];
    }
    
    if ([self.datas containsObject:self.addVideo]) {
        vedioindex = [self.datas indexOfObject:self.addVideo];
    }
    
    NSIndexPath * idx =[NSIndexPath indexPathForRow:picindex inSection:0];
    NSIndexPath * idx1 =[NSIndexPath indexPathForRow:vedioindex inSection:0];

    return @[idx, idx1];
}

- (CGFloat)viewHeight {
    NSInteger count = ceil(self.datas.count / per_row);
    
    CGFloat space = ([UIScreen mainScreen].bounds.size.width - 31 - NTWidthRatio(77) * per_row) / (per_row - 1);
    return count * NTWidthRatio(77) + (count - 1) * space + 10 * 2;
}

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas = [NSMutableArray arrayWithCapacity:self.dataMaxCount];
    }
    return _datas;
}

- (NSArray<UIImage *> *)imgDatas {
    
    NSMutableArray *imgArray = [NSMutableArray array];
    [self.datas enumerateObjectsUsingBlock:^(NTCircleClockModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.voiceType == 1) {
            [imgArray addObject:obj.contentImg];
        }
    }];
    return imgArray;
}


- (BOOL)_or_isEqualWithPictures:(NSArray<NSString *> *)pictures {
    
    if (pictures.count != _pictures.count) {
        return NO;
    }
    
    __block BOOL isEqual = YES;
    
    [pictures enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![self.pictures[idx] isEqualToString:obj]) {
            isEqual = NO;
            *stop = YES;
        }
    }];
    
    return isEqual;
    
}


- (NTCircleClockModel *)addVideo {
    if (!_addVideo) {
        _addVideo = [NTCircleClockModel modelWithImg:NTImage(@"圈子视频")];
    }
    return _addVideo;
}


- (void)setCanPicVideo:(BOOL)canPicVideo {
    _canPicVideo = YES;
    if (canPicVideo && self.datas.count == 1) {
        [self.datas addObject:self.addVideo];
    }
}

- (void)setPictures:(NSArray<NSString *> *)pictures {
    
    if ([self _or_isEqualWithPictures:pictures]) {
        return;
    }
    
    _pictures = pictures;
    
    [LCProgressHUD showLoading];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *ara = [NSMutableArray array];
        [pictures enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:obj]]];
            [ara addObject:[NTCircleClockModel imageModelWithImg:image]];
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.datas removeObject:self.addImage];
            [self.datas addObjectsFromArray:ara];
            if (self.datas.count < self.dataMaxCount) {
                [self.datas addObject:self.addImage];
            }
            [self.collectionView reloadData];
            NT_BLOCK(self.viewHeightUpdate);
            [LCProgressHUD hide];
        });
    });
    
    
}


- (void)getVideoOutputPathWithAsset:(PHAsset *)asset completion:(void (^)(NSURL *outputPath))completion {
    
    __block BOOL isVideoInICloud = NO;
    
    PHVideoRequestOptions* options = [[PHVideoRequestOptions alloc] init];
    options.version = PHVideoRequestOptionsVersionOriginal;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    options.networkAccessAllowed = YES;
    
    options.progressHandler = ^(double progress, NSError * _Nullable error, BOOL * _Nonnull stop, NSDictionary * _Nullable info) {
        isVideoInICloud = YES;
    };
    
    [[PHImageManager defaultManager] requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset* avasset, AVAudioMix* audioMix, NSDictionary* info){
        if (isVideoInICloud) {
            [LCProgressHUD show:@"视频正在下载，请稍等。。。"];
        }
        AVURLAsset *videoAsset = (AVURLAsset*)avasset;
        NT_BLOCK(completion,videoAsset.URL);
    }];
    
}


@end
