//
//  LZYLocationInfo.h
//  YGaoDeMapUtilsDemo
//
//  Created by lizy on 15/7/28.
//  Copyright (c) 2015年 lizy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLocationInfo : NSObject

@property(nonatomic,copy) NSString* locationName;//位置显示名称
@property(nonatomic,copy) NSString* latitude;//纬度
@property(nonatomic,copy) NSString* longitude;//经度
@property(nonatomic,copy) NSString* provinceName;//省名
@property(nonatomic,copy) NSString* cityName;//城市名
@property(nonatomic,copy) NSString* districtName;//地区名

@property(nonatomic,copy) NSString* districtCode;//地区编码

@property(nonatomic,copy) NSString* addressName;//地址




@end
