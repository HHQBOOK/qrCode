//
//  ViewController.m
//  二维码生成
//
//  Created by 韩贺强 on 16/7/15.
//  Copyright © 2016年 com.baiduniang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong) UIImageView * imageView;
@property (nonatomic, strong) UIImageView * colorImageview;
@property (nonatomic, strong) UIImageView * logoImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //二维码生成 实质:  把字符串转变为 图片
    // 需要 coreImage框架, 已经包含在了 UIKit框架里面
    
    [self qrCode];
    [self colorQrcode];

    [self logoQrCode];
}
//MARK:普通黑白二维码
-(void)qrCode{
    //获取内建的所有过滤器.

    
//  NSArray *filterArr = [CIFilter filterNamesInCategories:kCICategoryBuiltIn]; //也对
    NSArray * filterArr = [CIFilter filterNamesInCategories:@[kCICategoryBuiltIn]];  //对
//    NSLog(@"%@",filterArr);//所有内建过滤器,找CR...二维码的
    
    //二维码过滤器
    CIFilter *qrImageFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //设置过滤器默认属性 (老油条)
    [qrImageFilter setDefaults];
    
    //将字符串转换成 NSdata (虽然二维码本质上是 字符串,但是这里需要转换,不转换就崩溃)
    NSData *qrImageData = [@"你看我帅不帅" dataUsingEncoding:NSUTF8StringEncoding];
    
    //我们可以打印,看过滤器的 输入属性.这样我们才知道给谁赋值
    NSLog(@"%@",qrImageFilter.inputKeys);
    /*
     inputMessage,        //二维码输入信息
     inputCorrectionLevel //二维码错误的等级,就是容错率
     */
    
    
    //设置过滤器的 输入值  ,KVC赋值
    [qrImageFilter setValue:qrImageData forKey:@"inputMessage"];
    
    //取出图片
    CIImage *qrImage = [qrImageFilter outputImage];
    
    //但是图片 发现有的小 (27,27),我们需要放大..我们进去CIImage 内部看属性
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(9, 9)];
    
    
    self.imageView.image = [UIImage imageWithCIImage:qrImage];
    //    self.imageView.image = [UIImage imageWithCIImage:qrImage scale:100.0 orientation:UIImageOrientationUp];
    
    
    
    //    //如果还想加上阴影，就在ImageView的Layer上使用下面代码添加阴影
    
    self.imageView.layer.shadowOffset=CGSizeMake(0, 5);//设置阴影的偏移量
    
    self.imageView.layer.shadowRadius=1;//设置阴影的半径
    
    self.imageView.layer.shadowColor=[UIColor redColor].CGColor;//设置阴影的颜色为黑色
    
    self.imageView.layer.shadowOpacity=0.3;
}

//MARK:彩色的二维码
-(void)colorQrcode{
    
    
    //二维码的实质是 字符串, 我们生产二维码,就是根据字符串去生产一张图片

    
    //获取内建的所有过滤器.
    //        NSArray *filterArr = [CIFilter filterNamesInCategories:kCICategoryBuiltIn]; //也对
    NSArray *filterArr = [CIFilter filterNamesInCategories:@[kCICategoryBuiltIn]];   //对
    
    NSLog(@"%@",filterArr); //所有内建过滤器,找CR... 二维码的
    
    //创建二维码过滤器
    CIFilter * qrfilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //设置默认属性(老油条)
    [qrfilter setDefaults];
    
    //我们需要给 二维码过期器 设置一下属性,给它一些东西,让它去生成图片吧,那些属性呢,跳进去看
    NSLog(@"%@",qrfilter.inputKeys);
    /*
     inputMessage,            //二维码的信息
     inputCorrectionLevel     //二维码的容错率 ()到达一定值后,就不能识别二维码了
     */
    
    //我们需要给 二维码 的 inputMessage 设置值,  这是私有属性,我们 使用KVC.给其私有属性赋值
    
    //将字符串转为NSData,去获取图片
    NSData * qrimgardata = [@"http://www.baidu.com" dataUsingEncoding:NSUTF8StringEncoding];
    
    //去获取对应的图片(因为测试,直接用字符串会崩溃)
    [qrfilter setValue:qrimgardata forKey:@"inputMessage"];
    
    //去获得对应图片 outPut
    CIImage *qrImage = qrfilter.outputImage;
    
    //图片不清除,打印知道其 大小 为 (27,27). 进入 CIImage,看属性,
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(9, 9)];
    
    
    //创建彩色过滤器   (彩色的用的不多)-----------------------------------------------------
    CIFilter * colorFilter = [CIFilter filterWithName:@"CIFalseColor"];
    
    //设置默认值
    [colorFilter setDefaults];
    
    //同样打印这样的 输入属性  inputKeys
    NSLog(@"%@",colorFilter.inputKeys);
    /*
     inputImage,   //输入的图片
     inputColor0,  //前景色
     inputColor1   //背景色
     */
    
    //KVC 给私有属性赋值
    [colorFilter setValue:qrImage forKey:@"inputImage"];
    
    //需要使用 CIColor
    [colorFilter setValue:[CIColor colorWithRed:1 green:0 blue:0.8] forKey:@"inputColor0"];
    [colorFilter setValue:[CIColor colorWithRed:0 green:1 blue:0.4] forKey:@"inputColor1"];
    
    //设置输出
    CIImage *colorImage = [colorFilter outputImage];
    
    
    self.colorImageview.image = [UIImage imageWithCIImage:colorImage];
    
}

