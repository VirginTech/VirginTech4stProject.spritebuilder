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
#import "Reachability.h"

@implementation TitleScene

CGSize winSize;
MessageLayer* msgBox;
CCLabelTTF* ticketLabel;

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
    
    //Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:1.0f green:0.07f blue:0.57f alpha:1.0f]];
    [self addChild:background];
    
    //初回時データ初期化
    [GameManager initialize_Save_Data];
    
    //初回起動時ウェルカムメッセージ
    //NSDate* currentDate= [NSDate dateWithTimeIntervalSinceNow:[[NSTimeZone systemTimeZone] secondsFromGMT]];
    NSDate* currentDate=[NSDate date];//GMTで貫く
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] persistentDomainForName:appDomain];
    if([dict valueForKey:@"LoginDate"]==nil){//初回なら
        [GameManager save_login_Date:currentDate];
        
        //カスタムアラートメッセージ
        msgBox=[[MessageLayer alloc]initWithTitle:NSLocalizedString(@"Welcome",NULL)
                                                msg:NSLocalizedString(@"FirstLogin",NULL)
                                                pos:ccp(winSize.width/2,winSize.height/2)
                                                size:CGSizeMake(250, 200)
                                                modal:true
                                                rotation:false
                                                type:0
                                                procNum:2];//初回ログインボーナスメッセージへ
        msgBox.delegate=self;//デリゲートセット
        [self addChild:msgBox z:3];
    }

    //日付変更監視スケジュール(デイリーボーナス)
    [self schedule:@selector(status_Schedule:) interval:1.0];
    
    //インフォメーションレイヤー
    //Information* infoLayer=[[Information alloc]init];
    //[self addChild:infoLayer z:1];
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"title_default.plist"];
    
    //タイトル
    CCLabelTTF* titleLogo=[CCLabelTTF labelWithString:@"4st Project" fontName:@"Verdana-Bold" fontSize:30];
    titleLogo.position=ccp(winSize.width/2,winSize.height/2+100);
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
    
    //コンティニューチケット
    CCSprite* ticket=[CCSprite spriteWithSpriteFrame:
                      [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket.png"]];
    ticket.scale=0.2;
    ticket.position=ccp((ticket.contentSize.width*ticket.scale)/2,
                        levelLabel.position.y-levelLabel.contentSize.height/2-(ticket.contentSize.height*ticket.scale)/2);
    [self addChild:ticket];
    
    //コンティニューチケット枚数
    ticketLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@" ×%03d",
                                    [GameManager load_Continue_Ticket]] fontName:@"Verdana-Bold" fontSize:15];
    ticketLabel.position=ccp(ticket.position.x+ticketLabel.contentSize.width/2,ticket.position.y);
    [self addChild:ticketLabel];
    
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
    moreAppButton.position=ccp(winSize.width/2,80);
    [moreAppButton setTarget:self selector:@selector(onMoreAppClicked:)];
    [self addChild:moreAppButton];
    
    return self;
}

//===================
// 状態監視スケジュール
//===================
-(void)status_Schedule:(CCTime)dt
{
    //デイリー・ボーナス
    NSDate* recentDate=[GameManager load_Login_Date];
    NSDate* currentDate=[NSDate date];//GMTで貫く
    //日付のみに変換
    NSCalendar *calen = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *comps = [calen components:unitFlags fromDate:currentDate];
    //[comps setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];//GMTで貫く
    currentDate = [calen dateFromComponents:comps];
    
    if([currentDate compare:recentDate]==NSOrderedDescending){//日付が変わってるなら「1」
        [GameManager save_login_Date:currentDate];
        
        //カスタムアラートメッセージ
        msgBox=[[MessageLayer alloc]initWithTitle:NSLocalizedString(@"BonusGet",NULL)
                                                msg:NSLocalizedString(@"DailyBonus",NULL)
                                                pos:ccp(winSize.width/2,winSize.height/2)
                                                size:CGSizeMake(200, 100)
                                                modal:true
                                                rotation:false
                                                type:0
                                                procNum:4];//デイリーボーナス付与
        msgBox.delegate=self;//デリゲートセット
        [self addChild:msgBox z:3];
    }
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
            [GameManager setPointCount:5];
            [GameManager setStageLavel:[GameManager load_Stage_Level]+1];
            [GameManager setScore:[GameManager load_High_Score]];
            //チケット
            [GameManager save_Continue_Ticket:[GameManager load_Continue_Ticket]-1];
            [TitleScene ticket_Update];
            
            [[CCDirector sharedDirector] replaceScene:[StageScene scene]
                                   withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
        }
    }
    //初回ボーナス（メッセージ）
    else if(procNum==2){
        //カスタムアラートメッセージ
        msgBox=[[MessageLayer alloc]initWithTitle:NSLocalizedString(@"BonusGet",NULL)
                                                msg:NSLocalizedString(@"FirstBonus",NULL)
                                                pos:ccp(winSize.width/2,winSize.height/2)
                                                size:CGSizeMake(200, 100)
                                                modal:true
                                                rotation:false
                                                type:0
                                                procNum:3];//初回ログインボーナス付与
        msgBox.delegate=self;//デリゲートセット
        [self addChild:msgBox z:3];
    }
    //初回ボーナス（付与）
    else if(procNum==3){
        [GameManager save_Continue_Ticket:[GameManager load_Continue_Ticket]+30];
        [TitleScene ticket_Update];
        msgBox.delegate=nil;//デリゲート解除
    }
    //デイリーボーナス
    else if(procNum==4){
        [GameManager save_Continue_Ticket:[GameManager load_Continue_Ticket]+1];
        [TitleScene ticket_Update];
        msgBox.delegate=nil;//デリゲート解除
    }
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
    if (![SKPaymentQueue canMakePayments]){//ダメ
        //カスタムアラートメッセージ
        msgBox=[[MessageLayer alloc]initWithTitle:NSLocalizedString(@"Error",NULL)
                                                msg:NSLocalizedString(@"InAppBillingIslimited",NULL)
                                                pos:ccp(winSize.width/2,winSize.height/2)
                                                size:CGSizeMake(200, 100)
                                                modal:true
                                                rotation:false
                                                type:0
                                                procNum:0];//処理なし
        msgBox.delegate=self;//デリゲートセット
        [self addChild:msgBox z:3];
        
        return;
        
    }else{
        
        //ネット接続できるか確認
        Reachability *internetReach = [Reachability reachabilityForInternetConnection];
        //[internetReach startNotifier];
        NetworkStatus netStatus = [internetReach currentReachabilityStatus];
        if(netStatus == NotReachable)//ダメ
        {
            //カスタムアラートメッセージ
            msgBox=[[MessageLayer alloc]initWithTitle:NSLocalizedString(@"Error",NULL)
                                                    msg:NSLocalizedString(@"NotNetwork",NULL)
                                                    pos:ccp(winSize.width/2,winSize.height/2)
                                                    size:CGSizeMake(200, 100)
                                                    modal:true
                                                    rotation:false
                                                    type:0
                                                    procNum:0];//処理なし
            msgBox.delegate=self;//デリゲートセット
            [self addChild:msgBox z:3];
            
            return;
            
        }else{//ネットワークOK!
            [[CCDirector sharedDirector] replaceScene:[ShopScene scene]
                                   withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
        }
    }
        
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

+(void)ticket_Update
{
    ticketLabel.string=[NSString stringWithFormat:@" ×%03d",[GameManager load_Continue_Ticket]];
}

@end
