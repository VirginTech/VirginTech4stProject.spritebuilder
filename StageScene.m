//
//  StageScene.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/05.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import "StageScene.h"
#import "TitleScene.h"
#import "Ball.h"
#import "Ground.h"
#import "Windmill.h"
#import "InitManager.h"
#import "Corner.h"
#import "Wall.h"
#import "Piston.h"
#import "GameManager.h"
#import "Basket.h"
#import "Information.h"
#import "NaviLayer.h"
#import "MsgEffect.h"
//#import "BallShadow.h"
#import "SoundManager.h"
#import "EndingScene.h"

#import "ImobileSdkAds/ImobileSdkAds.h"

@implementation StageScene

CGSize winSize;

CMMotionManager *motionManager;
CCPhysicsNode* physicWorld;

Ball* ball;
Ground* ground;
Corner* corner;
Windmill* windmill;
Wall* wall_r;
Wall* wall_l;
Wall* wall_u;
Wall* wall_m;
Piston* piston;
Basket* basket;
CCSprite* basket_shadow;
CCSprite* spark;
CCSprite* boost;

int ballCount;//発射ボール数
int ballTimingCnt;//ボール間隔経過タイム
int ballLaunchCnt;//ボール発射間隔
int maxBallCount;//最大ボール数
int doneBallCount;//処理済みボール数
bool lastBallFlg;//最終ボールフラグ
float force;//ボール打ち上げフォース

NSMutableIndexSet* angelBall;//天使ボール
NSMutableIndexSet* devilBall;//悪魔ボール

int adjustValue;//バスケット調整値

NSMutableArray* ballArray;
NSMutableArray* removeBallArray;

NaviLayer* naviLayer;
CCButton* pauseBtn;
CCButton* resumeBtn;

bool illuminationFlg;

//シャドーボール
//BallShadow* ballShadow;
//NSMutableArray* ballShadowArray;

//ボールカウンター
CCLabelBMFont* ballCntLbl;

//デバッグラベル
//CCLabelTTF* maxBallCount_lbl;
//CCLabelTTF* ballCount_lbl;
//CCLabelTTF* doneBallCount_lbl;

