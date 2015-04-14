//
//  TitleScene.h
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/05.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GKitController.h"

@interface TitleScene : CCScene
{
    GKitController* gkc;
}

+ (TitleScene *)scene;
- (id)init;

@end
