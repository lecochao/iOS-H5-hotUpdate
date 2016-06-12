//
//  ItPostImgViewController.m
//  itour
//
//  Created by Lannister on 16/5/24.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "ItPostImgViewController.h"
#import "AMapLocationKit/AMapLocationKit.h"
#import "QiniuSDK.h"
#import "AFNetworking.h"
#import "iTourNetworking.h"
#import "MBProgressHUD.h"
#import "UMSocial.h"
#import "WXApi.h"
static NSString* const URL_getQiniuToken = @"http://iuxlabs.com/iux/web/s/qiniu/token.php?url=web";
static NSString* const URL_postInfo = @"http://iuxlabs.com/iux/web/s/comment/v2/write.php";
static NSString* const kplacehoderOfTxtViewDetails = @"详情文字（最多输入100个字）";
static NSString* const kplacehoderOfTxtViewContactInfo = @"填写您的联系方式（若您的图片入选影展，我们将通知您领取礼品。联系方式我们为您严格保密）";


@interface ItPostImgViewController()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (strong, nonatomic) IBOutlet UITextField *txtTitle;
@property (strong, nonatomic) IBOutlet UITextView *txtViewDetails;
@property (strong, nonatomic) IBOutlet UITextView *txtViewContactInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentDate;
@property (strong, nonatomic) IBOutlet UIView *imgView;
@property (strong, nonatomic) IBOutlet UIImageView *imgPost;
@property (strong, nonatomic) IBOutlet UIButton *btnWeChatShare;
@property (strong, nonatomic) IBOutlet UIButton *btnWeBoShare;
@property (strong, nonatomic) IBOutlet UIButton *btnPostInfo;
@property (nonatomic, strong) NSMutableDictionary *dicWithInfo;
@property (nonatomic, strong) NSString *locationString;
@end
@implementation ItPostImgViewController{
    BOOL _btnWeBoStatus;
    BOOL _btnWeChatStatus;
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    _imgPost.image = _postImg;
    [self configUI];
    [self configTime];
    [self configLocation];
    [self popGestureRecognizer];
    
    WEAKSELF
    [self setNavigationBarLeftItem:[UIImage imageNamed:@"nav_back_b"] Action:^{
         [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    self.navigationItem.title = @"发布照片";
#warning share
    

    
 }

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationBarStyle:0];
    
}
-(void) configUI{

    self.view.backgroundColor = [UIColor whiteColor];
    _txtTitle.delegate = self;
    _txtViewContactInfo.delegate = self;
    _txtViewDetails.delegate = self;
    [_btnWeBoShare setImage:[UIImage imageNamed:@"weibo_highlight"] forState:UIControlStateSelected];
    [_btnWeChatShare setImage:[UIImage imageNamed:@"wechat_highlight"] forState:UIControlStateSelected];
    [self.view addGestureRecognizer:({
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(touchView)];
        tapGestureRecognizer;
    })];
    [self configShareBtn];
    [self setPhotoLayout];
}
-(void) touchView{
    [self.view endEditing:YES];
}
-(void) configShareBtn{
    if (![WXApi isWXAppInstalled]) {
        _btnWeChatShare.hidden = YES;
    }
    _btnWeChatStatus = NO;
    _btnWeBoStatus = NO;
    [_btnWeChatShare addTarget:self action:@selector(configShareImg:) forControlEvents:UIControlEventTouchUpInside];
    [_btnWeBoShare addTarget:self action:@selector(configShareImg:) forControlEvents:UIControlEventTouchUpInside];
}
-(void) configTime{

    _lblCurrentDate.text = ({
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM-dd hh:mm";
        NSString* locationDate = [[NSString alloc] init];
        locationDate = [dateFormatter stringFromDate:nowDate];
        locationDate;
    });
}
-(void) configShareImg:(UIButton*) btn{
    
    if (btn == _btnWeBoShare) {
        
        _btnWeBoStatus = !_btnWeBoStatus;
        _btnWeBoShare.selected = _btnWeBoStatus;
    }
    if (btn == _btnWeChatShare) {
        _btnWeChatStatus = !_btnWeChatStatus;
        _btnWeChatShare.selected = _btnWeChatStatus;
    }
    
}
-(void) configLocation{
    
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
            _lblLocation.text = @"定位失败";
            return;
        }else{
            
            if (location) {
                if (regeocode) {
                    
                    if (regeocode.township&&regeocode.building) {
                        _locationString =  [NSString stringWithFormat:@"%@%@",regeocode.township,regeocode.building];
                    }else if (regeocode.building){
                        _locationString =  [NSString stringWithFormat:@"%@",regeocode.building];
                    }else if(regeocode.city){
                        _locationString =  [NSString stringWithFormat:@"%@",regeocode.city];
                    }else{
                        _locationString =  [NSString stringWithFormat:@""];

                    }
                    _lblLocation.text = _locationString;
                }else{
                    _lblLocation.text = [NSString stringWithFormat:@"(%f,%f)",location.coordinate.latitude,location.coordinate.longitude];
                }
            }
        }
    }];
}
- (void) setPhotoLayout{
     _imgPost.layer.borderWidth = 2;
     _imgPost.layer.borderColor = [UIColor blueColor].CGColor;
    
    [self configBackgroundImgViewWthSizeRatio:0.7 offsetX:80 alpha:0.6];
    [self configBackgroundImgViewWthSizeRatio:0.7 offsetX:-80 alpha:0.6];
    [self configBackgroundImgViewWthSizeRatio:0.9 offsetX:40 alpha:0.3];
    [self configBackgroundImgViewWthSizeRatio:0.9 offsetX:-40 alpha:0.3];
    
}
- (void) configBackgroundImgViewWthSizeRatio:(CGFloat) sizeRatio offsetX:(CGFloat) offsetX alpha:(CGFloat) alpha{
    
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.center = CGPointMake(self.view.center.x + offsetX,  _imgPost.center.y);
    imgView.bounds = CGRectMake(0,
                                0,
                                CGRectGetHeight( _imgPost.bounds) * sizeRatio,
                                CGRectGetWidth( _imgPost.bounds) * sizeRatio);
    imgView.layer.borderWidth = 2;
    imgView.layer.borderColor = [UIColor blueColor].CGColor;
    imgView.image = _imgPost.image;
    
    CALayer *layer = [[CALayer alloc] init];
    layer.bounds = CGRectMake(0, 0, CGRectGetHeight(imgView.bounds) *1, CGRectGetWidth(imgView.bounds)*1);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    layer.anchorPoint = CGPointMake(0, 0);
    [imgView.layer addSublayer:layer];
    layer.opacity  = alpha;
    
    [_imgView insertSubview:imgView belowSubview:_imgPost];
}

