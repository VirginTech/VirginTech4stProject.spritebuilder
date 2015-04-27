//
//  GameManager.h
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/07.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameManager : NSObject

+(float)getOsVersion;
+(void)setOsVersion:(float)version;
+(int)getDevice;
+(void)setDevice:(int)type;// 1:iPhone5,6 2:iPhone4 3:iPad2

+(void)setScore:(int)point;
+(int)getScore;
+(void)setLifePoint:(int)point;
+(int)getLifePoint;
+(void)setPause:(bool)flg;
+(bool)getPause;
+(void)setStageLavel:(int)level;
+(int)getStageLevel;
+(void)setPlayMode:(int)mode;
+(int)getPlayMode;
    
+(void)initialize_Save_Data;

//スコアモード用
+(void)save_High_Score_1:(int)value;
+(int)load_High_Score_1;
+(void)save_Stage_Level_1:(int)value;
+(int)load_Stage_Level_1;

//ステージモード用
+(void)save_High_Score_2:(int)value;
+(int)load_High_Score_2;
+(void)save_Stage_Level_2:(int)value;
+(int)load_Stage_Level_2;

+(int)load_Continue_Ticket;
+(void)save_Continue_Ticket:(int)value;

+(NSDate*)load_Login_Date;
+(void)save_login_Date:(NSDate*)date;

@end
