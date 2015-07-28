//
//  YGaoDeMapTool.m
//  YGaoDeMapUtilsDemo
//
//  Created by lizy on 15/7/27.
//  Copyright (c) 2015年 lizy. All rights reserved.
//

#import "YGaoDeMapUtils.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#include <objc/runtime.h>


@interface YGaoDeMapUtils()<AMapSearchDelegate,MAMapViewDelegate>
@end


@implementation YGaoDeMapUtils{
    MAMapView *_mapView;
    AMapSearchAPI *_search;
    BOOL _requireExtension;
    BOOL _requireMoreData;//
    YGaoDeMapSuccessBlock _gaoDeMapSuccessBlock;
    YGaoDeMapFailureBlock _gaoDeMapFailureBlock;
    
    YGaoDeMapPOISuccessBlock _gaoDeMapPOISuccessBlock;

}


-(instancetype)init
{
    self = [super init];
    if(self){
    }
    return self;
}

static char gaoDeMapToolArrayKey;
+(void)strongSelf:(YGaoDeMapUtils*)gaoDeMapTool{
    NSMutableArray* gaoDeMapToolArray =  objc_getAssociatedObject([UIApplication sharedApplication].delegate, &gaoDeMapToolArrayKey);
    if(gaoDeMapToolArray == nil){
        gaoDeMapToolArray = [NSMutableArray array];
    }
    [gaoDeMapToolArray addObject:gaoDeMapTool];
    
    objc_setAssociatedObject([UIApplication sharedApplication].delegate, &gaoDeMapToolArrayKey, gaoDeMapToolArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

+(void)releaseSelf:(YGaoDeMapUtils*)gaoDeMapTool
{
    NSMutableArray* gaoDeMapToolArray =  objc_getAssociatedObject([UIApplication sharedApplication].delegate, &gaoDeMapToolArrayKey);
    [gaoDeMapToolArray removeObject:gaoDeMapTool];
    
    if(gaoDeMapToolArray.count == 0){
        objc_setAssociatedObject([UIApplication sharedApplication].delegate, &gaoDeMapToolArrayKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}


+(void)getUserCurrentLocationInfoSuccessBlock:(YGaoDeMapSuccessBlock)successBlock failure:(YGaoDeMapFailureBlock)failureBlock;
{
    YGaoDeMapUtils* gaodeMapTool = [[YGaoDeMapUtils alloc]init];
    [gaodeMapTool getUserCurrentLocationInfoSuccessBlock:successBlock failure:failureBlock];
    
    [YGaoDeMapUtils strongSelf:gaodeMapTool];
}

-(void)getUserCurrentLocationInfoSuccessBlock:(YGaoDeMapSuccessBlock)successBlock failure:(YGaoDeMapFailureBlock)failureBlock;
{
    _gaoDeMapSuccessBlock = successBlock;
    _gaoDeMapFailureBlock = failureBlock;
    
//    _search=[[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:self];
    _mapView=[[MAMapView alloc ] initWithFrame:CGRectZero];
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _mapView.delegate =self;
    _mapView.showsUserLocation = YES; //打开定位
    
}

-(void)dealloc
{
    _mapView.delegate = nil;
    _mapView = nil;
    _search.delegate = nil;
    _search = nil;
    _gaoDeMapFailureBlock = nil;
    _gaoDeMapPOISuccessBlock = nil;
    _gaoDeMapSuccessBlock = nil;
    NSLog(@"YGaoDeMapTool dealloc");
}

+(void)getUserCurrentLocationMoreInfoRequireExtension:(BOOL)requireExtension successBlock:(YGaoDeMapSuccessBlock)successBlock failure:(YGaoDeMapFailureBlock)failureBlock
{
    YGaoDeMapUtils* gaodeMapTool = [[YGaoDeMapUtils alloc]init];
    [gaodeMapTool getUserCurrentLocationMoreInfoRequireExtension:requireExtension successBlock:successBlock failure:failureBlock];
    [YGaoDeMapUtils strongSelf:gaodeMapTool];
}
-(void)getUserCurrentLocationMoreInfoRequireExtension:(BOOL)requireExtension successBlock:(YGaoDeMapSuccessBlock)successBlock failure:(YGaoDeMapFailureBlock)failureBlock
{
    _gaoDeMapSuccessBlock = successBlock;
    _gaoDeMapFailureBlock = failureBlock;
    _requireExtension = requireExtension;
    _requireMoreData = YES;
    
    _mapView=[[MAMapView alloc ] initWithFrame:CGRectZero];
    _mapView.userTrackingMode = MAUserTrackingModeFollow;
    _search=[[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:self];
    _mapView.delegate =self;
    _mapView.showsUserLocation = YES; //打开定位
}



//定位更新时的回调函数
-(void)mapView:(MAMapView*)mapView didUpdateUserLocation:(MAUserLocation*)userLocation updatingLocation:(BOOL)updatingLocation
{
    _mapView.showsUserLocation = NO;
    _mapView.userTrackingMode = MAUserTrackingModeNone;
    
    CLLocationCoordinate2D coordinate = userLocation.location.coordinate;
    
    YLocationInfo* info = [[YLocationInfo alloc]init];
    info.longitude = [NSString stringWithFormat:@"%f",coordinate.longitude];
    info.latitude = [NSString stringWithFormat:@"%f",coordinate.latitude];
    
    if(!_requireMoreData){
        _gaoDeMapSuccessBlock(info);
        [YGaoDeMapUtils releaseSelf:self];
    }
    
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension = _requireExtension;
    [_search AMapReGoecodeSearch:regeo];
    //- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response

}


-(void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    _gaoDeMapFailureBlock(error);
    [YGaoDeMapUtils releaseSelf:self];
}


- (void)searchRequest:(id)request didFailWithError:(NSError *)error
{
    _gaoDeMapFailureBlock(error);
    [YGaoDeMapUtils releaseSelf:self];
}


#pragma mark - 逆地理
/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    
    YLocationInfo* info = [[YLocationInfo alloc]init];
    info.longitude = [NSString stringWithFormat:@"%f",request.location.longitude];
    info.latitude = [NSString stringWithFormat:@"%f",request.location.latitude];
    if (response.regeocode != nil){
        NSString* locationName ;
        if ([response.regeocode.pois count]>0) {
            locationName=[NSString stringWithFormat:@"%@",[response.regeocode.pois[0] name]];
        }else{
            locationName=[NSString stringWithFormat:@"%@%@号",response.regeocode.addressComponent.streetNumber.street,response.regeocode.addressComponent.streetNumber.number];
        }
        info.locationName = locationName;
        info.provinceName = response.regeocode.addressComponent.province;
        info.cityName = response.regeocode.addressComponent.city;
        info.districtName  = response.regeocode.addressComponent.district;
        info.districtCode = response.regeocode.addressComponent.adcode;
    }
    _gaoDeMapSuccessBlock(info);
    [YGaoDeMapUtils releaseSelf:self];
}

+(void)queryLocationInfoWithAddressName:(NSString *)addressName successBlock:(YGaoDeMapSuccessBlock)successBlock failure:(YGaoDeMapFailureBlock)failureBlock
{
    YGaoDeMapUtils* gaodeMapTool = [[YGaoDeMapUtils alloc]init];
    [gaodeMapTool queryLocationInfoWithAddressName:addressName successBlock:successBlock failure:failureBlock];
    [YGaoDeMapUtils strongSelf:gaodeMapTool];
}

-(void)queryLocationInfoWithAddressName:(NSString *)addressName successBlock:(YGaoDeMapSuccessBlock)successBlock failure:(YGaoDeMapFailureBlock)failureBlock
{
    _gaoDeMapSuccessBlock = successBlock;
    _gaoDeMapFailureBlock = failureBlock;
    _search=[[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:self];
    AMapGeocodeSearchRequest* request = [[AMapGeocodeSearchRequest alloc]init];
    request.searchType = AMapSearchType_Geocode;
    request.address = addressName;
    [_search AMapGeocodeSearch:request];
    //-(void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
}

#pragma mark 地址信息
-(void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    if (response.geocodes.count != 0){
        AMapGeocode* geoCode = response.geocodes[0];
        YLocationInfo* info = [[YLocationInfo alloc]init];
        info.locationName = geoCode.formattedAddress;
        info.longitude = [NSString stringWithFormat:@"%f",geoCode.location.longitude];
        info.latitude = [NSString stringWithFormat:@"%f",geoCode.location.latitude];
        info.provinceName = geoCode.province;
        info.cityName = geoCode.city;
        info.districtName  = geoCode.district;
        _gaoDeMapSuccessBlock(info);
    }else{
        _gaoDeMapSuccessBlock(nil);
    }
    [YGaoDeMapUtils releaseSelf:self];
}


//关键字查搜索
+(void)queryPoiByKeyword:(NSString *)keyword cityInfo:(NSString*)cityInfo requireExtension:(BOOL)requireExtension  successBlock:(YGaoDeMapPOISuccessBlock)successBlock  failure:(YGaoDeMapFailureBlock)failureBlock
{
    YGaoDeMapUtils* gaodeMapTool = [[YGaoDeMapUtils alloc]init];
    [gaodeMapTool queryPoiByKeyword:keyword cityInfo:cityInfo requireExtension:requireExtension successBlock:successBlock failure:failureBlock];
    [YGaoDeMapUtils strongSelf:gaodeMapTool];
}
//关键字查搜索
-(void)queryPoiByKeyword:(NSString *)keyword cityInfo:(NSString*)cityInfo requireExtension:(BOOL)requireExtension  successBlock:(YGaoDeMapPOISuccessBlock)successBlock  failure:(YGaoDeMapFailureBlock)failureBlock
{
    _gaoDeMapPOISuccessBlock = nil;
    _gaoDeMapPOISuccessBlock = successBlock;
    _gaoDeMapFailureBlock = failureBlock;
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    _requireExtension = requireExtension;
    
    request.searchType          = AMapSearchType_PlaceKeyword;
    request.keywords            = keyword;
    NSString* cityStr = cityInfo;
    if(cityStr == nil){
        cityStr = @"010";
    }
    request.city                = @[cityStr];//010
    request.requireExtension    = _requireExtension;
    _search=[[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:self];
    
    [_search AMapPlaceSearch:request];
}


//周边搜索
+(void)queryPoiByAroundWithLatitude:(NSString*)latitude andLongitude:(NSString*)longitude cityInfo:(NSString*)cityInfo requireExtension:(BOOL)requireExtension successBlock:(YGaoDeMapPOISuccessBlock)successBlock failure:(YGaoDeMapFailureBlock)failureBlock
{
    YGaoDeMapUtils* gaodeMapTool = [[YGaoDeMapUtils alloc]init];
    [gaodeMapTool queryPoiByAroundWithLatitude:latitude andLongitude:longitude cityInfo:cityInfo requireExtension:requireExtension successBlock:successBlock failure:failureBlock];
    [YGaoDeMapUtils strongSelf:gaodeMapTool];
}
-(void)queryPoiByAroundWithLatitude:(NSString*)latitude andLongitude:(NSString*)longitude cityInfo:(NSString*)cityInfo requireExtension:(BOOL)requireExtension successBlock:(YGaoDeMapPOISuccessBlock)successBlock failure:(YGaoDeMapFailureBlock)failureBlock
{
    _gaoDeMapPOISuccessBlock = nil;
    _gaoDeMapPOISuccessBlock = successBlock;
    _gaoDeMapFailureBlock = failureBlock;
    AMapPlaceSearchRequest *request = [[AMapPlaceSearchRequest alloc] init];
    _requireExtension = requireExtension;
    
    request.searchType          = AMapSearchType_PlaceAround;
    request.location           = [AMapGeoPoint locationWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
    NSString* cityStr = cityInfo;
    if(cityStr == nil){
        cityStr = @"010";
    }
    request.city                = @[cityStr];//010
    request.requireExtension    = _requireExtension;
    if(_search == nil){
        _search=[[AMapSearchAPI alloc] initWithSearchKey:[MAMapServices sharedServices].apiKey Delegate:self];
    }
    [_search AMapPlaceSearch:request];
}


/* POI 搜索回调. */
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)respons
{
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:respons.pois.count];
    
    [respons.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        YLocationInfo* info = [[YLocationInfo alloc]init];
        info.locationName = obj.name;
        info.latitude = [NSString stringWithFormat:@"%f",obj.location.latitude ];
        info.longitude = [NSString stringWithFormat:@"%f",obj.location.longitude ];
        info.provinceName = obj.province;
        info.cityName = obj.city;
        info.districtName = obj.district;
        info.addressName = obj.address;
        
        info.districtCode = obj.adcode;
        [poiAnnotations addObject:info];
        
    }];
    _gaoDeMapPOISuccessBlock(poiAnnotations);
    [YGaoDeMapUtils releaseSelf:self];
}


+(void)setApiKey:(NSString*)apiKey
{
    [MAMapServices sharedServices].apiKey = apiKey;
}

@end
