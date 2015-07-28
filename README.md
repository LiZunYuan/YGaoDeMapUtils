# YGaoDeMapUtils
高德地图工具类，使用Blocks调用方法

使用方法

######首先设置下高德的Key(需要到高德官网绑定下 [传送门](http://lbs.amap.com/console/key)
    [YGaoDeMapUtils setApiKey:@"apiKey"];


1.仅获得用户当前位置的经纬度

    [YGaoDeMapUtils getUserCurrentLocationInfoSuccessBlock:^(YLocationInfo *yLocationInfo) {
        NSLog(@"1查");
    } failure:^(NSError *error) {
        NSLog(@"1%@",error);
    }];
     
2.获得用户经纬度之外  再获得额外信息，如地区编码，城市等信息  RequireExtension 参数设置YES 可以获得更多

    [YGaoDeMapUtils getUserCurrentLocationMoreInfoRequireExtension:NO successBlock:^(YLocationInfo *locationInfo) {
        NSLog(@"2查");
    } failure:^(NSError *error) {
        NSLog(@"2%@",error);
    }];
    
    
    
3.该查询功能根据关键字,查询该关键字所匹配的兴趣点信息

    [YGaoDeMapUtils queryPoiByKeyword:@"后海" cityInfo:@"北京" requireExtension:YES successBlock:^(NSArray *poiArray) {
        NSLog(@"4查");
    } failure:^(NSError *error) {
        NSLog(@"4%@",error);
    }];
    
    
5.根据地址信息查询

    
    [YGaoDeMapUtils queryLocationInfoWithAddressName:@"瑞博国际" successBlock:^(YLocationInfo *locationInfo) {
        NSLog(@"5查%@",locationInfo);
    } failure:^(NSError *error) {
        NSLog(@"5%@",error);
    }];
    
    
6.该查询可以实现以某一地理坐标点为圆心,指定半径和指定关键字附近的兴趣点信息

    [YGaoDeMapUtils queryPoiByAroundWithLatitude:@"30" andLongitude:@"120" cityInfo:@"背景" requireExtension:YES successBlock:^(NSArray *poiArray) {
        NSLog(@"6查");
    } failure:^(NSError *error) {
        NSLog(@"6%@",error);
    }];