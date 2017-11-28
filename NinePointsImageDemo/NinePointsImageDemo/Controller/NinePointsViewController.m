//
//  NinePointsViewController.m
//  NinePointsImageDemo
//
//  Created by mjbest on 2017/11/17.
//  Copyright © 2017年 chinaway. All rights reserved.
//

#import "NinePointsViewController.h"
#import "UIImage+NinePoints.h"
#import "NinePatchUtils.h"
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
            NinePatchContentRange *contentRange = [ninepatch1  getImageContentRange];
            NSArray *ninePatchs = [ninepatch1 getAllNinePatchAreaPoint:ninepatch1];

            [p_view setContentRange:contentRange];
            [p_view setNinePatchAry:ninePatchs];
            [p_view setNinePatchImage:[NinePatchUtils  crop:CGRectMake(1, 1, ninepatch1.size.width - 2, ninepatch1.size.height - 2) image:ninepatch1]];
        }
    }
    [p_view redrawWithFontSize:floorf([self.sliderView value])];
}


- (IBAction)sliderValueChange:(id)sender {
    [p_view redrawWithFontSize:floorf([self.sliderView value])];

}





@end