+ (StageScene *)scene
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
    //CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.0f green:0.4f blue:0.0f alpha:1.0f]];
    //[self addChild:background];

    //BGM
    [SoundManager playBGM:@"bgm.mp3"];
    
    //背景
    NSString* bgName=[NSString stringWithFormat:@"bg_%02d.png",((([GameManager getStageLevel]-1)/5)+1)%3];//5区切り
    CCSprite* bg=[CCSprite spriteWithImageNamed:bgName];
    bg.position=ccp(winSize.width/2,winSize.height/2);
    [self addChild:bg];
    
    //初期化
    doneBallCount=0;
    ballCount=0;
    ballTimingCnt=0;
    force=((arc4random()%5)+63)*0.1;//6.3〜6.7
    ballArray=[[NSMutableArray alloc]init];
    //ballShadowArray=[[NSMutableArray alloc]init];
    [GameManager setPause:false];
    lastBallFlg=false;
    angelBall=[[NSMutableIndexSet alloc]init];
    devilBall=[[NSMutableIndexSet alloc]init];
    
    
    //=============================== ゲームバランス調整 =============================//
    
    //=====================
    //　Maxボール数
    //=====================
    if([GameManager getPlayMode]==1){//スコアチャレンジ
        maxBallCount=12;
    }else{//ステージモード
        if([GameManager getStageLevel]<=20){//1〜20
            maxBallCount=[GameManager getStageLevel];
        }else if([GameManager getStageLevel]<=40){//21〜40
            maxBallCount=20;
        }else if([GameManager getStageLevel]<=60){//41〜60
            maxBallCount=25;
        }else{//61〜75
            maxBallCount=30;
        }
    }
    //=====================
    //　天使・悪魔ボール取得
    //=====================
    if([GameManager getPlayMode]==1){
        angelBall=[self special_Ball_Num:1 range:9];//１個 9以内
        devilBall=[self special_Ball_Num:2 range:9];//２個 9以内
    }else{
        if([GameManager getStageLevel]<=3){//1〜3

        }else if([GameManager getStageLevel]<=5){//4〜5
            angelBall=[self special_Ball_Num:1 range:3];//1個 3以内
            devilBall=[self special_Ball_Num:1 range:3];//1個 3以内
        }else if([GameManager getStageLevel]<=10){//6〜10
            angelBall=[self special_Ball_Num:1 range:5];//1個 5以内
            devilBall=[self special_Ball_Num:2 range:5];//2個 5以内
        }else if([GameManager getStageLevel]<=20){//11〜20
            angelBall=[self special_Ball_Num:2 range:10];//2個 10以内
            devilBall=[self special_Ball_Num:3 range:10];//3個 10以内
        }else if([GameManager getStageLevel]<=30){//21〜30
            angelBall=[self special_Ball_Num:2 range:15];//2個 15以内
            devilBall=[self special_Ball_Num:3 range:15];//3個 15以内
        }else if([GameManager getStageLevel]<=40){//31〜40
            angelBall=[self special_Ball_Num:3 range:15];//3個 15以内
            devilBall=[self special_Ball_Num:4 range:15];//4個 15以内
        }else if([GameManager getStageLevel]<=50){//41〜50
            angelBall=[self special_Ball_Num:3 range:15];//3個 15以内
            devilBall=[self special_Ball_Num:4 range:15];//4個 15以内
        }else if([GameManager getStageLevel]<=60){//51〜60
            angelBall=[self special_Ball_Num:4 range:15];//4個 15以内
            devilBall=[self special_Ball_Num:5 range:15];//5個 15以内
        }else if([GameManager getStageLevel]<=70){//61〜70
            angelBall=[self special_Ball_Num:5 range:20];//5個 20以内
            devilBall=[self special_Ball_Num:6 range:20];//6個 20以内
        }else{//71〜75
            angelBall=[self special_Ball_Num:5 range:20];//6個 20以内
            devilBall=[self special_Ball_Num:7 range:20];//7個 20以内
        }
    }
    //=====================
    //　ボール発射間隔
    //=====================
    if([GameManager getPlayMode]==1){
        ballLaunchCnt=300-((([GameManager getStageLevel]-1)/10)*10);//10ステージごとに-10
        if(ballLaunchCnt<50){
            ballLaunchCnt=50;//50を下回ったら50を維持
        }
    }else{
        ballLaunchCnt=300-((([GameManager getStageLevel]-1)/3)*10);//3ステージごとに-10
        if(ballLaunchCnt<50){
            ballLaunchCnt=50;//50を下回ったら50を維持
        }
    }
    //=====================
    //　ライフポイント
    //=====================
    if([GameManager getPlayMode]==1){
        //[GameManager setLifePoint:5];
    }else{
        [GameManager setLifePoint:1+((([GameManager getStageLevel]-1)/10)*1)];//10ステージごとに+1
        if([GameManager getLifePoint]>5){
            [GameManager setLifePoint:5];
        }
    }
    
    //=============================== ここまで =============================//

    
    //ジャイロセンサー初期化
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
    
    //バスケット調整値
    if([GameManager getDevice]==1){//iPad
        adjustValue = 45;
    }else if([GameManager getDevice]==2){//iPhone4
        adjustValue = 25;
    }else if([GameManager getDevice]==3){//iPhone5
        adjustValue = 25;
    }else if([GameManager getDevice]==4){//iPhone6
        adjustValue = 40;
    }else{
        adjustValue = 25;
    }
    
    //インフォメーションレイヤー
    Information* infoLayer=[[Information alloc]init];
    [self addChild:infoLayer z:1];
    
    //ポーズレイヤー
    naviLayer=[[NaviLayer alloc]init];
    [self addChild:naviLayer z:3];
    naviLayer.visible=false;
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"navi_default.plist"];
    
    //ポーズボタン
    //pauseBtn=[CCButton buttonWithTitle:@"[ポーズ]"];
    pauseBtn=[CCButton buttonWithTitle:@""
                spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"pause.png"]
                highlightedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"pause.png"]
                disabledSpriteFrame:nil];
    pauseBtn.scale=0.4;
    pauseBtn.position=ccp(winSize.width-(pauseBtn.contentSize.width*pauseBtn.scale)/2,
                                                    (pauseBtn.contentSize.height*pauseBtn.scale)/2+50);
    [pauseBtn setTarget:self selector:@selector(onPauseClicked:)];
    [self addChild:pauseBtn z:3];
    
    //レジュームボタン
    //resumeBtn=[CCButton buttonWithTitle:@"[レジューム]"];
    resumeBtn=[CCButton buttonWithTitle:@""
                spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"resume.png"]
                highlightedSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"resume.png"]
                disabledSpriteFrame:nil];
    resumeBtn.scale=0.4;
    resumeBtn.position=ccp(winSize.width-(resumeBtn.contentSize.width*resumeBtn.scale)/2,
                                                    (resumeBtn.contentSize.height*resumeBtn.scale)/2+50);
    [resumeBtn setTarget:self selector:@selector(onResumeClicked:)];
    [self addChild:resumeBtn z:3];
    resumeBtn.visible=false;
    
    //開始メッセージ
    MsgEffect* msg=[[MsgEffect alloc]initWithMsg:[NSString stringWithFormat:@"%@ %d \n%@",
                                                NSLocalizedString(@"Stage_Lv",NULL),
                                                [GameManager getStageLevel],
                                                NSLocalizedString(@"Stage_Start",NULL)]
                                                nextFlg:false
                                                highScoreFlg:false];
    [self addChild:msg z:2];
    
    
    /*/デバッグラベル
    maxBallCount_lbl=[CCLabelTTF labelWithString:[NSString stringWithFormat:
                            @"MaxBallCount:%03d",maxBallCount] fontName:@"Verdana-Bold" fontSize:10];
    maxBallCount_lbl.position=ccp(maxBallCount_lbl.contentSize.width/2,winSize.height-50);
    [self addChild:maxBallCount_lbl z:1];

    ballCount_lbl=[CCLabelTTF labelWithString:[NSString stringWithFormat:
                                                  @"BallCount:%03d",ballCount] fontName:@"Verdana-Bold" fontSize:10];
    ballCount_lbl.position=ccp(ballCount_lbl.contentSize.width/2,winSize.height-60);
    [self addChild:ballCount_lbl z:1];

    doneBallCount_lbl=[CCLabelTTF labelWithString:[NSString stringWithFormat:
                                               @"DoneBallCount:%03d",doneBallCount] fontName:@"Verdana-Bold" fontSize:10];
    doneBallCount_lbl.position=ccp(doneBallCount_lbl.contentSize.width/2,winSize.height-70);
    [self addChild:doneBallCount_lbl z:1];*/

