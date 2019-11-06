//
//  BLTopicModel.m
//  BigLionEdu
//
//  Created by manjiwang on 2019/9/20.
//  Copyright © 2019 LionEdu. All rights reserved.
//

#import "BLTopicModel.h"
#import <YYLabel.h>
#import <UIKit/UIKit.h>
#import <YYModel.h>
#import "NSMutableAttributedString+BLTextBorder.h"
#import "NSString+BLXmlDecomposition.h"
#import "BLTopicTextModel.h"
#import "BLTopicImageModel.h"
#import <NSArray+BlocksKit.h>
#import "BLTopicVoiceModel.h"
#import "BLTopicVideoModel.h"
#import "BLTopicFontManager.h"


@implementation BLTopicModel


+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"Id": @[@"Id", @"id"],
             @"type": @[@"type", @"questionType"],
             @"title":@[@"questionTitle", @"title"]
    };
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"optionList" : [BLTopicOptionModel class],
             @"questionList": [BLTopicModel class],
             @"fillAnswer": [BLFillTopicKeyModel class]
             };
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _judgment = -1;
    }
    return self;
}

- (void)setIsCollection:(NSString *)isCollection {
    _isCollection = isCollection;
}

- (void)setAnswerDTOList:(NSArray *)answerDTOList {
    _answerDTOList = answerDTOList;
    NSMutableArray *list = [NSMutableArray array];
    [answerDTOList enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *answer = [obj objectForKey:@"answer"];
        [list addObject:answer?answer:@""];
    }];
    _answerString = [list componentsJoinedByString:@" "];
}

- (void)setMaterial:(NSString *)material {
    _material = material;
    [self updateMaterial];
}

- (void)updateMaterial {
   if (_material && _material.length > 0) {
            NSArray *list = [_material getImageurlFromHtml];
            NSMutableArray *materialArray = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSInteger type = [[obj objectForKey:@"type"] integerValue];
                NSString *content = [obj objectForKey:@"content"];
                if (type == 0) {
                    NSMutableAttributedString *att;
                    if (idx == 0) {
                        att = [[NSMutableAttributedString alloc] initWithString:@"(材料)"];
                        att.yy_font = [BLTopicFontManager sharedInstance].titleFont;
                        att.yy_color = [UIColor colorWithRed:255/255.0 green:185/255.0 blue:0.00/255.0 alpha:1.0];
                        NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithString:content?content:@""];
                        titleAttributedString.yy_font = [BLTopicFontManager sharedInstance].titleFont;
                        titleAttributedString.yy_color = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
                        [att appendAttributedString:titleAttributedString];
                        titleAttributedString.yy_lineSpacing = 8;
                    }else {
                        att = [[NSMutableAttributedString alloc] initWithString:content?content:@""];
                        att.yy_font = [BLTopicFontManager sharedInstance].titleFont;
                        att.yy_color = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
                        att.yy_lineSpacing = 8;
                    }
                    [materialArray addObject:({
                        BLTopicTextModel *model = [BLTopicTextModel new];
                        model.attributedString = att;
                        model;
                    })];
                }
                if (type == 1) {
                    [materialArray addObject:({
                        BLTopicImageModel *model = [BLTopicImageModel new];
                        model.url = content;
                        model;
                    })];
                }
                
            }];
            if (materialArray.count == 0) {
                NSMutableAttributedString *att;
               att = [[NSMutableAttributedString alloc] initWithString:_material?_material:@""];
               att.yy_font = [BLTopicFontManager sharedInstance].titleFont;
               att.yy_color = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
               att.yy_lineSpacing = 8;
               [materialArray addObject:({
                   BLTopicTextModel *model = [BLTopicTextModel new];
                   model.attributedString = att;
                   model;
               })];
            }
            _materialArray = materialArray;
        }
}

- (void)setOptionList:(NSArray<BLTopicOptionModel *> *)optionList {
    _optionList = optionList;
}

