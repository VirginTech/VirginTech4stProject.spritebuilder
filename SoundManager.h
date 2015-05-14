//
//  SoundManager.h
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2015/01/07.
//  Copyright 2015年 VirginTech LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SoundManager : NSObject {
    
}

+(void)initSoundPreload;

//スイッチ
+(void)setBgmSwitch:(bool)flg;
+(bool)getBgmSwitch;
+(void)setEffectSwitch:(bool)flg;
+(bool)getEffectSwitch;

//BGM
+(void)playBGM:(NSString*)fileName;
+(void)stopBGM;
+(void)pauseBGM;
+(void)resumeBGM;

//ボリューム
+(void)setBgmVolume:(float)value;
+(float)getBgmVolume;
+(void)setEffectVolume:(float)value;
+(float)getEffectVolume;

+(void)all_Stop;

//エフェクト
+(void)pin_Ball_11_Effect;
+(void)pin_Ball_12_Effect;
+(void)pin_Ball_13_Effect;
+(void)pin_Ball_14_Effect;
+(void)pin_Ball_15_Effect;
+(void)pin_Ball_21_Effect;
+(void)pin_Ball_31_Effect;

+(void)catch_Ball_Effect;
+(void)catch_Pin_Effect;
+(void)ground_Ball_Effect;
+(void)ball_Launch_Effect;

//UIエフェクト
+(void)click_Effect;

@end
