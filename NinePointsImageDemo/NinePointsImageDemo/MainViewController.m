//
//  MainViewController.m
//  NinePointsImageDemo
//
//  Created by mjbest on 2017/11/17.
//  Copyright © 2017年 chinaway. All rights reserved.
//

#import "MainViewController.h"
#import "NinePointsViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clickStretchingWithOnesMorePoints:(id)sender {

    NinePointsViewController *controller = [[NinePointsViewController alloc] initWithNibName:@"NinePointsViewController" bundle:nil];
    controller.picName = @"btn_login_normal";
    [self.navigationController pushViewController:controller animated:NO];
}
- (IBAction)clickStretchingWithSinglePoints:(id)sender {
    
    NinePointsViewController *controller = [[NinePointsViewController alloc] initWithNibName:@"NinePointsViewController" bundle:nil];
    controller.picName = @"stretchingOnesPointsssss";
    [self.navigationController pushViewController:controller animated:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
