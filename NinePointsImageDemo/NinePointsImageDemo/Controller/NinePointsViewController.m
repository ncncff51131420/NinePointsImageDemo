//
//  NinePointsViewController.m
//  NinePointsImageDemo
//
//  Created by mjbest on 2017/11/17.
//  Copyright © 2017年 chinaway. All rights reserved.
//

#import "NinePointsViewController.h"
#import "NinePointsView.h"
#import "Masonry.h"

@interface NinePointsViewController (){
    NinePointsView *p_view;
}
@property (weak, nonatomic) IBOutlet UIView *ninePointsView;
@property (weak, nonatomic) IBOutlet UISlider *sliderView;

@end

@implementation NinePointsViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];

    p_view = [[NinePointsView alloc] init];
    [self.ninePointsView addSubview:p_view];
    [p_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.ninePointsView);
    }];
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:[NSString stringWithFormat:@"%@.9",_picName] ofType:@"png"];
    if (filePath) {
        UIImage *ninepatch1 = [[UIImage alloc] initWithContentsOfFile:filePath];

        if (ninepatch1) {
            [p_view initNinePatchImage:ninepatch1];
        }
    }
    [p_view redrawWithFontSize:floorf([self.sliderView value])];
}


- (IBAction)sliderValueChange:(id)sender {
    [p_view redrawWithFontSize:floorf([self.sliderView value])];

}





@end
