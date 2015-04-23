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
#import "Pin.h"
#import "InitManager.h"
#import "Corner.h"
#import "Wall.h"
#import "Piston.h"
#import "GameManager.h"
#import "Basket.h"
#import "Information.h"
#import "NaviLayer.h"
#import "MsgLayer.h"
#import "BallShadow.h"

@implementation StageScene

CGSize winSize;

CMMotionManager *motionManager;
CCPhysicsNode* physicWorld;

Ball* ball;
Ground* ground;
Corner* corner;
Pin* pin;
Wall* wall_r;
Wall* wall_l;
Wall* wall_u;
Wall* wall_m;
Piston* piston;
Basket* basket;
CCSprite* basket_shadow;
CCSprite* spark;

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

//シャドーボール
BallShadow* ballShadow;
NSMutableArray* ballShadowArray;

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
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.0f green:0.4f blue:0.0f alpha:1.0f]];
    [self addChild:background];

    //初期化
    maxBallCount=12;
    doneBallCount=0;
    ballCount=0;
    ballTimingCnt=0;
    force=((arc4random()%41)+60)*0.1;
    ballArray=[[NSMutableArray alloc]init];
    ballShadowArray=[[NSMutableArray alloc]init];
    [GameManager setPause:false];
    lastBallFlg=false;
    angelBall=[[NSMutableIndexSet alloc]init];
    devilBall=[[NSMutableIndexSet alloc]init];
    
    //天使・悪魔ボール取得
    angelBall=[self special_Ball_Num:1];//１個分
    devilBall=[self special_Ball_Num:2];//２個分
    //NSLog(@"AngelBall=%@",angelBall);
    //NSLog(@"DevilBall=%@",devilBall);
    
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
    
    //ボール発射間隔
    ballLaunchCnt=300-((([GameManager getStageLevel]-1)/10)*10);//10ステージごとに-10
    if(ballLaunchCnt<50){
        ballLaunchCnt=50;//50を下回ったら50を維持
    }
    //NSLog(@"BallLaunchCnt=%d",ballLaunchCnt);
    
    //インフォメーションレイヤー
    Information* infoLayer=[[Information alloc]init];
    [self addChild:infoLayer z:1];
    
    //ポーズレイヤー
    naviLayer=[[NaviLayer alloc]init];
    [self addChild:naviLayer z:2];
    naviLayer.visible=false;
    
    //画像読み込み
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
    MsgLayer* msg=[[MsgLayer alloc]initWithMsg:[NSString stringWithFormat:@"Lv.%d Start!",
                                                            [GameManager getStageLevel]] nextFlg:false];
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
        pin=[Pin createPin:pos];
        [physicWorld addChild:pin];
    }

    //バスケット生成
    basket=[Basket createBasket:ccp(winSize.width/2,ground.position.y+(ground.contentSize.height*ground.scale)/2+23)];
    [physicWorld addChild:basket];
    
    //バスケットシャドー生成
    basket_shadow=[CCSprite spriteWithImageNamed:@"basket_shadow.png"];
    basket_shadow.scale=0.7;
    basket_shadow.opacity=0.3;
    basket_shadow.position=ccp(basket.position.x+35,ground.position.y+(ground.contentSize.height*ground.scale)/2-(basket_shadow.contentSize.height*basket_shadow.scale)/2);
    [physicWorld addChild:basket_shadow];
    
    //スパーク
    spark=[CCSprite spriteWithImageNamed:@"spark.png"];
    spark.position=ccp(basket.position.x,basket.position.y+(basket.contentSize.height*basket.scale)/2+(spark.contentSize.height*spark.scale)/2 -20);
    spark.scale=1.0;
    spark.opacity=0.0;
    [physicWorld addChild:spark];
    
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
    ball.position=ccp(winSize.width-(ball.contentSize.width*ball.scale)/2,winSize.height/2-50);
    [physicWorld addChild:ball z:1];
    [ballArray addObject:ball];
    
    //シャドーボール
    ballShadow=[BallShadow createBall:ballCount];
    //ballShadow.position=ball.position;
    [physicWorld addChild:ballShadow z:0];
    [ballShadowArray addObject:ballShadow];
    
    //ボール発射スケジュール
    [self schedule:@selector(ball_State_Schedule:)interval:0.01 repeat:CCTimerRepeatForever delay:1.5];
    
    //ジャイロセンサー開始タイムウェイト
    [self schedule:@selector(basket_Start_Schedule:)interval:1.0 repeat:0 delay:2.0];
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
    if(tmpPos.x>basket.contentSize.width/3 && tmpPos.x<winSize.width-basket.contentSize.width/3)
    {
        //タイヤ回転
        [basket tire_Rotation:gravityX*5];
        //バスケット移動
        basket.position = tmpPos;
        //[basket.physicsBody applyForce:ccpAdd(basket.position,ccp(gravityX,0.0))];
        //バスケットシャドー移動
        basket_shadow.position=ccp(basket.position.x+35,basket_shadow.position.y);
    }
}

