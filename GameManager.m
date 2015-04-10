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
int scorePoint;//スコア
int pointCount;//持ち点
bool pauseFlg;//ポーズ

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
}

//====================
//ハイスコアの保存
//====================
+(void)save_High_Score:(long)value
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber* score=[NSNumber numberWithLong:value];
    [userDefault setObject:score forKey:@"highscore"];
    [userDefault synchronize];
}
//====================
//ハイスコアの取得
//====================
+(long)load_High_Score
{
    NSUserDefaults  *userDefault=[NSUserDefaults standardUserDefaults];
    long score=[[userDefault objectForKey:@"highscore"]longValue];
    return score;
}

@end
