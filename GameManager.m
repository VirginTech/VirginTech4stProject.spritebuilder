//
//  GameManager.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/07.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "GameManager.h"

@implementation GameManager

float osVersion;//OSバージョン
int deviceType;// 1:iPad2 2:iPhone4 3:iPhone5 4:iPhone6
int scorePoint;//スコア
int pointCount;//持ち点
bool pauseFlg;//ポーズ
int stageLavel;//現在ステージレヴェル

//OSバージョン
+(void)setOsVersion:(float)version{
    osVersion=version;
}
+(float)getOsVersion{
    return osVersion;
}
//デバイス取得／登録
+(void)setDevice:(int)type{
    deviceType=type;
}
+(int)getDevice{
    return deviceType;
}
//スコア
+(void)setScore:(int)point{
    scorePoint=point;
}
+(int)getScore{
    return scorePoint;
}
//持ち点
+(void)setPointCount:(int)count{
    pointCount=count;
}
+(int)getPointCount{
    return pointCount;
}
//ポーズフラグ
+(void)setPause:(bool)flg{
    pauseFlg=flg;
}
+(bool)getPause{
    return pauseFlg;
}
//現在ステージレヴェル
+(void)setStageLavel:(int)level{
    stageLavel=level;
}
+(int)getStageLevel{
    return stageLavel;
}

//=======================
// 初回起動時 初期化処理
//=======================
+(void)initialize_Save_Data
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain];
    
    if([dict valueForKey:@"highscore"]==nil){
        [self save_High_Score:0];
    }
    if([dict valueForKey:@"stagelevel"]==nil){
        [self save_Stage_Level:0];
    }
    if([dict valueForKey:@"ticket"]==nil){
        [self save_Continue_Ticket:0];
    }
}

//====================
//ハイスコアの保存
//====================
+(void)save_High_Score:(int)value
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber* score=[NSNumber numberWithLong:value];
    [userDefault setObject:score forKey:@"highscore"];
    [userDefault synchronize];
}
//====================
//ハイスコアの取得
//====================
+(int)load_High_Score
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    int score=[[userDefault objectForKey:@"highscore"]intValue];
    return score;
}
//====================
//レヴェルの保存
//====================
+(void)save_Stage_Level:(int)value
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber* level=[NSNumber numberWithInt:value];
    [userDefault setObject:level forKey:@"stagelevel"];
    [userDefault synchronize];
}
//====================
//レヴェルの取得
//====================
+(int)load_Stage_Level
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    int level=[[userDefault objectForKey:@"stagelevel"]intValue];
    return level;
}
//===========================
//　コンティニューチケットの取得
//===========================
+(int)load_Continue_Ticket
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    int ticket=[[userDefault objectForKey:@"ticket"]intValue];
    return ticket;
}
//===========================
//　コンティニューチケットの保存
//===========================
+(void)save_Continue_Ticket:(int)value
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber* ticket=[NSNumber numberWithInt:value];
    [userDefault setObject:ticket forKey:@"ticket"];
}

@end
