//
//  DataCubModel.h
//  AOPDemo
//
//  Created by Anmo on 2021/2/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataCubModel : NSObject

/** @abstract 上一个页面名称*/
@property (nonatomic ,copy) NSString  * lastPageName;

/** @abstract 当前页面名称*/
@property (nonatomic ,copy) NSString  * curPageName;


@end

NS_ASSUME_NONNULL_END
