//
//  Basket.h
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/08.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Basket : CCSprite {
    
    CCSprite* tire1;//CCB定義
    CCSprite* tire2;//CCB定義
}

+(id)createBasket:(CGPoint)pos;

-(void)tire_Rotation:(float)angle;

@end
