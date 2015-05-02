//
//  Ball.h
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/07.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Ball : CCSprite
{
    int ball_Id;
    bool stateFlg;
    int ballType;//1:ノーマル 2:天使 3:悪魔
    CCColor* ballColor;
}

@property int ball_Id;
@property bool stateFlg;
@property int ballType;;
@property CCColor* ballColor;

+(id)createBall:(CGPoint)pos type:(int)type cnt:(int)cnt;

@end
