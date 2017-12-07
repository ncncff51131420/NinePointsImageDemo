//
//  NinePointsViewController.m
//  NinePointsImageDemo
//
//  Created by mjbest on 2017/11/17.
//  Copyright © 2017年 chinaway. All rights reserved.
//

#import "NinePointsViewController.h"
#import "Masonry.h"
#import "NinePatchManager.h"

@interface NinePointsViewController ()<UITextViewDelegate>{
    UIImage *ninepatch1;
    UIImageView *imageView ;
}
@property (strong, nonatomic)  UITextView * inputTextView;
@property (weak, nonatomic) IBOutlet UISlider *sliderView;
@property (weak, nonatomic) IBOutlet UIView *ninePointsView;

@end

@implementation NinePointsViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self inputContentToDisplayTheChangeBackgroundImage];
}


/**
 做内容背景的时候，直接设置最大输入内容区域背景
 */
-(void)inputContentToDisplayTheMaximumBackgroundImage{
    _inputTextView = [[UITextView alloc] init];
    [self.ninePointsView addSubview:_inputTextView];
    _inputTextView.font = [UIFont systemFontOfSize:18];
    _inputTextView.delegate = self;

    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:[NSString stringWithFormat:@"%@.9",_picName] ofType:@"png"];
    if (filePath) {
        ninepatch1 = [[UIImage alloc] initWithContentsOfFile:filePath];

        if (ninepatch1) {
            NinePatchContentRange * contentRange = [[NinePatchManager alloc] getBackgroundImageConstraints:ninepatch1];
            [_inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.ninePointsView.mas_left).offset(contentRange.leftEdgeDistance);
                make.right.equalTo(self.ninePointsView.mas_right).offset(-contentRange.rightEdgeDistance);
                make.top.equalTo(self.ninePointsView.mas_top).offset(-contentRange.topEdgeDistance);
                make.bottom.equalTo(self.ninePointsView.mas_bottom).offset(contentRange.bottomEdgeDistance);
            }];
            UIImage *image =  [[NinePatchManager alloc] drawNinePatchImage:ninepatch1 stretchingSize:CGSizeMake(self.inputTextView.bounds.size.width-contentRange.leftEdgeDistance -contentRange.rightEdgeDistance, self.inputTextView.bounds.size.height-contentRange.topEdgeDistance -contentRange.bottomEdgeDistance)];
             _inputTextView.backgroundColor = [UIColor clearColor];
            self.inputTextView.layer.contents = (id)image.CGImage;
            self.inputTextView.layer.backgroundColor = [UIColor clearColor].CGColor;
        }
    }
}


/**
 做输入背景的时候，根据输入内容大小不停变化背景大小
 */
- (void)inputContentToDisplayTheChangeBackgroundImage{

    imageView = [[UIImageView alloc] init];
    [self.ninePointsView addSubview:imageView];
    _inputTextView = [[UITextView alloc] init];
    [self.ninePointsView addSubview:_inputTextView];
    _inputTextView.delegate = self;

    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *filePath = [mainBundle pathForResource:[NSString stringWithFormat:@"%@.9",_picName] ofType:@"png"];
    if (filePath) {
        ninepatch1 = [[UIImage alloc] initWithContentsOfFile:filePath];

        if (ninepatch1) {
            NinePatchContentRange * contentRange = [[NinePatchManager alloc] getBackgroundImageConstraints:ninepatch1];
            [_inputTextView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.ninePointsView.mas_left).offset(contentRange.leftEdgeDistance);
                make.right.equalTo(self.ninePointsView.mas_right).offset(-contentRange.rightEdgeDistance);
                make.top.equalTo(self.ninePointsView.mas_top).offset(contentRange.topEdgeDistance);
                make.bottom.equalTo(self.ninePointsView.mas_bottom).offset(-contentRange.bottomEdgeDistance);
            }];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.inputTextView.mas_left).offset(-contentRange.leftEdgeDistance);
                make.top.equalTo(self.inputTextView.mas_top).offset(-contentRange.topEdgeDistance);
            }];
            [self drawBackgroundImageView:self.inputTextView];

        }
    }
}
- (void)textViewDidChange:(UITextView *)textView
{
    [self drawBackgroundImageView:textView];
}

- (IBAction)sliderValueChange:(id)sender {
//    [p_view redrawWithFontSize:floorf([self.sliderView value])];

}

- (void)drawBackgroundImageView:(UITextView *)textView{

    CGSize size =  [textView sizeThatFits:textView.bounds.size];
    UIImage *image =  [[NinePatchManager alloc] drawNinePatchImage:ninepatch1 stretchingSize:CGSizeMake(size.width, size.height)];
    textView.backgroundColor = [UIColor clearColor];
    imageView.image = image;
}
@end
