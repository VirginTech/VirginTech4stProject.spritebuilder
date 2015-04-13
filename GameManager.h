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

+(void)setScore:(int)point;
+(int)getScore;
+(void)setPointCount:(int)count;
+(int)getPointCount;
+(void)setPause:(bool)flg;
+(bool)getPause;
+(void)setStageLavel:(int)level;
+(int)getStageLevel;

+(void)initialize_Save_Data;

+(void)save_High_Score:(int)value;
+(int)load_High_Score;
+(void)save_Stage_Level:(int)value;
+(int)load_Stage_Level;

@end
