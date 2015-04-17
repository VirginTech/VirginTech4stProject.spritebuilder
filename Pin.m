//
//  Pin.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/07.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "Pin.h"


@implementation Pin

@synthesize axis;

-(id)initWithPin:(CGPoint)pos
{
    if(self=[super init]){

        self=(id)[CCBReader load:@"Pin"];
        self.position=pos;
        self.scale=0.2;
        
        pinBody.physicsBody.collisionType = @"pinBody";
    }
    return self;
}

+(id)createPin:(CGPoint)pos
{
    return [[self alloc] initWithPin:pos];
}

@end
