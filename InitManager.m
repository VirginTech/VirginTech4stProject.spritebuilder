//
//  InitManager.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/07.
//  Copyright (c) 2015年 Apportable. All rights reserved.
//

#import "InitManager.h"
#import "GameManager.h"

@implementation InitManager

CGSize winSize;

+(NSMutableArray*)init_Pin_Pattern:(int)stageNum
{
    winSize=[[CCDirector sharedDirector]viewSize];
    
    NSMutableArray* pinArray=[[NSMutableArray alloc]init];
    CGPoint pos;
    NSValue* value;
    CGPoint sPoint;
    int xOff=0;
    int yOff=0;
    int row;
    
    if([GameManager getDevice]==3){//iPad
        sPoint=ccp(25.0,winSize.height*0.90);
    }else{
        sPoint=ccp(0.0,winSize.height*0.90);
    }
    
    for(int i=0;i<8;i++)
    {
        yOff=yOff-40;
        if(i%2==0){
            xOff=20;
            row=5;
        }else{
            xOff=0;
            row=6;
        }
        for(int j=0;j<row;j++)
        {
            xOff=xOff+40;
            pos=ccp(sPoint.x+xOff,sPoint.y+yOff);
            value=[NSValue valueWithCGPoint:pos];
            [pinArray addObject:value];
        }
    }
    
    return pinArray;
}

@end
