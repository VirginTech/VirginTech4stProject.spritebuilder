//
//  MsgLayer.m
//  VirginTech2ndProject
//
//  Created by VirginTech LLC. on 2014/09/25.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "MsgEffect.h"
#import "GameManager.h"
#import "StageScene.h"

#import "ImobileSdkAds/ImobileSdkAds.h"

@implementation MsgEffect

CGSize winSize;
CCLabelBMFont* msg;
int cnt;
bool nextFlg;

+(MsgEffect *)scene{
    
    return [[self alloc] init];
}

-(id)initWithMsg:(NSString*)str nextFlg:(bool)flg{
    
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //バックグラウンド
    CCNodeColor* background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.7f]];
    [self addChild:background];
    
    cnt=0;
    nextFlg=flg;
    //msg=[CCLabelTTF labelWithString:str fontName:@"Chalkduster" fontSize:40];
    msg=[CCLabelBMFont labelWithString:str fntFile:@"msgEffect.fnt"];
    msg.position=ccp(winSize.width/2,winSize.height/2+50);
    msg.opacity=0.0f;
    //msg.color=[CCColor redColor];
    [self addChild:msg];
    
    [self schedule:@selector(show_Message_Schedule:)interval:0.01];
    
    return self;
}

-(void)show_Message_Schedule:(CCTime)dt
{
    //ポーズ脱出
    if([GameManager getPause]){
        return;
    }

    if(cnt<=100){
        msg.opacity+=0.01f;
    }else if(cnt>=150){
        msg.opacity-=0.01f;
    }
    cnt++;
    
    if(cnt==100 && nextFlg){
        //エンディング効果音
        //[SoundManager endingEffect];

        //レイティング
        if([GameManager getStageLevel]%10==0){
            //カスタムアラートメッセージ
            MsgBoxLayer* msgBox=[[MsgBoxLayer alloc]initWithTitle:NSLocalizedString(@"Rate",NULL)
                                                        msg:NSLocalizedString(@"Rate_Message",NULL)
                                                        pos:ccp(winSize.width/2,winSize.height/2)
                                                        size:CGSizeMake(230, 100)
                                                        modal:true
                                                        rotation:false
                                                        type:1
                                                        procNum:1];
            msgBox.delegate=self;//デリゲートセット
            [self addChild:msgBox z:3];
            
            //停止
            [[CCDirector sharedDirector]pause];
            //[GameManager setPause:true];
        }

    }
    
    if(cnt>=250){
        //終了時
        if(nextFlg){
            [self unschedule:@selector(show_Message_Schedule:)];
            
            //インターステイシャル広告表示
            //[ImobileSdkAds showBySpotID:@"457103"];
            
            //次ステージへ
            if([GameManager getPlayMode]==1){
                [GameManager setStageLavel:[GameManager getStageLevel]+1];//ステージレヴェル設定
                [[CCDirector sharedDirector] replaceScene:[StageScene scene]
                                       withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
            }else{
                [GameManager setStageLavel:[GameManager getStageLevel]+1];//ステージレヴェル設定
                [GameManager setScore:0];

                [[CCDirector sharedDirector] replaceScene:[StageScene scene]
                                           withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
            }
            [self removeFromParentAndCleanup:YES];
        //スタート時
        }else{
            [self unschedule:@selector(show_Message_Schedule:)];
            [self removeFromParentAndCleanup:YES];
        }
    }
}

//=====================
// デリゲートメソッド
//=====================
-(void)onMessageLayerBtnClocked:(int)btnNum procNum:(int)procNum
{
    if(procNum==1){
        if(btnNum==2){//YES
            NSURL* url = [NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=985536616&mt=8&type=Purple+Software"];
            [[UIApplication sharedApplication]openURL:url];
            //再開
            [[CCDirector sharedDirector]resume];
            //[GameManager setPause:false];
        }else{
            //再開
            [[CCDirector sharedDirector]resume];
            //[GameManager setPause:false];
        }
    }
}

@end
