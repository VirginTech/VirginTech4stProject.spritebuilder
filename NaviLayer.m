//
//  NaviLayer.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/10.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "NaviLayer.h"
#import "TitleScene.h"
#import "GameManager.h"
#import "StageScene.h"
#import "StageModeMenu.h"
#import "SoundManager.h"
#import <Social/Social.h>

#import "IAdLayer.h"
#import "IMobileLayer.h"

@implementation NaviLayer

@synthesize gameOverLabel;

CGSize winSize;
CCNodeColor *background;
MsgBoxLayer* msgBox;

//Ad
IMobileLayer* iMobileAd;
IAdLayer* iAdLayer;

+ (NaviLayer *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //バックグラウンド
    background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.7f]];
    [self addChild:background];
        
    //ゲームオーバーラベル
    //gameOverLabel=[CCLabelTTF labelWithString:@"" fontName:@"Verdana-Bold" fontSize:30];
    gameOverLabel=[CCLabelBMFont labelWithString:@"" fntFile:@"msgEffect.fnt"];
    gameOverLabel.position=ccp(winSize.width/2,winSize.height/2+70);
    [self addChild:gameOverLabel];
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"navi_default.plist"];
    
    //タイトルボタン
    CCButton* titleBtn=[CCButton buttonWithTitle:@""
                    spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"title01.png"]
                    highlightedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"title02.png"]
                    disabledSpriteFrame:nil];
    titleBtn.scale=0.5;
    titleBtn.position=ccp(winSize.width/2,winSize.height/2-50);
    [titleBtn setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleBtn];
    
    //タイトルボタンラベル
    CCLabelTTF* titleLabel=[CCLabelTTF labelWithString:NSLocalizedString(@"HomeTo",NULL)
                                                            fontName:@"Verdana-Bold" fontSize:20];
    titleLabel.position=ccp(titleBtn.contentSize.width/2,-titleLabel.contentSize.height/2);
    [titleBtn addChild:titleLabel];
    
    if([GameManager getPlayMode]==1){
        //プレイボタン
        //CCButton* startBtn=[CCButton buttonWithTitle:@"[はじめから]" fontName:@"Verdana-Bold" fontSize:15];
        CCButton* playBtn=[CCButton buttonWithTitle:@""
                    spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"play01.png"]
                    highlightedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"play02.png"]
                    disabledSpriteFrame:nil];
        playBtn.scale=0.5;
        playBtn.position=ccp(titleBtn.position.x-(titleBtn.contentSize.width*titleBtn.scale)/2-(playBtn.contentSize.width*playBtn.scale)/2,winSize.height/2-50);
        [playBtn setTarget:self selector:@selector(onPlayClicked:)];
        [self addChild:playBtn];
        
        //プレイボタンラベル
        CCLabelTTF* startLabel=[CCLabelTTF labelWithString:NSLocalizedString(@"FirstPlay",NULL)
                                                  fontName:@"Verdana-Bold" fontSize:20];
        startLabel.position=ccp(playBtn.contentSize.width/2,-startLabel.contentSize.height/2);
        [playBtn addChild:startLabel];
        
        //コンティニューボタン
        //CCButton* continueBtn=[CCButton buttonWithTitle:@"[続きから]" fontName:@"Verdana-Bold" fontSize:15];
        CCButton* continueBtn=[CCButton buttonWithTitle:@""
                    spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"continue01.png"]
                    highlightedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"continue02.png"]
                    disabledSpriteFrame:nil];
        continueBtn.scale=0.5;
        continueBtn.position=ccp(titleBtn.position.x+(titleBtn.contentSize.width*titleBtn.scale)/2+(continueBtn.contentSize.width*continueBtn.scale)/2,winSize.height/2-50);
        [continueBtn setTarget:self selector:@selector(onContinueClicked:)];
        [self addChild:continueBtn];
        
        //コティニューボタンラベル
        CCLabelTTF* continueLabel=[CCLabelTTF labelWithString:NSLocalizedString(@"ContinuePlay",NULL)
                                                     fontName:@"Verdana-Bold" fontSize:20];
        continueLabel.position=ccp(continueBtn.contentSize.width/2,-continueLabel.contentSize.height/2);
        [continueBtn addChild:continueLabel];
    
    }else{
        
        //リプレイボタン
        CCButton* replayBtn=[CCButton buttonWithTitle:@""
                spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"replay01.png"]
                highlightedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"replay02.png"]
                disabledSpriteFrame:nil];
        replayBtn.scale=0.5;
        replayBtn.position=ccp(titleBtn.position.x-(titleBtn.contentSize.width*titleBtn.scale)/2-(replayBtn.contentSize.width*replayBtn.scale)/2,winSize.height/2-50);
        [replayBtn setTarget:self selector:@selector(onReplayClicked:)];
        [self addChild:replayBtn];
        
        //リプレイボタンラベル
        CCLabelTTF* replayLabel=[CCLabelTTF labelWithString:NSLocalizedString(@"Replay",NULL)
                                                   fontName:@"Verdana-Bold" fontSize:20];
        replayLabel.position=ccp(replayBtn.contentSize.width/2,-replayLabel.contentSize.height/2);
        [replayBtn addChild:replayLabel];
    
        //セレクトボタン
        CCButton* selectBtn=[CCButton buttonWithTitle:@""
                spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"select01.png"]
                highlightedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"select02.png"]
                disabledSpriteFrame:nil];
        selectBtn.scale=0.5;
        selectBtn.position=ccp(titleBtn.position.x+(titleBtn.contentSize.width*titleBtn.scale)/2+(selectBtn.contentSize.width*selectBtn.scale)/2,winSize.height/2-50);
        [selectBtn setTarget:self selector:@selector(onSelectClicked:)];
        [self addChild:selectBtn];
        
        //セレクトボタンラベル
        CCLabelTTF* selectLabel=[CCLabelTTF labelWithString:NSLocalizedString(@"LevelSelect",NULL)
                                                   fontName:@"Verdana-Bold" fontSize:20];
        selectLabel.position=ccp(selectBtn.contentSize.width/2,-selectLabel.contentSize.height/2);
        [selectBtn addChild:selectLabel];
    }

    //ソーシャルボタン
    CCButton* twitterBtn;
    if([GameManager getLocale]==1){
        twitterBtn=[CCButton buttonWithTitle:@"" spriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"twitter.png"]];
    }else{
        twitterBtn=[CCButton buttonWithTitle:@"" spriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"twitter_en.png"]];
    }
    twitterBtn.scale=0.7;
    twitterBtn.position=ccp(winSize.width/2-(twitterBtn.contentSize.width*twitterBtn.scale)/2-10,100);
    [twitterBtn setTarget:self selector:@selector(onTwitterClicked:)];
    [self addChild:twitterBtn];

    CCButton* facebookBtn;
    if([GameManager getLocale]==1){
        facebookBtn=[CCButton buttonWithTitle:@"" spriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"facebook.png"]];
    }else{
        facebookBtn=[CCButton buttonWithTitle:@"" spriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"facebook_en.png"]];
    }
    facebookBtn.scale=0.7;
    facebookBtn.position=ccp(winSize.width/2+(facebookBtn.contentSize.width*facebookBtn.scale)/2+10,100);
    [facebookBtn setTarget:self selector:@selector(onFacebookClicked:)];
    [self addChild:facebookBtn];

    
    /*CCButton* titleButton=[CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15];
    titleButton.position=ccp(winSize.width/2,winSize.height/2-50);
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleButton];
    
    CCButton* startBtn=[CCButton buttonWithTitle:@"[はじめから]" fontName:@"Verdana-Bold" fontSize:15];
    startBtn.position=ccp(winSize.width/2,titleButton.position.y-25);
    [startBtn setTarget:self selector:@selector(onPlayClicked:)];
    [self addChild:startBtn];

    CCButton* continueBtn=[CCButton buttonWithTitle:@"[続きから]" fontName:@"Verdana-Bold" fontSize:15];
    continueBtn.position=ccp(winSize.width/2,startBtn.position.y-25);
    [continueBtn setTarget:self selector:@selector(onContinueClicked:)];
    [self addChild:continueBtn];*/
    
    return self;
}

