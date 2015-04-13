//
//  MsgLayer.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/25.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "MsgLayer.h"
#import "GameManager.h"
#import "StageScene.h"

@implementation MsgLayer

CGSize winSize;
CCLabelTTF* msg;
int cnt;
bool nextFlg;

+(MsgLayer *)scene{
    
    return [[self alloc] init];
}

-(id)initWithMsg:(NSString*)str nextFlg:(bool)flg{
    
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    cnt=0;
    nextFlg=flg;
    msg=[CCLabelTTF labelWithString:str fontName:@"Chalkduster" fontSize:40];
    msg.position=ccp(winSize.width/2,winSize.height/2+100);
    msg.opacity=0.0f;
    msg.color=[CCColor redColor];
    [self addChild:msg];
    
    [self schedule:@selector(show_Message_Schedule:)interval:0.05];
    
    return self;
}

-(void)show_Message_Schedule:(CCTime)dt
{
    //ポーズ脱出
    if([GameManager getPause]){
        return;
    }

    if(cnt<=20){
        msg.opacity+=0.05f;
    }else if(cnt>=30){
        msg.opacity-=0.05f;
    }
    cnt++;
    
    if(cnt==20 && nextFlg){
        //エンディング効果音
        //[SoundManager endingEffect];
    }
    
    if(cnt>=50){
        //終了時
        if(nextFlg){
            [self unschedule:@selector(show_Message_Schedule:)];
            //次ステージへ
            [GameManager setStageLavel:[GameManager getStageLevel]+1];//ステージレヴェル設定
            [[CCDirector sharedDirector] replaceScene:[StageScene scene]
                                       withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
            [self removeFromParentAndCleanup:YES];
        //スタート時
        }else{
            [self unschedule:@selector(show_Message_Schedule:)];
            [self removeFromParentAndCleanup:YES];
        }
    }
}

@end
