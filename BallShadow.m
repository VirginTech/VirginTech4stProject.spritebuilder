//
//  BallShadow.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/21.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "BallShadow.h"


@implementation BallShadow

@synthesize ball_Id;

-(id)initWithBall:(int)cnt
{
    if(self=[super init]){
        
        self=(id)[CCBReader load:@"BallShadow"];
        
        self.ball_Id=cnt;
        self.scale=0.3;
    }
    return self;
}
        
+(id)createBall:(int)cnt
{
    return [[self alloc] initWithBall:cnt];
}

@end