- (void)onTitleClicked:(id)sender
{
    //サウンドエフェクト
    [SoundManager btn_Click_Effect];
    
    //Ad非表示
    [self hideAdLayer];
    
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
    //インターステイシャル広告表示
    [ImobileSdkAds showBySpotID:@"457103"];
}

- (void)onReplayClicked:(id)sender
{
    //サウンドエフェクト
    [SoundManager game_Start_Effect];
    
    //Ad非表示
    [self hideAdLayer];
    
    [GameManager setPlayMode:2];
    [GameManager setStageLavel:[GameManager getStageLevel]];
    //[GameManager setLifePoint:1];
    [GameManager setScore:0];
    
    [[CCDirector sharedDirector] replaceScene:[StageScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];}

- (void)onSelectClicked:(id)sender
{
    //サウンドエフェクト
    [SoundManager btn_Click_Effect];
    
    //Ad非表示
    [self hideAdLayer];
    
    [[CCDirector sharedDirector] replaceScene:[StageModeMenu scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
    //インターステイシャル広告表示
    [ImobileSdkAds showBySpotID:@"457103"];
}

- (void)onPlayClicked:(id)sender
{
    //サウンドエフェクト
    [SoundManager game_Start_Effect];
    
    //Ad非表示
    [self hideAdLayer];
    
    [GameManager setLifePoint:5];
    [GameManager setStageLavel:1];
    [GameManager setScore:0];
    [[CCDirector sharedDirector] replaceScene:[StageScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
    
}

- (void)onContinueClicked:(id)sender
{
    if([GameManager load_Stage_Level_1]>0){
        if([GameManager load_Continue_Ticket]>0){
            //カスタムアラートメッセージ
            msgBox=[[MsgBoxLayer alloc]initWithTitle:NSLocalizedString(@"Continue",NULL)
                                                    msg:NSLocalizedString(@"Ticket_Use",NULL)
                                                    pos:ccp(winSize.width/2,winSize.height/2)
                                                    size:CGSizeMake(200, 100)
                                                    modal:true
                                                    rotation:false
                                                    type:1
                                                    procNum:1];
            msgBox.delegate=self;//デリゲートセット
            [self addChild:msgBox z:3];
            return;
        }else{
            //カスタムアラートメッセージ
            msgBox=[[MsgBoxLayer alloc]initWithTitle:NSLocalizedString(@"NotCoin",NULL)
                                                    msg:NSLocalizedString(@"ShopPurchase",NULL)
                                                    pos:ccp(winSize.width/2,winSize.height/2)
                                                    size:CGSizeMake(200, 100)
                                                    modal:true
                                                    rotation:false
                                                    type:0
                                                    procNum:0];
            msgBox.delegate=self;//デリゲートセット
            [self addChild:msgBox z:3];
            return;
        }
    }else{
        //カスタムアラートメッセージ
        msgBox=[[MsgBoxLayer alloc]initWithTitle:NSLocalizedString(@"Continue",NULL)
                                                msg:NSLocalizedString(@"NotContinue",NULL)
                                                pos:ccp(winSize.width/2,winSize.height/2)
                                                size:CGSizeMake(200, 100)
                                                modal:true
                                                rotation:false
                                                type:0
                                                procNum:0];
        msgBox.delegate=self;//デリゲートセット
        [self addChild:msgBox z:3];
        return;
    }
}

//=====================
// デリゲートメソッド
//=====================
-(void)onMessageLayerBtnClocked:(int)btnNum procNum:(int)procNum
{
    if(procNum==0){
        
    }else if(procNum==1){
        if(btnNum==2){//Yes
            //サウンドエフェクト
            [SoundManager game_Start_Effect];
            
            [GameManager setLifePoint:5];
            [GameManager setStageLavel:[GameManager load_Stage_Level_1]+1];
            [GameManager setScore:[GameManager load_High_Score_1]];
            //チケット
            [GameManager save_Continue_Ticket:[GameManager load_Continue_Ticket]-1];
            //[TitleScene ticket_Update];
            
            //Ad非表示
            [self hideAdLayer];
            
            [[CCDirector sharedDirector] replaceScene:[StageScene scene]
                                       withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
        }
    }
}

-(void)onTwitterClicked:(id)sender
{
    SLComposeViewController *vc = [SLComposeViewController
                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
    [vc setInitialText:[NSString stringWithFormat:@"%@ %d %@\n",
                                                        NSLocalizedString(@"PostMessage",NULL),
                                                        [GameManager load_High_Score_1],
                                                        NSLocalizedString(@"PostEnd",NULL)]];
    [vc addURL:[NSURL URLWithString:NSLocalizedString(@"URL",NULL)]];
    [vc setCompletionHandler:^(SLComposeViewControllerResult result)
     {
         switch (result) {
             case SLComposeViewControllerResultDone:
                 //チケットを付与
                 [GameManager save_Continue_Ticket:[GameManager load_Continue_Ticket]+10];
                 break;
             case SLComposeViewControllerResultCancelled:
                 break;
         }
     }];
    [[CCDirector sharedDirector]presentViewController:vc animated:YES completion:nil];
}

-(void)onFacebookClicked:(id)sender
{
    SLComposeViewController *vc = [SLComposeViewController
                                   composeViewControllerForServiceType:SLServiceTypeFacebook];
    [vc setInitialText:[NSString stringWithFormat:@"%@ %d %@\n",
                                                        NSLocalizedString(@"PostMessage",NULL),
                                                        [GameManager load_High_Score_1],
                                                        NSLocalizedString(@"PostEnd",NULL)]];
    [vc addURL:[NSURL URLWithString:NSLocalizedString(@"URL",NULL)]];
    [vc setCompletionHandler:^(SLComposeViewControllerResult result)
     {
         switch (result) {
             case SLComposeViewControllerResultDone:
                 //チケットを付与
                 [GameManager save_Continue_Ticket:[GameManager load_Continue_Ticket]+10];
                 break;
             case SLComposeViewControllerResultCancelled:
                 break;
         }
     }];
    [[CCDirector sharedDirector]presentViewController:vc animated:YES completion:nil];
}

-(void)dispAdLayer
{
    //Ad広告レイヤー
    if([GameManager getLocale]==1){//日本語なら
        //i-Mobile広告(フッター、アイコン)
        iMobileAd=[[IMobileLayer alloc]init:false];
        [self addChild:iMobileAd];
    }else{//それ以外
        //iAd広告
        iAdLayer=[[IAdLayer alloc]init];
        [self addChild:iAdLayer];
    }

}

-(void)hideAdLayer
{
    //Ad非表示
    if([GameManager getLocale]==1){//日本語なら
        [iMobileAd removeLayer];
    }else{
        [iAdLayer removeLayer];
    }

}

@end
