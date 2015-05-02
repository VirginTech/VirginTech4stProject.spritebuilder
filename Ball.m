//
//  Ball.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/07.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "Ball.h"


@implementation Ball

@synthesize ball_Id;
@synthesize stateFlg;
@synthesize ballType;//1:ノーマル 2:天使 3:悪魔
@synthesize ballColor;

-(id)initWithBall:(CGPoint)pos type:(int)type cnt:(int)cnt
{
    if(self=[super init]){
        
        int i;
        NSString* ballName;
        if(type==1){
            i=arc4random()%5+1;
            ballName=[NSString stringWithFormat:@"Ball_%02d_%02d",type,i];
        }else{
            ballName=[NSString stringWithFormat:@"Ball_%02d",type];
        }
        self=(id)[CCBReader load:ballName];

        /*/画像読み込み
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"object_default.plist"];
        [self setSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"bird_02.png"]];

        self.position=pos;
        self.physicsBody=[CCPhysicsBody bodyWithCircleOfRadius:self.contentSize.width*0.5
                                        andCenter:ccp(self.contentSize.width/2,self.contentSize.height/2)];
        self.scale=0.5*0.3;//0.5 -> CCB:2x

        [self.physicsBody setType:CCPhysicsBodyTypeDynamic];
        [self.physicsBody setAffectedByGravity:YES];
        [self.physicsBody setAllowsRotation:YES];
        
        self.physicsBody.density=1.0;
        self.physicsBody.friction=0.3;
        self.physicsBody.elasticity=0.5;
        */
        
        //色情報
        if(type==1){
            if(i==1){
                ballColor=[CCColor colorWithRed:1.0 green:1.0 blue:1.0];//白
            }else if(i==2){
                ballColor=[CCColor colorWithRed:0.0 green:1.0 blue:0.0];//緑
            }else if(i==3){
                ballColor=[CCColor colorWithRed:0.0 green:0.0 blue:1.0];//青
            }else if(i==4){
                ballColor=[CCColor colorWithRed:1.0 green:0.0 blue:0.0];//赤
            }else if(i==5){
                ballColor=[CCColor colorWithRed:1.0 green:0.0 blue:1.0];//紫
            }
        }else if(type==2){
            ballColor=[CCColor yellowColor];
        }else if(type==3){
            ballColor=[CCColor blackColor];
        }
        
        self.ball_Id=cnt;
        self.position=pos;
        self.scale=0.3;
        self.physicsBody.collisionType = @"ball";
    
        ballType=type;
        stateFlg=false;
    }
    return self;
}

+(id)createBall:(CGPoint)pos type:(int)type cnt:(int)cnt
{
    return [[self alloc] initWithBall:pos type:type cnt:cnt];
}

@end
