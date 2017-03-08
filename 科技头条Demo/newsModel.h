//
//  newsModel.h
//  科技头条Demo
//
//  Created by locklight on 17/3/8.
//  Copyright © 2017年 LockLight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface newsModel : NSObject

/**
 新闻的id
 */
@property (nonatomic, copy) NSString *id;

/**
 新闻的标题
 */
@property (nonatomic, copy) NSString *title;

/**
 新闻的图片
 */
@property (nonatomic, copy) NSString *src_img;

/**
 新闻的来源
 */
@property (nonatomic, copy) NSString *sitename;

/**
 新闻的发布时间
 */
@property (nonatomic, copy) NSString *addtime;

@end