#if DEBUG

    CCLabelTTF* ballLaunchTiming_lbl=[CCLabelTTF labelWithString:
            [NSString stringWithFormat:@"BallLaunchTiming:%d",ballLaunchCnt] fontName:@"Verdana-Bold" fontSize:10];
    ballLaunchTiming_lbl.position=ccp(ballLaunchTiming_lbl.contentSize.width/2,winSize.height-50);
    [self addChild:ballLaunchTiming_lbl z:1];
    
#endif
    
    return self;
}

- (void)dealloc
{
    // clean up code goes here
}

-(void)onEnter
{
    [super onEnter];
    
    //物理ワールド生成
    physicWorld=[CCPhysicsNode node];
    physicWorld.gravity = ccp(0,-1000);
    //physicWorld.debugDraw = true;
    [self addChild:physicWorld];
    
    //衝突判定デリゲート設定
    physicWorld.collisionDelegate = self;
    
    //地面生成
    ground=[Ground createGround:ccp(winSize.width/2,10.0)];
    [physicWorld addChild:ground];
    
    //コーナー生成
    corner=[Corner createCorner:ccp(0,0) type:0];//右
    corner.position=ccp(winSize.width-corner.contentSize.width/2+5,winSize.height-corner.contentSize.height/2+5);
    [physicWorld addChild:corner];
    
    corner=[Corner createCorner:ccp(0,0) type:1];//左
    corner.position=ccp(corner.contentSize.width/2-5,winSize.height-corner.contentSize.height/2+5);
    [physicWorld addChild:corner];
    
    //ピストン壁
    wall_m=[Wall createWall:ccp(winSize.width-35,winSize.height/2)];
    [physicWorld addChild:wall_m];

    //右壁
    wall_r=[Wall createWall:ccp(0,0)];
    wall_r.scale=1.5;
    wall_r.position=ccp(winSize.width+(wall_r.contentSize.width*wall_r.scale)/2,winSize.height/2+30);
    [physicWorld addChild:wall_r];

    //左壁
    wall_l=[Wall createWall:ccp(0,0)];
    wall_l.scale=1.5;
    wall_l.position=ccp(-(wall_l.contentSize.width*wall_l.scale)/2,winSize.height/2+30);
    [physicWorld addChild:wall_l];
    
    //天井壁
    wall_u=[Wall createWall:ccp(0,0)];
    wall_u.scale=1.5;
    wall_u.position=ccp(winSize.width/2,winSize.height+(wall_u.contentSize.width*wall_u.scale)/2);
    wall_u.rotation=90;
    [physicWorld addChild:wall_u];
    
    //ピストン
    piston=[Piston createPiston:ccp(0,0)];
    piston.position=ccp(winSize.width-piston.contentSize.width/2-1,winSize.height/2-100);
    [physicWorld addChild:piston];
    
    //ピン生成
    CGPoint pos;
    NSMutableArray* array=[InitManager init_Pin_Pattern:[GameManager getStageLevel]];
    for(int i=0;i<array.count;i++){
        pos=[[array objectAtIndex:i]CGPointValue];
        windmill=[Windmill createWindmill:pos titleFlg:false cnt:i+1];
        [physicWorld addChild:windmill];
    }

    //バスケット生成
    basket=[Basket createBasket:ccp(winSize.width/2,ground.position.y+(ground.contentSize.height*ground.scale)/2+23)];
    [physicWorld addChild:basket];
    
    //バスケットシャドー生成
    basket_shadow=[CCSprite spriteWithImageNamed:@"basket_shadow.png"];
    basket_shadow.scale=0.7;
    basket_shadow.opacity=0.3;
    basket_shadow.position=ccp(basket.position.x+30,ground.position.y+(ground.contentSize.height*ground.scale)/2-(basket_shadow.contentSize.height*basket_shadow.scale)/2);
    [physicWorld addChild:basket_shadow];
    
    //スパーク
    spark=[CCSprite spriteWithImageNamed:@"spark.png"];
    spark.position=ccp(basket.position.x,basket.position.y+(basket.contentSize.height*basket.scale)/2+(spark.contentSize.height*spark.scale)/2 -20);
    spark.scale=1.0;
    spark.opacity=0.0;
    [physicWorld addChild:spark];
    
    //ブーストエフェクト
    boost=[CCSprite spriteWithImageNamed:@"boost.png"];
    boost.position=ccp(piston.position.x,piston.position.y-(piston.contentSize.height*piston.scale)/2);
    boost.scale=0.3;
    boost.opacity=0.0;
    [physicWorld addChild:boost];
    
    //ボール生成
    ballCount++;
    //ballCount_lbl.string=[NSString stringWithFormat:@"BallCount:%03d",ballCount];
    if([angelBall containsIndex:ballCount]){
        ball=[Ball createBall:ccp(0,0) type:2 cnt:ballCount];//天使ボール
    }else if([devilBall containsIndex:ballCount]){
        ball=[Ball createBall:ccp(0,0) type:3 cnt:ballCount];//悪魔ボール
    }else{
        ball=[Ball createBall:ccp(0,0) type:1 cnt:ballCount];//ノーマルボール
    }
    ball.position=ccp(piston.position.x,winSize.height/2-50);
    [physicWorld addChild:ball z:1];
    [ballArray addObject:ball];
    
    /*/シャドーボール
    ballShadow=[BallShadow createBall:ballCount];
    //ballShadow.position=ball.position;
    [physicWorld addChild:ballShadow z:0];
    [ballShadowArray addObject:ballShadow];*/
    
    //ボールカウンター
    //ballCntLbl=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%02d",maxBallCount-(ballCount-1)]
    //                                                            fontName:@"Verdana-Bold" fontSize:15];
    ballCntLbl=[CCLabelBMFont labelWithString:
                        [NSString stringWithFormat:@"%02d",maxBallCount-(ballCount-1)]fntFile:@"score.fnt"];
    ballCntLbl.scale=0.7;
    ballCntLbl.position=ccp(piston.position.x,wall_m.position.y-(wall_m.contentSize.height*wall_m.scale)/2-10);
    [self addChild:ballCntLbl];
    
    //ボール発射スケジュール
    int delay;
    if(ballLaunchCnt<=100){
        delay=3.0;
    }else if(ballLaunchCnt<=200){
        delay=2.0;
    }else{
        delay=1.5;
    }
    [self schedule:@selector(ball_State_Schedule:)interval:0.01 repeat:CCTimerRepeatForever delay:delay];
    
    //ジャイロセンサー開始タイムウェイト
    [self scheduleOnce:@selector(basket_Start_Schedule:) delay:2.0];
}

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

