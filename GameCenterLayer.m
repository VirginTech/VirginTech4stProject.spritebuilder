//
//  GameCenterLayer.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/07/04.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "GameCenterLayer.h"

@implementation GameCenterLayer

CGSize winSize;

+ (GameCenterLayer *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    return self;
}

//=====================
//　リーダーボード表示
//=====================
- (void) showLeaderboard
{
    //LeaderboardのViewControllerを生成する
    GKLeaderboardViewController *leaderboardController=[[GKLeaderboardViewController alloc]init];
    
    //UIViewControllerを取得する
    UIViewController *viewController = (UIViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    /*こちらでも良い
     UIViewController *viewController=[[UIViewController alloc]init];
    [[[CCDirector sharedDirector]view] addSubview:viewController.view];
     */
    
    // delegateを設定する
    leaderboardController.leaderboardDelegate = self;
    
    //Leaderboardを表示する
    [viewController.view.window.rootViewController presentViewController:
                                        leaderboardController animated:YES completion:^(void){}];
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)_viewController
{
    //Leaderboardを非表示にする
    [_viewController dismissViewControllerAnimated:YES completion:^(void){}];
}

@end
