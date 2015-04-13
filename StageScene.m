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

int ballCount;//発射ボール数
int ballTimingCnt;//ボール発射間隔
int maxBallCount;//最大ボール数
int doneBallCount;//処理済みボール数
bool lastBallFlg;//最終ボールフラグ
float force;//ボール打ち上げフォース

NSMutableArray* ballArray;
NSMutableArray* removeBallArray;

NaviLayer* naviLayer;
CCButton* pauseBtn;
CCButton* resumeBtn;

//デバッグラベル
CCLabelTTF* maxBallCount_lbl;
CCLabelTTF* ballCount_lbl;
CCLabelTTF* doneBallCount_lbl;

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
    
    //初期化
    maxBallCount=5;
    doneBallCount=0;
    ballCount=0;
    ballTimingCnt=0;
    force=((arc4random()%41)+60)*0.1;
    ballArray=[[NSMutableArray alloc]init];
    [GameManager setPause:false];
    lastBallFlg=false;
    
    //インフォメーションレイヤー
    Information* infoLayer=[[Information alloc]init];
    [self addChild:infoLayer z:1];
    
    //ポーズレイヤー
    naviLayer=[[NaviLayer alloc]init];
    [self addChild:naviLayer z:2];
    naviLayer.visible=false;
    
    //ポーズボタン
    pauseBtn=[CCButton buttonWithTitle:@"[ポーズ]"];
    pauseBtn.position=ccp(winSize.width-pauseBtn.contentSize.width/2,pauseBtn.contentSize.height/2+50);
    [pauseBtn setTarget:self selector:@selector(onPauseClicked:)];
    [self addChild:pauseBtn z:3];
    
    //レジュームボタン
    resumeBtn=[CCButton buttonWithTitle:@"[レジューム]"];
    resumeBtn.position=ccp(winSize.width-resumeBtn.contentSize.width/2,resumeBtn.contentSize.height/2+50);
    [resumeBtn setTarget:self selector:@selector(onResumeClicked:)];
    [self addChild:resumeBtn z:3];
    resumeBtn.visible=false;
    
    //開始メッセージ
    MsgLayer* msg=[[MsgLayer alloc]initWithMsg:[NSString stringWithFormat:@"Lv.%d Start!",
                                                            [GameManager getStageLevel]] nextFlg:false];
    [self addChild:msg z:2];
    
    
    //デバッグラベル
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
    [self addChild:doneBallCount_lbl z:1];

    
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
    
    //バスケット生成
    basket=[Basket createBasket:ccp(winSize.width/2,70)];
    [physicWorld addChild:basket];
    
    //地面生成
    ground=[Ground createGround:ccp(winSize.width/2,10.0)];
    [physicWorld addChild:ground];
    
    //コーナー生成
    corner=[Corner createCorner:ccp(0,0)];
    corner.position=ccp(winSize.width-corner.contentSize.width/2+5,winSize.height-corner.contentSize.height/2+5);
    [physicWorld addChild:corner];
    
    corner=[Corner createCorner:ccp(0,0)];
    corner.position=ccp(corner.contentSize.width/2-5,winSize.height-corner.contentSize.height/2+5);
    corner.rotation=-90;
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
    piston.position=ccp(winSize.width-piston.contentSize.width/2,winSize.height/2-100);
    [physicWorld addChild:piston];
    
    //ピン生成
    CGPoint pos;
    NSMutableArray* array=[InitManager init_Pin_Pattern:[GameManager getStageLevel]];
    for(int i=0;i<array.count;i++){
        pos=[[array objectAtIndex:i]CGPointValue];
        pin=[Pin createPin:pos];
        [physicWorld addChild:pin];
    }

    //ボール生成
    ballCount++;
    ballCount_lbl.string=[NSString stringWithFormat:@"BallCount:%03d",ballCount];
    ball=[Ball createBall:ccp(0,0)];
    ball.position=ccp(winSize.width-(ball.contentSize.width*ball.scale)/2,winSize.height/2-50);
    [physicWorld addChild:ball];
    [ballArray addObject:ball];
    
    //ボール発射スケジュール
    [self schedule:@selector(ball_State_Schedule:)interval:0.01 repeat:CCTimerRepeatForever delay:1.5];
    
    //ジャイロセンサー開始
    motionManager = [[CMMotionManager alloc] init];
    motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
    NSOperationQueue *queueMotion = [[NSOperationQueue alloc] init];
    [motionManager startDeviceMotionUpdatesToQueue:queueMotion
                                       withHandler:^(CMDeviceMotion *data, NSError *error) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [self moveBasket:data.gravity];
                                           });
                                       }];

}

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