//================================
//　ボール種別生成
//================================
-(NSMutableIndexSet*)special_Ball_Num:(int)cnt
{
    NSMutableIndexSet* tmpIndex=[[NSMutableIndexSet alloc]init];
    int i=0;
    int num;

    while(i<cnt){
        num=(arc4random()%(maxBallCount-3))+1;//Max=12 → 1〜9
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
                
                ballTimingCnt=0;
                force=((arc4random()%5)+63)*0.1;//6.3〜6.7
                //NSLog(@"Force=%f",force);
                //下降
                piston.position=ccp(piston.position.x,winSize.height/2-100);
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
                    ball.position=ccp(winSize.width-(ball.contentSize.width*ball.scale)/2,winSize.height/2-50);
                    [physicWorld addChild:ball z:1];
                    //配列追加
                    [ballArray addObject:ball];
                    
                    //シャドーボール
                    ballShadow=[BallShadow createBall:ballCount];
                    ballShadow.position=ball.position;
                    [physicWorld addChild:ballShadow z:0];
                    [ballShadowArray addObject:ballShadow];
                    
                }else{
                    lastBallFlg=true;
                }
            }
        }
    }
    
    //シャドーボール移動
    for(Ball* _ball in ballArray){
        for(BallShadow* _ballShadow in ballShadowArray){
            if(_ball.ball_Id == _ballShadow.ball_Id){
                _ballShadow.position=_ball.position;
                break;
            }
        }
    }
    
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
        
        //シャドーボール削除
        BallShadow* removeBallShadow;
        for(BallShadow* _shadow in ballShadowArray){
            if(_shadow.ball_Id==_ball.ball_Id){
                removeBallShadow=_shadow;
                break;
            }
        }
        [physicWorld removeChild:removeBallShadow cleanup:YES];
        [ballShadowArray removeObject:removeBallShadow];

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
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair catch_point:(Ground*)catch_point ball:(Ball*)ball
{
    if(![GameManager getPause]){
        if(ball.stateFlg){
            doneBallCount++;
            //doneBallCount_lbl.string=[NSString stringWithFormat:@"DoneBallCount:%03d",doneBallCount];
            //[GameManager setScore:[GameManager getScore]+1];
            //[Information scoreUpdata];
        }
    }
    //スコアリング
    if(ball.ballType==2){//天使
        [GameManager setScore:[GameManager getScore]+50];
    }else if(ball.ballType==3){//悪魔
        [GameManager setScore:[GameManager getScore]+30];
    }else{
        [GameManager setScore:[GameManager getScore]+10];
    }
    [Information scoreUpdata];

    //天使ボール（回復）
    if(ball.ballType==2){
        if([GameManager getPointCount]<5){
            [GameManager setPointCount:[GameManager getPointCount]+1];
            [Information pointCountUpdata];
        }
    }
    
    //シャドーボール削除
    BallShadow* removeBallShadow;
    for(BallShadow* _shadow in ballShadowArray){
        if(_shadow.ball_Id==ball.ball_Id){
            removeBallShadow=_shadow;
            break;
        }
    }
    [physicWorld removeChild:removeBallShadow cleanup:YES];
    [ballShadowArray removeObject:removeBallShadow];
    
    //ボール削除
    [physicWorld removeChild:ball cleanup:YES];
    [ballArray removeObject:ball];
    
    //スパーク
    spark.position=ccp(basket.position.x,basket.position.y+(basket.contentSize.height*basket.scale)/2+(spark.contentSize.height*spark.scale)/2 -20);
    spark.opacity=1.0;
    [self schedule:@selector(spark_Schedule:)interval:0.01];
    
    //終了判定
    [self exit_Judgment];
    
    return TRUE;
}

