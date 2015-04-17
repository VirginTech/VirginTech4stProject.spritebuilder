//
//  Pin.h
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/07.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Pin : CCSprite
{
    CCSprite* axis;//CCB定義
    CCSprite* pinBody;//CCB定義
}

@property CCSprite* axis;

+(id)createPin:(CGPoint)pos;

@end
