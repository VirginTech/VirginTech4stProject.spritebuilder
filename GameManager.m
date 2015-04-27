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
int lifePoint;//持ち点
bool pauseFlg;//ポーズ
int stageLavel;//現在ステージレヴェル
int playMode;//1:スコアチャレンジ 2:ステージチャレンジ

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
+(void)setLifePoint:(int)point{
    lifePoint=point;
}
+(int)getLifePoint{
    return lifePoint;
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
//プレイモード
+(void)setPlayMode:(int)mode{
    playMode=mode;
}
+(int)getPlayMode{
    return playMode;
}

//=======================
// 初回起動時 初期化処理
//=======================
+(void)initialize_Save_Data
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain];
    
    if([dict valueForKey:@"highscore1"]==nil){
        [self save_High_Score_1:0];
    }
    if([dict valueForKey:@"stagelevel1"]==nil){
        [self save_Stage_Level_1:0];
    }
    if([dict valueForKey:@"highscore2"]==nil){
        [self save_High_Score_2:0];
    }
    if([dict valueForKey:@"stagelevel2"]==nil){
        [self save_Stage_Level_2:0];
    }
    if([dict valueForKey:@"ticket"]==nil){
        [self save_Continue_Ticket:0];
    }
}

//====================
//ハイスコアの保存（スコアモード用）
//====================
+(void)save_High_Score_1:(int)value
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber* score=[NSNumber numberWithLong:value];
    [userDefault setObject:score forKey:@"highscore1"];
    [userDefault synchronize];
}
//====================
//ハイスコアの取得（スコアモード用）
//====================
+(int)load_High_Score_1
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    int score=[[userDefault objectForKey:@"highscore1"]intValue];
    return score;
}
//====================
//レヴェルの保存（スコアモード用）
//====================
+(void)save_Stage_Level_1:(int)value
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber* level=[NSNumber numberWithInt:value];
    [userDefault setObject:level forKey:@"stagelevel1"];
    [userDefault synchronize];
}
//====================
//レヴェルの取得（スコアモード用）
//====================
+(int)load_Stage_Level_1
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    int level=[[userDefault objectForKey:@"stagelevel1"]intValue];
    return level;
}
//====================
//ハイスコアの保存（ステージモード用）
//====================
+(void)save_High_Score_2:(int)value
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber* score=[NSNumber numberWithLong:value];
    [userDefault setObject:score forKey:@"highscore2"];
    [userDefault synchronize];
}
//====================
//ハイスコアの取得（ステージモード用）
//====================
+(int)load_High_Score_2
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    int score=[[userDefault objectForKey:@"highscore2"]intValue];
    return score;
}
//====================
//レヴェルの保存（ステージモード用）
//====================
+(void)save_Stage_Level_2:(int)value
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber* level=[NSNumber numberWithInt:value];
    [userDefault setObject:level forKey:@"stagelevel2"];
    [userDefault synchronize];
}
//====================
//レヴェルの取得（ステージモード用）
//====================
+(int)load_Stage_Level_2
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    int level=[[userDefault objectForKey:@"stagelevel2"]intValue];
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

//=========================================
//　ログイン日の取得
//=========================================
+(NSDate*)load_Login_Date
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSDate* date =[userDefault objectForKey:@"LoginDate"];
    return date;
}

//=========================================
//　ログイン日の保存
//=========================================
+(void)save_login_Date:(NSDate*)date
{
    //日付のみに変換
    NSCalendar *calen = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *comps = [calen components:unitFlags fromDate:date];
    //[comps setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];//GMTで貫く
    NSDate *date_ = [calen dateFromComponents:comps];
    
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    [userDefault setObject:date_ forKey:@"LoginDate"];
}

@end
