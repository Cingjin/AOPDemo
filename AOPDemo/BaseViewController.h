//
//  BaseViewController.h
//  AOPDemo
//
//  Created by Anmo on 2021/2/20.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class DataCubModel;

@interface BaseViewController : UIViewController

/** @abstract 记录模型*/
@property (nonatomic ,strong) DataCubModel  * cubModel;

@end

NS_ASSUME_NONNULL_END