//================================
//　ジャイロセンサー始動（タイムウェイト）
//================================
-(void)basket_Start_Schedule:(CCTime)dt
{
    //ジャイロセンサー開始
    if(![GameManager getPause]){
        NSOperationQueue *queueMotion = [[NSOperationQueue alloc] init];
        [motionManager startDeviceMotionUpdatesToQueue:queueMotion
                                           withHandler:^(CMDeviceMotion *data, NSError *error) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   [self moveBasket:data.gravity];
                                               });
                                           }];
    }
}

//================================
//　バスケット移動
//================================
- (void)moveBasket: (CMAcceleration)gravity
{
    //int adjustValue = 45;
    float gravityX = gravity.x * adjustValue;
    //float gravityY = gravity.y * adjustValue;
    
    CGPoint tmpPos=ccpAdd(basket.position,ccp(gravityX,0.0));
    if(tmpPos.x>basket.contentSize.width/5 && tmpPos.x<winSize.width-basket.contentSize.width/3)
    {
        //タイヤ回転
        [basket tire_Rotation:gravityX*5];
        //バスケット移動
        basket.position = tmpPos;
        //[basket.physicsBody applyForce:ccpAdd(basket.position,ccp(gravityX,0.0))];
        //バスケットシャドー移動
        basket_shadow.position=ccp(basket.position.x+30,basket_shadow.position.y);
    }
}

