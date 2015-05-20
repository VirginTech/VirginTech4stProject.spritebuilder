//
//  PreferencesScene.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/14.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "PreferencesScene.h"
#import "TitleScene.h"
#import "GameManager.h"
#import "SoundManager.h"

#import "IAdLayer.h"
#import "IMobileLayer.h"

@implementation PreferencesScene

CGSize winSize;

CCSlider* bgmSlider;
CCSlider* effectSlider;
CCButton* onBgmSwitch;
CCButton* offBgmSwitch;
CCButton* onEffectSwitch;
CCButton* offEffectSwitch;

+ (PreferencesScene *)scene
{
    return [[self alloc] init];
}

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
    self.userInteractionEnabled = YES;
    
    //Create a colored background (Dark Grey)
    //CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.8f]];
    //[self addChild:background];
    
    /*/Ad広告レイヤー
    if([GameManager getLocale]==1){//日本語なら
        //i-Mobile広告(フッター、アイコン)
        IMobileLayer* iMobileAd=[[IMobileLayer alloc]init:false];
        [self addChild:iMobileAd];
    }else{//それ以外
        //iAd広告
        IAdLayer* iAdLayer=[[IAdLayer alloc]init];
        [self addChild:iAdLayer];
    }*/
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"config_default.plist"];
    
    /*/タイトルボタン
    CCButton *titleButton=[CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15];
    titleButton.position=ccp(winSize.width-titleButton.contentSize.width/2,winSize.height-titleButton.contentSize.height/2);
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleButton];*/
    
    //パネル
    CCSprite* panel=[CCSprite spriteWithSpriteFrame:
                     [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"msgBoard.png"]];
    panel.position=ccp(winSize.width/2,winSize.height/2);
    if([GameManager getDevice]==1){
        panel.scale=0.4;
    }else{
        panel.scale=0.3;
    }
    [self addChild:panel];
    
    //閉じるボタン
    CCButton *closeButton = [CCButton buttonWithTitle:@"" spriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"closeBtn.png"]];
    //titleButton.positionType = CCPositionTypeNormalized;
    closeButton.scale=0.8;
    closeButton.position = ccp(panel.contentSize.width +5,panel.contentSize.height +5);
    [closeButton setTarget:self selector:@selector(onCloseClicked:)];
    [panel addChild:closeButton];
    
    //=================
    //BGM音量
    //=================
    
    //BGMスイッチ
    onBgmSwitch=[CCButton buttonWithTitle:@""
                              spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"on.png"]];
    onBgmSwitch.position=ccp(200,panel.contentSize.height-70);
    onBgmSwitch.scale=(1/panel.scale)*0.5;
    [onBgmSwitch setTarget:self selector:@selector(bgmSwitchClicked:)];
    onBgmSwitch.name=@"1";
    
    offBgmSwitch=[CCButton buttonWithTitle:@""
                               spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"off.png"]];
    offBgmSwitch.position = onBgmSwitch.position;
    offBgmSwitch.scale=(1/panel.scale)*0.5;
    [offBgmSwitch setTarget:self selector:@selector(bgmSwitchClicked:)];
    offBgmSwitch.name=@"0";
    
    if([SoundManager getBgmSwitch]){
        onBgmSwitch.visible=true;
        offBgmSwitch.visible=false;
    }else{
        onBgmSwitch.visible=false;
        offBgmSwitch.visible=true;
    }
    
    [panel addChild:onBgmSwitch z:1];
    [panel addChild:offBgmSwitch z:1];
    
    //BGMラベル
    CCLabelTTF* bgmLabel=[CCLabelTTF labelWithString:NSLocalizedString(@"Bgm",NULL)
                                            fontName:@"Verdana-Bold" fontSize:30.0];
    bgmLabel.position=ccp(onBgmSwitch.position.x-(onBgmSwitch.contentSize.width*onBgmSwitch.scale)/2-bgmLabel.contentSize.width/2,onBgmSwitch.position.y);
    [panel addChild:bgmLabel];
    
    //BGM音量スライダー
    bgmSlider=[[CCSlider alloc]initWithBackground:
            [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"bgm_line.png"]
            andHandleImage:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"handle_bgm.png"]];
    bgmSlider.scale=(1/panel.scale)*0.5;
    bgmSlider.position=ccp(panel.contentSize.width/2-(bgmSlider.contentSize.width*bgmSlider.scale)/2,onBgmSwitch.position.y-80);
    [bgmSlider setSliderValue:[SoundManager getBgmVolume]];
    bgmSlider.name=@"BGM-Volume";
    bgmSlider.handle.scale=(1/bgmSlider.scale)*0.5;
    [panel addChild:bgmSlider];
    
    //=================
    //エフェクト音量
    //=================
    
    //Effectスイッチ
    onEffectSwitch=[CCButton buttonWithTitle:@""
                                 spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"on.png"]];
    onEffectSwitch.position=ccp(200,bgmSlider.position.y-70);
    onEffectSwitch.scale=(1/panel.scale)*0.5;
    [onEffectSwitch setTarget:self selector:@selector(effectSwitchClicked:)];
    onEffectSwitch.name=@"1";
    
    offEffectSwitch=[CCButton buttonWithTitle:@""
                                  spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"off.png"]];
    offEffectSwitch.position = onEffectSwitch.position;
    offEffectSwitch.scale=(1/panel.scale)*0.5;
    [offEffectSwitch setTarget:self selector:@selector(effectSwitchClicked:)];
    offEffectSwitch.name=@"0";
    
    if([SoundManager getEffectSwitch]){
        onEffectSwitch.visible=true;
        offEffectSwitch.visible=false;
    }else{
        onEffectSwitch.visible=false;
        offEffectSwitch.visible=true;
    }
    
    [panel addChild:onEffectSwitch z:1];
    [panel addChild:offEffectSwitch z:1];
    
    //Effectラベル
    CCLabelTTF* effectLabel=[CCLabelTTF labelWithString:NSLocalizedString(@"Effect",NULL)
                                               fontName:@"Verdana-Bold" fontSize:30.0];
    effectLabel.position=ccp(onEffectSwitch.position.x-(onEffectSwitch.contentSize.width*onEffectSwitch.scale)/2-effectLabel.contentSize.width/2,onEffectSwitch.position.y);
    [panel addChild:effectLabel];
    
    //エフェクト音量スライダー
    effectSlider=[[CCSlider alloc]initWithBackground:
                [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"effect_line.png"]
                andHandleImage:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"handle_effect.png"]];
    effectSlider.scale=(1/panel.scale)*0.5;
    effectSlider.position=ccp(panel.contentSize.width/2-(effectSlider.contentSize.width*effectSlider.scale)/2,onEffectSwitch.position.y-80);
    [effectSlider setSliderValue:[SoundManager getEffectVolume]];
    effectSlider.name=@"Effect-Volume";
    effectSlider.handle.scale=(1/effectSlider.scale)*0.5;
    [panel addChild:effectSlider];
    
    
    
    return self;
}