//MARK: 二维码中间内置图片,可以是公司logo
-(void)logoQrCode{
    
    //
    NSArray *filters = [CIFilter filterNamesInCategory:kCICategoryBuiltIn];
    NSLog(@"%@",filters);
    
    //二维码过滤器
    CIFilter *qrImageFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //设置过滤器默认属性 (老油条)
    [qrImageFilter setDefaults];
    
    //将字符串转换成 NSdata (虽然二维码本质上是 字符串,但是这里需要转换,不转换就崩溃)
    NSData *qrImageData = [@"你好,我爱你" dataUsingEncoding:NSUTF8StringEncoding];
    
    //我们可以打印,看过滤器的 输入属性.这样我们才知道给谁赋值
    NSLog(@"%@",qrImageFilter.inputKeys);
    /*
     inputMessage,        //二维码输入信息
     inputCorrectionLevel //二维码错误的等级,就是容错率
     */
    
    
    //设置过滤器的 输入值  ,KVC赋值
    [qrImageFilter setValue:qrImageData forKey:@"inputMessage"];
    
    //取出图片
    CIImage *qrImage = [qrImageFilter outputImage];
    
    //但是图片 发现有的小 (27,27),我们需要放大..我们进去CIImage 内部看属性
    qrImage = [qrImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    
    //转成 UI的 类型
    UIImage *qrUIImage = [UIImage imageWithCIImage:qrImage];
    
    
    //----------------给 二维码 中间增加一个 自定义图片----------------
    //开启绘图,获取图形上下文  (上下文的大小,就是二维码的大小)
    UIGraphicsBeginImageContext(qrUIImage.size);
    
    //把二维码图片画上去. (这里是以,图形上下文,左上角为 (0,0)点)
    [qrUIImage drawInRect:CGRectMake(0, 0, qrUIImage.size.width, qrUIImage.size.height)];
    
    
    //再把小图片画上去
    UIImage *sImage = [UIImage imageNamed:@"龙之母.jpg"];
    
    CGFloat sImageW = 100;
    CGFloat sImageH= sImageW;
    CGFloat sImageX = (qrUIImage.size.width - sImageW) * 0.5;
    CGFloat sImgaeY = (qrUIImage.size.height - sImageH) * 0.5;
    
    [sImage drawInRect:CGRectMake(sImageX, sImgaeY, sImageW, sImageH)];
    
    //获取当前画得的这张图片
    UIImage *finalyImage = UIGraphicsGetImageFromCurrentImageContext();
    
    //关闭图形上下文
    UIGraphicsEndImageContext();
    
    
    
    //设置图片
    self.logoImageView.image = finalyImage;
}

//MARK:懒加载
//黑白普通视图
-(UIImageView *)imageView{
    if(_imageView == nil){
        
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, 0, 200, 200)];
        [self.view addSubview:_imageView];
    }
    return _imageView;
}
//彩色视图
-(UIImageView *)colorImageview{
    if (_colorImageview == nil) {
        _colorImageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 210, 200, 200)];
        [self.view addSubview:_colorImageview];
    }
    return _colorImageview;
}
//logo视图
-(UIImageView *)logoImageView{
    if (_logoImageView == nil) {
        _logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(206, 400, 200, 200)];
        [self.view addSubview:_logoImageView];
    }
    return _logoImageView;
}
@end