- (void)setType:(NSString *)type {
    _type = type;
    if ([_type isEqualToString:@"判断"]) {
        NSMutableArray *optionList = [_optionList mutableCopy];
        if (!optionList) {
            optionList = [NSMutableArray array];
        }
        [optionList addObject:({
            BLTopicOptionModel *optionModel = [BLTopicOptionModel new];
            optionModel.value = @"正确";
            optionModel.moption = @"A";
            if (_judgment == 1) {
                optionModel.isSelect = YES;
            }
            optionModel;
        })];
        
        [optionList addObject:({
            BLTopicOptionModel *optionModel = [BLTopicOptionModel new];
            optionModel.value = @"错误";
            optionModel.moption = @"B";
            if (_judgment == 0) {
                optionModel.isSelect = YES;
            }
            optionModel;
        })];
        _optionList = optionList;
    }
    
}

- (void)setIsParsing:(BOOL)isParsing {
    _isParsing = isParsing;
    NSArray *answer = [_answer componentsSeparatedByString:@","];
    if ([_type isEqualToString:@"判断"]) {
        if ([_answer isEqualToString:@"错误"]) {
            answer = @[@"B"];
        }else {
            answer = @[@"A"];
        }
    }
    [_optionList enumerateObjectsUsingBlock:^(BLTopicOptionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.isParsing = isParsing;
        obj.keyStatus = 0;
        //✅、x代表正确答案,错误答案
        //背景颜色来表示选择状态：黄：选中正确，灰：选中错误，白：未选中
        [answer enumerateObjectsUsingBlock:^(NSString *  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([key isEqualToString:obj.moption]) {
                obj.isRight = YES;
                obj.keyStatus = 1;
            }
        }];
        if (obj.isSelect) {
            if(obj.keyStatus == 0) {
                obj.keyStatus = 2;
            }
        }
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self initTitleString];
}

- (NSMutableArray <BLTopicOptionModel *> *)currentTopicOptionModels {
    if (!_currentTopicOptionModels) {
        _currentTopicOptionModels = [NSMutableArray array];
    }
    return _currentTopicOptionModels;
}

- (void)initTitleString {
    NSMutableArray * titlesArray = [self htmlStringToModel:_title];
    if (titlesArray.count == 0) {
        NSMutableAttributedString *att = [NSMutableAttributedString initText:_type?_type:@"题型" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12]  strokeColor:[UIColor colorWithRed:255/255.0 green:87/255.0 blue:84/255.0 alpha:1.0] fillColor:[UIColor colorWithRed:255/255.0 green:87/255.0 blue:84/255.0 alpha:1.0] cornerRadius:5 strokeWidth:0];
         
         NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithData:[_title?_title:@"" dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil]];
         titleAttributedString.yy_font = [BLTopicFontManager sharedInstance].titleFont;
         titleAttributedString.yy_color = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
         [att yy_appendString:@"  "];
         [att appendAttributedString:titleAttributedString];
         att.yy_lineSpacing = 8;
        [titlesArray addObject:({
            BLTopicTextModel *model = [BLTopicTextModel new];
            model.attributedString = att;
            model.tagAttributedString = [att mutableCopy];
            model.contentAttributedString = titleAttributedString;
            model;
        })];
    }else {
        id obj = titlesArray[0];
        if ([obj isKindOfClass:[BLTopicTextModel class]]) {
            BLTopicTextModel *model = (BLTopicTextModel *)obj;
            NSMutableAttributedString *att = [NSMutableAttributedString initText:_type?_type:@"题型" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12]  strokeColor:[UIColor colorWithRed:255/255.0 green:87/255.0 blue:84/255.0 alpha:1.0] fillColor:[UIColor colorWithRed:255/255.0 green:87/255.0 blue:84/255.0 alpha:1.0] cornerRadius:5 strokeWidth:0];
            model.tagAttributedString = [att mutableCopy];
            model.contentAttributedString = model.attributedString;
            [att appendAttributedString:model.attributedString];
            att.yy_lineSpacing = 8;
            model.attributedString = att;
            
        }else {
            NSMutableAttributedString *att = [NSMutableAttributedString initText:_type?_type:@"题型" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:12]  strokeColor:[UIColor colorWithRed:255/255.0 green:87/255.0 blue:84/255.0 alpha:1.0] fillColor:[UIColor colorWithRed:255/255.0 green:87/255.0 blue:84/255.0 alpha:1.0] cornerRadius:5 strokeWidth:0];
            [titlesArray insertObject:({
                BLTopicTextModel *textModel = [BLTopicTextModel new];
                textModel.attributedString = att;
                textModel;
            }) atIndex:0];
        }
    }
    _titleArray = titlesArray;
}

