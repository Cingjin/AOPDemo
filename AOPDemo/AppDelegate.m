//
//  AppDelegate.m
//  AOPDemo
//
//  Created by Anmo on 2021/2/20.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "DataTrackManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        
    [DataTrackManager jrys_startHook];
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    [self.window makeKeyAndVisible];

    
    return YES;
}


@end
