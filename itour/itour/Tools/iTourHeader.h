//
//  iTourHeader.h
//  
//
//  Created by Chaos on 16/5/23.
//
//

#ifndef iTourHeader_h
#define iTourHeader_h


#endif /* iTourHeader_h */

#import "NSObject+HUD.h"


#define RGB(r,g,b) [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1]

#define WGNull @""

#pragma mark - 系统数据 -
//applicationFrame
#define ApplicationFrame [[UIScreen mainScreen] applicationFrame]
//bounds
#define Bounds [[UIScreen mainScreen] bounds]
//keyWindow
#define KeyWindow [[UIApplication sharedApplication] keyWindow]

#define DelegateWindow [[[UIApplication sharedApplication] delegate] window]

//weakSelf
#define WEAKOBJECT(obj,objName) typeof(obj) __weak objName = obj;

#define WEAKSELF WEAKOBJECT(self,weakSelf);


/**
 *	永久存储对象
 *
 *	@param	object    需存储的对象
 *	@param	key    对应的key
 */
#define ITOUR_SET_OBJECT(object, key)                                                                                                 \
({                                                                                                                                             \
NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];                                                                         \
[defaults setObject:object forKey:key];                                                                                                    \
[defaults synchronize];                                                                                                                    \
})
/**
 *	取出永久存储的对象
 *
 *	@param	key    所需对象对应的key
 *	@return	key所对应的对象
 */
#define ITOUR_GET_OBJECT(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define ITOUR_REMOVE_OBJECT(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]

#define key_openCamera  @"iTourOpenCamera"




#define APPSourceFV @"3"  /**< 当前工程文件下H5资源包的版本*/
/*!
 *  document下 HTMl5文件夹
 *
 *  @return HTMl5文件夹
 */
#define HTML5Source @"HTML5"
#define HTML5Versions @"HTML5Versions"
#define APPFirstStarting @"APPFirstStarting"
#define UserToken @"iTourUserToken"
#define APPColorRed RGB(226,59,35)
#define APPColorGray RGB(99,99,99)
#define APPTextFont(s) [UIFont systemFontOfSize:s]
#pragma mark - api -
#define iTourWebUpdate @"http://iuxlabs.com/iux/web/update/ios.json"
#define iTourBaseUrl @"http://iuxlabs.com/iux/web/s/" //全部 post

/*
 返回类型
{
    "errorCode": 0,
    "result": {
        "sid": "qi5na2tiheoktfs1m4jle0o6q4"   //token，以后每次访问都传递该数值
    }
}
 */


/*!
 *  登录（获取token）,每次打开APP都调用此接口重新获取token
 *
 *  @return token
 */
#define iTourUserLogin @"user/login.php"

/*!
 *  发布照片/发布排行榜/发布评论
 *  参数 -- 发布照片
 sessionId  :token
 dispatch: gallery
 intro：介绍
 topic：主题
 address：定位地址
 postTime：当前时间戳，int型，10位
 contact：联系方式
 img：七牛上传图片返回的key
 
 *  参数 -- 发布排行榜
 sessionId  :token
 dispatch: gallery
 intro：介绍
 topic：主题
 address：定位地址
 postTime：当前时间戳，int型，10位
 contact：联系方式
 reason：推荐原因
 img：七牛上传图片返回的key，多个key使用|拼接
 
 *  参数 -- 发布评论
 sessionId  :token
 dispatch：scene或者message，scene为景点评论，message为其它评论
 assoId：关联ID，若为景点则为景点ID，若为其它，则为主题ID
 
 intro：评论内容
 *  @return 不知道
 */
#define iTourCommentWrite @"comment/v2/write.php"



