//
//  CreditScene.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/14.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "CreditScene.h"
#import "TitleScene.h"
#import "GameManager.h"
#import "SoundManager.h"

#import "ImobileSdkAds/ImobileSdkAds.h"

@implementation CreditScene

CGSize winSize;
CCSprite* bgSpLayer;
CCScrollView* scrollView;

+ (CreditScene *)scene
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
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.9f green:0.9f blue:1.0f alpha:1.0f]];
    [self addChild:background];
    
    //背景画像拡大
    UIImage *image = [UIImage imageNamed:@"bgLayer.png"];
    UIGraphicsBeginImageContext(CGSizeMake(winSize.width,800));
    [image drawInRect:CGRectMake(0, 0, winSize.width,800)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //スクロールビュー配置
    bgSpLayer=[CCSprite spriteWithCGImage:image.CGImage key:nil];
    scrollView=[[CCScrollView alloc]initWithContentNode:bgSpLayer];
    scrollView.horizontalScrollEnabled=NO;
    [self addChild:scrollView];

    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"option_default.plist"];
    
    /*/タイトルボタン
    CCButton *titleButton=[CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15];
    titleButton.position=ccp(winSize.width-titleButton.contentSize.width/2,winSize.height-titleButton.contentSize.height/2);
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleButton];*/
    
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
    
    //ロゴ
    CCSprite* logo=[CCSprite spriteWithImageNamed:@"virgintechLogo.png"];
    logo.position=ccp(winSize.width/2,600);
    logo.scale=0.5;
    [bgSpLayer addChild:logo];
    
    //開発者
    CCLabelTTF* label;
    
    label=[CCLabelTTF labelWithString:@"Developer" fontName:@"Verdana-Italic" fontSize:12];
    label.position=ccp(winSize.width/2,logo.position.y-150);
    label.fontColor=[CCColor blackColor];
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"OOTANI,Kenji" fontName:@"Verdana-Bold" fontSize:15];
    label.position=ccp(winSize.width/2,logo.position.y-170);
    label.fontColor=[CCColor blackColor];
    [bgSpLayer addChild:label];
    
    //マテリアル
    label=[CCLabelTTF labelWithString:@"Material by" fontName:@"Verdana-Italic" fontSize:12];
    label.position=ccp(winSize.width/2,logo.position.y-220);
    label.fontColor=[CCColor blackColor];
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"無料イラスト素材.com - www.無料イラスト素材.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,logo.position.y-250);
    label.fontColor=[CCColor blackColor];
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"やじるし素材天国 - yajidesign.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,logo.position.y-270);
    label.fontColor=[CCColor blackColor];
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"GATAG - free-illustrations.gatag.net" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,logo.position.y-290);
    label.fontColor=[CCColor blackColor];
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"いらすとや - www.irasutoya.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,logo.position.y-310);
    label.fontColor=[CCColor blackColor];
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"PremiumPixels - www.premiumpixels.com" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,logo.position.y-330);
    label.fontColor=[CCColor blackColor];
    [bgSpLayer addChild:label];
    
    //サウンド
    label=[CCLabelTTF labelWithString:@"Sound by" fontName:@"Verdana-Italic" fontSize:12];
    label.position=ccp(winSize.width/2,logo.position.y-380);
    label.fontColor=[CCColor blackColor];
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"くらげ工匠 - www.kurage-kosho.info" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,logo.position.y-410);
    label.fontColor=[CCColor blackColor];
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"効果音ラボ - soundeffect-lab.info" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,logo.position.y-430);
    label.fontColor=[CCColor blackColor];
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"SoundLabel - www.snd-jpn.net" fontName:@"Verdana-Bold" fontSize:10];
    label.position=ccp(winSize.width/2,logo.position.y-450);
    label.fontColor=[CCColor blackColor];
    [bgSpLayer addChild:label];
    
    
    label=[CCLabelTTF labelWithString:@"Special Thanks! " fontName:@"Verdana-Italic" fontSize:20];
    label.position=ccp(winSize.width/2,logo.position.y-500);
    label.fontColor=[CCColor blackColor];
    [bgSpLayer addChild:label];
    
    label=[CCLabelTTF labelWithString:@"ありがとう! " fontName:@"Verdana-Italic" fontSize:20];
    label.position=ccp(winSize.width/2,logo.position.y-530);
    label.fontColor=[CCColor blackColor];
    [bgSpLayer addChild:label];

    
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
