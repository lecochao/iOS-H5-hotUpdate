//
//  ItPostInfoViewController.m
//  itour
//
//  Created by Lannister on 16/6/3.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "ItPostInfoViewController.h"
#import "iTourNetworking.h"
#import "MBProgressHUD.h"
static NSString* const kplaceholderOfComment = @"请填写您的评论";
static NSString* const kplaceholderOfMessage = @"请将您的建议填写下来，谢谢！";
static NSString* const kplaceholderOfFeedback = @"请将反馈信息填写下来，谢谢！";

static NSString* const URL_comment = @"http://iuxlabs.com/iux/web/s/comment/v2/write.php";
static NSString* const URL_suggestion = @"http://iuxlabs.com/iux/web/s/suggestion/write.php";
//手机号码正则验证
#define RE_MobileNumber @"^((13)|(17)|(15)|(18))\\d{9}$"
@interface ItPostInfoViewController ()<UITextFieldDelegate,UITextViewDelegate>

typedef NS_ENUM(NSInteger,ViewControllerStyle){
    CommentStyle = 0,
    MessageStyle,
    FeedbackStyle
};

@property (strong, nonatomic) IBOutlet UITextView *txtViewPostInfo;
@property (strong, nonatomic) IBOutlet UITextField *txtPhoneNum;
@property (strong, nonatomic) IBOutlet UITextField *txtEmaii;
@property (strong, nonatomic) IBOutlet UIView *suggestionView;


@property (nonatomic, strong) NSMutableDictionary *InfoDic;
@property (nonatomic, strong) NSString *ViewStyle;
@property (nonatomic) NSInteger style;

@end

@implementation ItPostInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

 
    UIButton *right = [UIButton new];
    right.frame = CGRectMake(0, 0, 50, 35);
    [right.titleLabel setFont:APPTextFont(14)];
    right.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    [right setTitle:@"发送" forState:UIControlStateNormal];
    [right setTitleColor:RGB(44, 138, 224) forState:UIControlStateNormal];
    [right setImage:[UIImage imageNamed:@"nav_recom_right"] forState:UIControlStateNormal];
    WEAKSELF
    [self setNavigationBarRightItem:right Action:^{
        [weakSelf touchBtnPostInfo];
    }];
    [self setNavigationBarLeftItem:[UIImage imageNamed:@"nav_back_b"] Action:^{
         [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    [self configUI];
    [self configViewTypeByParameters];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setNavigationBarStyle:0];
}
-(void) configUI{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _txtEmaii.delegate = self;
    _txtPhoneNum.delegate = self;
    _txtViewPostInfo.delegate = self;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchView)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    _InfoDic = [NSMutableDictionary new];
    _ViewStyle = [NSString new];
}
-(void)configViewTypeByParameters{

    if (_type) {                                                                    //建议
        if ([_type isEqualToString:@"message"]) {                   //谏言模块
            _suggestionView.hidden = NO;
            _txtViewPostInfo.text = kplaceholderOfMessage;
            _style = MessageStyle;

        }else if ([_type isEqualToString:@"feedback"]){             //反馈模块
            _txtViewPostInfo.text = kplaceholderOfFeedback;

            _style = FeedbackStyle;
        }else{
            NSLog(@"===========tpye parameter error ============");
        }
    }else{                                                                          //反馈

        _style = CommentStyle;
    }
}
-(void)touchBtnPostInfo{
    
    if ([_txtViewPostInfo.text isEqualToString:@""]
        ||[_txtViewPostInfo.text isEqualToString:kplaceholderOfMessage]
        ||[_txtViewPostInfo.text isEqualToString:kplaceholderOfFeedback]
        ||[_txtViewPostInfo.text isEqualToString:kplaceholderOfComment]) {
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"请您填写信息详情"
                                                        message:@"" delegate:nil
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
        [alter show];
        
    }else{
        if (_style == MessageStyle) {
            if ([_txtPhoneNum.text isEqualToString:@""]) {
                
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"请填写您的手机号码"
                                                                message:@"" delegate:nil
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
                [alter show];
            }else if(![self isPhoneNumber:_txtPhoneNum.text]){
                UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"请输入正确的手机号码"
                                                                message:@"" delegate:nil
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
                [alter show];
            }else{
                [self postInfo];
            }
        }else{
            [self postInfo];
        }
    }
}
-(void) touchView{
    [self.view endEditing:YES];
}
-(void)postInfo{
    
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
       NSString *token =ITOUR_GET_OBJECT(UserToken);
       [_InfoDic setObject:token forKey:@"sessionId"];
    
    if (_style == CommentStyle) {                                   //发布评论
        [_InfoDic setObject:_dispatch forKey:@"dispatch"];
        [_InfoDic setObject:_assoId forKey:@"assoId"];
        [_InfoDic setObject:_txtViewPostInfo.text forKey:@"intro"];
        
        [iTourNetworking iTour_Post_JSONWithUrl:URL_comment parameters:_InfoDic success:^(id json) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [self showHint:@"评论成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });

            
        } fail:^(NSError *error) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
             [self showHint:@"评论失败"];
        }];
        
    }else if (_style == MessageStyle||_style == FeedbackStyle ){                    //建议
        [_InfoDic setObject:_txtViewPostInfo.text forKey:@"content"];
        [_InfoDic setObject:_txtPhoneNum.text forKey:@"tel"];
        [_InfoDic setObject:_txtEmaii.text forKey:@"mail"];
        [_InfoDic setObject:_type forKey:@"type"];
        
        [iTourNetworking iTour_Post_JSONWithUrl:URL_suggestion parameters:_InfoDic success:^(id json) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            
            [self showHint:@"评论成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } fail:^(NSError *error) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
            [self showHint:@"评论失败"];
        }];
        
    }else{
        NSLog(@"===========viewTpye parameter error ============");
    }
   
}
# pragma mark - text delegate

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
   
    if ([textView.text isEqualToString:kplaceholderOfComment]
        ||[_txtViewPostInfo.text isEqualToString:kplaceholderOfMessage]
        ||[_txtViewPostInfo.text isEqualToString:kplaceholderOfFeedback]) {
            textView.text = @"";
        }
    

    return YES;
}

-(BOOL)isPhoneNumber:(NSString *)string
{
    //正则表达式匹配
    //手机的格式以13、15、18 开头，后面9位数字
    NSString *patternTel = @"^1[3,5,8][0-9]{9}$";
    //邮箱的格式
    NSError *err = nil;
    NSRegularExpression *TelExp = [NSRegularExpression regularExpressionWithPattern:patternTel options:NSRegularExpressionCaseInsensitive error:&err];
    
    NSTextCheckingResult * isMatchTel = [TelExp firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    //二者匹配成功一个即可
    if (isMatchTel) {
        NSLog(@"格式正确");
        return YES;
    }
    //    NSLog(@"格式不正确");
    return NO;
}
@end
