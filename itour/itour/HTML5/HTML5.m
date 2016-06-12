//
//  HTML5.m
//  itour
//
//  Created by Chaos on 16/5/25.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "HTML5.h"
#import "SSZipArchive.h"
#import "iTourNetworking.h"
#import <UIKit/UIKit.h>
@implementation HTML5

- (void) updateZipData
{
//    {
//        "app_version":"2.0", //APP的原生版本号
//        "html_version":1,    //html5的版本号，此版本号从1开始递增，整形
//        "title":"2016-05-25 2.0版本更新",
//        "note":"1.xxxx。\n2.xxxx。\n3.xxxx。\n4.xxxx。\n5.xxxx",
//        "app_url":"http://baidu.com",  //APP更新地址
//        "html_url" :"http://163.com/", //html更新地址，完整地址增加 html_version.zip，例如 http://163.com/5.zip ,全量包命名a+最新版本号.zip，录入a5.zip
//    }
   
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
    hud.labelText = @"加载中...";
    [iTourNetworking iTour_GET_JSONDataWithUrl:iTourWebUpdate Params:nil success:^(id json) {
        [hud hide:YES];
        if (json) {
            NSDictionary *data = (NSDictionary*)json;
            NSNumber *webversion = data[@"html_version"];
            NSString *baseUrl= data[@"html_url"];
            NSString *nowversion = ITOUR_GET_OBJECT(HTML5Versions);
            NSInteger fv = 0;
            if (nowversion) {
                fv = [nowversion integerValue];
            }else fv = fv +1;
            if ([webversion integerValue]>fv) {
                [self downloadWithFirst:fv Now:fv+1 Latest:[webversion integerValue] Url:baseUrl];
            }
        }
        
    } fail:^(NSError *error) {
         NSLog(@"检查更新 code=%@ %s",error.domain, __func__);
        [hud hide:YES];
    }];
}


/*!
 *  下载资源zip
 *
 *  @param fv      启动时的版本
 *  @param nv      当前需要下载版本
 *  @param lv      最新的版本
 *  @param baseUrl 资源基础地址
 */
- (void)downloadWithFirst:(NSInteger)fv Now:(NSInteger)nv Latest:(NSInteger)lv Url:(NSString *)baseUrl
{
    if (nv<=lv) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
        hud.labelText = @"下载中...";
        hud.detailsLabelText = [NSString stringWithFormat:@"(%ld/%ld)",nv-fv,lv-fv];
        hud.mode = MBProgressHUDModeDeterminate;
        NSString *url = [NSString stringWithFormat:@"%@%ld.zip",baseUrl,(long)nv];
        [iTourNetworking iTour_Down_UploadWithUrl:url
                                         FileName:@"HTML5.zip"
                                         Progress:^(CGFloat Progress) {
                                             hud.progress = Progress;
                                         }
                                          success:^(id filePath) {
                                              [hud hide:YES];
                                              if ([self zipReleaseAtHTML5]) {
                                                  NSString *nvStr = [NSString stringWithFormat:@"%ld",nv];
                                                  ITOUR_SET_OBJECT(nvStr, HTML5Versions);
                                             
                                                  [self downloadWithFirst:fv Now:nv+1 Latest:lv Url:baseUrl];
                                              }else{
                                                  //解压失败
                                                  [self showHint:[NSString stringWithFormat:@"资源V.%ld解压失败!",nv]];
                                                  if ([self zipReleaseAtHTML5]) {
                                                      NSString *nvStr = [NSString stringWithFormat:@"%ld",nv];
                                                      ITOUR_SET_OBJECT(nvStr, HTML5Versions);
                                                      [self downloadWithFirst:fv Now:nv+1 Latest:lv Url:baseUrl];
                                                  }else{
                                                      //二次解压失败后 下载全包
                                                      [self downloadWithUrl:baseUrl Latest:lv];
                                                  }
                                              }
                                          }
                                             fail:^(NSError *error) {
                                                 [hud hide:YES];
                                                 [self showHint:[NSString stringWithFormat:@"资源文件V.%ld下载失败\n请检查网络",nv]];
                                             }];

    }else if(nv-1 == lv) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"webViewReload" object:nil];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KeyWindow animated:NO];
        hud.mode = MBProgressHUDModeCustomView;
        UIImage *image = [[UIImage imageNamed:@"Checkmark"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        hud.customView = [[UIImageView alloc] initWithImage:image];
        hud.square = YES;
        hud.labelText = @"更新完成";
        [hud hide:YES afterDelay:1.f];
    }
}

/*!
 *  下载全包
 *
 *  @param url  基础地址
 *  @param lv   最新资源包版本
 */
- (void)downloadWithUrl:(NSString *)url Latest:(NSInteger)lv
{
    
    NSString *aUrl = [NSString stringWithFormat:@"%@a%ld.zip",url,lv];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:KeyWindow animated:YES];
    hud.labelText = @"下载中...";
    hud.mode = MBProgressHUDModeDeterminate;
    [iTourNetworking iTour_Down_UploadWithUrl:aUrl FileName:@"HTML5.zip" Progress:^(CGFloat Progress) {
         hud.progress = Progress;
    } success:^(id filePath) {
        if ([self zipReleaseAtHTML5]) {
            NSString *nvStr = [NSString stringWithFormat:@"%ld",lv];
            ITOUR_SET_OBJECT(nvStr, HTML5Versions);
        }
    } fail:^(NSError *error) {
        [self showHint:[NSString stringWithFormat:@"资源文件V.a%ld下载失败请检查网络",lv]];
    }];
}

/*!
 *  首次启动 zip写入沙盒
 *
 *  @return 是否成功
 */
- (BOOL) zipWriteAtDocument
{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSLog(document);
    NSString *zipPath= [document stringByAppendingPathComponent:@"HTML5.zip"];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *resPath = [bundle resourcePath];
    NSString *filePath = [resPath stringByAppendingPathComponent:@"HTML5.zip"];
    
    NSData*data = [NSData dataWithContentsOfFile:filePath options:0 error:nil];
    NSError *error;
    BOOL succeed = [data writeToFile:zipPath options:0 error:&error];
    if (!succeed || error) {
        NSLog(@"zip 写入沙盒失败！%@",error.domain);
    }
    return succeed;
}

/*!
 *  解压zip 并写入已存在文件夹下HTML5中
 */
- (BOOL) zipReleaseAtHTML5
{
    NSString *document = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *zipPath= [document stringByAppendingPathComponent:@"HTML5.zip"];
    NSString *destinationPath = [document stringByAppendingPathComponent:@"HTML5"];
    //    NSString *zipPath = @"被解压的文件路径";
    //    NSString *destinationPath = @"解压到的目录";
    BOOL success = [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath];
    if (success) {
        return success;
    }else{
        return [SSZipArchive unzipFileAtPath:zipPath toDestination:destinationPath];
    }
}

@end
