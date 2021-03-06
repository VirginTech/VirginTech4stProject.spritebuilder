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
    CCNode* catch_point;//CCB定義（キャッチ判定用）
    CCSprite* basket_Color;//CCB定義
}

@property CCSprite* basket_Color;

+(id)createBasket:(CGPoint)pos;

-(void)tire_Rotation:(float)angle;

@end
