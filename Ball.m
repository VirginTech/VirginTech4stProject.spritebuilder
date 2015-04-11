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

-(id)initWithBall:(CGPoint)pos
{
    if(self=[super init]){
        
        self=(id)[CCBReader load:@"Ball"];
        self.position=pos;
        self.scale=0.3;
        self.physicsBody.collisionType = @"ball";
    
        stateFlg=false;
    }
    return self;
}

+(id)createBall:(CGPoint)pos
{
    return [[self alloc] initWithBall:pos];
}

@end
