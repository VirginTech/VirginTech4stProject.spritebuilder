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
    int row1;
    int row2;
    int col;
    
    if([GameManager getDevice]==3){//iPad
        sPoint=ccp(5.0,winSize.height*0.90);
        col=7;
        row1=5;
        row2=6;
    }else if([GameManager getDevice]==2){//iPhone4
        sPoint=ccp(-10.0,winSize.height*0.90);
        col=7;
        row1=4;
        row2=5;
    }else{
        sPoint=ccp(-10.0,winSize.height*0.90);
        col=8;
        row1=4;
        row2=5;
    }
    
    for(int i=0;i<col;i++)
    {
        yOff=yOff-40;
        if(i%2==0){
            xOff=25;
            row=row1;
        }else{
            xOff=0;
            row=row2;
        }
        for(int j=0;j<row;j++)
        {
            xOff=xOff+50;
            pos=ccp(sPoint.x+xOff,sPoint.y+yOff);
            value=[NSValue valueWithCGPoint:pos];
            [pinArray addObject:value];
        }
    }
    
    return pinArray;
}

@end
