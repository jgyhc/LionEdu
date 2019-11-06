//
//  BLTopicTextInputTableViewCell.m
//  BigLionEdu
//
//  Created by 刘聪 on 2019/8/6.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import "BLTopicTextInputTableViewCell.h"
#import "BLInputAccessoryView.h"
#import <TZImagePickerController.h>
#import "UIViewController+ORAdd.h"
#import "UIImagePickerController+NTAdd.h"
#import "ZLNetTool.h"
#import <YYWebImage.h>
#import <LCProgressHUD.h>
#import "SDPhotoBrowser.h"
#import "UIViewController+ORAdd.h"

@interface BLTopicTextInputTableViewCell ()<BLInputAccessoryViewDelegate, TZImagePickerControllerDelegate, UITextFieldDelegate, SDPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UILabel *placeholderLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) BLInputAccessoryView *inputAccessoryView;
@property (weak, nonatomic) IBOutlet UIView *imageContentView;
@property (weak, nonatomic) IBOutlet UIImageView *keyImageView;
@property (nonatomic, strong) NSArray * assets;
@property (nonatomic, strong) UIImagePickerController * imagePickerController;
@end

@implementation BLTopicTextInputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textField.delegate = self;
    [self.textField setInputAccessoryView:self.inputAccessoryView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent)];
    [self.containerView addGestureRecognizer:tap];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:self.textField];
    
    self.keyImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapEvent:)];
    [self.keyImageView addGestureRecognizer:imageTap];
}

- (void)textDidChange:(NSNotification *)notification {
    self.model.value = self.textField.text;
    if (self.model.value.length > 0) {
        self.model.type = @"text";
    }else {
        self.model.type = @"";
    }
}

- (void)imageTapEvent:(UITapGestureRecognizer *)tap {
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = 0;
    browser.sourceImagesContainerView = self.imageContentView;
    browser.imageCount = 1;
    browser.delegate = self;
    [browser show];
}

#pragma mark -- UITextFieldDelegate method
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text && textField.text.length > 0) {
        _placeholderLabel.hidden = YES;
        _textField.hidden = NO;
    }else {
        _textField.hidden = YES;
        _placeholderLabel.hidden = NO;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(textDidInput:model:)]) {
        [self.delegate textDidInput:textField.text model:_model];
    }
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index {
    return self.keyImageView.image;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _placeholderLabel.hidden = YES;
    return YES;
}


- (void)tapEvent {
    if (_model.image || [_model.type isEqualToString:@"img"]) {
        return;
    }
    _imageContentView.hidden = YES;
    _placeholderLabel.hidden = YES;
    _textField.hidden = NO;
    [_textField becomeFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)finishEvent {
    [self.textField resignFirstResponder];
}

- (IBAction)deleteImageEvent:(id)sender {
    __weak typeof(self) wself = self;
    UIAlertController *alertCon = [UIAlertController alertControllerWithTitle:@"确定删除图片吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertCon addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:nil]];
    [alertCon addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
       if (wself.delegate && [wself.delegate respondsToSelector:@selector(didImageInput:model:)]) {
            [wself.delegate didImageInput:nil model:wself.model];
        }
    }]];
    [[UIViewController currentViewController] presentViewController:alertCon animated:YES completion:nil];
    
}

- (void)photoSelectEvent {
    [self.textField resignFirstResponder];
    _placeholderLabel.hidden = YES;
    TZImagePickerController *imagePickerVc =  [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
//    imagePickerVc.selectedAssets = _assets.mutableCopy;
    [[UIViewController currentViewController] presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)uploadImageWithImage:(UIImage *)image {
    __weak typeof(self) wself = self;
    [ZLNetTool zl_upLoadWithImage:image success:^(id  _Nullable obj) {
        if ([obj[@"code"] intValue] == 200) {
            wself.model.value = obj[@"data"];
        }
   } failure:^(NSError * _Nullable error) {
       [LCProgressHUD show:error.localizedDescription];
   }];
}

- (void)cameraSelectEvent {
    __weak typeof(self) wself = self;
    [UIImagePickerController nt_showImgaePickerWithType:NTImagePickerTypeTakePhoto firstFrontCamera:NO showConfig:^(UIImagePickerController *picker) {
        wself.imagePickerController = picker;
        [[UIViewController currentViewController] presentViewController:picker animated:YES completion:nil];
    } completion:^(UIImage *selectImage) {
        if (selectImage) {
            [wself uploadImageWithImage:selectImage];
            if (wself.delegate && [wself.delegate respondsToSelector:@selector(didImageInput:model:)]) {
                [wself.delegate didImageInput:selectImage model:wself.model];
            }
        }
    } failed:^(NTImagePickerShowErrorType errorType) {
        
    }];
}

- (void)setModel:(BLFillTopicKeyModel *)model {
    _model = model;
    [self updateView];
}

- (void)updateView {
    if (_model.type.length == 0) {
        _placeholderLabel.hidden = NO;
        _imageContentView.hidden = YES;
        _textField.hidden = YES;
    }else {
        _placeholderLabel.hidden = YES;
        if ([_model.type isEqualToString:@"text"]) {
            _imageContentView.hidden = YES;
            _textField.hidden = NO;
            if (_model.value && _model.value.length > 0) {
                _textField.text = _model.value;
                _textField.hidden = NO;
            }else {
                _textField.hidden = YES;
            }
        }
        if ([_model.type isEqualToString:@"img"]) {
            _imageContentView.hidden = NO;
            _textField.hidden = YES;
            if (_model.image) {
                _imageContentView.hidden = NO;
                _keyImageView.image = _model.image;
            }else {
                if (_model.value && _model.value.length > 0) {
                    [_keyImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", IMG_URL, _model.value]] placeholder:[UIImage imageNamed:@"b_placeholder"]];
                }else {
                    _imageContentView.hidden = YES;
                }
            }
        }
    }
}

#pragma mark -- TZImagePickerControllerDelegate method
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
//    _assets = assets;
    UIImage *image = photos[0];
    [self uploadImageWithImage:image];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didImageInput:model:)]) {
        [self.delegate didImageInput:image model:_model];
    }
}

- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    [self updateView];
}

- (BLInputAccessoryView *)inputAccessoryView {
    if (!_inputAccessoryView) {
        _inputAccessoryView = [[BLInputAccessoryView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        _inputAccessoryView.delegate = self;
    }
    return _inputAccessoryView;
}

@end
