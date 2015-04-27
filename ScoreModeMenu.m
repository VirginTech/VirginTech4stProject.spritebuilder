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

@implementation ScoreModeMenu

CGSize winSize;
MessageLayer* msgBox;
CCLabelTTF* ticketLabel;

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
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"menu_default.plist"];
    
    //レヴェル表示
    CCLabelTTF* levelLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level:%03d",
                                          [GameManager load_Stage_Level_1]] fontName:@"Verdana-Bold" fontSize:15];
    levelLabel.position=ccp(levelLabel.contentSize.width/2,winSize.height-levelLabel.contentSize.height/2);
    [self addChild:levelLabel];
    
    //ハイスコア表示
    CCLabelTTF* highscoreLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"HighScore:%05d",
                                          [GameManager load_High_Score_1]] fontName:@"Verdana-Bold" fontSize:15];
    highscoreLabel.position=ccp(winSize.width-highscoreLabel.contentSize.width/2,
                                winSize.height-highscoreLabel.contentSize.height/2);
    [self addChild:highscoreLabel];
    
    //コンティニューチケット
    CCSprite* ticket=[CCSprite spriteWithSpriteFrame:
                      [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket.png"]];
    ticket.scale=0.2;
    ticket.position=ccp((ticket.contentSize.width*ticket.scale)/2,
                    (levelLabel.position.y-levelLabel.contentSize.height/2)-(ticket.contentSize.height*ticket.scale)/2);
    [self addChild:ticket];
    
    //コンティニューチケット枚数
    ticketLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@" ×%03d",
                                             [GameManager load_Continue_Ticket]] fontName:@"Verdana-Bold" fontSize:15];
    ticketLabel.position=ccp(ticket.position.x+ticketLabel.contentSize.width/2,ticket.position.y);
    [self addChild:ticketLabel];
    
    //タイトルボタン
    CCButton *titleButton=[CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15];
    titleButton.position=ccp(winSize.width/2,winSize.height/2);
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleButton];
    
    //プレイボタン
    //CCButton* startBtn=[CCButton buttonWithTitle:@"[はじめから]" fontName:@"Verdana-Bold" fontSize:15];
    CCButton* startBtn=[CCButton buttonWithTitle:@""
                                     spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"play01.png"]
                          highlightedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"play02.png"]
                             disabledSpriteFrame:nil];
    startBtn.scale=0.5;
    startBtn.position=ccp(winSize.width/2-(startBtn.contentSize.width*startBtn.scale)/2-20,winSize.height/2-50);
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
    continueBtn.position=ccp(winSize.width/2+(continueBtn.contentSize.width*continueBtn.scale)/2+20,winSize.height/2-50);
    [continueBtn setTarget:self selector:@selector(onContinueClicked:)];
    [self addChild:continueBtn];
    
    //コティニューボタンラベル
    CCLabelTTF* continueLabel=[CCLabelTTF labelWithString:@"続きから" fontName:@"Verdana-Bold" fontSize:20];
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

+(void)ticket_Update
{
    ticketLabel.string=[NSString stringWithFormat:@" ×%03d",[GameManager load_Continue_Ticket]];
}

- (void)onTitleClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

@end