//================================
//　ボール種別生成
//================================
-(NSMutableIndexSet*)special_Ball_Num:(int)cnt range:(int)range
{
    NSMutableIndexSet* tmpIndex=[[NSMutableIndexSet alloc]init];
    int i=0;
    int num;

    while(i<cnt){
        num=(arc4random()%range)+1;//1〜Range
        if(![angelBall containsIndex:num] && ![tmpIndex containsIndex:num]){
            i++;
            [tmpIndex addIndex:num];
        }
    }
    //NSLog(@"Index=%lu",(unsigned long)[tmpIndex indexGreaterThanIndex:0]);
    
    return tmpIndex;
}

//================================
//　メインループ
//================================
-(void)ball_State_Schedule:(CCTime)dt
{
    //ポーズ脱出
    if([GameManager getPause]){
        return;
    }
    
    //初期化
    removeBallArray=[[NSMutableArray alloc]init];
    
    //ボール発射
    ballTimingCnt++;
    if(!lastBallFlg){
        if(ballTimingCnt>ballLaunchCnt){
            if(piston.position.y<winSize.height/2){
                //ピストン上昇
                piston.position=ccp(piston.position.x,piston.position.y+force);
            }else{
                //発射後TRUEにする
                ball.stateFlg=true;
                //ピストン下降
                piston.position=ccp(piston.position.x,winSize.height/2-100);

                ballTimingCnt=0;
                force=((arc4random()%5)+63)*0.1;//6.3〜6.7
                //NSLog(@"Force=%f",force);
                
                //サウンドエフェクト
                [SoundManager ball_Launch_Effect];
                
                //ブーストエフェクト
                boost.position=ccp(piston.position.x,piston.position.y-(piston.contentSize.height*piston.scale)/2);
                boost.opacity=1.0;
                [self schedule:@selector(boost_Schedule:) interval:0.01];
                
                //ボール生成
                ballCount++;
                if(ballCount<=maxBallCount){
                    //ballCount_lbl.string=[NSString stringWithFormat:@"BallCount:%03d",ballCount];
                    if([angelBall containsIndex:ballCount]){
                        ball=[Ball createBall:ccp(0,0) type:2 cnt:ballCount];//天使ボール
                    }else if([devilBall containsIndex:ballCount]){
                        ball=[Ball createBall:ccp(0,0) type:3 cnt:ballCount];//悪魔ボール
                    }else{
                        ball=[Ball createBall:ccp(0,0) type:1 cnt:ballCount];//ノーマルボール
                    }
                    ball.position=ccp(piston.position.x,winSize.height/2-50);
                    [physicWorld addChild:ball z:1];
                    //配列追加
                    [ballArray addObject:ball];
                    
                    /*/シャドーボール
                    ballShadow=[BallShadow createBall:ballCount];
                    ballShadow.position=ball.position;
                    [physicWorld addChild:ballShadow z:0];
                    [ballShadowArray addObject:ballShadow];*/
                    
                }else{
                    lastBallFlg=true;
                }
                //ボールカウンター
                ballCntLbl.string=[NSString stringWithFormat:@"%02d",maxBallCount-(ballCount-1)];
            }
        }
    }
    
    /*/シャドーボール移動
    for(Ball* _ball in ballArray){
        for(BallShadow* _ballShadow in ballShadowArray){
            if(_ball.ball_Id == _ballShadow.ball_Id){
                _ballShadow.position=_ball.position;
                break;
            }
        }
    }*/
    
    //ボール静止判定
    for(Ball* _ball in ballArray){
        if(_ball.stateFlg){
            if(_ball.physicsBody.sleeping){
                doneBallCount++;
                //doneBallCount_lbl.string=[NSString stringWithFormat:@"DoneBallCount:%03d",doneBallCount];
                _ball.stateFlg=false;
                //終了判定
                [self exit_Judgment];
            }
        }
    }
    //画面外ボール削除
    [self ball_Screen_Out];
    [self removeBall];
}

