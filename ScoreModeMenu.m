//
//  ScoreModeMenu.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/27.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "ScoreModeMenu.h"
#import "StageScene.h"
#import "GameManager.h"
#import "TitleScene.h"
#import "Information.h"
#import "SoundManager.h"

#import "IAdLayer.h"
#import "IMobileLayer.h"

@implementation ScoreModeMenu

CGSize winSize;
MsgBoxLayer* msgBox;
CCLabelBMFont* ticketLabel;

+ (ScoreModeMenu *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:1.0f green:0.8f blue:0.0f alpha:1.0f]];
    [self addChild:background];
    
    //インフォメーションレイヤー
    //Information* infoLayer=[[Information alloc]init];
    //[self addChild:infoLayer z:1];
    
    //Ad広告レイヤー
    if([GameManager getLocale]==1){//日本語なら
        //i-Mobile広告(フッター、アイコン)
        IMobileLayer* iMobileAd=[[IMobileLayer alloc]init:false];
        [self addChild:iMobileAd];
    }else{//それ以外
        //iAd広告
        IAdLayer* iAdLayer=[[IAdLayer alloc]init];
        [self addChild:iAdLayer];
    }
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"menu_default.plist"];
    
    //レヴェル表示
    //CCLabelTTF* levelLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level:%03d",
    //                                      [GameManager load_Stage_Level_1]] fontName:@"Verdana-Bold" fontSize:15];
    CCLabelBMFont* levelLabel=[CCLabelBMFont labelWithString:
                [NSString stringWithFormat:@"Level:%03d",[GameManager load_Stage_Level_1]] fntFile:@"score.fnt"];
    levelLabel.scale=0.6;
    levelLabel.position=ccp((levelLabel.contentSize.width*levelLabel.scale)/2,
                            winSize.height-(levelLabel.contentSize.height*levelLabel.scale)/2);
    [self addChild:levelLabel];
    
    //ハイスコア表示
    //CCLabelTTF* highscoreLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"HighScore:%05d",
    //                                      [GameManager load_High_Score_1]] fontName:@"Verdana-Bold" fontSize:15];
    CCLabelBMFont* highscoreLabel=[CCLabelBMFont labelWithString:
                [NSString stringWithFormat:@"HighScore:%05d",[GameManager load_High_Score_1]] fntFile:@"score.fnt"];
    highscoreLabel.scale=0.6;
    highscoreLabel.position=ccp(winSize.width-(highscoreLabel.contentSize.width*highscoreLabel.scale)/2,
                                winSize.height-(highscoreLabel.contentSize.height*highscoreLabel.scale)/2);
    [self addChild:highscoreLabel];
    
    //コンティニューチケット
    CCSprite* ticket=[CCSprite spriteWithSpriteFrame:
                      [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket.png"]];
    ticket.scale=0.3;
    ticket.position=ccp((ticket.contentSize.width*ticket.scale)/2,(levelLabel.position.y-(levelLabel.contentSize.height*levelLabel.scale)/2)-(ticket.contentSize.height*ticket.scale)/2);
    [self addChild:ticket];
    
    //コンティニューチケット枚数
    //ticketLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@" ×%03d",
    //                                         [GameManager load_Continue_Ticket]] fontName:@"Verdana-Bold" fontSize:15];
    ticketLabel=[CCLabelBMFont labelWithString:
                 [NSString stringWithFormat:@"×%03d",[GameManager load_Continue_Ticket]] fntFile:@"score.fnt"];
    ticketLabel.scale=0.6;
    ticketLabel.position=ccp(ticket.position.x+(ticket.contentSize.width*ticket.scale)/2+(ticketLabel.contentSize.width*ticketLabel.scale)/2,ticket.position.y);
    [self addChild:ticketLabel];
    
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
    
    return self;
}

//=====================
// デリゲートメソッド
//=====================
-(void)onMessageLayerBtnClocked:(int)btnNum procNum:(int)procNum
{
    if(procNum==0){
        
    }
    //コンティニューチケット使用
    else if(procNum==1){
        if(btnNum==2){//Yes
            //サウンドエフェクト
            [SoundManager game_Start_Effect];
            
            [GameManager setPlayMode:1];
            [GameManager setLifePoint:5];
            [GameManager setStageLavel:[GameManager load_Stage_Level_1]+1];
            [GameManager setScore:[GameManager load_High_Score_1]];
            //チケット
            [GameManager save_Continue_Ticket:[GameManager load_Continue_Ticket]-1];
            [ScoreModeMenu ticket_Update];
            
            [[CCDirector sharedDirector] replaceScene:[StageScene scene]
                                       withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
        }
    }
}

- (void)onPlayClicked:(id)sender
{
    //サウンドエフェクト
    [SoundManager game_Start_Effect];
    
    [GameManager setPlayMode:1];
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

+(void)ticket_Update
{
    ticketLabel.string=[NSString stringWithFormat:@"×%03d",[GameManager load_Continue_Ticket]];
}

- (void)onTitleClicked:(id)sender
{
    //サウンドエフェクト
    [SoundManager btn_Click_Effect];
    
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
    //インターステイシャル広告表示
    [ImobileSdkAds showBySpotID:@"457103"];
}

@end