- (void)bgmSwitchClicked:(id)sender
{
    //NSLog(@"押された！");
    CCButton* button=(CCButton*)sender;
    if([button.name intValue]==0){//停止中〜開始
        onBgmSwitch.visible=true;
        offBgmSwitch.visible=false;
        [SoundManager setBgmSwitch:true];
        [SoundManager playBGM:@"bgm.mp3"];
    }else{
        onBgmSwitch.visible=false;
        offBgmSwitch.visible=true;
        [SoundManager setBgmSwitch:false];
        [SoundManager stopBGM];
    }
}

- (void)effectSwitchClicked:(id)sender
{
    CCButton* button=(CCButton*)sender;
    if([button.name intValue]==0){//停止中〜開始
        onEffectSwitch.visible=true;
        offEffectSwitch.visible=false;
        [SoundManager setEffectSwitch:true];
    }else{
        onEffectSwitch.visible=false;
        offEffectSwitch.visible=true;
        [SoundManager setEffectSwitch:false];
    }
}

- (void)onCloseClicked:(id)sender
{
    //サウンドエフェクト
    [SoundManager btn_Click_Effect];
    
    [self removeFromParentAndCleanup:YES];
    
    //[[CCDirector sharedDirector] replaceScene:[TitleScene scene]
    //                          withTransition:[CCTransition transitionCrossFadeWithDuration:0.5]];
    
    //インターステイシャル広告表示
    [ImobileSdkAds showBySpotID:@"457103"];
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
}

@end
