# NinePointsImageDemo
deal ninePoints

现在已经引入pod管理，可以直接：'MJNinePatch','~>0.0.3’


1.网上其实有其他写的支持点9图变化的demo，但是基本都不满足需求，因为对点9的认识还是比较肤浅的。

2.作为android过来的同学。点9图在左边，上边是可能会有多个点的情况，而每个点拉伸的长度就是按照黑边的长度等比例来拉伸的

3.点9图右边和底部的黑边要求只能是一条，代表的意思是内容填充区，在内容超过这个区域后，图片才进行拉伸

etc。。。

本方法主要结合系统方法和一些自己的处理，使之适应各种情况下的点9图片拉伸变化（包括多方向多点和有无内容填充区的支持）。并在testResources文件夹下放了一些图片，方便大家测试 ，只需要修改MainViewController中传递的参数即可

供外部提供了下面三个使用方法：


//传入点9图片。stretchingSize为需要拉伸到的宽高，
此一般用作单纯的图片拉伸

-(UIImage *)drawNinePatchImage:(UIImage *)image stretchingSize:(CGSize)stretchingSize;

//image 传入点9图片
//contenttext为显示文本，
//textFont 为文本字体大小
//viewMaxSize为显示的最大宽高，默认优先拉伸宽度，宽度达到上限拉伸高度，高度达到最大时候不在拉伸
//此一般用作固定的文本，然后输入背景，比如聊天记录中的泡泡和文字
-(UIImage *)drawNinePatchImage:(UIImage *)image contentText:(NSString *)contentText textFont:(UIFont *)font  viewMaxSize:(CGSize)viewMaxSize;

//作为内容填充者，还有两种需求，1.做内容背景的时候，直接设置最大输入内容区域背景 ，这个在NinePointsViewController提供了inputContentToDisplayTheMaximumBackgroundImage这个事例方法给大家看看
2.做输入背景的时候，根据输入内容大小不停变化背景大小。这个在NinePointsViewController提供了inputContentToDisplayTheChangeBackgroundImage
事例给大家看看。基本原理就是就输入区域后放置一个image，然后文本内容变化的时候根据内容不停的变化大小。提供了一个gif效果图：
![img](https://github.com/mjlovelf/NinePointsImageDemo/blob/master/NinePointsImageDemo/NinePointsImageDemo/testResources/文字变化的时候处理方式.gif)
1. In fact, there are several demo of the change of support point 9 on the Internet, 
but it is either very old or not satisfying the requirements.
2. As an android student. The point 9 is shown on the left side,
which may have multiple points, and the length of each point is stretched according to the length of the black side
3. The black edge requirement on the right and bottom of the point 9 graph can only be one, 
which means that the content fills the area. After the content exceeds this area, the image will be stretched

Etc...
This method mainly combines the system method and some of its own processing to make it adapt to the changes of the point 9 images in various situations (including the support of multi-direction and the presence of content filling areas). And I've put some images in the testResources folder so that you can test them and just modify the parameters passed in the mainview controller

The following three usage methods are provided externally:


// incoming point 9 image. StretchingSize is the width that needs to be stretched,
This is generally used for simple picture stretching

- (UIImage *) drawNinePatchImage: UIImage *) image stretchingSize (CGSize) stretchingSize;

//image incoming point 9 image
//contenttext is the display text,
//textFont size is text font size
//viewMaxSize is the maximum width shown, the default preferred stretch width, the width reaches the maximum tensile height, and the height reaches the maximum when it is not stretched
// this is generally used as a fixed text, and then input background, such as bubbles and text in chat records
(UI image *)image contentText:(NSString *) content_viewmaxsize (CGSize)viewMaxSize;

/ / as a filler content, there are two kinds of demand, 1. The content background set maximum input content area directly, this in NinePointsViewController provides inputContentToDisplayTheMaximumBackgroundImage this case method for everyone to see
2. When entering background, change the background size according to the input content. This provides inputContentToDisplayTheChangeBackgroundImage in NinePointsViewController
Let me give you an example. The basic principle is to put an image after the input area, and then change the text content according to the change of content. Provides a GIF rendering




other：
 ![img](https://github.com/mjlovelf/NinePointsImageDemo/blob/master/ddd.gif)

if find some question or other suggest please tell me QQ:515588601@qq.com.

