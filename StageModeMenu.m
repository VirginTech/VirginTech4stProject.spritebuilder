//
//  StageModeMenu.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/27.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "StageModeMenu.h"
#import "TitleScene.h"
#import "GameManager.h"
#import "StageScene.h"
#import "Information.h"

@implementation StageModeMenu

CGSize winSize;

CCSprite* bgSpLayer;
CCScrollView* scrollView;

+ (StageModeMenu *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    //Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.3f green:0.8f blue:0.8f alpha:1.0f]];
    [self addChild:background];
    
    //インフォメーションレイヤー
    //Information* infoLayer=[[Information alloc]init];
    //[self addChild:infoLayer z:1];
    
    //ハイスコア表示
    CCLabelTTF* highscoreLabel=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"HighScore:%05d",
                                        [GameManager load_High_Score_2]] fontName:@"Verdana-Bold" fontSize:15];
    highscoreLabel.position=ccp(winSize.width-highscoreLabel.contentSize.width/2,
                                winSize.height-highscoreLabel.contentSize.height/2);
    [self addChild:highscoreLabel];
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"menu_default.plist"];

    //画面サイズ設定
    UIImage *image = [UIImage imageNamed:@"bgLayer.png"];
    UIGraphicsBeginImageContext(CGSizeMake(winSize.width * 5,winSize.height));
    [image drawInRect:CGRectMake(0, 0, winSize.width * 5,winSize.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //スクロールビュー配置 z:0
    bgSpLayer=[CCSprite spriteWithCGImage:image.CGImage key:nil];
    scrollView=[[CCScrollView alloc]initWithContentNode:bgSpLayer];
    scrollView.verticalScrollEnabled=NO;
    bgSpLayer.position=CGPointMake(0, 0);
    [self addChild:scrollView z:0];
    
    //タイトルボタン
    CCButton *titleButton=[CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15];
    titleButton.position=ccp(winSize.width/2,winSize.height-50);
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleButton];
    
    //セレクトレヴェルボタン
    int btnCnt=0;
    CGPoint btnNormPos;
    CGPoint btnPos;
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"menu_default.plist"];
    
    for(int i=0;i<5;i++)
    {
        btnNormPos=CGPointMake((i*winSize.width)+winSize.width*0.325, winSize.height*0.8);
        
        for(int j=0;j<5;j++)
        {
            btnPos.y=btnNormPos.y-(j*70);
            
            for(int k=0;k<3;k++)
            {
                btnCnt++;
                CCButton* selectBtn=[CCButton buttonWithTitle:@"" spriteFrame:
                                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"select_a.png"]];
                selectBtn.scale=0.3;
                btnPos.x=btnNormPos.x+(k*60);
                selectBtn.position=btnPos;
                selectBtn.name=[NSString stringWithFormat:@"%d",btnCnt];
                [selectBtn setTarget:self selector:@selector(onStageLevel:)];
                selectBtn.enabled=true;

                //ラベル
                CCLabelTTF* selectLbl=[CCLabelTTF labelWithString:
                                       [NSString stringWithFormat:@"%02d",btnCnt] fontName:@"Verdana-Bold" fontSize:60];
                selectLbl.position=ccp(selectBtn.contentSize.width/2,selectBtn.contentSize.height/2);
                [selectBtn addChild:selectLbl];
                
                [bgSpLayer addChild:selectBtn z:2];
            }
        }
    }

    return self;
}

- (void)onStageLevel:(id)sender
{
    CCButton* button=(CCButton*)sender;
    int stageNum=[[button name]intValue];
    
    [GameManager setPlayMode:2];
    [GameManager setStageLavel:stageNum];
    [GameManager setLifePoint:1];
    [[CCDirector sharedDirector] replaceScene:[StageScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
}

- (void)onTitleClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}

@end
