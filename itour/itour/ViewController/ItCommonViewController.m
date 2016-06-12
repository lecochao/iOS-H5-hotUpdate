//
//  itCommonViewController.m
//  itour
//
//  Created by Chaos on 16/6/1.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "ItCommonViewController.h"
#import "LGPhoto.h"
#import "ItRecommendViewController.h"
#import "ItMapSceneViewController.h"

@interface ItCommonViewController ()<LGPhotoPickerViewControllerDelegate>
@property(nonatomic ,strong) UILabel *aboutUs;
@end
@implementation ItCommonViewController

-(void)viewDidLoad
{
    [self setView];
    NSString *imgName;
    if (_style == iTourNavigationBarStyleRed) {
        imgName = @"nav_back_w";
    }else if (_style == iTourNavigationBarStyleColourless){
        imgName = @"nav_back_w";
    }else{
        imgName = @"nav_back_b";
    }
    WEAKSELF
    [self setNavigationBarLeftItem:[UIImage imageNamed:imgName] Action:^{
        if ([weakSelf.webView canGoBack]) {
            [weakSelf.webView goBack];
        }else
            [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    if (_isLeaf) {
        [self setNavigationBarRightItem:@"进入" Action:^{
            NSLog(@"____right_进入");
            ItMapSceneViewController *mapScene = [[ItMapSceneViewController alloc]init];
            [weakSelf.navigationController pushViewController:mapScene animated:YES];

        }];
    }
    
    if(_type){
        UIButton *right = [UIButton new];
        right.frame = CGRectMake(0, 0, 80, 35);
        [right.titleLabel setFont:APPTextFont(14)];
        right.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
        [right setTitle:@"我要推荐" forState:UIControlStateNormal];
        [right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [right setImage:[UIImage imageNamed:@"nav_board_right"] forState:UIControlStateNormal];
        [self setNavigationBarRightItem:right Action:^{
            //我要推荐
            [weakSelf presentPhotoPickerViewControllerWithStyle:LGShowImageTypeImagePicker];
            
        }];
    }
    [self webViewReload];
    [self setHeaderWithRefresh:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationBarStyle:_style];
    [self.navigationItem setTitle:_txtTitle];
}

-(void)webViewReload
{
    NSRange foundObj=[_url rangeOfString:@"http" options:NSCaseInsensitiveSearch];
    if(foundObj.length>0) {
        _url = [_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [self loadingWebWithUrl:_url];
    } else {
        [self loadingHtmlWithName:_url];
    }
    
    NSRange about = [_url rangeOfString:@"aboutUs" options:NSCaseInsensitiveSearch];
    if (about.length>0) {
        if (!_aboutUs) {
            _aboutUs = [[UILabel alloc]init];
            _aboutUs.frame = CGRectMake(CGRectGetWidth(Bounds)-105, CGRectGetHeight(Bounds)-20, 100, 20);
            _aboutUs.textColor = [UIColor whiteColor];
            _aboutUs.textAlignment = 2;
            _aboutUs.font = APPTextFont(12);
            [self.view addSubview:_aboutUs];
        }
        NSString *key = (NSString *)kCFBundleVersionKey;
        NSString *version = [NSBundle mainBundle].infoDictionary[key];
        NSString *aboyStr = [NSString stringWithFormat:@"v.%@  .%@  ",version,ITOUR_GET_OBJECT(HTML5Versions)];
        _aboutUs.text = aboyStr;
    }
}



/**
 *  初始化相册选择器
 */
- (void)presentPhotoPickerViewControllerWithStyle:(LGShowImageType)style {
    LGPhotoPickerViewController *pickerVc = [[LGPhotoPickerViewController alloc] initWithShowType:style];
    pickerVc.status = PickerViewShowStatusGroup;
    pickerVc.maxCount = 4;   // 最多能选9张图片
    pickerVc.delegate = self;
    [pickerVc showPickerVc:self];
}

#pragma mark - LGPhotoPickerViewControllerDelegate

- (void)pickerViewControllerDoneAsstes:(NSArray *)assets isOriginal:(BOOL)original{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
     //assets的元素是LGPhotoAssets对象，获取image方法如下:
     NSMutableArray *thumbImageArray = [NSMutableArray array];
     NSMutableArray *originImage = [NSMutableArray array];
     NSMutableArray *fullResolutionImage = [NSMutableArray array];
     
     for (LGPhotoAssets *photo in assets) {
     //缩略图
     [thumbImageArray addObject:photo.thumbImage];
     //原图
     [originImage addObject:photo.originImage];
     //全屏图
     [fullResolutionImage addObject:photo.fullResolutionImage];
     }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"ItPostImgStoryboard" bundle:nil];
    ItRecommendViewController *recommendController = [storyboard instantiateViewControllerWithIdentifier:@"ItRecommendViewControllerIdentifier"];
    recommendController.imgArray = originImage;
    recommendController.type = _type;
    [self.navigationController pushViewController:recommendController animated:YES];
    [hud hide:YES];
}
@end
