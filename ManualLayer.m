//
//  ManualLayer.m
//  VirginTech3rdProject
//
//  Created by VirginTech LLC. on 2015/01/19.
//  Copyright 2015年 VirginTech LLC. All rights reserved.
//

#import "ManualLayer.h"
#import "TitleScene.h"
//#import "SoundManager.h"
#import "GameManager.h"

#import "IAdLayer.h"
#import "IMobileLayer.h"

@implementation ManualLayer

CGSize winSize;
CCSprite* bgSpLayer;
CCScrollView* scrollView;

+ (ManualLayer *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    // Create a colored background (Dark Grey)
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.5f blue:0.3f alpha:1.0f]];
    [self addChild:background];

    if([GameManager getLocale]==1){//日本語なら
        //i-Mobile広告(フッター、アイコン)
        IMobileLayer* iMobileAd=[[IMobileLayer alloc]init:false];
        [self addChild:iMobileAd];
    }else{//それ以外
        //iAd広告
        IAdLayer* iAdLayer=[[IAdLayer alloc]init];
        [self addChild:iAdLayer];
    }

    //スクロール背景画像拡大
    int length;
    if([GameManager getDevice]==2){//iPhone4は2048pxが限界・・・。
        length=5;//1920px
    }else{//iPhone5以降なら4096pxまで可能
        length=5;//2880px
    }
    UIImage *image = [UIImage imageNamed:@"bgLayer.png"];
    UIGraphicsBeginImageContext(CGSizeMake(winSize.width * length,winSize.height));
    [image drawInRect:CGRectMake(0, 0, winSize.width * length,winSize.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //スクロールビュー配置
    bgSpLayer=[CCSprite spriteWithCGImage:image.CGImage key:nil];
    scrollView=[[CCScrollView alloc]initWithContentNode:bgSpLayer];
    scrollView.verticalScrollEnabled=NO;
    [self addChild:scrollView];
    
    for(int i=0;i<length;i++)
    {
        /*/背景
        CCSprite* bg=[CCSprite spriteWithImageNamed:@"itemLayer.png"];
        bg.scale=0.6;
        bg.position=ccp(winSize.width/2*(((i+1)*2)-1),winSize.height/2);
        [bgSpLayer addChild:bg z:0];*/
        
        //ページ
        CCSprite* page;
        if([GameManager getLocale]==1){//日本
            page=[CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"manual_%02d.png",i+1]];
        }else{
            page=[CCSprite spriteWithImageNamed:[NSString stringWithFormat:@"manual_en_%02d.png",i+1]];
        }
        page.scale=0.6;
        page.position=ccp(winSize.width/2*(((i+1)*2)-1),winSize.height/2);
        [bgSpLayer addChild:page z:1];
    }
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"option_default.plist"];
    
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
        
    return self;
}

- (void)onTitleClicked:(id)sender
{
    //[SoundManager click_Effect];
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
    //インターステイシャル広告表示
    [ImobileSdkAds showBySpotID:@"457103"];
}

@end
