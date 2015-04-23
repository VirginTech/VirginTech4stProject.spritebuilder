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

@implementation NaviLayer

@synthesize gameOverLabel;

CGSize winSize;
CCNodeColor *background;
MessageLayer* msgBox;

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
    
    background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.7f]];
    [self addChild:background];
    
    //ゲームオーバーラベル
    gameOverLabel=[CCLabelTTF labelWithString:@"" fontName:@"Verdana-Bold" fontSize:30];
    gameOverLabel.position=ccp(winSize.width/2,winSize.height/2+50);
    [self addChild:gameOverLabel];
    
    //画像読み込み
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
    CCLabelTTF* titleLabel=[CCLabelTTF labelWithString:@"ホームへ" fontName:@"Verdana-Bold" fontSize:20];
    titleLabel.position=ccp(titleBtn.contentSize.width/2,-titleLabel.contentSize.height/2);
    [titleBtn addChild:titleLabel];
    
    //プレイボタン
    //CCButton* startBtn=[CCButton buttonWithTitle:@"[はじめから]" fontName:@"Verdana-Bold" fontSize:15];
    CCButton* startBtn=[CCButton buttonWithTitle:@""
                spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"play01.png"]
                highlightedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"play02.png"]
                disabledSpriteFrame:nil];
    startBtn.scale=0.5;
    startBtn.position=ccp(titleBtn.position.x-(titleBtn.contentSize.width*titleBtn.scale)/2-(startBtn.contentSize.width*startBtn.scale)/2,winSize.height/2-50);
    [startBtn setTarget:self selector:@selector(onPlayClicked:)];
    [self addChild:startBtn];
    
    //プレイボタンラベル
    CCLabelTTF* startLabel=[CCLabelTTF labelWithString:@"はじめから" fontName:@"Verdana-Bold" fontSize:20];
    startLabel.position=ccp(startBtn.contentSize.width/2,-startLabel.contentSize.height/2);
    [startBtn addChild:startLabel];
    
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
    CCLabelTTF* continueLabel=[CCLabelTTF labelWithString:@"続きから" fontName:@"Verdana-Bold" fontSize:20];
    continueLabel.position=ccp(continueBtn.contentSize.width/2,-continueLabel.contentSize.height/2);
    [continueBtn addChild:continueLabel];
    
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
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

- (void)onPlayClicked:(id)sender
{
    [GameManager setPointCount:5];
    [GameManager setStageLavel:1];
    [GameManager setScore:0];
    [[CCDirector sharedDirector] replaceScene:[StageScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
    
}

- (void)onContinueClicked:(id)sender
{
    if([GameManager load_Stage_Level]>0){
        if([GameManager load_Continue_Ticket]>0){
            //カスタムアラートメッセージ
            msgBox=[[MessageLayer alloc]initWithTitle:NSLocalizedString(@"Continue",NULL)
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
            msgBox=[[MessageLayer alloc]initWithTitle:NSLocalizedString(@"Continue",NULL)
                                                    msg:NSLocalizedString(@"Ticket_Shortage",NULL)
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
        msgBox=[[MessageLayer alloc]initWithTitle:NSLocalizedString(@"Continue",NULL)
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
            [GameManager setPointCount:5];
            [GameManager setStageLavel:[GameManager load_Stage_Level]+1];
            [GameManager setScore:[GameManager load_High_Score]];
            //チケット
            [GameManager save_Continue_Ticket:[GameManager load_Continue_Ticket]-1];
            //[TitleScene ticket_Update];
            
            [[CCDirector sharedDirector] replaceScene:[StageScene scene]
                                       withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
        }
    }
}

@end
