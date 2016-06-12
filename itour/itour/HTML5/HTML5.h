//
//  HTML5.h
//  itour
//
//  Created by Chaos on 16/5/25.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTML5 : NSObject

/*!
 *  zip检测更新
 */
- (void) updateZipData;


/*!
 *  首次启动 zip写入沙盒
 *
 *  @return 是否成功
 */
- (BOOL) zipWriteAtDocument;

/*!
 *  解压zip 并写入已存在文件夹下HTML5中
 */
- (BOOL)zipReleaseAtHTML5;
@end
