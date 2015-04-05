//
//  StageScene.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/05.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "StageScene.h"
#import "TitleScene.h"

@implementation StageScene

CGSize winSize;

+ (StageScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    CCButton* titleBtn=[CCButton buttonWithTitle:@"[タイトル]"];
    titleBtn.position=ccp(winSize.width-titleBtn.contentSize.width/2,winSize.height-titleBtn.contentSize.height/2);
    [titleBtn setTarget:self selector:@selector(onTitltClicked:)];
    [self addChild:titleBtn];
    
    return self;
}

- (void)dealloc
{
    // clean up code goes here
}

-(void)onEnter
{
    [super onEnter];
}

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

- (void)onTitltClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
    
}

@end
