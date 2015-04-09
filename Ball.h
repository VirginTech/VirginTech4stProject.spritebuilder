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
    bool stateFlg;
}

@property bool stateFlg;

+(id)createBall:(CGPoint)pos;

@end
