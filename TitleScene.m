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
#import "ScoreModeMenu.h"
#import "StageModeMenu.h"
#import "Windmill.h"
#import "Ground.h"

@implementation TitleScene

CGSize winSize;
MsgBoxLayer* msgBox;
CCLabelBMFont* ticketLabel;

CCPhysicsNode* physicWorld;
Ground* ground;
CCButton* scoreModeBtn;
CCButton* stageModeBtn;
int boundCnt;

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
    
    //初期化
    boundCnt=0;
    
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
        msgBox=[[MsgBoxLayer alloc]initWithTitle:NSLocalizedString(@"Welcome",NULL)
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
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"title_default.plist"];
    
    //タイトルロゴ
    //CCLabelTTF* titleLogo=[CCLabelTTF labelWithString:@"windmill" fontName:@"Verdana-Bold" fontSize:30];
    //titleLogo.position=ccp(winSize.width/2,winSize.height/2+100);
    //[self addChild:titleLogo];
    
    CCSprite* titleLogo=[CCSprite spriteWithImageNamed:@"titleLogo.png"];
    titleLogo.scale=0.4;
    titleLogo.position=ccp(winSize.width/2,winSize.height/2 +100);
    [self addChild:titleLogo];
    
    //物理ワールド生成
    physicWorld=[CCPhysicsNode node];
    physicWorld.gravity = ccp(0,-1000);
    //physicWorld.debugDraw = true;
    [self addChild:physicWorld z:1];
    
    //衝突判定デリゲート設定
    physicWorld.collisionDelegate = self;
    
    //風車
    Windmill* windmill;
    
    windmill=[Windmill createWindmill:ccp(winSize.width/2 -70,winSize.height/2 +150) titleFlg:true];
    [physicWorld addChild:windmill];
    
    windmill=[Windmill createWindmill:ccp(winSize.width/2 +20,winSize.height/2 +30) titleFlg:true];
    [physicWorld addChild:windmill];

    windmill=[Windmill createWindmill:ccp(winSize.width/2 +60,winSize.height/2 +170) titleFlg:true];
    [physicWorld addChild:windmill];

    windmill=[Windmill createWindmill:ccp(winSize.width/2 -80,winSize.height/2 +50) titleFlg:true];
    [physicWorld addChild:windmill];

    windmill=[Windmill createWindmill:ccp(winSize.width/2 -0,winSize.height/2 +190) titleFlg:true];
    [physicWorld addChild:windmill];
    
    windmill=[Windmill createWindmill:ccp(winSize.width/2 +70,winSize.height/2 +40) titleFlg:true];
    [physicWorld addChild:windmill];

    windmill=[Windmill createWindmill:ccp(winSize.width/2 -100,winSize.height/2 +180) titleFlg:true];
    [physicWorld addChild:windmill];

    windmill=[Windmill createWindmill:ccp(winSize.width/2 +100,winSize.height/2 +200) titleFlg:true];
    [physicWorld addChild:windmill];

    //地面生成
    ground=[Ground createGround:ccp(winSize.width/2,0.0)];
    ground.position=ccp(winSize.width/2,-(ground.contentSize.height*ground.scale)/2);
    [physicWorld addChild:ground];
    
    
    //レヴェル表示
    //CCLabelTTF* levelLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level:%03d",
    //                                      [GameManager load_Stage_Level]] fontName:@"Verdana-Bold" fontSize:15];
    //levelLabel.position=ccp(levelLabel.contentSize.width/2,winSize.height-levelLabel.contentSize.height/2);
    //[self addChild:levelLabel];
    
    //ハイスコア表示
    //CCLabelTTF* highscoreLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"HighScore:%05d",
    //                                      [GameManager load_High_Score]] fontName:@"Verdana-Bold" fontSize:15];
    //highscoreLabel.position=ccp(winSize.width-highscoreLabel.contentSize.width/2,
    //                            winSize.height-highscoreLabel.contentSize.height/2);
    //[self addChild:highscoreLabel];
    
    //コンティニューチケット
    CCSprite* ticket=[CCSprite spriteWithSpriteFrame:
                      [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket.png"]];
    ticket.scale=0.3;
    ticket.position=ccp((ticket.contentSize.width*ticket.scale)/2+5,
                                        winSize.height-(ticket.contentSize.height*ticket.scale)/2-5);
    [self addChild:ticket];
    
    //コンティニューチケット枚数
    ticketLabel=[CCLabelBMFont labelWithString:
                 [NSString stringWithFormat:@"×%03d",[GameManager load_Continue_Ticket]] fntFile:@"score.fnt"];
    ticketLabel.scale=0.6;
    ticketLabel.position=ccp(ticket.position.x+(ticket.contentSize.width*ticket.scale)/2+(ticketLabel.contentSize.width*ticketLabel.scale)/2,ticket.position.y);
    [self addChild:ticketLabel];
    
    //===========================
    //スコアチャレンジモード
    //===========================
    //CCButton* startBtn=[CCButton buttonWithTitle:@"[はじめから]" fontName:@"Verdana-Bold" fontSize:15];
    scoreModeBtn=[CCButton buttonWithTitle:@""
                spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"scoreMode01.png"]
                highlightedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"scoreMode02.png"]
                disabledSpriteFrame:nil];
    scoreModeBtn.scale=0.5;
    scoreModeBtn.position=ccp(winSize.width/2-(scoreModeBtn.contentSize.width*scoreModeBtn.scale)/2-20,winSize.height/2-50);
    [scoreModeBtn setTarget:self selector:@selector(onScoreModeClicked:)];
    //フィジックス適用
    scoreModeBtn.physicsBody=[CCPhysicsBody bodyWithCircleOfRadius:50 andCenter:ccp(scoreModeBtn.contentSize.width/2,scoreModeBtn.contentSize.height/2)];
    [scoreModeBtn.physicsBody setType:CCPhysicsBodyTypeStatic];
    [scoreModeBtn.physicsBody setElasticity:1.0];
    [scoreModeBtn.physicsBody setCollisionType:@"button01"];
    [physicWorld addChild:scoreModeBtn];
    
    //スコアチャレンジモードラベル
    CCLabelTTF* scoreModeLabel=[CCLabelTTF labelWithString:NSLocalizedString(@"ScoreChallenge",NULL)
                                                  fontName:@"Verdana-Bold" fontSize:10];
    scoreModeLabel.position=ccp(scoreModeBtn.position.x,
                                scoreModeBtn.position.y-(scoreModeBtn.contentSize.height*scoreModeBtn.scale)/2 -8);
    [self addChild:scoreModeLabel];
    
    //===========================
    //ステージチャレンジモード
    //===========================
    //CCButton* continueBtn=[CCButton buttonWithTitle:@"[続きから]" fontName:@"Verdana-Bold" fontSize:15];
    stageModeBtn=[CCButton buttonWithTitle:@""
                spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"stageMode01.png"]
                highlightedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"stageMode02.png"]
                disabledSpriteFrame:nil];
    stageModeBtn.scale=0.5;
    stageModeBtn.position=ccp(winSize.width/2+(stageModeBtn.contentSize.width*stageModeBtn.scale)/2+20,winSize.height/2-50);
    [stageModeBtn setTarget:self selector:@selector(onStageModeClicked:)];
    //フィジックス適用
    stageModeBtn.physicsBody=[CCPhysicsBody bodyWithCircleOfRadius:50 andCenter:ccp(stageModeBtn.contentSize.width/2,stageModeBtn.contentSize.height/2)];
    [stageModeBtn.physicsBody setType:CCPhysicsBodyTypeStatic];
    [stageModeBtn.physicsBody setElasticity:1.0];
    [stageModeBtn.physicsBody setCollisionType:@"button02"];
    [physicWorld addChild:stageModeBtn];

    //ステージチャレンジモードラベル
    CCLabelTTF* stageModeLabel=[CCLabelTTF labelWithString:NSLocalizedString(@"StageMode",NULL)
                                                  fontName:@"Verdana-Bold" fontSize:10];
    stageModeLabel.position=ccp(stageModeBtn.position.x,
                                stageModeBtn.position.y-(stageModeBtn.contentSize.height*stageModeBtn.scale)/2 -8);
    [self addChild:stageModeLabel];
    
    
    /*/スコアチャレンジモード
    CCButton* scoreModeBtn=[CCButton buttonWithTitle:@"[スコアチャレンジ]" fontName:@"Verdana-Bold" fontSize:20];
    scoreModeBtn.position=ccp(winSize.width/2,winSize.height/2-70);
    [scoreModeBtn setTarget:self selector:@selector(onScoreModeClicked:)];
    [self addChild:scoreModeBtn];
    
    //ステージチャレンジモード
    CCButton* stageModeBtn=[CCButton buttonWithTitle:@"[ステージチャレンジ]" fontName:@"Verdana-Bold" fontSize:20];
    stageModeBtn.position=ccp(winSize.width/2,scoreModeBtn.position.y-30);
    [stageModeBtn setTarget:self selector:@selector(onStageModeClicked:)];
    [self addChild:stageModeBtn];*/
    
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
    
    //バージョン表記
    CCLabelTTF* version=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"©VirginTech v%@",
                        [[[NSBundle mainBundle] infoDictionary]objectForKey:@"CFBundleShortVersionString"]]
                                           fontName:@"Verdana" fontSize:10];
    version.position=ccp(winSize.width/2,110);
    version.color=[CCColor whiteColor];
    [self addChild:version];
    
    //モアアプリ
    CCButton *moreAppButton;
    if([GameManager getLocale]==1){
        moreAppButton = [CCButton buttonWithTitle:@"" spriteFrame:
                         [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"moreAppBtn.png"]];
    }else{
        moreAppButton = [CCButton buttonWithTitle:@"" spriteFrame:
                         [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"moreAppBtn_en.png"]];
    }
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
        msgBox=[[MsgBoxLayer alloc]initWithTitle:NSLocalizedString(@"BonusGet",NULL)
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
    /*/コンティニューチケット使用
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
    }*/
    //初回ボーナス（メッセージ）
    else if(procNum==2){
        //カスタムアラートメッセージ
        msgBox=[[MsgBoxLayer alloc]initWithTitle:NSLocalizedString(@"BonusGet",NULL)
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
        [GameManager save_Continue_Ticket:[GameManager load_Continue_Ticket]+3];
        [TitleScene ticket_Update];
        msgBox.delegate=nil;//デリゲート解除
    }
}

- (void)onScoreModeClicked:(id)sender
{
    [scoreModeBtn.physicsBody setType:CCPhysicsBodyTypeDynamic];
    [scoreModeBtn.physicsBody applyImpulse:ccp(0,250)];
    //[scoreModeBtn.physicsBody applyForce:ccp(0,15000)];
    [scoreModeBtn.physicsBody applyAngularImpulse:-3000.f];
    
    //[[CCDirector sharedDirector] replaceScene:[ScoreModeMenu scene]
    //                           withTransition:[CCTransition transitionCrossFadeWithDuration:0.3]];
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair cGround:(Ground*)cGround
                                                                    button01:(CCSprite*)button01
{
    boundCnt++;
    if(boundCnt>2){
        boundCnt=0;
        [[CCDirector sharedDirector] replaceScene:[ScoreModeMenu scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.3]];
    }
    return TRUE;
}

- (void)onStageModeClicked:(id)sender
{
    [stageModeBtn.physicsBody setType:CCPhysicsBodyTypeDynamic];
    [stageModeBtn.physicsBody applyImpulse:ccp(0,250)];
    [stageModeBtn.physicsBody applyAngularImpulse:3000.f];
    
    //[[CCDirector sharedDirector] replaceScene:[StageModeMenu scene]
    //                           withTransition:[CCTransition transitionCrossFadeWithDuration:0.3]];
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair cGround:(Ground*)cGround
                                                                    button02:(CCSprite*)button02
{
    boundCnt++;
    if(boundCnt>2){
        boundCnt=0;
        [[CCDirector sharedDirector] replaceScene:[StageModeMenu scene]
                                   withTransition:[CCTransition transitionCrossFadeWithDuration:0.3]];
    }
    return TRUE;
}

/*
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
*/

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
        msgBox=[[MsgBoxLayer alloc]initWithTitle:NSLocalizedString(@"Error",NULL)
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
            msgBox=[[MsgBoxLayer alloc]initWithTitle:NSLocalizedString(@"Error",NULL)
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
