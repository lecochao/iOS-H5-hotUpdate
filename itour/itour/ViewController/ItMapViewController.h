//
//  ItMapViewController.h
//  itour
//
//  Created by Chaos on 16/5/19.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "ItBaseViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ItMapViewController : ItBaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic ,strong) AVAudioPlayer *avAudioPlayer;
@property(nonatomic ,strong) AVAudioPlayer *playerNiao;
@end
