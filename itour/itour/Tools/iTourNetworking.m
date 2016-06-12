//
//  iTourNetworking.m
//  itour
//
//  Created by Chaos on 16/5/26.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "iTourNetworking.h"
#import "SSKeychain.h"
#import "MBProgressHUD.h"

@implementation iTourNetworking

+ (void)iTourUserLoading
{
    NSString *udid = [NSString stringWithFormat:@"ios_%@",[self UUID]];
    NSString *url = [NSString stringWithFormat:@"%@%@",iTourBaseUrl,iTourUserLogin];
    NSLog(@"%@",udid);
    [self iTour_Post_JSONWithUrl:url parameters:@{@"udid":udid} success:^(id json) {
        if (json) {
            NSDictionary *data = json;
            NSNumber *errorCode = data[@"errorCode"];
            if ([errorCode isEqualToNumber:@0]) {
                NSString *sid = data[@"result"][@"sid"];
                ITOUR_SET_OBJECT(sid, UserToken);
                NSLog(@"token sid_%@",sid);
            }else{
                NSLog(@"错误 code=%@ %s",errorCode, __func__);
                [self errorCode:errorCode];
            }
        }
        
    } fail:^(NSError *error) {
         NSLog(@"错误 code=%@ %s",error.domain, __func__);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"错误，请检查网络";
        hud.margin = 10;
        hud.yOffset = 200;
        [hud hide:YES afterDelay:2.f];
    }];
}

+ (void)errorCode:(NSNumber *)code
{
    NSUInteger _code = [code integerValue];
    switch (_code) {
        case 1001:
            NSLog(@"服务器内部-数据库连接错误");
            break;
        case 1002:
            NSLog(@"服务器内部-权限引发错误");
            break;
        case 1003:
            NSLog(@"服务器内部-尚未实现");
            break;
        case 1004:
            NSLog(@"服务器内部-数据库更新操作失败");
            break;
        case 2001:
            NSLog(@"非法调用-参数错误等");
            break;
        case 2002:
            NSLog(@"無權限$cPermissionError");
            break;
        case 9999:
            NSLog(@"unknown error");
            break;
        case 101:
            NSLog(@"userLoginFailed");
            break;
        case 102:
            NSLog(@"userNotLogin");
            break;
        case 103:
            NSLog(@"User not exists");
            break;
        case 104:
            NSLog(@"scene not exists");
            break;
        case 105:
            NSLog(@"Too far to plan a route");
            break;
        default:
            NSLog(@"unknown error");
            break;
    }
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
//+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
//    if (jsonString == nil) {
//        return nil;
//    }
//    
//    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err;
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
//                                                        options:NSJSONReadingMutableContainers
//                                                          error:&err];
//    if(err) {
//        NSLog(@"json解析失败：%@",err);
//        return nil;
//    }
//    return dic;
//}

+ (NSString *)UUID {

    NSString *UUID = [SSKeychain passwordForService:@"iTourAPPUUID" account:@"com.iuxlabs.iTour.group"];
    
    if (UUID.length == 0) {
        NSError *error;
        UUID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        BOOL success = [SSKeychain setPassword:UUID forService:@"iTourAPPUUID"  account:@"com.iuxlabs.iTour.group" error:&error];
        if (!success || error) {
            NSLog(@"UUID 存入 Keychain 失败");
        }
    }
    return UUID;
}

#pragma mark - 检测网络状态
+ (void)netWorkingStatus
{
    /**
     AFNetworkReachabilityStatusUnknown          = -1,  // 未知
     AFNetworkReachabilityStatusNotReachable     = 0,   // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1,   // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2,   // WiFi
     */
    //如果要检测网络状态变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    //监测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"netWorkingStatus %ld", (long)status);
        if (status == AFNetworkReachabilityStatusReachableViaWWAN||
            status ==  AFNetworkReachabilityStatusReachableViaWiFi) {
             NSString *sid = ITOUR_GET_OBJECT(UserToken);
            if (!sid) {
                [self iTourUserLoading];
            }
        }else{
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"网络异常";
            hud.margin = 10;
            hud.yOffset = 200;
            [hud hide:YES afterDelay:2.f];

        }
        
    }];
    
}