//================================
//　ボール削除
//================================
-(void)removeBall
{
    for(Ball* _ball in removeBallArray){
        if(_ball.stateFlg){
            doneBallCount++;
            //doneBallCount_lbl.string=[NSString stringWithFormat:@"DoneBallCount:%03d",doneBallCount];
        }
        
        /*/シャドーボール削除
        BallShadow* removeBallShadow;
        for(BallShadow* _shadow in ballShadowArray){
            if(_shadow.ball_Id==_ball.ball_Id){
                removeBallShadow=_shadow;
                break;
            }
        }
        [physicWorld removeChild:removeBallShadow cleanup:YES];
        [ballShadowArray removeObject:removeBallShadow];*/

        //ボール削除
        [ballArray removeObject:_ball];
        [physicWorld removeChild:_ball cleanup:YES];
        
        //終了判定
        [self exit_Judgment];
    }
}

//================================
//　ボール画面外判定
//================================
-(void)ball_Screen_Out
{
    for(Ball* _ball in ballArray){
        if(_ball.position.x<-(_ball.contentSize.width*_ball.scale)/2 ||
                                    _ball.position.x>winSize.width+(_ball.contentSize.width*_ball.scale)/2){
            [removeBallArray addObject:_ball];
        }
    }
}

//================================
//　ボールキャッチ判定
//================================
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair catch_point:(Ground*)catch_point cBall:(Ball*)cBall
{
    if(![GameManager getPause]){
        if(cBall.stateFlg){
            doneBallCount++;
            //doneBallCount_lbl.string=[NSString stringWithFormat:@"DoneBallCount:%03d",doneBallCount];
            //[GameManager setScore:[GameManager getScore]+1];
            //[Information scoreUpdata];
        }
    }
    //スコアリング
    if(cBall.ballType==2){//天使
        [GameManager setScore:[GameManager getScore]+50];
    }else if(cBall.ballType==3){//悪魔
        [GameManager setScore:[GameManager getScore]+30];
    }else{
        [GameManager setScore:[GameManager getScore]+10];
    }
    [Information scoreUpdata];

    //天使ボール（回復）
    if(cBall.ballType==2){
        if([GameManager getLifePoint]<5){
            [GameManager setLifePoint:[GameManager getLifePoint]+1];
            [Information lifePointUpdata];
        }
    }
    
    /*/シャドーボール削除
    BallShadow* removeBallShadow;
    for(BallShadow* _shadow in ballShadowArray){
        if(_shadow.ball_Id==ball.ball_Id){
            removeBallShadow=_shadow;
            break;
        }
    }
    [physicWorld removeChild:removeBallShadow cleanup:YES];
    [ballShadowArray removeObject:removeBallShadow];*/
    
    //ボール削除
    [physicWorld removeChild:cBall cleanup:YES];
    [ballArray removeObject:cBall];
    
    //サウンドエフェクト
    [SoundManager catch_Ball_Effect];
    
    //スパーク
    spark.position=ccp(basket.position.x,basket.position.y+(basket.contentSize.height*basket.scale)/2+(spark.contentSize.height*spark.scale)/2 -20);
    spark.opacity=1.0;
    [self schedule:@selector(spark_Schedule:)interval:0.01];
    
    //バスケットイルミネーション
    basket.basket_Color.color=cBall.ballColor;
    illuminationFlg=false;
    [self schedule:@selector(basket_Illumination_Schedule:)interval:0.01];
    
    //終了判定
    [self exit_Judgment];
    
    return TRUE;
}

//================================
//　ピンキャッチ判定
//================================
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair
                                            catch_point:(Ground*)catch_point
                                            cWindmill:(CCSprite*)cWindmill
{
    Windmill* _windmill=(Windmill*)[cWindmill parent];//親Pinオブジェクトを特定、代入
    [physicWorld removeChild:_windmill cleanup:YES];//削除
    
    //スコアリング
    [GameManager setScore:[GameManager getScore]+100];
    [Information scoreUpdata];
    
    //サウンドエフェクト
    [SoundManager catch_Pin_Effect];
    
    //スパーク
    spark.position=ccp(basket.position.x,basket.position.y+(basket.contentSize.height*basket.scale)/2+(spark.contentSize.height*spark.scale)/2 -20);
    spark.opacity=1.0;
    [self schedule:@selector(spark_Schedule:)interval:0.01];
    
    return TRUE;
}

