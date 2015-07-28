//
//  YGaoDeMapUtils.h
//
//  Created by lizy on 15/7/27.
//  Copyright (c) 2015年 lizy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YLocationInfo.h"

typedef void (^YGaoDeMapSuccessBlock)(YLocationInfo* yLocationInfo);
typedef void (^YGaoDeMapFailureBlock)(NSError* error);
typedef void (^YGaoDeMapPOISuccessBlock)(NSArray* poiArray);



@interface YGaoDeMapUtils : NSObject


+(void)setApiKey:(NSString*)apiKey;

/*获得用户当前位置信息 不仅经纬度
{
 address: 浙江省杭州市西湖区萍水西街44, addressComponent: {province: 浙江省, city: 杭州市, district: 西湖区, township: , neighborhood: , building: , citycode: 0571, adcode: 330106, streetNumber: {street: 萍水西街, number: 44, location: {30.300390, 120.101607}, distance: 4, direction: 东}},roads: [], roadinters: [], pois: []
 }
 
 requireExtension = YES
 
 多了如下内容
{
 roads: [Road: {uid: 0571H51F0210014268, name: 萍水西街, distance: 22, direction: 东北, location: {30.300300, 120.101000}, citycode: , width: , type: }
 roadinters: [Inter: {distance: 28, direction: 东北, location: {30.300166, 120.101447}, firstId: 0571H51F0210014268, firstName: 萍水西街, secondId: 0571H51F0210014277, secondName: 梅园路}], pois: [
 POI: {uid: B023B1DH1L, name: 布丁酒店(城西银泰城店), type: 住宿服务;宾馆酒店;经济型连锁酒店, location: {30.300747, 120.101227}, address: 萍水西街80号, tel: 0571-87698088;4008802802, distance: 51, postcode: , website: , email: , province: , pcode: , city: , citycode: , district: , adcode: , gridcode: , navipoiid: , enterLocation: {0.000000, 0.000000}, exitLocation: {0.000000, 0.000000}, weight: 0.00, match: 0.00, recommend: 0, timestamp: , direction: 西北, hasIndoorMap: 0, indoorMapProvider: , bizExtension: {rating: 0.00, cost: 0.00, starForHotel: 0, lowestPriceForHotel: 0.00, mealOrderingForDining: 0, seatOrderingForCinema: 0, ticketOrderingScenic: 0, hasGroupbuy: 0, hasDiscount: 0}, richContent: {groupbuys:[], discounts:[]}, deepContent: (null)}]
 }
 */
+(void)getUserCurrentLocationMoreInfoRequireExtension:(BOOL)requireExtension successBlock:(YGaoDeMapSuccessBlock)successBlock failure:(YGaoDeMapFailureBlock)failureBlock;


/**
 *  //获得用户当前位置信息 只有经纬度
 *
 *  @param successBlock 成功返回
 *  @param failureBlock 失败返回
 */
+(void)getUserCurrentLocationInfoSuccessBlock:(YGaoDeMapSuccessBlock)successBlock failure:(YGaoDeMapFailureBlock)failureBlock;


/**
 *  根据地址信息查询
 *  {address: 浙江省杭州市西湖区萍水西街44, addressComponent: {province: 浙江省, city: 杭州市, district: 西湖区, township: , neighborhood: , building: , citycode: 0571, adcode: 330106, streetNumber: {street: 萍水西街, number: 44, location: {30.300390, 120.101607}, distance: 4, direction: 东}}, roads: [], roadinters: [], pois: []}
 *
 *  @param addressName  地址名称
 *  @param successBlock 成功返回
 *  @param failureBlock 失败返回
 */
+(void)queryLocationInfoWithAddressName:(NSString *)addressName successBlock:(YGaoDeMapSuccessBlock)successBlock failure:(YGaoDeMapFailureBlock)failureBlock;

/**
 *  该查询功能根据关键字,查询该关键字所匹配的兴趣点信息
 {keywords:[], cities:[]}, POIs:[
 poi:{uid: B000A843G6, name: 后海公园, type: 风景名胜;公园广场;公园, location: {39.941982, 116.382622}, address: 羊房胡同, tel: , distance: 0, postcode: , website: , email: , province: , pcode: , city: , citycode: , district: , adcode: , gridcode: , navipoiid: , enterLocation: {0.000000, 0.000000}, exitLocation: {0.000000, 0.000000}, weight: 0.00, match: 0.00, recommend: 0, timestamp: , direction: , hasIndoorMap: 0, indoorMapProvider: , bizExtension: {rating: 0.00, cost: 0.00, starForHotel: 0, lowestPriceForHotel: 0.00, mealOrderingForDining: 0, seatOrderingForCinema: 0, ticketOrderingScenic: 0, hasGroupbuy: 0, hasDiscount: 0}, richContent: {groupbuys:[], discounts:[]}, deepContent: (null)}
 ]
 *  @param keyword          关键字
 *  @param cityInfo         城市信息
 *  @param requireExtension 是否需要更多信息
 *  @param successBlock     成功返回
 *  @param failureBlock     失败返回
 */
+(void)queryPoiByKeyword:(NSString *)keyword cityInfo:(NSString*)cityInfo requireExtension:(BOOL)requireExtension  successBlock:(YGaoDeMapPOISuccessBlock)successBlock  failure:(YGaoDeMapFailureBlock)failureBlock;


/**
 *  该查询可以实现以某一地理坐标点为圆心,指定半径和指定关键字附近的兴趣点信息
 *
 *  @param latitude         纬度
 *  @param longitude        经度
 *  @param cityInfo         城市信息
 *  @param requireExtension 是否需要更多信息
 *  @param successBlock     成功返回
 *  @param failureBlock     失败返回
 */
+(void)queryPoiByAroundWithLatitude:(NSString*)latitude andLongitude:(NSString*)longitude cityInfo:(NSString*)cityInfo requireExtension:(BOOL)requireExtension successBlock:(YGaoDeMapPOISuccessBlock)successBlock failure:(YGaoDeMapFailureBlock)failureBlock;
@end