- (NSMutableAttributedString *)titleString {
    if (!_titleString) {
        NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:[[NSAttributedString alloc] initWithData:[_title?_title:@"" dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil]];
        titleAttributedString.yy_font = [UIFont systemFontOfSize:15];
        titleAttributedString.yy_color = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
        _titleString = titleAttributedString;
    }
    return _titleString;
}

//- (NSString *)isManual {
//    if ([_type isEqualToString:@"填空"]) {
//        return @"1";
//    }
//    if ([_type isEqualToString:@"阅读"]) {
//        return @"1";
//    }
//    return @"0";
//}
- (void)setAnalysis:(NSString *)analysis {
    _analysis = analysis;
    [self initAnalysisString];
}

- (void)initAnalysisString {
    if (_analysis && _analysis.length > 0) {
        NSMutableArray * analysisArray = [self htmlStringToModel:_analysis];
        if (analysisArray.count == 0) {
            NSMutableAttributedString *att;
            att = [[NSMutableAttributedString alloc] initWithString:_analysis?_analysis:@""];
            att.yy_font = [BLTopicFontManager sharedInstance].titleFont;
            att.yy_color = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
            att.yy_lineSpacing = 8;
            [analysisArray addObject:({
                BLTopicTextModel *model = [BLTopicTextModel new];
                model.attributedString = att;
                model;
            })];
        }
        _analysisArray = analysisArray;
    }
}


- (NSMutableArray *)htmlStringToModel:(NSString *)string {
    NSArray *list = [string getImageurlFromHtml];
    NSMutableArray *array = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger type = [[obj objectForKey:@"type"] integerValue];
        NSString *content = [obj objectForKey:@"content"];
        if (type == 0) {
            NSMutableAttributedString *att;
            att = [[NSMutableAttributedString alloc] initWithString:content?content:@""];
            att.yy_font = [UIFont fontWithName:@"TsangerJinKai03-W03" size:15];
            att.yy_color = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
            att.yy_lineSpacing = 8;
            [array addObject:({
                BLTopicTextModel *model = [BLTopicTextModel new];
                model.attributedString = att;
                model;
            })];
        }
        if (type == 1) {
            [array addObject:({
                BLTopicImageModel *model = [BLTopicImageModel new];
                model.url = content;
                model;
            })];
        }
        if (type == 2) {
            [array addObject:({
                BLTopicVoiceModel *model = [BLTopicVoiceModel new];
                model.url = content;
                model;
            })];
        }
        
        if (type == 3) {
            [array addObject:({
                BLTopicVideoModel *model = [BLTopicVideoModel new];
                model.url = content;
                model;
            })];
        }
        
    }];
    return array;
}

- (float)score {
    if ([self.isManual isEqualToString:@"1"] || [self.isCorrect isEqualToString:@"0"]) {//客观题或者答错了 得0分
        return 0;
    }
    return _score;
}

