//
//  TitleScene.h
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/05.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <StoreKit/StoreKit.h>
#import "MsgBoxLayer.h"

@interface TitleScene : CCScene <MsgLayerDelegate,CCPhysicsCollisionDelegate>
{
    
}

+ (TitleScene *)scene;
- (id)init;

+(void)ticket_Update;

@end
