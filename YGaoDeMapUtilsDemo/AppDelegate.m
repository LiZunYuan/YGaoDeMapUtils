//
//  AppDelegate.m
//  YGaoDeMapUtilsDem
//
//  Created by lizy on 15/7/27.
//  Copyright (c) 2015年 lizy. All rights reserved.
//

#import "AppDelegate.h"
#import "YGaoDeMapUtils.h"
#import <MAMapKit/MAMapKit.h>


#define IOS9_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending )
#define IOS8_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )

@interface AppDelegate ()<CLLocationManagerDelegate>

@end

@implementation AppDelegate{
    CLLocationManager* _locationmanager;
    

}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    
    
    //授权
    _locationmanager = [[CLLocationManager alloc] init];
    if(IOS8_OR_LATER){
        _locationmanager = [[CLLocationManager alloc] init];
        [_locationmanager requestAlwaysAuthorization];     //NSLocationWhenInUseDescription
        if(IOS9_OR_LATER){
            //            _locationmanager.allowsBackgroundLocationUpdates = YES;
        }
        //badge权限
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
    
        _locationmanager.delegate=self;
    _locationmanager.desiredAccuracy=kCLLocationAccuracyBest;
    _locationmanager.distanceFilter=1000.0f;
    
    [_locationmanager startUpdatingLocation];
    
    
    //设置Key
    [YGaoDeMapUtils setApiKey:@"aa87695ed0f4d1afaf3919a966ff772e"];
    
    //只获得用户经纬度
    [YGaoDeMapUtils getUserCurrentLocationInfoSuccessBlock:^(YLocationInfo *yLocationInfo) {
        NSLog(@"1查");
    } failure:^(NSError *error) {
        NSLog(@"1%@",error);
    }];
    
    
    
    //获得用户经纬度之外  再获得额外信息，如地区编码，城市等信息
    [YGaoDeMapUtils getUserCurrentLocationMoreInfoRequireExtension:NO successBlock:^(YLocationInfo *yLocationInfo) {
        NSLog(@"2查");
    } failure:^(NSError *error) {
        NSLog(@"2%@",error);
    }];
    
    
    [YGaoDeMapUtils getUserCurrentLocationMoreInfoRequireExtension:YES successBlock:^(YLocationInfo *yLocationInfo) {
        NSLog(@"3查");
    } failure:^(NSError *error) {
        NSLog(@"3%@",error);
    }];
    
    
    [YGaoDeMapUtils queryPoiByKeyword:@"后海" cityInfo:@"北京" requireExtension:YES successBlock:^(NSArray *poiArray) {
        NSLog(@"4查");
    } failure:^(NSError *error) {
        NSLog(@"4%@",error);
    }];
    
    
    [YGaoDeMapUtils queryLocationInfoWithAddressName:@"瑞博国际" successBlock:^(YLocationInfo *yLocationInfo) {
        NSLog(@"5查%@",yLocationInfo);
    } failure:^(NSError *error) {
        NSLog(@"5%@",error);
    }];
    
    
    [YGaoDeMapUtils queryPoiByAroundWithLatitude:@"30" andLongitude:@"120" cityInfo:@"北京" requireExtension:YES successBlock:^(NSArray *poiArray) {
        NSLog(@"6查");
    } failure:^(NSError *error) {
        NSLog(@"6%@",error);
    }];
    return YES;
}




@end
