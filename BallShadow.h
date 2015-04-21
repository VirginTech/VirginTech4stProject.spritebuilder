//
//  BallShadow.h
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/21.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BallShadow : CCSprite
{
    int ball_Id;
}

@property int ball_Id;

+(id)createBall:(int)cnt;

@end
