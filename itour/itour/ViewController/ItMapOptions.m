//
//  ItMapOptions.m
//  itour
//
//  Created by Chaos on 16/6/8.
//  Copyright © 2016年 Chaos. All rights reserved.
//

#import "ItMapOptions.h"

@implementation ItMapOptions

+(void)showMapOptions:(NSArray*)titles Add:(UIView *)view Action:(void (^)(NSInteger n))action
{
    NSLog(@"ItMapOptions___%@ ",titles);
    ItMapOptions *_self = [[ItMapOptions alloc]initWithTitle:titles];
    _self.center = CGPointMake(CGRectGetWidth(view.bounds)/2, CGRectGetHeight(view.bounds)/2);
    [view addSubview:_self];
    _self.actionBlock =^(NSInteger mm){
        if (action) {
            action(mm);
        }
    };
}

-(instancetype)initWithTitle:(NSArray*)titles
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 200, 40*titles.count);
        [self setUIKitWithTitle:titles];
        
    }
    return self;
}

-(void)setUIKitWithTitle:(NSArray*)titles
{
    UIView *backView = [UIView new];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 3.f;
    backView.layer.masksToBounds = YES;
    backView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    backView.layer.borderWidth = 0.5f;
    backView.frame = self.bounds;
    [self addSubview:backView];
    for (int i=0; i<titles.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(-0.5, 40*i, 1+CGRectGetWidth(backView.bounds), 40)];
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i+100;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 0.5f;
        [backView addSubview:btn];
    }
}

-(void)action:(UIButton *)btn
{
    [self removeFromSuperview];
    if (_actionBlock) {
        self.actionBlock(btn.tag -100);
        
    }
    
}
@end
