//
//  BLMyMistakeModel.h
//  BigLionEdu
//
//  Created by mac on 2019/8/30.
//  Copyright © 2019 刘聪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BLMyMistakeQuestionModel;

@interface BLMyMistakeIDotsModel : NSObject
@property (nonatomic, assign) NSInteger functionId;// (integer, optional): 功能Id ,
@property (nonatomic, assign) NSInteger modelid;// (integer, optional): 模块功能类型id ,
@property (nonatomic, copy) NSString *isDaily;// (string, optional): 每日一练:Y, 其他为N ,
@property (nonatomic, copy) NSString *isTest;// (string, optional): 1: 模考大赛，0：其他 ,
@property (nonatomic, assign) NSInteger modelId;// (integer, optional): 模块id ,
@property (nonatomic, copy) NSString *sort;// (string, optional): 展示顺序 ,
@property (nonatomic, copy) NSString *title;// (string, optional): 标题 ,
@property (nonatomic, copy) NSString *type;// (string, optional): 类型 1:题库，2：直播，3：录播，4：狮享等等


@end

@interface BLMyMistakeModel : NSObject
@property (nonatomic, copy) NSString *content;// (string, optional): 内容 ,
@property (nonatomic, copy) NSArray <BLMyMistakeModel *>*functionTypeDTOList;//(Array[KylinIndexFunctionTypeErrorDTO], optional): 题模块功能类型 ,
@property (nonatomic, assign) NSInteger modelid;// (integer, optional): id ,
@property (nonatomic, copy) NSString *img;// (string, optional): 图片 ,
@property (nonatomic, copy) NSString *sort;// (string, optional): 展示顺序 ,
@property (nonatomic, copy) NSString *title;// (string, optional): 标题

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) BOOL isPull; //是否展开

@property (readonly) NSInteger questionNum; //
@property (readonly) NSArray * questionIDData; //选中问题id集合

@property(nonatomic,copy)NSArray <BLMyMistakeQuestionModel *>*questionList;

- (void)or_changeSelect;
@end

@interface BLMyMistakeFunctionTypesModel : NSObject
@property (nonatomic, copy) NSString *allParentId;
@property (nonatomic, assign) NSInteger createBy;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *delFlag;
@property (nonatomic, assign) NSInteger doingNum;
@property (nonatomic, assign) NSInteger unctionId;
@property (nonatomic, assign) NSInteger modelid;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *introduction;
@property (nonatomic, copy) NSString *isDaily;
@property (nonatomic, copy) NSString *isFree;
@property (nonatomic, copy) NSString *isRecommend;
@property (nonatomic, copy) NSString *isTest;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, assign) NSInteger modelId;
@property (nonatomic, assign) NSInteger parentId;
@property (nonatomic, assign) NSInteger price;
@property (nonatomic, assign) NSInteger setNum;
@property (nonatomic, copy) NSString *sort;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger topPid;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger updateBy;
@property (nonatomic, copy) NSString *updateTime;

@end

@interface BLMyMistakeQuestionListModel : NSObject
@property (nonatomic, copy) NSString *analysis;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger functionTypeId;
@property (nonatomic, assign) NSInteger modelId;
@property (nonatomic, copy) NSString *isMaterial;
@property (nonatomic, copy) NSString *material;
@property (nonatomic, assign) NSInteger materialId;
@property (nonatomic, assign) NSInteger memberId;
@property (nonatomic, assign) NSInteger memberQuestionId;
@property (nonatomic, assign) NSInteger questionId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) BOOL selected;

@end



@interface BLMyMistakeQuestionModel : NSObject
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger functionTypeId;
@property (nonatomic, assign) NSInteger modelId;
@property (nonatomic, assign) NSInteger materialId;
@property (nonatomic, assign) NSInteger memberQuestionId;
@property (nonatomic, assign) NSInteger memberId;
@property (nonatomic, copy) NSString *material;
@property (nonatomic, copy) NSString *analysis;
@property (nonatomic, copy) NSString *isMaterial;
@property (nonatomic, strong) NSString *answerDTOList;
@property (nonatomic, strong) NSArray *optionList;

@property (nonatomic, assign) NSInteger questionId;
@property (nonatomic, copy) NSString *questionTitle;
@property (nonatomic, copy) NSString *questionType;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, copy) NSString *isCollection;
@property (nonatomic, copy) NSString *answer;



@end



@interface BLMyMistakeInfoModel : NSObject
@property(nonatomic,copy)NSArray <BLMyMistakeFunctionTypesModel *>*functionTypes;
@property(nonatomic,copy)NSArray <BLMyMistakeQuestionListModel *>*questionList;
@end

NS_ASSUME_NONNULL_END
