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

-(id)initWithWindmill:(CGPoint)pos titleFlg:(bool)titleFlg
{
    if(self=[super init]){

        int i=arc4random()%5+1;
        NSString* objName=[NSString stringWithFormat:@"Windmill_%02d",i];
        
        self=(id)[CCBReader load:objName];
        
        num=i;
        self.position=pos;
        self.scale=0.2;
        
        //タイトル画面だったら
        if(titleFlg){
            if(num%2==0){
                self.scale=0.10;
            }else{
                self.scale=0.07;
            }
            
            [self schedule:@selector(rotation_Schedule:) interval:0.01];
        }
        
        body.physicsBody.collisionType = @"cWindmill";
    }
    return self;
}

-(void)rotation_Schedule:(CCTime)dt
{
    if(num%2==0){
        self.rotation+=3.0;
    }else{
        self.rotation-=2.5;
    }
}

+(id)createWindmill:(CGPoint)pos titleFlg:(bool)titleFlg
{
    return [[self alloc] initWithWindmill:pos titleFlg:titleFlg];
}

@end
