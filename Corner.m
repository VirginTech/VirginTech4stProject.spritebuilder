//
//  Corner.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/07.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "Corner.h"


@implementation Corner

-(id)initWithCorner:(CGPoint)pos
{
    self=(id)[CCBReader load:@"Corner"];
    self.position=pos;
    self.scale=1.0;
    
    return self;
}

+(id)createCorner:(CGPoint)pos
{
    return [[self alloc] initWithCorner:pos];
}

@end