//================================
//　ピンキャッチ判定
//================================
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair
                                            catch_point:(Ground*)catch_point
                                            windmill:(CCSprite*)windmill
{
    Pin* _pin=(Pin*)[windmill parent];//親Pinオブジェクトを特定、代入
    [physicWorld removeChild:_pin cleanup:YES];//削除
    
    //スコアリング
    [GameManager setScore:[GameManager getScore]+100];
    [Information scoreUpdata];
    
    return TRUE;
}

//================================
//　ピン＆地上当たり判定
//================================
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ground:(Ground*)ground windmill:(CCSprite*)windmill
{
    Pin* _pin=(Pin*)[windmill parent];//親Pinオブジェクトを特定、代入
    [physicWorld removeChild:_pin cleanup:YES];//削除
    
    return TRUE;
}

//================================
//　ボール＆地上当たり判定
//================================
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ground:(Ground*)ground ball:(Ball*)ball
{
    if(![GameManager getPause]){
        if(ball.stateFlg){
            ball.stateFlg=false;
            doneBallCount++;
            //doneBallCount_lbl.string=[NSString stringWithFormat:@"DoneBallCount:%03d",doneBallCount];
            [GameManager setPointCount:[GameManager getPointCount]-1];
            [Information pointCountUpdata];
            
            //終了判定
            [self exit_Judgment];
        }
    }
    return TRUE;
}

//================================
//　ボール＆ピン当たり判定
//================================
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair windmill:(CCSprite*)windmill ball:(Ball*)ball
{
    //悪魔ボール
    if(ball.ballType==3)
    {
        Pin* _pin=(Pin*)[windmill parent];//親Pinオブジェクトを特定、代入
        [_pin.axis.physicsBody setType:CCPhysicsBodyTypeDynamic];//動的物体にして落とす
    
        //[physicWorld removeChild:_pin cleanup:YES];//削除するなら
    }
    return true;
}

//================================
//　スパーク
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
//　終了判定
//================================
-(void)exit_Judgment
{
    //終了判定
    if([GameManager getPointCount]<=0){//ゲームオーバー
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
    [motionManager stopDeviceMotionUpdates];//ジャイロセンサー停止
    physicWorld.paused=YES;
    
    if(flg){//ステージクリア
        //ステージレヴェル保存
        if([GameManager load_Stage_Level]<[GameManager getStageLevel]){
            [GameManager save_Stage_Level:[GameManager getStageLevel]];
        }
        //ネクストステージへ
        MsgLayer* msg=[[MsgLayer alloc]initWithMsg:@"  Stage\nComplete!" nextFlg:true];
        [self addChild:msg z:2];
    }else{//ゲームオーバー
        [GameManager setPause:true];
        naviLayer.visible=true;
        naviLayer.gameOverLabel.string=@"Game Over!";
        pauseBtn.visible=false;
        resumeBtn.visible=false;
    }
    //ハイスコア保存
    if([GameManager load_High_Score]<[GameManager getScore]){
        [GameManager save_High_Score:[GameManager getScore]];
        [Information highScoreUpdata];
    }
}

//================================
//　ポーズ
//================================
-(void)onPauseClicked:(id)sender
{
    [GameManager setPause:true];
    [motionManager stopDeviceMotionUpdates];//ジャイロセンサー停止
    physicWorld.paused=YES;//物理ワールド停止
    
    //ポーズレイヤー表示
    naviLayer.visible=true;
    pauseBtn.visible=false;
    resumeBtn.visible=true;
}

//================================
//　レジューム
//================================
-(void)onResumeClicked:(id)sender
{
    [GameManager setPause:false];
    physicWorld.paused=NO;//物理ワールド再開

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

}

@end
