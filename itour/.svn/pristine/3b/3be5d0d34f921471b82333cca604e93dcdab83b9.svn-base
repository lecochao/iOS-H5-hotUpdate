//
//  ItMapViewController.m
//  itour
//
//  Created by Chaos on 16/5/19.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "ItMapViewController.h"

@implementation ItMapViewController

-(void)viewDidLoad
{
    NSLog(@"___viewDidLoad");
    [self setView];
    [self setNavigationBarTintColor:[UIColor redColor]];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 35)];
    [btn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [self setNavigationBarLeftItem:btn Action:^{
        NSLog(@"___back");
    }];
    [btn setImage:[UIImage imageNamed:@"nav_add"] forState:UIControlStateNormal];
    [self setNavigationBarRightItem:btn Action:^{
        NSLog(@"____right");
    }];
    [self loadingWebWithUrl:[NSURL URLWithString:@"http://www.th7.cn/web/html-css/201412/70846.shtml"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openCamera) name:key_openCamera object:nil];
}

#pragma mark - JS web -

-(void)JSWithData:(NSArray<JSValue *> *)data
{
    if (data) {
        NSLog(@"___JS___%@",[data firstObject]);
    }
}
- (void)openCamera
{
    //资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate                 = self;
        //设置拍照后的图片可被编辑
        //        picker.allowsEditing            = YES;
        //资源类型为照相机
        picker.sourceType               = sourceType;
        [self presentViewController:picker animated:YES completion:^(void){}];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"模拟器没摄像头");
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    UIImage *new_image = [info objectForKey:UIImagePickerControllerEditedImage];
    //    new_image = [self imageWithImage:new_image scaledToSize:CGSizeMake(new_image.size.width/3, new_image.size.height/3 )];
    //    NSData *imageData = UIImageJPEGRepresentation(new_image, 0.5);
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }];
    
}

//对图片尺寸进行压缩--

-(UIImage*)imageWithImage:(UIImage*)myImage scaledToSize:(CGSize)newSize

{
    
    // Create a graphics image context
    
    UIGraphicsBeginImageContext(newSize);
    
    
    // Tell the old image to draw in this new context, with the desired
    
    // new size
    
    [myImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    
    // Get the new image from the context
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    // End the context
    
    UIGraphicsEndImageContext();
    
    
    // Return the new image.
    
    return newImage;
}
@end
