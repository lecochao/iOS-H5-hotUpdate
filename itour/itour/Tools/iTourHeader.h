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

#define key_openCamera  @"iTourOpenCamera"