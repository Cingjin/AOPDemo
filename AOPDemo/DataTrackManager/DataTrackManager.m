//
//  DataTrackManager.m
//  AOPDemo
//
//  Created by Anmo on 2021/2/20.
//

#import "DataTrackManager.h"
#import "BaseViewController.h"
#import "DataCubModel.h"
#import "Aspects.h"
#import <objc/runtime.h>

@interface DataTrackManager ()

/** @abstract 上一个页面名称*/
@property (nonatomic ,copy) NSString  * lastPageName;

/** @abstract 当前页面名称*/
@property (nonatomic ,copy) NSString  * curPageName;


@end

@implementation DataTrackManager

static DataTrackManager * _instance = nil;

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

+ (void)jrys_startHook
{
    // Hook viewDidLoad
    [self jrys_hookViewDidLoad];
    // Hook viewDidAppear
    [self jrys_hookViewDidAppear];
    // Hook viewDidDisappear:
    [self jrys_hookViewDidDisappear];
}

// Hook viewDidLoad
+ (void)jrys_hookViewDidLoad
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [BaseViewController aspect_hookSelector:@selector(viewDidLoad) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo){
            BaseViewController * baseVC = aspectInfo.instance;
            if (!baseVC.cubModel) baseVC.cubModel = [DataCubModel new];
            // 未设置别名的控制设置别名
            if (baseVC.cubModel.curPageName == nil) {
                NSDictionary *dict = [DataTrackManager shareInstance].cubMapp;
                [dict enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
                    __block BOOL isContain = NO;
                    if ([obj containsString:@","]) {
                        NSArray *objArr = [obj componentsSeparatedByString:@","];
                        [objArr enumerateObjectsUsingBlock:^(NSString *obj1, NSUInteger idx, BOOL *stop1) {
                            if ([obj1 isEqualToString:NSStringFromClass([baseVC class])]) {
                                isContain = YES;
                                *stop1 = YES;
                            }
                        }];
                    }else{
                        if ([obj isEqualToString:NSStringFromClass([baseVC class])]) {
                            isContain = YES;
                        }
                    }
                    if (isContain) {
                        if ([key containsString:@"|"]) {
                            key = [[key componentsSeparatedByString:@"|"] firstObject];
                        }
                        baseVC.cubModel.curPageName = key;
                        *stop = YES;
                    }
                }];
            }
            if (baseVC.cubModel.curPageName == nil) {
                baseVC.cubModel.curPageName = NSStringFromClass([baseVC class]);
            }
            NSLog(@"viewDidLoad:\ncurPage:%@\n",baseVC.cubModel.curPageName);
        } error:NULL];
    });
}

// Hook viewDidAppear
+ (void)jrys_hookViewDidAppear
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [BaseViewController aspect_hookSelector:@selector(viewDidAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo,BOOL animated){
            BaseViewController * baseVC = aspectInfo.instance;
            UITabBarController *presentVC = (UITabBarController *)baseVC.presentingViewController;
            NSString *lasePage = [[DataTrackManager shareInstance].lastPageName copy];
            NSString *curPage = [[DataTrackManager shareInstance].curPageName copy];
            
            UINavigationController *navi;
            if(presentVC) {//只有modal出来的才会走
                if ([presentVC isKindOfClass:[UITabBarController class]]) {
                    navi = [presentVC selectedViewController];
                } else if([presentVC isKindOfClass:[UINavigationController class]]){
                    navi = (UINavigationController *)presentVC;
                }
            } else {
                navi = baseVC.navigationController;
            }
            NSArray *viewcontrollers = navi.viewControllers;
            BaseViewController *lastVC = nil;
            if(viewcontrollers.count >= 1){
                lastVC = [viewcontrollers objectAtIndex:viewcontrollers.count - 1];
            }
            if(lastVC && [lastVC isKindOfClass:[BaseViewController class]]){
                lasePage = lastVC.cubModel.curPageName;
                curPage = baseVC.cubModel.curPageName;
            }
            NSLog(@"viewDidAppear:\nlastPage:%@  curPage:%@\n",lasePage,curPage);
            [DataTrackManager shareInstance].lastPageName = nil;
            [DataTrackManager shareInstance].curPageName = nil;
        } error:NULL];
    });
}


// Hook viewDidDisappear
+ (void)jrys_hookViewDidDisappear
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [BaseViewController aspect_hookSelector:@selector(viewDidDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo,BOOL animated){
            BaseViewController * baseVC = aspectInfo.instance;
            //只走一次
            if (![DataTrackManager shareInstance].curPageName) {
                [DataTrackManager shareInstance].curPageName = baseVC.cubModel.curPageName;
            }
            NSLog(@"viewDidDisappear:\ncurPage:%@\n",[DataTrackManager shareInstance].curPageName);
        } error:NULL];
    });
}

#pragma mark - Lazy
 
- (NSDictionary *)cubMapp
{
    if (!_cubMapp) {
        _cubMapp = @{@"HomePage|主页控制器": @"ViewController",
                     @"APage|A控制器": @"AViewController",
                     @"BPage|B控制器": @"BViewController"};
    }
    return _cubMapp;
}

@end
