//
//  Basket.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/08.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "Basket.h"


@implementation Basket

-(id)initWithBasket:(CGPoint)pos
{
    if(self=[super init]){

        self=(id)[CCBReader load:@"Basket"];
        self.position=pos;
        self.scale=1.0;
        
        catch_point.physicsBody.collisionType=@"catch_point";
        catch_point.physicsBody.sensor = TRUE;
    }
    return self;
}

+(id)createBasket:(CGPoint)pos
{
    return [[self alloc] initWithBasket:pos];
}

-(void)tire_Rotation:(float)angle
{
    tire1.rotation=tire1.rotation+angle;
    tire2.rotation=tire2.rotation+angle;
}

@end
