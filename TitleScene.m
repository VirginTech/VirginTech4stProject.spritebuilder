//
//  TitleScene.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/05.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "TitleScene.h"
#import "StageScene.h"
#import "GameManager.h"
#import "Information.h"

@implementation TitleScene

CGSize winSize;

+ (TitleScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //初期化
    [GameManager setPointCount:5];
    
    //初回時データ初期化
    [GameManager initialize_Save_Data];
    
    //インフォメーションレイヤー
    Information* infoLayer=[[Information alloc]init];
    [self addChild:infoLayer z:1];
    
    CCLabelTTF* titleLogo=[CCLabelTTF labelWithString:@"4st Project" fontName:@"Verdana-Bold" fontSize:30];
    titleLogo.position=ccp(winSize.width/2,winSize.height/2);
    [self addChild:titleLogo];
    
    CCButton* startBtn=[CCButton buttonWithTitle:@"[ プレイ ]" fontName:@"Verdana-Bold" fontSize:15];
    startBtn.position=ccp(winSize.width/2,winSize.height/2-50);
    [startBtn setTarget:self selector:@selector(onPlayClicked:)];
    [self addChild:startBtn];
    
    return self;
}

- (void)onPlayClicked:(id)sender
{
    [GameManager setStageLavel:1];
    [GameManager setScore:0];
    [[CCDirector sharedDirector] replaceScene:[StageScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
    
}

@end
