//
//  ItRecommendViewController.m
//  itour
//
//  Created by Lannister on 16/6/1.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "ItRecommendViewController.h"
#import "AMapLocationKit/AMapLocationKit.h"
#import "QiniuSDK.h"
#import "AFNetworking.h"
#import "iTourNetworking.h"
#import "MBProgressHUD.h"

static NSString* const kplacehoderOfTxtRecommendDetails = @"在此输入详情文字";
static NSString* const kplacehoderOfTxtViewContactInfo = @"填写您的联系方式（若您的图片入选影展，我们将通知您领取礼品。联系方式我们为您严格保密）";
static NSString* const URL_getQiniuToken = @"http://iuxlabs.com/iux/web/s/qiniu/token.php?url=web";
static NSString* const URL_postInfo = @"http://iuxlabs.com/iux/web/s/comment/v2/write.php";
#define  kScreenBounds  [UIScreen mainScreen].bounds

@interface ItRecommendViewController ()<UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *imgView;
@property (strong, nonatomic) IBOutlet UITextField *txtTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtRecommendReason;
@property (strong, nonatomic) IBOutlet UITextView *txtRecommendDetails;
@property (strong, nonatomic) IBOutlet UITextView *txtContactInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblTime;

//@property (nonatomic, strong) NSArray *imgArray;
@property (nonatomic, strong) NSMutableArray *qiniuTokenArray;
@property (nonatomic, strong) NSMutableDictionary *dicWithInfo;
@property (nonatomic, strong) AMapLocationManager *locationManager;
@property (nonatomic, strong) NSString *locationString;

@end

