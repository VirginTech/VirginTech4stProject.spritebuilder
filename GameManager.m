//
//  GameManager.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/07.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager

int deviceType;// 1:iPhone5,6 2:iPhone4 3:iPad2

//デバイス取得／登録
+(void)setDevice:(int)type{
    deviceType=type;
}
+(int)getDevice{
    return deviceType;
}

@end
