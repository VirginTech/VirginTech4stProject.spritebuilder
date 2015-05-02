//
//  Pin.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/07.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "Windmill.h"


@implementation Windmill

@synthesize axis;

-(id)initWithPin:(CGPoint)pos
{
    if(self=[super init]){

        int i=arc4random()%5+1;
        NSString* objName=[NSString stringWithFormat:@"Windmill_%02d",i];
        self=(id)[CCBReader load:objName];
        self.position=pos;
        self.scale=0.2;
        
        body.physicsBody.collisionType = @"windmill";
    }
    return self;
}

+(id)createPin:(CGPoint)pos
{
    return [[self alloc] initWithPin:pos];
}

@end
