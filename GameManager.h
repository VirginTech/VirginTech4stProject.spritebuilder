//
//  GameManager.h
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/07.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameManager : NSObject

+(int)getDevice;
+(void)setDevice:(int)type;// 1:iPhone5,6 2:iPhone4 3:iPad2

+(void)setFailurePoint:(int)point;
+(int)getFailurePoint;
    
@end
