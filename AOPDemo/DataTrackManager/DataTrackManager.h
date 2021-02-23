//
//  DataTrackManager.h
//  AOPDemo
//
//  Created by Anmo on 2021/2/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataTrackManager : NSObject

/** @abstract 别名字典*/
@property (nonatomic ,strong) NSDictionary  * cubMapp;


+ (instancetype)shareInstance;

+ (void)jrys_startHook;

@end

NS_ASSUME_NONNULL_END
