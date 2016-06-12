//
//  ItMapViewController.m
//  itour
//
//  Created by Chaos on 16/5/19.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "ItMapViewController.h"
#import "ItRouteplanViewController.h"
#import "ItPostImgViewController.h"
#import "ItMapOptions.h"
@implementation ItMapViewController

-(void)viewDidLoad
{
    NSLog(@"___viewDidLoad");
    [self setView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openCamera) name:key_openCamera object:nil];
   
    [self webViewReload];
    [self setavAudio];
    
    WEAKSELF
    UIButton *right = [UIButton new];
    right.frame = CGRectMake(0, 0, 50, 35);
    [right.titleLabel setFont:APPTextFont(14)];
    right.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    [right setTitle:@"规划" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [right setImage:[UIImage imageNamed:@"nav_map_right"] forState:UIControlStateNormal];
    right.semanticContentAttribute = UISemanticContentAttributeForceRightToLeft;
    [self setNavigationBarRightItem:right Action:^{
        ItRouteplanViewController *routeplan = [[ItRouteplanViewController alloc]init];
        [weakSelf.navigationController pushViewController:routeplan animated:YES];
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"景区导览图"];
    [self setNavigationBarStyle:1];
    [self performSelector:@selector(avPlay) withObject:nil afterDelay:0.3];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self performSelector:@selector(avPause) withObject:nil afterDelay:0.5];
}
-(void)webViewReload
{
    [self loadingHtmlWithName:@"index.html"];
    [self performSelector:@selector(avPlay) withObject:nil afterDelay:0.3];
}

-(void)setavAudio
{
    NSString *string = [[NSBundle mainBundle] pathForResource:@"map" ofType:@"mp3"];
    NSURL *url = [NSURL fileURLWithPath:string];
    _avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _avAudioPlayer.numberOfLoops = -1;
    [_avAudioPlayer prepareToPlay];
    
    
    NSString *stringNiao = [[NSBundle mainBundle] pathForResource:@"niao" ofType:@"mp3"];
    NSURL *urlNiao = [NSURL fileURLWithPath:stringNiao];
    _playerNiao = [[AVAudioPlayer alloc] initWithContentsOfURL:urlNiao error:nil];
    _playerNiao.numberOfLoops = -1;
    _playerNiao.volume =0.2;
    [_playerNiao prepareToPlay];
    
}

- (void)avPause
{
    [_avAudioPlayer pause];
    [_playerNiao pause];
}

- (void)avPlay
{
    [_avAudioPlayer play];
    [_playerNiao play];
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
    
        NSLog(@"模拟器没摄像头");
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //    new_image = [self imageWithImage:new_image scaledToSize:CGSizeMake(new_image.size.width/3, new_image.size.height/3 )];
    //    NSData *imageData = UIImageJPEGRepresentation(new_image, 0.5);
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
    [picker dismissViewControllerAnimated:NO completion:^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ItPostImgStoryboard" bundle:nil];
        ItPostImgViewController *postImgViewController = [storyboard instantiateViewControllerWithIdentifier:@"postImgViewControllerIdentifier"];
        postImgViewController.postImg = image;
        [self.tabBarController.selectedViewController pushViewController:postImgViewController animated:YES];
        [hud hide:YES];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
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