+ (void)iTour_GET_JSONDataWithUrl:(NSString *)urlStr
                           Params:(NSDictionary*)params
                          success:(void (^)(id json))success
                             fail:(void (^)(NSError *error))fail
{

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求格式
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString *url = [NSString stringWithFormat:@"%@",urlStr];
    NSLog(@"GET_param == %@", params);
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"url %lli  currentProgress %lli",downloadProgress.totalUnitCount,downloadProgress.completedUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];
}

+ (void)iTour_Post_JSONWithUrl:(NSString *)urlStr
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(id json))success
                          fail:(void (^)(NSError *error))fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求格式
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 5.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString *url = [NSString stringWithFormat:@"%@",urlStr];
    NSLog(@"Post_param == %@", parameters);
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"url %lli  currentProgress %lli",downloadProgress.totalUnitCount,downloadProgress.completedUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];
    
}

+ (void)iTour_Post_UploadWithUrl:(NSString *)urlStr
                          Params:(NSDictionary*)params
                        Data_arr:(NSArray*)data_arr
                         success:(void (^)(id responseObject))success
                            fail:(void (^)(NSError *error))fail
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    //设置请求格式
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    // 设置超时时间
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = 5.f;
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < data_arr.count; i++) {
            NSDictionary *picDic = [data_arr objectAtIndex:i];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setTimeZone:[NSTimeZone systemTimeZone]];
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString* dateString = [formatter stringFromDate:[NSDate date]];
            dateString = [NSString stringWithFormat:@"%@_%lu.png",dateString,data_arr.count + 1];
            NSData* data = [NSData data];
            data = [picDic objectForKey:@"picData"];
            NSString  *path = NSHomeDirectory();
            NSLog(@"path:%@",path);
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString* documentsDirectory = [paths objectAtIndex:0];
            NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:dateString];
            
            [data writeToFile:fullPathToFile atomically:NO];
            //            NSString* name = [picDic objectForKey:@"picKey"]; 原来是这样写的
            //            [formData appendPartWithFileData:data name:name fileName:dateString mimeType:@"image/png"];
            [formData appendPartWithFileData:data name:@"avatar" fileName:@"photo.png" mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
        }
    }];
}


+(void)iTour_Down_UploadWithUrl:(NSString *)url
                       FileName:(NSString *)fileName
                       Progress:(void (^)(CGFloat Progress))progress
                        success:(void (^)(id filePath))success
                           fail:(void (^)(NSError *error))fail
{
    
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
//    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request
//                                                                     progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"___%lli__%lli",downloadProgress.completedUnitCount,downloadProgress.totalUnitCount);
//    }
//                                                                  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//    }
//                                                            completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        NSLog(@"File downloaded to: %@", filePath);
//    }];
//    [downloadTask resume];
    
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    //默认传输的数据类型是二进制
//    sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSURLSessionDownloadTask *downloadTask = [sessionManager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
                                   progress:^(NSProgress * _Nonnull downloadProgress) {
                                       //处理下载进度
                                       if (progress) {
                                           
                                           CGFloat _progress = (float)downloadProgress.completedUnitCount/(float)downloadProgress.totalUnitCount;
                                           NSLog(@"_progress %f",_progress);
                                           progress(_progress);
                                       }
    }
                                destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                                    //沙盒的Documents路径
                                    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
                                    return [documentsDirectoryURL URLByAppendingPathComponent:@"HTML5.zip"];

    }
                          completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                              if (!error) {
                                  NSLog(@"download %@ path:%@",fileName,filePath);
                                  if (success) {
                                      success(filePath);
                                  }
                              }else{
                                  if (fail) {
                                      fail(error);
                                  }
                              }
        
    }];
    [downloadTask resume];
}
@end
