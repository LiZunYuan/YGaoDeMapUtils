//
//  AppDelegate.m
//  YGaoDeMapUtilsDem
//
//  Created by lizy on 15/7/27.
//  Copyright (c) 2015年 lizy. All rights reserved.
//

#import "AppDelegate.h"
#import "YTableViewController.h"
#import "YGaoDeMapUtils.h"



@interface AppDelegate ()

@end

@implementation AppDelegate{

    

}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    YTableViewController* yTableViewController = [[YTableViewController alloc]init];
    UINavigationController* navi = [[UINavigationController alloc]initWithRootViewController:yTableViewController];
    
    self.window.rootViewController = navi;
    
    //设置Key
    [YGaoDeMapUtils setApiKey:@"aa87695ed0f4d1afaf3919a966ff772e"];
    




    


    

    return YES;
}




@end