//================================
//　ピン＆地上当たり判定
//================================
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair cGround:(Ground*)cGround cWindmill:(CCSprite*)cWindmill
{
    Windmill* _windmill=(Windmill*)[cWindmill parent];//親Pinオブジェクトを特定、代入
    [physicWorld removeChild:_windmill cleanup:YES];//削除
    
    return TRUE;
}

//================================
//　ボール＆地上当たり判定
//================================
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair cGround:(Ground*)cGround cBall:(Ball*)cBall
{
    if(![GameManager getPause]){
        if(cBall.stateFlg){
            cBall.stateFlg=false;
            doneBallCount++;
            //doneBallCount_lbl.string=[NSString stringWithFormat:@"DoneBallCount:%03d",doneBallCount];
            [GameManager setLifePoint:[GameManager getLifePoint]-1];
            [Information lifePointUpdata];
            
            //サウンドエフェクト
            [SoundManager ground_Ball_Effect];
            
            //終了判定
            [self exit_Judgment];
        }
    }
    return TRUE;
}

//================================
//　ボール＆ピン当たり判定
//================================
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair cWindmill:(CCSprite*)cWindmill cBall:(Ball*)cBall
{

    Windmill* _windmill=(Windmill*)[cWindmill parent];//親Pinオブジェクトを特定、代入
    //サウンドエフェクト
    if(cBall.collisionWindmill!=_windmill.windmill_Id){
        if(cBall.stateFlg){
            cBall.collisionWindmill=_windmill.windmill_Id;
            if(cBall.ballGroup==11){
                [SoundManager pin_Ball_11_Effect];
            }else if(cBall.ballGroup==12){
                [SoundManager pin_Ball_12_Effect];
            }else if(cBall.ballGroup==13){
                [SoundManager pin_Ball_13_Effect];
            }else if(cBall.ballGroup==14){
                [SoundManager pin_Ball_14_Effect];
            }else if(cBall.ballGroup==15){
                [SoundManager pin_Ball_15_Effect];
            }else if(cBall.ballGroup==21){
                [SoundManager pin_Ball_21_Effect];
            }else if(cBall.ballGroup==31){
                [SoundManager pin_Ball_31_Effect];
            }
        }
    }
    //悪魔ボール
    if(cBall.ballType==3)
    {
        [_windmill.axis.physicsBody setType:CCPhysicsBodyTypeDynamic];//動的物体にして落とす
        //[physicWorld removeChild:_pin cleanup:YES];//削除するなら
    }
    return true;
}

//================================
//　ブーストエフェクトスケジュール
//================================
-(void)boost_Schedule:(CCTime)dt
{
    boost.opacity-=0.02;
    boost.position=ccp(boost.position.x,boost.position.y-0.5);
    if(boost.opacity<0){
        [self unschedule:@selector(boost_Schedule:)];
    }
}
//================================
//　スパークスケジュール
//================================
-(void)spark_Schedule:(CCTime)dt
{
    spark.opacity-=0.02;
    spark.position=ccp(spark.position.x,spark.position.y+0.5);
    if(spark.opacity<0){
        [self unschedule:@selector(spark_Schedule:)];
    }
}
//================================
//　バスケット発光スケジュール
//================================
-(void)basket_Illumination_Schedule:(CCTime)dt
{
    if(!illuminationFlg){
        basket.basket_Color.opacity+=0.02;
        if(basket.basket_Color.opacity>=0.5){
            illuminationFlg=true;
        }
    }else{
        basket.basket_Color.opacity-=0.02;
        if(basket.basket_Color.opacity<=0.0){
            illuminationFlg=false;
            [self unschedule:@selector(basket_Illumination_Schedule:)];
        }
    }
    
}
//================================
//　終了判定
//================================
-(void)exit_Judgment
{
    //終了判定
    if([GameManager getLifePoint]<=0){//ゲームオーバー
        [self gameEnd:false];
    }else if(lastBallFlg && maxBallCount==doneBallCount){//ステージクリア
        [self gameEnd:true];
    }
}

