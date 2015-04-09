//
//  Ground.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/07.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "Ground.h"


@implementation Ground

-(id)initWithGround:(CGPoint)pos
{
    if(self=[super init]){

        self=(id)[CCBReader load:@"Ground"];
        self.position=pos;
        self.rotation=0.0;
        self.scale=1.0;
        self.physicsBody.collisionType = @"ground";
    }
    return self;
}

+(id)createGround:(CGPoint)pos
{
    return [[self alloc] initWithGround:pos];
}


@end
