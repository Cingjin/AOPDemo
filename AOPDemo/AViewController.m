//
//  AViewController.m
//  AOPDemo
//
//  Created by Anmo on 2021/2/20.
//

#import "AViewController.h"
#import "BViewController.h"

@interface AViewController ()

@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController presentViewController:[BViewController new] animated:YES completion:^{
            
    }];
}

@end
