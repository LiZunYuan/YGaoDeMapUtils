//
//  LZYLocationInfo.m
//  YGaoDeMapUtilsDemo
//
//  Created by lizy on 15/7/28.
//  Copyright (c) 2015年 lizy. All rights reserved.
//

#import "YLocationInfo.h"

@implementation YLocationInfo




/*
 
 
 
 @property(nonatomic,copy) NSString* locationName;//位置显示名称
 @property(nonatomic,copy) NSString* latitude;//纬度
 @property(nonatomic,copy) NSString* longitude;//经度
 @property(nonatomic,copy) NSString* provinceName;//省名
 @property(nonatomic,copy) NSString* cityName;//城市名
 @property(nonatomic,copy) NSString* districtName;//地区名
 
 @property(nonatomic,copy) NSString* districtCode;//地区编码
 
 @property(nonatomic,copy) NSString* addressName;//地址
 
 
 
 */

-(NSString *)description
{
    NSMutableString* result = [NSMutableString stringWithString:@""];
    [result appendFormat:@"经度:%@\n",_longitude];
    [result appendFormat:@"纬度:%@\n",_latitude];
    [result appendFormat:@"位置显示名称度:%@\n",_locationName];
    [result appendFormat:@"省名:%@\n",_provinceName];
    [result appendFormat:@"城市名:%@\n",_cityName];
    [result appendFormat:@"地区名:%@\n",_districtName];
    [result appendFormat:@"地区编码:%@\n",_districtCode];
    [result appendFormat:@"地址:%@\n",_addressName];
    
    
    
    return result;
}

@end
