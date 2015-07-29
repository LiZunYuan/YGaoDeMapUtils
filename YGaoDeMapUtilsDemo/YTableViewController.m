//
//  YTableViewController.m
//  YGaoDeMapUtilsDemo
//
//  Created by lizy on 15/7/29.
//  Copyright (c) 2015年 lizy. All rights reserved.
//

#import "YTableViewController.h"
#import "YGaoDeMapUtils.h"
#import <MAMapKit/MAMapKit.h>
#import "MBProgressHUD.h"


#define IOS7_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS8_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )
#define IOS9_OR_LATER		( [[[UIDevice currentDevice] systemVersion] compare:@"9.0"] != NSOrderedAscending )


#define kCellIndentifier @"cellIndentifier"

@interface YTableViewController ()

@end

@implementation YTableViewController{
    CLLocationManager* _locationmanager;
}

-(instancetype)init
{
    self = [super init];
    if(self){
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
        

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellIndentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIndentifier];
    }
    [cell.detailTextLabel setTextColor:[UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:1]];

    switch (indexPath.row) {
        case 0:{
            cell.textLabel.text = @"获得经纬度";
            cell.detailTextLabel.text = @"无需请求网络,不耗流量";
            break;
        }
        case 1:{
            cell.textLabel.text = @"获得经纬度 再获得额外信息";
            cell.detailTextLabel.text = @"额外信息如 如地区编码，城市等信息";
            break;
        }
        case 2:{
            cell.textLabel.text = @"关键字查搜索兴趣点信息";
            cell.detailTextLabel.text = @"关键字:后海 城市:北京";
            break;
        }
        case 3:{
            cell.textLabel.text = @"根据地址名称查询经纬度等信息";
            cell.detailTextLabel.text = @"地区名:瑞博国际";
            break;
        }
        case 4:{
            cell.textLabel.text = @"查询周围兴趣点信息" ;
            cell.detailTextLabel.text = @"经度 120.096764 纬度 30.302628";
            break;
            ;
        }
            
        default:
            break;
    }
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    
    
    UIAlertView* alterView = [[UIAlertView alloc]initWithTitle:@"结果" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    switch (indexPath.row) {
        case 0:{
            //只获得用户经纬度
            [YGaoDeMapUtils getUserCurrentLocationInfoSuccessBlock:^(YLocationInfo *yLocationInfo) {
                [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                alterView.message = [NSString stringWithFormat:@"%@ %@",yLocationInfo.longitude,yLocationInfo.latitude ];
                [alterView show];
            } failure:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                alterView.message = [NSString stringWithFormat:@"获取信息失败 错误信息%@",error];
                [alterView show];
            }];
            break;
        }
        case 1:{
            [YGaoDeMapUtils getUserCurrentLocationMoreInfoRequireExtension:NO successBlock:^(YLocationInfo *yLocationInfo) {
                [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                alterView.message = [NSString stringWithFormat:@"%@",yLocationInfo];
                [alterView show];
            } failure:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                alterView.message = [NSString stringWithFormat:@"获取信息失败 错误信息%@",error];
                [alterView show];
            }];
            break;
        }
        case 2:{
            [YGaoDeMapUtils queryPoiByKeyword:@"后海" cityInfo:@"北京" requireExtension:NO successBlock:^(NSArray *poiArray) {
                [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                alterView.message = [self replaceUnicode:[NSString stringWithFormat:@"%@",poiArray]];
                [alterView show];
            } failure:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                alterView.message = [NSString stringWithFormat:@"获取信息失败 错误信息%@",error];
                [alterView show];
            }];
            break;
        }
        case 3:{
            [YGaoDeMapUtils queryLocationInfoWithAddressName:@"瑞博国际" successBlock:^(YLocationInfo *yLocationInfo) {
                [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                alterView.message = [NSString stringWithFormat:@"%@",yLocationInfo];
                [alterView show];
            } failure:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                alterView.message = [NSString stringWithFormat:@"获取信息失败 错误信息%@",error];
                [alterView show];
            }];
            break;
        }
        case 4:{
            [YGaoDeMapUtils queryPoiByAroundWithLatitude:@"30.302628" andLongitude:@"120.096764" cityInfo:nil requireExtension:NO successBlock:^(NSArray *poiArray) {
                [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                alterView.message = [self replaceUnicode:[NSString stringWithFormat:@"%@",poiArray]];
                [alterView show];
            } failure:^(NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view.window animated:YES];
                alterView.message = [NSString stringWithFormat:@"获取信息失败 错误信息%@",error];
                [alterView show];
            }];
            break;
        }
            
        default:
            break;
    }
}

//unicode 转 中文
- (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

@end
