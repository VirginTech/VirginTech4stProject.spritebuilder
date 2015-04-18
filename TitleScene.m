//
//  TitleScene.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/05.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "TitleScene.h"
#import "StageScene.h"
#import "GameManager.h"
#import "Information.h"
#import "CreditScene.h"
#import "PreferencesScene.h"
#import "ShopScene.h"

@implementation TitleScene

CGSize winSize;

+ (TitleScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //初期化
    [GameManager setPointCount:5];
    
    //初回時データ初期化
    [GameManager initialize_Save_Data];
    
    //インフォメーションレイヤー
    //Information* infoLayer=[[Information alloc]init];
    //[self addChild:infoLayer z:1];
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"title_default.plist"];
    
    //タイトル
    CCLabelTTF* titleLogo=[CCLabelTTF labelWithString:@"4st Project" fontName:@"Verdana-Bold" fontSize:30];
    titleLogo.position=ccp(winSize.width/2,winSize.height/2);
    [self addChild:titleLogo];
    
    //レヴェル表示
    CCLabelTTF* levelLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level:%03d",
                                            [GameManager load_Stage_Level]] fontName:@"Verdana-Bold" fontSize:15];
    levelLabel.position=ccp(levelLabel.contentSize.width/2,winSize.height-levelLabel.contentSize.height/2);
    [self addChild:levelLabel];
    
    //ハイスコア表示
    CCLabelTTF* highscoreLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"HighScore:%05d",
                                                [GameManager load_High_Score]] fontName:@"Verdana-Bold" fontSize:15];
    highscoreLabel.position=ccp(winSize.width-highscoreLabel.contentSize.width/2,
                                winSize.height-highscoreLabel.contentSize.height/2);
    [self addChild:highscoreLabel];
    
    
    //プレイボタン
    CCButton* startBtn=[CCButton buttonWithTitle:@"[はじめから]" fontName:@"Verdana-Bold" fontSize:15];
    startBtn.position=ccp(winSize.width/2,winSize.height/2-100);
    [startBtn setTarget:self selector:@selector(onPlayClicked:)];
    [self addChild:startBtn];

    //コンティニューボタン
    CCButton* continueBtn=[CCButton buttonWithTitle:@"[続きから]" fontName:@"Verdana-Bold" fontSize:15];
    continueBtn.position=ccp(winSize.width/2,startBtn.position.y-25);
    [continueBtn setTarget:self selector:@selector(onContinueClicked:)];
    [self addChild:continueBtn];

    //GameCenterボタン
    CCButton *gameCenterButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                  [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"gamecenter.png"]];
    gameCenterButton.positionType = CCPositionTypeNormalized;
    gameCenterButton.position = ccp(0.95f, 0.15f);
    gameCenterButton.scale=0.5;
    [gameCenterButton setTarget:self selector:@selector(onGameCenterClicked:)];
    [self addChild:gameCenterButton];
    
    //Twitter
    CCButton *twitterButton = [CCButton buttonWithTitle:@"" spriteFrame:
                               [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"twitter.png"]];
    twitterButton.positionType = CCPositionTypeNormalized;
    twitterButton.position = ccp(0.95f, 0.22f);
    twitterButton.scale=0.5;
    [twitterButton setTarget:self selector:@selector(onTwitterClicked:)];
    [self addChild:twitterButton];
    
    //Facebook
    CCButton *facebookButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"facebook.png"]];
    facebookButton.positionType = CCPositionTypeNormalized;
    facebookButton.position = ccp(0.95f, 0.29f);
    facebookButton.scale=0.5;
    [facebookButton setTarget:self selector:@selector(onFacebookClicked:)];
    [self addChild:facebookButton];
    
    //In-AppPurchaseボタン
    CCButton *inAppButton = [CCButton buttonWithTitle:@"" spriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"shopBtn.png"]];
    inAppButton.positionType = CCPositionTypeNormalized;
    inAppButton.position = ccp(0.05f, 0.15f);
    inAppButton.scale=0.5;
    [inAppButton setTarget:self selector:@selector(onInAppPurchaseClicked:)];
    [self addChild:inAppButton];
    
    //環境設定
    CCButton *preferencesButton = [CCButton buttonWithTitle:@"" spriteFrame:
                                   [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"configBtn.png"]];
    preferencesButton.positionType = CCPositionTypeNormalized;
    preferencesButton.position = ccp(0.05f, 0.22f);
    preferencesButton.scale=0.5;
    [preferencesButton setTarget:self selector:@selector(onPreferencesButtonClicked:)];
    [self addChild:preferencesButton];
    
    //クレジット
    CCButton *creditButton = [CCButton buttonWithTitle:@"" spriteFrame:
                              [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"creditBtn.png"]];
    creditButton.positionType = CCPositionTypeNormalized;
    creditButton.position = ccp(0.05f, 0.29f);
    creditButton.scale=0.5;
    [creditButton setTarget:self selector:@selector(onCreditButtonClicked:)];
    [self addChild:creditButton];
    
    CCButton *moreAppButton = [CCButton buttonWithTitle:@"" spriteFrame:
                               [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"moreAppBtn.png"]];
    moreAppButton.scale=0.6;
    moreAppButton.position=ccp(winSize.width/2,continueBtn.position.y-50);
    [moreAppButton setTarget:self selector:@selector(onMoreAppClicked:)];
    [self addChild:moreAppButton];
    
    return self;
}

- (void)onPlayClicked:(id)sender
{
    [GameManager setStageLavel:1];
    [GameManager setScore:0];
    [[CCDirector sharedDirector] replaceScene:[StageScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
    
}

- (void)onContinueClicked:(id)sender
{
    [GameManager setStageLavel:[GameManager load_Stage_Level]+1];
    [GameManager setScore:[GameManager load_High_Score]];
    [[CCDirector sharedDirector] replaceScene:[StageScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
    
}

-(void)onGameCenterClicked:(id)sender
{
    gkc=[[GKitController alloc]init];
    [gkc showLeaderboard];
}

-(void)onTwitterClicked:(id)sender
{
    NSURL* url = [NSURL URLWithString:@"https://twitter.com/VirginTechLLC"];
    [[UIApplication sharedApplication]openURL:url];
}

-(void)onFacebookClicked:(id)sender
{
    NSURL* url = [NSURL URLWithString:@"https://www.facebook.com/pages/VirginTech-LLC/516907375075432"];
    [[UIApplication sharedApplication]openURL:url];
}

-(void)onInAppPurchaseClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[ShopScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

-(void)onPreferencesButtonClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[PreferencesScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

-(void)onCreditButtonClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CreditScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

-(void)onMoreAppClicked:(id)sender
{
    NSURL* url = [NSURL URLWithString:@"https://itunes.apple.com/jp/artist/virgintech-llc./id869207880"];
    [[UIApplication sharedApplication]openURL:url];
}

@end
