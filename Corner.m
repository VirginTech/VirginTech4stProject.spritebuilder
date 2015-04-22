//
//  Corner.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/07.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "Corner.h"


@implementation Corner

-(id)initWithCorner:(CGPoint)pos type:(int)type
{
    if(self=[super init]){

        if(type==0){
            self=(id)[CCBReader load:@"Corner_r"];
        }else{
            self=(id)[CCBReader load:@"Corner_l"];
        }
        self.position=pos;
        self.scale=1.0;
    }
    return self;
}

+(id)createCorner:(CGPoint)pos type:(int)type
{
    return [[self alloc] initWithCorner:pos type:type];
}

@end
