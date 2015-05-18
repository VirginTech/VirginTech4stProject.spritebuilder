//
//  SoundManager.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2015/01/07.
//  Copyright 2015年 VirginTech LLC. All rights reserved.
//

#import "SoundManager.h"

@implementation SoundManager

bool bgmSwitch;
bool effectSwitch;

float bgmValue;
float effectValue;

//===================
//BGM・効果音プリロード
//===================
+(void)initSoundPreload
{
    //BGM
    [[OALSimpleAudio sharedInstance]preloadBg:@"bgm.mp3"];
    
    //エフェクト
    [[OALSimpleAudio sharedInstance]preloadEffect:@"pin_ball_11.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"pin_ball_12.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"pin_ball_13.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"pin_ball_14.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"pin_ball_15.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"pin_ball_21.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"pin_ball_31.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"catch_ball.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"catch_pin.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"ground_ball.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"ball_launch.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"game_finish.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"highscore1.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"highscore2.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"game_over.mp3"];
    
    //UI
    [[OALSimpleAudio sharedInstance]preloadEffect:@"mode_btn_click.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"btn_click.mp3"];
    [[OALSimpleAudio sharedInstance]preloadEffect:@"game_start.mp3"];
    
    //スイッチ
    bgmSwitch=true;
    effectSwitch=true;
    
    //BGM音量初期値セット
    bgmValue=0.5;
    //エフェクト音量初期値セット
    effectValue=0.5;
}

//===================
// BGMスイッチ
//===================
+(void)setBgmSwitch:(bool)flg
{
    bgmSwitch=flg;
}
+(bool)getBgmSwitch
{
    return bgmSwitch;
}
//===================
// エフェクトスイッチ
//===================
+(void)setEffectSwitch:(bool)flg
{
    effectSwitch=flg;
}
+(bool)getEffectSwitch
{
    return effectSwitch;
}
//===================
// BGM音量セット
//===================
+(void)setBgmVolume:(float)value
{
    bgmValue=value;
    [[OALSimpleAudio sharedInstance]setBgVolume:bgmValue];
}
+(float)getBgmVolume
{
    return bgmValue;
}

//===================
// エフェクト音量セット
//===================
+(void)setEffectVolume:(float)value
{
    effectValue=value;
}
+(float)getEffectVolume
{
    return effectValue;
}

//===================
// BGM
//===================
+(void)playBGM:(NSString*)fileName
{
    if(bgmSwitch){
        //BGMがプレイ中でなければ、もしくはポーズ中であれば
        if(![[OALSimpleAudio sharedInstance]bgPlaying] || [[OALSimpleAudio sharedInstance]bgPaused]){
            [[OALSimpleAudio sharedInstance]setBgVolume:bgmValue];
            [[OALSimpleAudio sharedInstance]playBg:fileName loop:YES];
        }
    }
}
+(void)stopBGM
{
    [[OALSimpleAudio sharedInstance]stopBg];
}
+(void)pauseBGM
{
    [[OALSimpleAudio sharedInstance]setPaused:YES];
}
+(void)resumeBGM
{
    [[OALSimpleAudio sharedInstance]setPaused:NO];
}

//===================
// エフェクト
//===================
+(void)pin_Ball_11_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"pin_ball_11.mp3"];
    }
}
+(void)pin_Ball_12_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"pin_ball_11.mp3"];
    }
}
+(void)pin_Ball_13_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"pin_ball_11.mp3"];
    }
}
+(void)pin_Ball_14_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"pin_ball_11.mp3"];
    }
}
+(void)pin_Ball_15_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"pin_ball_11.mp3"];
    }
}
+(void)pin_Ball_21_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"pin_ball_21.mp3"];
    }
}
+(void)pin_Ball_31_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"pin_ball_31.mp3"];
    }
}
+(void)catch_Ball_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"catch_ball.mp3"];
    }
}
+(void)catch_Pin_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"catch_pin.mp3"];
    }
}
+(void)ground_Ball_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"ground_ball.mp3"];
    }
}
+(void)ball_Launch_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"ball_launch.mp3"];
    }
}
+(void)high_Score1_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"highscore1.mp3"];
    }
}
+(void)high_Score2_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"highscore2.mp3"];
    }
}
+(void)game_Finish_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"game_finish.mp3"];
    }
}
+(void)game_Over_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"game_over.mp3"];
    }
}
//===================
// UI
//===================
+(void)mode_Btn_Click_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"mode_btn_click.mp3"];
    }
}
+(void)btn_Click_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"btn_click.mp3"];
    }
}
+(void)game_Start_Effect
{
    if(effectSwitch){
        [[OALSimpleAudio sharedInstance]setEffectsVolume:effectValue];
        [[OALSimpleAudio sharedInstance]playEffect:@"game_start.mp3"];
    }
}
//===================
// オールストップ
//===================
+(void)all_Stop
{
    [[OALSimpleAudio sharedInstance]stopEverything];
}

@end