//================================
//　ゲーム終了
//================================
-(void)gameEnd:(bool)flg
{
    bool highScoreFlg=false;
    
    [motionManager stopDeviceMotionUpdates];//ジャイロセンサー停止
    physicWorld.paused=YES;
    
    //BGM停止
    //[SoundManager stopBGM];
    
    //ハイスコア保存
    if([GameManager getPlayMode]==1)
    {
        if([GameManager load_High_Score_1]<[GameManager getScore]){
            [GameManager save_High_Score_1:[GameManager getScore]];
            [Information highScoreUpdata];
            highScoreFlg=true;
            
            //GameCenterへ送信
            [GameManager submit_Score_GameCenter:[GameManager load_High_Score_1] mode:1];
        }
    }
    else
    {
        if([GameManager getScore]>[GameManager load_Stage_Score:[GameManager getStageLevel]]){//ハイスコア！
            [GameManager save_Stage_Score:[GameManager getStageLevel] score:[GameManager getScore]];//ステージスコア保存
            [GameManager save_High_Score_2:[GameManager load_Total_Score:75]];//全スコアをハイスコアへ保存
            [Information highScoreUpdata];//ハイスコア更新
            highScoreFlg=true;
            
            //GameCenterへ送信
            [GameManager submit_Score_GameCenter:[GameManager load_High_Score_2] mode:2];
        }
    }
    
    //ステージクリア
    if(flg){
        //ステージレヴェル保存
        if([GameManager getPlayMode]==1)
        {
            if([GameManager load_Stage_Level_1]<[GameManager getStageLevel]){
                [GameManager save_Stage_Level_1:[GameManager getStageLevel]];
            }
        }else{
            if([GameManager load_Stage_Level_2]<[GameManager getStageLevel]){
                [GameManager save_Stage_Level_2:[GameManager getStageLevel]];
            }
        }
        //ネクストステージへ
        if([GameManager getPlayMode]==1){
            MsgEffect* msg=[[MsgEffect alloc]initWithMsg:NSLocalizedString(@"Stage_Complete",NULL)
                                                        nextFlg:true highScoreFlg:highScoreFlg];
            [self addChild:msg z:2];
        }else{
            if([GameManager getStageLevel]<75){
                MsgEffect* msg=[[MsgEffect alloc]initWithMsg:NSLocalizedString(@"Stage_Complete",NULL)
                                                        nextFlg:true highScoreFlg:highScoreFlg];
                [self addChild:msg z:2];
            }
            else//全ステージクリア！
            {
                /*
                [GameManager setPause:true];
                naviLayer.visible=true;
                naviLayer.gameOverLabel.string=@"Congratu\nlations!";
                pauseBtn.visible=false;
                resumeBtn.visible=false;
                 */
                
                //エンディングシーンへ
                [[CCDirector sharedDirector] replaceScene:[EndingScene scene]
                                           withTransition:[CCTransition transitionCrossFadeWithDuration:3.0]];
                
                //Ad表示
                [naviLayer dispAdLayer];
                //インターステイシャル広告表示
                [ImobileSdkAds showBySpotID:@"457103"];
            }
        }
    }else{//ゲームオーバー
        //BGM停止
        [SoundManager stopBGM];
        
        //サウンドエフェクト
        [SoundManager game_Over_Effect];
        
        [GameManager setPause:true];
        naviLayer.visible=true;
        naviLayer.gameOverLabel.string = NSLocalizedString(@"Stage_Failed",NULL);
        pauseBtn.visible=false;
        resumeBtn.visible=false;
        //Ad表示
        [naviLayer dispAdLayer];
        //インターステイシャル広告表示
        [ImobileSdkAds showBySpotID:@"457103"];
    }
}

//================================
//　ポーズ
//================================
-(void)onPauseClicked:(id)sender
{
    //if(![[CCDirector sharedDirector]isPaused]){ //レイティングポーズ時はポーズしない(2重ポーズ防止)
    if(![GameManager getPause]){ //レイティングポーズ時はポーズしない(2重ポーズ防止)
        [GameManager setPause:true];
        [motionManager stopDeviceMotionUpdates];//ジャイロセンサー停止
        physicWorld.paused=YES;//物理ワールド停止
        
        //BGMポーズ
        [SoundManager pauseBGM];
        
        //ポーズレイヤー表示
        naviLayer.visible=true;
        pauseBtn.visible=false;
        resumeBtn.visible=true;
        
        //Ad表示
        [naviLayer dispAdLayer];
    }
}

//================================
//　レジューム
//================================
-(void)onResumeClicked:(id)sender
{
    [GameManager setPause:false];
    physicWorld.paused=NO;//物理ワールド再開

    //BGMレジューム
    [SoundManager resumeBGM];
    
    //ジャイロセンサー再開
    NSOperationQueue *queueMotion = [[NSOperationQueue alloc] init];
    [motionManager startDeviceMotionUpdatesToQueue:queueMotion
                                       withHandler:^(CMDeviceMotion *data, NSError *error) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [self moveBasket:data.gravity];
                                           });
                                       }];
    //ポーズレイヤー非表示
    naviLayer.visible=false;
    pauseBtn.visible=true;
    resumeBtn.visible=false;
    
    //Ad非表示
    [naviLayer hideAdLayer];
}

@end
