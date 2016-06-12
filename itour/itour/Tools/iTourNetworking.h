//
//  iTourNetworking.h
//  itour
//
//  Created by Chaos on 16/5/26.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface iTourNetworking : NSObject


+ (void)iTourUserLoading;

+ (NSString *)UUID;

//检测网络状态
+ (void)netWorkingStatus;

/**
 *   Get 请求 JSON
 *
 *  @param urlStr   URL 名称
 *  @param params  数据字典
 *  @param success 请求成功返回值
 *  @param fail    请求失败返回值
 */
+ (void)iTour_GET_JSONDataWithUrl:(NSString *)urlStr
                           Params:(NSDictionary*)params
                          success:(void (^)(id json))success
                             fail:(void (^)(NSError *error))faill;

/**
 * POST 请求 JSON 不带缓存
 *  @param urlStr     URL 名称
 *  @param parameters 数据字典 (建议可变字典)
 *  @param success    请求成功返回的参数
 *  @param fail       请求失败返回的参数
 */
+ (void)iTour_Post_JSONWithUrl:(NSString *)urlStr
                    parameters:(NSDictionary *)parameters
                       success:(void (^)(id json))success
                          fail:(void (^)(NSError *error))fail;

/**
 *  post 上传文件! 图片
 *
 *  @param urlStr   URL 链接名/ 宏拼接
 *  @param params   除了文件以外需要上传的数据
 *  @param data_arr 图片数组 此数组只保存 data 格式的元素
 *  @param success  请求成功返回值
 *  @param fail     请求失败返回值
 */
+ (void)iTour_Post_UploadWithUrl:(NSString *)urlStr
                          Params:(NSDictionary*)params
                        Data_arr:(NSArray*)data_arr
                         success:(void (^)(id responseObject))success
                            fail:(void (^)(NSError *error))fail;


/*!
 *  文件下载
 *
 *  @param url      下载地址
 *  @param success  成功 文件路径
 *  @param fileName 存储文件名
 *  @param fail     失败的error
 */
+(void)iTour_Down_UploadWithUrl:(NSString *)url
                       FileName:(NSString *)fileName
                       Progress:(void (^)(CGFloat Progress))progress
                        success:(void (^)(id filePath))success
                           fail:(void (^)(NSError *error))fail;
/**
 要使用常规的AFN网络访问
 
 1. AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 
 所有的网络请求,均有manager发起
 
 2. 需要注意的是,默认提交请求的数据是二进制的,返回格式是JSON
 
 1> 如果提交数据是JSON的,需要将请求格式设置为AFJSONRequestSerializer
 2> 如果返回格式不是JSON的,
 
 3. 请求格式
 
 AFHTTPRequestSerializer            二进制格式
 AFJSONRequestSerializer            JSON
 AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
 
 4. 返回格式
 AFHTTPResponseSerializer           二进制格式
 AFJSONResponseSerializer           JSON
 AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
 AFXMLDocumentResponseSerializer (Mac OS X)
 AFPropertyListResponseSerializer   PList
 AFImageResponseSerializer          Image
 AFCompoundResponseSerializer       组合
 */
@end