@implementation ItRecommendViewController{
    NSInteger _imgKeyCount;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF
    [self setNavigationBarLeftItem:[UIImage imageNamed:@"nav_back_b"] Action:^{
        if ([weakSelf.webView canGoBack]) {
            [weakSelf.webView goBack];
        }else
            [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UIButton *right = [UIButton new];
    right.frame = CGRectMake(0, 0, 50, 35);
    [right.titleLabel setFont:APPTextFont(14)];
    right.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    [right setTitle:@"发送" forState:UIControlStateNormal];
    [right setTitleColor:RGB(44, 138, 224) forState:UIControlStateNormal];
    [right setImage:[UIImage imageNamed:@"nav_recom_right"] forState:UIControlStateNormal];

    [self setNavigationBarRightItem:right Action:^{
        [weakSelf touchBtnPostInfo];
    }];

    [self configUI];
    [self configLocation];
    [self configTime];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationBarStyle:0];
    [self.navigationItem setTitle:@"我要推荐"];
}
-(void) configUI{
    
    CGRect rect = _imgView.bounds;
    rect.size.height = 350;
    _imgView.bounds = rect;
    _txtContactInfo.delegate= self;
    _txtRecommendDetails.delegate = self;
    _txtRecommendReason.delegate = self;
    _txtTitle.delegate = self;
    [self configImgView];
    
    [self.view addGestureRecognizer:({
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(touchView)];
        tapGestureRecognizer;
    })];
}
-(void) touchBtnPostInfo{
  
    if ([_txtTitle.text isEqualToString:@""]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请您填写图片标题" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
    }else if(_txtTitle.text.length>8){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"标题最多输入8个字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alertView show];
    }else{
        
        _dicWithInfo = [NSMutableDictionary new];
        [_dicWithInfo setObject:_txtTitle.text forKey:@"topic"];
       
        if ([_txtRecommendReason.text isEqualToString:@""]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请您填写推荐理由" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alertView show];
        }else if(_txtRecommendReason.text.length>15){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"推荐理由最多输入15个字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alertView show];
        }else{
            [_dicWithInfo setObject:_txtRecommendReason.text forKey:@"reason"];
            if ([_txtRecommendDetails.text isEqualToString:@""]||[_txtRecommendDetails.text isEqualToString:kplacehoderOfTxtRecommendDetails]) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"请您填写图片详情" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                [alertView show];
            }else{
                [_dicWithInfo setObject:_txtRecommendDetails.text forKey:@"intro"];
                if (!([_txtContactInfo.text isEqualToString:@""]||[_txtContactInfo.text isEqualToString:kplacehoderOfTxtViewContactInfo])) {
                       // contactInfo 为选填
                    [_dicWithInfo setObject:_txtContactInfo forKey:@"contact"];
                }
                [_dicWithInfo setObject:({                      //添加时间戳到dic
                    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
                    NSTimeInterval a = [date timeIntervalSince1970];
                    NSInteger intTime = a;
                    NSNumber *postTime = [NSNumber numberWithInteger:intTime];
                    postTime;
                }) forKey:@"postTime"];
                
                if (_locationString) {                          //添加定位位置到dic
                    [_dicWithInfo setObject:_locationString forKey:@"address"];
                }else{
                    [_dicWithInfo setObject:@"" forKey:@"address"];
                }
                
                [self getQiniuToken];
                
            }
        }
    }
}
-(void) touchView{
    [self.view endEditing:YES];
}
-(void) configTime{
    
    _lblTime.text = ({
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"MM-dd hh:mm";
        NSString* locationDate = [[NSString alloc] init];
        locationDate = [dateFormatter stringFromDate:nowDate];
        locationDate;
    });
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
                    _locationString =  [NSString stringWithFormat:@"%@%@%@",regeocode.township,regeocode.neighborhood,regeocode.building];
                    _lblLocation.text = _locationString;
                }else{
                    _lblLocation.text = [NSString stringWithFormat:@"(%f,%f)",location.coordinate.latitude,location.coordinate.longitude];
                }
            }
        }
    }];
}
-(void) configImgView{
    switch (_imgArray.count) {
       
        case 1:{
            
            [_imgView addSubview:({
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:_imgView.bounds];
                imageView.contentMode = UIViewContentModeScaleAspectFill;
                imageView.image = _imgArray[0];
                imageView.clipsToBounds = YES;
                imageView;
            })];
        }
            break;
        case 2:{
            
            [_imgView addSubview:({
                UIImageView *imageViewR = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                       0,
                                                                                       CGRectGetWidth(kScreenBounds)/2-1,
                                                                                       CGRectGetHeight(_imgView.bounds))];
                imageViewR.contentMode = UIViewContentModeScaleAspectFill;
                imageViewR.image =_imgArray[0];
                imageViewR.clipsToBounds = YES;
                imageViewR;

            })];
            [_imgView addSubview:({
                UIImageView *imageViewL = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(kScreenBounds)/2+1,
                                                                                        0,
                                                                                        CGRectGetWidth(kScreenBounds)/2-1,
                                                                                        CGRectGetHeight(_imgView.bounds))];
                imageViewL.contentMode = UIViewContentModeScaleAspectFill;
                imageViewL.clipsToBounds = YES;
                imageViewL.image = _imgArray[1];
                imageViewL;
            })];
        }
            break;
        case 3:{
            [_imgView addSubview:({
                UIImageView *imageViewR = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                        0,
                                                                                        CGRectGetWidth(kScreenBounds)/2-1,
                                                                                        CGRectGetHeight(_imgView.bounds))];
                imageViewR.contentMode = UIViewContentModeScaleAspectFill;
                imageViewR.image = _imgArray[0];
                imageViewR.clipsToBounds = YES;
                imageViewR;
                
            })];
            
            [_imgView addSubview:({
                UIImageView *imageViewLTop = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(kScreenBounds)/2+1,
                                                                                        0,
                                                                                        CGRectGetWidth(kScreenBounds)/2-1,
                                                                                        CGRectGetHeight(_imgView.bounds)/2-1)];
                imageViewLTop.contentMode = UIViewContentModeScaleAspectFill;
                imageViewLTop.image = _imgArray[1];
                imageViewLTop.clipsToBounds = YES;
                imageViewLTop;
            })];
        }
            [_imgView addSubview:({
                UIImageView *imageViewLBom = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(kScreenBounds)/2+1,
                                                                                           CGRectGetHeight(_imgView.bounds)/2+1,
                                                                                           CGRectGetWidth(kScreenBounds)/2-1,
                                                                                           CGRectGetHeight(_imgView.bounds)/2-1)];
                imageViewLBom.contentMode = UIViewContentModeScaleAspectFill;
                imageViewLBom.image = _imgArray[2];
                imageViewLBom.clipsToBounds = YES;
                imageViewLBom;

            })];
            break;
        case 4:{
            CGFloat viewRWidth = CGRectGetWidth(kScreenBounds)/3;
            [_imgView addSubview:({
                UIImageView *imageViewR = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                        0,
                                                                                        viewRWidth *2-1,
                                                                                        CGRectGetHeight(_imgView.bounds))];
                imageViewR.contentMode = UIViewContentModeScaleAspectFill;
                imageViewR.image = _imgArray[0];
                imageViewR.clipsToBounds = YES;
                imageViewR;
                
            })];
            
            [_imgView addSubview:({
                UIImageView *imageViewLTop = [[UIImageView alloc] initWithFrame:CGRectMake(viewRWidth*2+1,
                                                                                           0,
                                                                                           viewRWidth-1,
                                                                                           CGRectGetHeight(_imgView.bounds)/3-1)];
                imageViewLTop.contentMode = UIViewContentModeScaleAspectFill;
                imageViewLTop.image = _imgArray[1];
                imageViewLTop.clipsToBounds = YES;
                imageViewLTop;
            })];
            
            [_imgView addSubview:({
                UIImageView *imageViewLMed = [[UIImageView alloc] initWithFrame:CGRectMake(viewRWidth*2+1,
                                                                                           CGRectGetHeight(_imgView.bounds)/3,
                                                                                           viewRWidth-1,
                                                                                           CGRectGetHeight(_imgView.bounds)/3-1)];
                imageViewLMed.contentMode = UIViewContentModeScaleAspectFill;
                imageViewLMed.image = _imgArray[2];
                imageViewLMed.clipsToBounds = YES;
                imageViewLMed;
            })];
            [_imgView addSubview:({
                UIImageView *imageViewLBom = [[UIImageView alloc] initWithFrame:CGRectMake(viewRWidth*2+1,
                                                                                           CGRectGetHeight(_imgView.bounds)/3*2,
                                                                                          viewRWidth-1,
                                                                                           CGRectGetHeight(_imgView.bounds)/3-1)];
                imageViewLBom.contentMode = UIViewContentModeScaleAspectFill;
                imageViewLBom.image = _imgArray[3];
                imageViewLBom.clipsToBounds = YES;
                imageViewLBom;
                
            })];

        }
            break;
        default:
            break;
    }
}
#pragma mark - network
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

    _qiniuTokenArray = [[NSMutableArray alloc] init];
    _imgKeyCount = 0;
    for (int i = 0; i< _imgArray.count; i++) {
        
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        NSData *imgData = [NSData new];
        UIImage *img= _imgArray[i];
        imgData = UIImageJPEGRepresentation(img, 0.2);

        [upManager putData:imgData
                       key:nil token:qiniuToken
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      
                        _imgKeyCount++;
                        NSString* qiniuImgKey = resp[@"key"];
                        [_qiniuTokenArray addObject:qiniuImgKey];
                    if (_imgKeyCount == _imgArray.count) {
                          if (_qiniuTokenArray.count == _imgArray.count) {
                              [self postInfoToServicerWithQiniuImgKey];
                          }else{

                          _imgKeyCount = 0;
                      }
                      

                      }
                  } option:nil];
    }
}
-(void) postInfoToServicerWithQiniuImgKey{                        //将发送图片的qiniuImgKey和其他参数上传到公司服务器

    
    NSString *imgKeyString = _qiniuTokenArray[0];
    for (int i=1; i<_imgArray.count; i++) {
        if (!(_imgArray.count ==1)) {
            imgKeyString = [imgKeyString stringByAppendingFormat:@"|%@",_qiniuTokenArray[i]];
        }
    }
    
    [_dicWithInfo setObject:imgKeyString forKey:@"img" ];
    [_dicWithInfo setObject:_type forKey:@"type"];
    [_dicWithInfo setObject:@"board" forKey:@"dispatch"];
    
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
            NSLog(@"post info error =========");
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self showHint:@"上传失败"];
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
    if (textView == _txtRecommendDetails) {
        if ([textView.text isEqualToString:kplacehoderOfTxtRecommendDetails]) {
            textView.text = @"";
        }
    }
    if (textView == _txtContactInfo) {
        if ([textView.text isEqualToString:kplacehoderOfTxtViewContactInfo]) {
            textView.text = @"";
        }
    }
    return YES;
}

@end