- (NSString *)isCorrect {
    if ([_type isEqualToString:@"单选"]) {
        if ([_currentTopicOptionModel.moption isEqualToString:_answer]) {
            return @"1";
        }
    }
    if ([_type isEqualToString:@"多选"]) {
        NSArray *answers = [_answer componentsSeparatedByString:@","];
        if (![_answer containsString:@","]) {
            NSMutableArray *temps = [NSMutableArray array];
            for(int i =0; i < [_answer length]; i++) {
                [temps addObject:[_answer substringWithRange:NSMakeRange(i,1)]];
            }
            answers = temps;
        }
        NSMutableSet *imAnswers = [NSMutableSet setWithArray:answers];
        NSMutableSet *userAnswers = [NSMutableSet set];
        [self.currentTopicOptionModels enumerateObjectsUsingBlock:^(BLTopicOptionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [userAnswers addObject:obj.moption?obj.moption:@""];
        }];
        if (imAnswers.count != userAnswers.count) {//先判断一下 用户选的 和 正确答案数组是否一样长
            return @"0";
        }
        [imAnswers intersectSet:userAnswers];//取交集  如果原来的set变长了  就说明不对了
        if (userAnswers.count == imAnswers.count) {
            return @"1";
        }
    }
    if ([_type isEqualToString:@"判断"]) {
        if (([_answer isEqualToString:@"错误"] && _judgment == 0) || ([_answer isEqualToString:@"正确"] && _judgment == 1)) {
            return @"1";
        }
    }
    if ([_type isEqualToString:@"填空"] || [_type isEqualToString:@"简答"]) {
        if (_isSelectHelp) {
            return @"0";
        }
        __block BOOL is = YES;
        //遍历答案
        [_answerDTOList enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (self.fillAnswer.count > idx) {
                NSString *answer = [obj objectForKey:@"answer"];
                BLFillTopicKeyModel *model = self.fillAnswer[idx];
                if (![answer isEqualToString:model.value]) {
                    is = NO;
                    *stop = YES;
                }
            }
        }];
        if (is) {
            return @"1";
        }
    }
    return @"0";
}
/** 单选
{“type”:”moptionSingle”,”answer”:”A”}
多选
{“type”:”moptionMul”,”answer”:”A,B,C”}
填空
{“type”:”insert”,”answer”:[{“type”:”img”,”value”:”fileName”},{“type”:”text”,”value”:”文字”}]}
判断：
{“type”:”judgment”,”answer”:”1”}//1正确，0错误
语音（面试）
{“type”:”voice”,”answer”:[{“file”:”fileName”,”time”:”15”}]} */
- (NSDictionary *)submitAnswer {
    /** 1:单选，2多选，3：判断，4:填空， 5：阅读 etc. */
    if ([_type isEqualToString:@"单选"]) {
        if (!_currentTopicOptionModel) {
            return nil;
        }
        return @{
               @"type":@"moptionSingle",
               @"answer":_currentTopicOptionModel.moption?_currentTopicOptionModel.moption:@""
           };
    }
    if ([_type isEqualToString:@"多选"]) {
        if (_currentTopicOptionModels.count == 0) {
            return nil;
        }
        NSMutableArray *keys = [NSMutableArray array];
        [_currentTopicOptionModels enumerateObjectsUsingBlock:^(BLTopicOptionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [keys addObject:obj.moption?obj.moption:@""];
        }];
        NSString *keyString = [keys componentsJoinedByString:@","];
        return @{
            @"type":@"moptionMul",
            @"answer":keyString?keyString:@""
        };
    }
    if ([_type isEqualToString:@"判断"]) {
        if (_judgment == -1) {
            return nil;
        }
        return @{
            @"type":@"judgment",
            @"answer":@(_judgment)
        };
    }
    if ([_type isEqualToString:@"填空"] || [_type isEqualToString:@"简答"]) {
        BOOL isFinish = [_fillAnswer bk_any:^BOOL(BLFillTopicKeyModel * obj) {
            return obj.image || obj.value.length > 0;
        }];
        if (!isFinish) {
            return nil;
        }
        NSArray *list = [_fillAnswer yy_modelToJSONObject];
        return @{
            @"type":@"insert",
            @"answer": list?list:@""
        };
    }
    return nil;
}

