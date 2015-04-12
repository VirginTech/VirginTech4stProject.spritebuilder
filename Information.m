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

CCSprite* star;
NSMutableArray* starArray;

CCLabelTTF* scoreLabel;
CCLabelTTF* highscoreLabel;


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
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"info_default.plist"];
    
    //スコアラベル
    scoreLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score:%05d",
                                    [GameManager getScore]] fontName:@"Verdana-Bold" fontSize:15];
    scoreLabel.position=ccp(scoreLabel.contentSize.width/2,winSize.height-scoreLabel.contentSize.height/2);
    [self addChild:scoreLabel];
    
    //ハイスコアラベル
    highscoreLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"HighScore:%05ld",
                                    [GameManager load_High_Score]] fontName:@"Verdana-Bold" fontSize:15];
    highscoreLabel.position=ccp(winSize.width-highscoreLabel.contentSize.width/2,
                                                        winSize.height-highscoreLabel.contentSize.height/2);
    [self addChild:highscoreLabel];

    //持ち点スター
    starArray=[[NSMutableArray alloc]init];
    for(int i=0;i<5;i++){
        star=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"star_B.png"]];
        star.scale=0.15;
        star.position=ccp(10+i*20,scoreLabel.position.y-scoreLabel.contentSize.height/2-(star.contentSize.height*star.scale)/2);
        [self addChild:star];
    }
    for(int i=0;i<[GameManager getPointCount];i++){
        star=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"star_G.png"]];
        star.scale=0.15;
        star.position=ccp(10+i*20,scoreLabel.position.y-scoreLabel.contentSize.height/2-(star.contentSize.height*star.scale)/2);
        [self addChild:star];
        [starArray addObject:star];
    }
    
    return self;
}

+(void)pointCountUpdata
{
    int i=0;
    for(CCSprite* _star in starArray){
        if(i<[GameManager getPointCount]){
            _star.visible=true;
        }else{
            _star.visible=false;
        }
        i++;
    }
}

+(void)scoreUpdata
{
    scoreLabel.string=[NSString stringWithFormat:@"Score:%05d",[GameManager getScore]];
}

+(void)highScoreUpdata
{
    highscoreLabel.string=[NSString stringWithFormat:@"HighScore:%05ld",[GameManager load_High_Score]];
}

- (void)dealloc
{
    // clean up code goes here
}

@end