- (IBAction)touchBtnPostInfo:(id)sender {
    
    if ([_txtTitle.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请您填写图片标题" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
    }else if(_txtTitle.text.length > 8){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"标题最多输入八个字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
    }else{
        _dicWithInfo = [NSMutableDictionary new];
        [_dicWithInfo setObject:_txtTitle.text forKey:@"topic"];
        
        if (([_txtViewDetails.text isEqualToString:@""]||[_txtViewDetails.text isEqualToString:kplacehoderOfTxtViewDetails])) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请您填写图片详情" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alertView show];
            
        }else if(_txtViewDetails.text.length>100){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"详情最多输入一百字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alertView show];
        }else{
            [_dicWithInfo setObject:_txtViewDetails.text forKey:@"intro"];
            
            if (!([_txtViewContactInfo.text isEqualToString:@""]||[_txtViewContactInfo.text isEqualToString:kplacehoderOfTxtViewContactInfo])) {        // contactInfo 为选填
                [_dicWithInfo setObject:_txtViewContactInfo.text forKey:@"contact"];
            }
           
            [_dicWithInfo setObject:({                      //添加时间戳到dic
                NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
                NSTimeInterval a = [date timeIntervalSince1970];
                int intTime = a;
                NSNumber *postTime = [NSNumber numberWithInteger:intTime];
                postTime;
            }) forKey:@"postTime"];
           
            if (_locationString) {                          //添加定位位置到dic
                [_dicWithInfo setObject:_locationString forKey:@"address"];
            }else{
                [_dicWithInfo setObject:@"" forKey:@"address"];
            }
#warning net request
           if (_btnWeBoStatus&&_btnWeChatStatus){               //选择了两个分享平台
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请您选择唯一的分享平台" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                [alertView show];
           }else{
               if ((_btnWeChatStatus || _btnWeBoStatus)) {      // 选择了一个分享平台
                   if (_btnWeChatStatus) {
                       
                              [UMSocialData defaultData].extConfig.title = _txtTitle.text;
                       [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://iuxlabs.com/iux/web/share.html";

                               [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:_txtTitle.text image:_imgPost.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                                   if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                                       NSLog(@"微信分享成功！");
                                   }
                               }];
                       
                   }else{
                               [UMSocialData defaultData].extConfig.title = _txtTitle.text;
                       
                               [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:_txtTitle.text image:_imgPost.image location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                                   if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                                       NSLog(@"微博分享成功！");
                                   }
                               }];
                   }
               }

           }
            [self getQiniuToken];
        }
    }
}
#pragma mark - Network

-(void) getQiniuToken{                                                          //首先获得七牛的授权token
    
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [sessionManager POST:URL_getQiniuToken parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       NSString *qiniuToken = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        [self postImgToQiniuServicerWithQiniuToken:qiniuToken];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"get qiniu token error is %@",error);

        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [self showHint:@"网络错误"];
    }];
    
}
-(void) postImgToQiniuServicerWithQiniuToken:(id) qiniuToken{                    //将图片上传到七牛服务器并获得其图片的qiniuImgKey
    
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
    NSData *imgData = [NSData new];
    imgData = UIImageJPEGRepresentation(_imgPost.image, 0.2);
 
   [upManager putData:imgData
                  key:nil token:qiniuToken
             complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
    
                 NSString* qiniuImgKey = resp[@"key"];
                 [self postInfoToServicerWithQiniuImgKey:qiniuImgKey];
            
              } option:nil];

}

-(void) postInfoToServicerWithQiniuImgKey:(id)qiniuKey {                        //将发送图片的qiniuImgKey和其他参数上传到公司服务器

    [_dicWithInfo setObject:qiniuKey forKey:@"img" ];
    [_dicWithInfo setObject:@"gallery" forKey:@"dispatch"];
         NSLog(@"%@=======",_dicWithInfo[@"img"]);
    NSString *token =ITOUR_GET_OBJECT(UserToken);
    if (!token) {
        NSLog(@" NO LOGAN IN ");
    }else{
        [_dicWithInfo setObject:token forKey:@"sessionId"];

        [iTourNetworking iTour_Post_JSONWithUrl:URL_postInfo parameters:_dicWithInfo success:^(id json) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [self showHint:@"上传成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } fail:^(NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
            [self showHint:@"上传失败"];
            NSLog(@"post info error =========");

        }];
    }
   
}
#pragma mark - text delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [self.view endEditing:YES];
    }
    return YES;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (textView == _txtViewDetails) {
        if ([textView.text isEqualToString:kplacehoderOfTxtViewDetails]) {
            textView.text = @"";
        }
    }
    if (textView == _txtViewContactInfo) {
        if ([textView.text isEqualToString:kplacehoderOfTxtViewContactInfo]) {
            textView.text = @"";
        }
    }
    return YES;
}
@end