- (void)setFillNum:(NSInteger)fillNum {
    _fillNum = fillNum;
    NSMutableArray *fillAnswer = [NSMutableArray array];
    for (NSInteger i = 0; i < _fillNum; i++) {
        [fillAnswer addObject:({
            BLFillTopicKeyModel *model = [BLFillTopicKeyModel new];
            model;
        })];
    }
    _fillAnswer = fillAnswer;
}

- (void)setEndSeconds:(NSInteger)endSeconds {
    _endSeconds = endSeconds;
    NSInteger difference = endSeconds - _startSeconds;
    if (difference < 0) {
        difference = difference * -1;
    }
    _timeInterval = difference + _timeInterval;
}

/** 单选
{“type”:”moptionSingle”,”answer”:”A”}
多选
{“type”:”moptionMul”,”answer”:”A,B,C”}
填空
{“type”:”insert”,”answer”:[{“type”:”img”,”value”:”fileName”},{“type”:”text”,”value”:”文字”}]}
判断：
{“type”:”judgment”,”answer”:”1”}//1正确，0错误
语音（面试）
{“type”:”voice”,”answer”:[{“file”:”fileName”,”time”:”15”}]} */
- (void)setMemAnswer:(NSString *)memAnswer {
    _memAnswer = memAnswer;
    NSDictionary *info = [self dictionaryWithJsonString:memAnswer];
    NSString * type = [info objectForKey:@"type"];
    if ([type isEqualToString:@"moptionSingle"]) {
        NSString *answer = [info objectForKey:@"answer"];
        [_optionList enumerateObjectsUsingBlock:^(BLTopicOptionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.moption isEqualToString:answer]) {
                obj.isSelect = YES;
                self.currentTopicOptionModel = obj;
            }
        }];
    }
    if ([type isEqualToString:@"moptionMul"]) {
        NSString *answer = [info objectForKey:@"answer"];
        NSArray *answers = [answer componentsSeparatedByString:@","];
        [_optionList enumerateObjectsUsingBlock:^(BLTopicOptionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [answers enumerateObjectsUsingBlock:^(NSString *  _Nonnull value, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([value isEqualToString:obj.moption]) {
                    obj.isSelect = YES;
                    [self.currentTopicOptionModels addObject:obj];
                }
            }];
        }];
    }
    if ([type isEqualToString:@"insert"]) {
        NSDictionary *answer = [info objectForKey:@"answer"];
        _fillAnswer = [NSArray yy_modelArrayWithClass:[BLFillTopicKeyModel class] json:answer];
    }
    if ([type isEqualToString:@"judgment"]) {
        _judgment = [[info objectForKey:@"answer"] integerValue];
        
        
    }
    
}


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

- (UIFont *)font {
    if (!_font) {
        _font = [UIFont fontWithName:@"TsangerJinKai03-W03" size:15];
    }
    return _font;
}

- (BOOL)isFinish {
    BOOL isFinish = NO;
    if ([_type isEqualToString:@"单选"]) {
        if (_currentTopicOptionModel) {
            isFinish = YES;
        }
    }
    if ([_type isEqualToString:@"填空"] || [_type isEqualToString:@"简答"]) {
        isFinish = [_fillAnswer bk_any:^BOOL(BLFillTopicKeyModel * obj) {
            return obj.image || obj.value.length > 0;
        }];
    }
    if ([_type isEqualToString:@"多选"]) {
        if (_currentTopicOptionModels.count > 0) {
            isFinish = YES;
        }
    }
    if ([_type isEqualToString:@"判断"]) {
        if (_judgment != -1) {
            isFinish = YES;
        }
    }
    return isFinish;
}

@end
