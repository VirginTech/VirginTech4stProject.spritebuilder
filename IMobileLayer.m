//
//  IMobileLayer.m
//  VirginTechFirstProject
//
//  Created by VirginTech LLC. on 2014/08/22.
//  Copyright 2014年 VirginTech LLC. All rights reserved.
//

#import "IMobileLayer.h"
#import "GameManager.h"

@implementation IMobileLayer

CGSize winSize;

+ (IMobileLayer*)scene
{
    return [[self alloc] init];
}

- (id)init:(bool)iconFlg
{
    self = [super init];
    if (!self) return(nil);
    
    winSize=[[CCDirector sharedDirector]viewSize];
    
#if DEBUG
    [ImobileSdkAds setTestMode:YES];//テストモード
#else
    [ImobileSdkAds setTestMode:NO];
#endif
    
    //=================
    //フッターバナー
    //=================
    if([GameManager getDevice]==1)//iPad
    {
        [ImobileSdkAds registerWithPublisherID:@"31967" MediaID:@"170328" SpotID:@"457125"];
        [ImobileSdkAds startBySpotID:@"457125"];
        
        adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 728, 90)];
        adView.frame=CGRectOffset(adView.frame, 20,winSize.height*2);
        
        [[[CCDirector sharedDirector]view]addSubview:adView];
        
        [ImobileSdkAds setSpotDelegate:@"457125" delegate:self];
        [ImobileSdkAds showBySpotID:@"457125" View:adView];
    }
    else//iPhone
    {
        [ImobileSdkAds registerWithPublisherID:@"31967" MediaID:@"170299" SpotID:@"457095"];
        [ImobileSdkAds startBySpotID:@"457095"];

        adView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        adView.frame=CGRectOffset(adView.frame, 0,winSize.height);

        [[[CCDirector sharedDirector]view]addSubview:adView];
        
        [ImobileSdkAds setSpotDelegate:@"457095" delegate:self];
        [ImobileSdkAds showBySpotID:@"457095" View:adView];
    }
    
    //=================
    //アイコン
    //=================
    if(iconFlg){
        if([GameManager getDevice]==1)//iPad
        {
            [ImobileSdkAds registerWithPublisherID:@"31967" MediaID:@"170299" SpotID:@"457108"];
            [ImobileSdkAds startBySpotID:@"457108"];
            
            ImobileSdkAdsIconParams *iconParams = [[ImobileSdkAdsIconParams alloc] init];
            iconParams.iconNumber = 2;
            iconParams.iconSize = 80;
            iconParams.iconViewLayoutWidth = winSize.width*2+1200;
            iconParams.iconTitleEnable = YES;
            iconParams.iconTitleFontSize = 10;
            iconParams.iconTitleOffset = 4;
            iconParams.iconTitleFontColor = @"#ffffff";
            iconParams.iconTitleShadowEnable = YES;
            
            [ImobileSdkAds startBySpotID:@"457108"];
            
            viewCon=[[UIViewController alloc]init];
            [[[CCDirector sharedDirector]view]addSubview:viewCon.view];
            
            [ImobileSdkAds showBySpotID:@"457108" ViewController:viewCon
                        Position:CGPointMake(-600,(winSize.height*2)/2-100) IconPrams:iconParams];
        }
        else
        {
            [ImobileSdkAds registerWithPublisherID:@"31967" MediaID:@"170299" SpotID:@"457108"];
            [ImobileSdkAds startBySpotID:@"457108"];
            
            ImobileSdkAdsIconParams *iconParams = [[ImobileSdkAdsIconParams alloc] init];
            iconParams.iconNumber = 2;
            iconParams.iconSize = 47;
            iconParams.iconViewLayoutWidth = winSize.width+450;
            iconParams.iconTitleEnable = YES;
            iconParams.iconTitleFontSize = 8;
            iconParams.iconTitleOffset = 1;
            iconParams.iconTitleFontColor = @"#ffffff";
            iconParams.iconTitleShadowEnable = YES;
            
            [ImobileSdkAds startBySpotID:@"457108"];
            
            viewCon=[[UIViewController alloc]init];
            [[[CCDirector sharedDirector]view]addSubview:viewCon.view];

            [ImobileSdkAds showBySpotID:@"457108" ViewController:viewCon
                    Position:CGPointMake(-225,winSize.height/2-50) IconPrams:iconParams];
        }
    }
    
    adViewFlg=false;
    
    return self;
}

- (void) dealloc
{
    if([GameManager getDevice]==1){//iPad
        [ImobileSdkAds setSpotDelegate:@"457125" delegate:nil];
    }else{
        [ImobileSdkAds setSpotDelegate:@"457095" delegate:nil];
    }
    [adView removeFromSuperview];
    adView=nil;
    
    [viewCon.view removeFromSuperview];
    viewCon.view=nil;
}

-(void)removeLayer
{
    if([GameManager getDevice]==1){//iPad
        [ImobileSdkAds setSpotDelegate:@"457125" delegate:nil];
    }else{
        [ImobileSdkAds setSpotDelegate:@"457095" delegate:nil];
    }
    [adView removeFromSuperview];
    adView=nil;

    [viewCon.view removeFromSuperview];
    viewCon.view=nil;
}

//広告の表示が準備完了した際に呼ばれます
- (void)imobileSdkAdsSpot:(NSString *)spotId didReadyWithValue:(ImobileSdkAdsReadyResult)value
{
    /*[UIView animateWithDuration:0.3 animations:^
    {
        adView.frame=CGRectOffset(adView.frame, 0,-adView.frame.size.height);
    }];*/
}

//広告の取得を失敗した際に呼ばれます
- (void)imobileSdkAdsSpot:(NSString *)spotId didFailWithValue:(ImobileSdkAdsFailResult)value
{
    //NSLog(@"ERROR=%u",value);
}

//広告の表示要求があった際に、準備が完了していない場合に呼ばれます
- (void)imobileSdkAdsSpotIsNotReady:(NSString *)spotId{};

//広告クリックした際に呼ばれます
- (void)imobileSdkAdsSpotDidClick:(NSString *)spotId{};

//広告を閉じた際に呼ばれます(広告の表示がスキップされた場合も呼ばれます)
- (void)imobileSdkAdsSpotDidClose:(NSString *)spotId{};

//広告の表示が完了した際に呼ばれます
- (void)imobileSdkAdsSpotDidShow:(NSString *)spotId
{
    if(!adViewFlg)
    {
        [UIView animateWithDuration:0.3 animations:^
        {
            adView.frame=CGRectOffset(adView.frame, 0,-adView.frame.size.height);
        }];
        adViewFlg=true;
    }
}

@end
