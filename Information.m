//
//  Infomation.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/09.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "Information.h"
#import "GameManager.h"

@implementation Information

CGSize winSize;

CCLabelTTF* failureLabel;

+ (Information *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    failureLabel=[CCLabelTTF labelWithString:@"失敗:00000" fontName:@"Verdana-Bold" fontSize:20];
    failureLabel.position=ccp(winSize.width/2,winSize.height-failureLabel.contentSize.height/2);
    [self addChild:failureLabel];
    
    return self;
}

+(void)failureLabelUpdata
{
    failureLabel.string=[NSString stringWithFormat:@"失敗:%05d",[GameManager getFailurePoint]];
}

- (void)dealloc
{
    // clean up code goes here
}

@end
