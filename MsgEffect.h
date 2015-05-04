//
//  MsgLayer.h
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/25.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MsgBoxLayer.h"

@interface MsgEffect : CCScene <MsgLayerDelegate>
{
    
}

+ (MsgEffect *)scene;
- (id)initWithMsg:(NSString*)str nextFlg:(bool)flg;

@end
