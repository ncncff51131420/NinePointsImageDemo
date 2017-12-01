# NinePointsImageDemo
deal ninePoints

现在已经引入pod管理，可以直接：'MJNinePatch','~>0.0.3’


1.网上其实有其他写的支持点9图变化的demo，但是要不很老，要不就是不满足需求。

2.作为android过来的同学。点9图在左边，上边是可能会有多个点的情况，而每个点拉伸的长度就是按照黑边的长度等比例来拉伸的

3.点9图右边和底部的黑边要求只能是一条，代表的意思是内容填充区，在内容超过这个区域后，图片才进行拉伸

etc。。。

本方法主要结合系统方法和一些自己的处理，使之适应各种情况下的点9图片拉伸变化（包括多方向多点和有无内容填充区的支持）。并在testResources文件夹下放了一些图片，方便大家测试 ，只需要修改MainViewController中传递的参数即可

使用方法如下：
//传入点9图片。stretchingSize为需要拉伸到的宽高

-(void)drawNinePatchImage:(UIImage *)image stretchingSize:(CGSize)stretchingSize;

//image 传入点9图片
//contenttext为显示文本，
//textFont 为文本字体大小
//viewMaxSize为显示的最大宽高，默认优先拉伸宽度，宽度达到上限拉伸高度，高度达到最大时候不在拉伸

-(void)drawNinePatchImage:(UIImage *)image contentText:(NSString *)contentText textFont:(UIFont *)font  viewMaxSize:(CGSize)viewMaxSize;


1. In fact, there are several demo of the change of support point 9 on the Internet, 
but it is either very old or not satisfying the requirements.
2. As an android student. The point 9 is shown on the left side,
which may have multiple points, and the length of each point is stretched according to the length of the black side
3. The black edge requirement on the right and bottom of the point 9 graph can only be one, 
which means that the content fills the area. After the content exceeds this area, the image will be stretched

Etc...


 ![img](https://github.com/mjlovelf/NinePointsImageDemo/blob/master/ddd.gif)

if find some question or other suggest please tell me QQ:515588601@qq.com.

