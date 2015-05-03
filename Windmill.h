//
//  Pin.h
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/07.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Windmill : CCSprite
{
    CCSprite* axis;//CCB定義
    CCSprite* body;//CCB定義
    int num;
}

@property CCSprite* axis;

+(id)createWindmill:(CGPoint)pos titleFlg:(bool)titleFlg;

@end
