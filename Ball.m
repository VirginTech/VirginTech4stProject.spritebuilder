//
//  Ball.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/07.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "Ball.h"


@implementation Ball

@synthesize stateFlg;
@synthesize ballType;//1:ノーマル 2:天使 3:悪魔

-(id)initWithBall:(CGPoint)pos type:(int)type
{
    if(self=[super init]){
        
        NSString* ballName=[NSString stringWithFormat:@"Bird_%02d",type];
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
        
        self.position=pos;
        self.scale=0.3;
        self.physicsBody.collisionType = @"ball";
    
        ballType=type;
        stateFlg=false;
    }
    return self;
}

+(id)createBall:(CGPoint)pos type:(int)type
{
    return [[self alloc] initWithBall:pos type:type];
}

@end
