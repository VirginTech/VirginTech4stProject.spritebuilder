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

@implementation StageScene

CGSize winSize;

CMMotionManager *motionManager;
CCPhysicsNode* physicWorld;

Ball* ball;
Ground* ground;
Corner* corner;
Pin* pin;
Wall* wall;
Piston* piston;
Basket* basket;

int ballTimingCnt;

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
    ballTimingCnt=0;
    
    CCButton* titleBtn=[CCButton buttonWithTitle:@"[タイトル]"];
    titleBtn.position=ccp(winSize.width-titleBtn.contentSize.width/2,titleBtn.contentSize.height/2+50);
    [titleBtn setTarget:self selector:@selector(onTitltClicked:)];
    [self addChild:titleBtn];
    
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
    
    //壁
    wall=[Wall createWall:ccp(winSize.width-35,winSize.height/2)];
    [physicWorld addChild:wall];
    
    //ピストン
    piston=[Piston createPiston:ccp(0,0)];
    piston.position=ccp(winSize.width-piston.contentSize.width/2,winSize.height/2-100);
    [physicWorld addChild:piston];
    
    //ピン生成
    CGPoint pos;
    NSMutableArray* array=[InitManager init_Pin_Pattern:1];
    for(int i=0;i<array.count;i++){
        pos=[[array objectAtIndex:i]CGPointValue];
        pin=[Pin createPin:pos];
        [physicWorld addChild:pin];
    }

    //バスケット生成
    basket=[Basket createBasket:ccp(winSize.width/2,70)];
    [physicWorld addChild:basket];
    
    //ボール生成
    ball=[Ball createBall:ccp(0,0)];
    ball.position=ccp(winSize.width-(ball.contentSize.width*ball.scale)/2,winSize.height/2-50);
    [physicWorld addChild:ball];

    //ボール発射スケジュール
    [self schedule:@selector(ball_Launch_Schedule:)interval:0.01];
    
    //ジャイロセンサー
    CMMotionManager *manager = [[CMMotionManager alloc] init];
    motionManager = manager;
    motionManager.deviceMotionUpdateInterval = 1.0 / 30.0;
    
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
    int adjustValue = 20;
    float gravityX = gravity.x * adjustValue;
    //float gravityY = gravity.y * adjustValue;
    
    CGPoint tmpPos=ccpAdd(basket.position,ccp(gravityX,0.0));
    if(tmpPos.x>basket.contentSize.width/2 && tmpPos.x<winSize.width-basket.contentSize.width/2)
    {
        //タイヤ回転
        [basket tire_Rotation:gravityX*5];
        //バスケット移動
        basket.position = tmpPos;
        //[basket.physicsBody applyForce:ccpAdd(basket.position,ccp(gravityX,0.0))];
    }
}

-(void)ball_Launch_Schedule:(CCTime)dt
{
    ballTimingCnt++;
    
    if(ballTimingCnt>300){
        if(piston.position.y<winSize.height/2){
            piston.position=ccp(piston.position.x,piston.position.y+6.5);
        }else{
            ballTimingCnt=0;
            //下降
            piston.position=ccp(piston.position.x,winSize.height/2-100);
            //ボール生成
            ball=[Ball createBall:ccp(0,0)];
            ball.position=ccp(winSize.width-(ball.contentSize.width*ball.scale)/2,winSize.height/2-50);
            [physicWorld addChild:ball];
        }
    }
}

- (void)onTitltClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
    
}

@end
