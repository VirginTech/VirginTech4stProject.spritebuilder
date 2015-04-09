//
//  Wall.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/07.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "Wall.h"


@implementation Wall

-(id)initWithWall:(CGPoint)pos
{
    if(self=[super init]){

        self=(id)[CCBReader load:@"Wall"];
        self.position=pos;
        self.scale=1.0;
    }
    return self;
}

+(id)createWall:(CGPoint)pos
{
    return [[self alloc] initWithWall:pos];
}

@end
