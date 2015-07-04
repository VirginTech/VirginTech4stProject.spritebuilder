//
//  GameCenterLayer.h
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/07/04.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <GameKit/GameKit.h>

@interface GameCenterLayer : CCScene <GKLeaderboardViewControllerDelegate>
{

}

+ (GameCenterLayer *)scene;
- (id)init;

-(void)showLeaderboard;

@end
