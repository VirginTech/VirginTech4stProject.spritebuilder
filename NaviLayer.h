//
//  NaviLayer.h
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/10.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MsgBoxLayer.h"

@interface NaviLayer : CCScene <MsgLayerDelegate>
{
    CCLabelBMFont* gameOverLabel;
}

@property CCLabelBMFont* gameOverLabel;

+ (NaviLayer *)scene;
- (id)init;

@end
