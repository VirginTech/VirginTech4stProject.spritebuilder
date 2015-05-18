//
//  EndingScene.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/05/18.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "EndingScene.h"
#import "TitleScene.h"
#import "GameManager.h"
#import "SoundManager.h"

#import "IAdLayer.h"
#import "IMobileLayer.h"
#import "ImobileSdkAds/ImobileSdkAds.h"

@implementation EndingScene

CGSize winSize;

+ (EndingScene *)scene
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
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f]];
    [self addChild:background];
    
    //Ad広告レイヤー
    if([GameManager getLocale]==1){//日本語なら
        //i-Mobile広告(フッター、アイコン)
        IMobileLayer* iMobileAd=[[IMobileLayer alloc]init:false];
        [self addChild:iMobileAd];
    }else{//それ以外
        //iAd広告
        IAdLayer* iAdLayer=[[IAdLayer alloc]init];
        [self addChild:iAdLayer];
    }
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"option_default.plist"];
    
    //タイトルボタン
    CCButton *titleButton;
    if([GameManager getLocale]==1){
        titleButton = [CCButton buttonWithTitle:@"" spriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"titleBtn.png"]];
    }else{
        titleButton = [CCButton buttonWithTitle:@"" spriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"titleBtn_en.png"]];
    }
    //titleButton.positionType = CCPositionTypeNormalized;
    titleButton.scale=0.6;
    titleButton.position = ccp(winSize.width-(titleButton.contentSize.width*titleButton.scale)/2,
                               winSize.height-(titleButton.contentSize.height*titleButton.scale)/2);
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleButton];
    
    //エンディングメッセージ
    NSString* msg=NSLocalizedString(@"EndingMessage",NULL);
    CCLabelTTF* msgLabel=[CCLabelTTF labelWithString:msg fontName:@"Verdana-Bold" fontSize:10];
    msgLabel.position=ccp(winSize.width/2,winSize.height/2);
    msgLabel.fontColor=[CCColor blackColor];
    [self addChild:msgLabel];
    
    
    return self;
}

- (void)onTitleClicked:(id)sender
{
    //サウンドエフェクト
    [SoundManager btn_Click_Effect];
    
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
    //インターステイシャル広告表示
    [ImobileSdkAds showBySpotID:@"457103"];
    
}

@end
