//
//  Piston.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/07.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "Piston.h"


@implementation Piston

-(id)initWithPiston:(CGPoint)pos
{
    if(self=[super init]){

        self=(id)[CCBReader load:@"Piston"];
        self.position=pos;
        self.scale=1.0;
    }
    return self;
}

+(id)createPiston:(CGPoint)pos
{
    return [[self alloc] initWithPiston:pos];
}

@end
