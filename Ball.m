//
//  Ball.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/07.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "Ball.h"


@implementation Ball

-(id)initWithBall:(CGPoint)pos
{
    self=(id)[CCBReader load:@"Ball"];
    self.position=pos;
    self.scale=0.3;
    
    return self;
}

+(id)createBall:(CGPoint)pos
{
    return [[self alloc] initWithBall:pos];
}

@end
