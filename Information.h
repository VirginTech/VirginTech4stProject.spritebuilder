//
//  Infomation.h
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/09.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Information : CCScene {
    
}

+ (Information *)scene;
- (id)init;

+(void)scoreUpdata;
+(void)highScoreUpdata;
+(void)lifePointUpdata;

@end
