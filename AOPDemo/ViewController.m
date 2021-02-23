//
//  ViewController.m
//  AOPDemo
//
//  Created by Anmo on 2021/2/20.
//

#import "ViewController.h"
#import "Aspects.h"
#import "Person.h"
#import <objc/runtime.h>
#import "AViewController.h"

@interface ViewController ()

/** @abstract person*/
@property (nonatomic ,strong) Person  * person;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.person aspect_hookSelector:@selector(eat) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo>aspectInfo){
        NSLog(@"1231：%@",aspectInfo);
    } error:nil];

    Class catMetal = objc_getMetaClass(NSStringFromClass(Person.class).UTF8String);
    [catMetal aspect_hookSelector:@selector(drank) withOptions:AspectPositionBefore usingBlock:^(){
        NSLog(@"aspectFee");
    } error:NULL];    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
   
//    [self.person eat];
//    [Person drank];
    [self.navigationController pushViewController:[AViewController new] animated:YES];
}

- (Person *)person
{
    if (!_person) {
        _person = [Person new];
    }
    return _person;
}

@end
