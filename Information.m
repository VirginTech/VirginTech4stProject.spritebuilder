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

CCLabelBMFont* scoreLabel;
CCLabelBMFont* highscoreLabel;

int totalScore;

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
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"info_default.plist"];
    
    //スコアラベル
    if([GameManager getPlayMode]==1){//スコアモードなら
        scoreLabel=[CCLabelBMFont labelWithString:
                    [NSString stringWithFormat:@"Score:%05d",[GameManager getScore]] fntFile:@"score.fnt"];
    }else{
        totalScore=[GameManager load_Total_Score:[GameManager getStageLevel]-1];//1つ前までのステージスコア
        scoreLabel=[CCLabelBMFont labelWithString:
                    [NSString stringWithFormat:@"Score:%05d",totalScore+[GameManager getScore]] fntFile:@"score.fnt"];
    }
    scoreLabel.scale=0.6;
    scoreLabel.position=ccp((scoreLabel.contentSize.width*scoreLabel.scale)/2,
                            winSize.height-(scoreLabel.contentSize.height*scoreLabel.scale)/2);
    [self addChild:scoreLabel];

    //ハイスコアラベル
    if([GameManager getPlayMode]==1){
        highscoreLabel=[CCLabelBMFont labelWithString:
            [NSString stringWithFormat:@"HighScore:%05d",[GameManager load_High_Score_1]] fntFile:@"score.fnt"];
    }else{
        highscoreLabel=[CCLabelBMFont labelWithString:
            [NSString stringWithFormat:@"HighScore:%05d",[GameManager load_High_Score_2]] fntFile:@"score.fnt"];
    }
    highscoreLabel.scale=0.6;
    highscoreLabel.position=ccp(winSize.width-(highscoreLabel.contentSize.width*highscoreLabel.scale)/2,
                                winSize.height-(highscoreLabel.contentSize.height*highscoreLabel.scale)/2);
    [self addChild:highscoreLabel];

    //持ち点スター
    starArray=[[NSMutableArray alloc]init];
    for(int i=0;i<5;i++){
        star=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"star_B.png"]];
        star.scale=0.3;
        star.position=ccp(10+i*16,scoreLabel.position.y-(scoreLabel.contentSize.height*scoreLabel.scale)/2-(star.contentSize.height*star.scale)/2);
        [self addChild:star];
    }
    for(int i=0;i<5;i++){
        star=[CCSprite spriteWithSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"star_G.png"]];
        star.scale=0.3;
        star.position=ccp(10+i*16,scoreLabel.position.y-(scoreLabel.contentSize.height*scoreLabel.scale)/2-(star.contentSize.height*star.scale)/2);
        [self addChild:star];
        [starArray addObject:star];
    }
    //持ち点更新
    [Information lifePointUpdata];
    
    return self;
}

+(void)lifePointUpdata
{
    int i=0;
    for(CCSprite* _star in starArray){
        if(i<[GameManager getLifePoint]){
            _star.visible=true;
        }else{
            _star.visible=false;
        }
        i++;
    }
}

+(void)scoreUpdata
{
    if([GameManager getPlayMode]==1){
        scoreLabel.string=[NSString stringWithFormat:@"Score:%05d",[GameManager getScore]];
    }else{
        scoreLabel.string=[NSString stringWithFormat:@"Score:%05d",totalScore+[GameManager getScore]];
    }
}

+(void)highScoreUpdata
{
    if([GameManager getPlayMode]==1){
        highscoreLabel.string=[NSString stringWithFormat:@"HighScore:%05d",[GameManager load_High_Score_1]];
    }else{
        highscoreLabel.string=[NSString stringWithFormat:@"HighScore:%05d",[GameManager load_High_Score_2]];
    }
}

- (void)dealloc
{
    // clean up code goes here
}

@end