- (void)moveBasket: (CMAcceleration)gravity
{
    int adjustValue = 25;
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
    }
}

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
        if(ballTimingCnt>300){
            if(piston.position.y<winSize.height/2){
                //ピストン上昇
                piston.position=ccp(piston.position.x,piston.position.y+force);
            }else{
                //発射後TRUEにする
                ball.stateFlg=true;
                
                ballTimingCnt=0;
                force=((arc4random()%41)+60)*0.1;
                //NSLog(@"Force=%f",force);
                //下降
                piston.position=ccp(piston.position.x,winSize.height/2-100);
                //ボール生成
                ballCount++;
                if(ballCount<=maxBallCount){
                    ballCount_lbl.string=[NSString stringWithFormat:@"BallCount:%03d",ballCount];
                    ball=[Ball createBall:ccp(0,0)];
                    ball.position=ccp(winSize.width-(ball.contentSize.width*ball.scale)/2,winSize.height/2-50);
                    [physicWorld addChild:ball];
                    //配列追加
                    [ballArray addObject:ball];
                }else{
                    lastBallFlg=true;
                }
            }
        }
    }
    //ボール静止判定
    for(Ball* _ball in ballArray){
        if(_ball.stateFlg){
            if(_ball.physicsBody.sleeping){
                doneBallCount++;
                doneBallCount_lbl.string=[NSString stringWithFormat:@"DoneBallCount:%03d",doneBallCount];
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

-(void)removeBall
{
    for(Ball* _ball in removeBallArray){
        if(_ball.stateFlg){
            doneBallCount++;
            doneBallCount_lbl.string=[NSString stringWithFormat:@"DoneBallCount:%03d",doneBallCount];
        }
        //ボール削除
        [ballArray removeObject:_ball];
        [physicWorld removeChild:_ball cleanup:YES];
        
        //終了判定
        [self exit_Judgment];
    }
}

-(void)ball_Screen_Out
{
    for(Ball* _ball in ballArray){
        if(_ball.position.x<-(_ball.contentSize.width*_ball.scale)/2 ||
                                    _ball.position.x>winSize.width+(_ball.contentSize.width*_ball.scale)/2){
            [removeBallArray addObject:_ball];
        }
    }
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair catch_point:(Ground*)catch_point ball:(Ball*)ball
{
    if(![GameManager getPause]){
        if(ball.stateFlg){
            doneBallCount++;
            doneBallCount_lbl.string=[NSString stringWithFormat:@"DoneBallCount:%03d",doneBallCount];
            //[GameManager setScore:[GameManager getScore]+1];
            //[Information scoreUpdata];
        }
    }
    //スコアリング
    [GameManager setScore:[GameManager getScore]+1];
    [Information scoreUpdata];

    //ボール削除
    [physicWorld removeChild:ball cleanup:YES];
    [ballArray removeObject:ball];
    
    //終了判定
    [self exit_Judgment];
    
    return TRUE;
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ground:(Ground*)ground ball:(Ball*)ball
{
    if(![GameManager getPause]){
        if(ball.stateFlg){
            ball.stateFlg=false;
            doneBallCount++;
            doneBallCount_lbl.string=[NSString stringWithFormat:@"DoneBallCount:%03d",doneBallCount];
            [GameManager setPointCount:[GameManager getPointCount]-1];
            [Information pointCountUpdata];
            
            //終了判定
            [self exit_Judgment];
        }
    }
    return TRUE;
}

-(void)exit_Judgment
{
    //終了判定
    if([GameManager getPointCount]<=0){//ゲームオーバー
        [self gameEnd:false];
    }else if(lastBallFlg && maxBallCount==doneBallCount){//ステージクリア
        [self gameEnd:true];
    }
}

-(void)gameEnd:(bool)flg
{
    [motionManager stopDeviceMotionUpdates];//ジャイロセンサー停止
    physicWorld.paused=YES;
    
    if(flg){//ステージクリア
        //ステージレヴェル保存
        [GameManager save_Stage_Level:[GameManager getStageLevel]];
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

-(void)onResumeClicked:(id)sender
{
    [GameManager setPause:false];
    physicWorld.paused=NO;//物理ワールド再開

    //ジャイロセンサー再開
    //motionManager = [[CMMotionManager alloc] init];
    //motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
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
