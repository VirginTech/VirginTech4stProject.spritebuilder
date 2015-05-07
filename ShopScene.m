//
//  ShopScene.m
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/14.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import "ShopScene.h"
#import "TitleScene.h"
#import "GameManager.h"

@implementation ShopScene

CGSize winSize;

CCLabelBMFont* ticketLabel;

SKProductsRequest *productsRequest;
PaymentManager* paymane;

SKProduct* product01;
SKProduct* product02;
SKProduct* product03;
SKProduct* product04;
SKProduct* product05;

+ (ShopScene *)scene
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
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.7f green:0.2f blue:0.2f alpha:1.0f]];
    [self addChild:background];
    
    //初期化
    paymane = [[PaymentManager alloc]init];
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"shop_default.plist"];
    
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
    
    //コンティニューチケット
    CCSprite* ticket=[CCSprite spriteWithSpriteFrame:
                      [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket.png"]];
    ticket.scale=0.3;
    ticket.position=ccp((ticket.contentSize.width*ticket.scale)/2 +5,
                                    winSize.height-(ticket.contentSize.height*ticket.scale)/2 -5);
    [self addChild:ticket];
    
    //コンティニューチケット枚数
    ticketLabel=[CCLabelBMFont labelWithString:
                 [NSString stringWithFormat:@"×%03d",[GameManager load_Continue_Ticket]] fntFile:@"score.fnt"];
    ticketLabel.scale=0.6;
    ticketLabel.position=ccp(ticket.position.x+(ticket.contentSize.width*ticket.scale)/2+(ticketLabel.contentSize.width*ticketLabel.scale)/2,ticket.position.y);
    [self addChild:ticketLabel];
    
    //インジケータ
    if([indicator isAnimating]==false)
    {
        indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [[[CCDirector sharedDirector] view] addSubview:indicator];
        if([GameManager getDevice]==1){//iPad
            indicator.center = ccp(winSize.width, winSize.height);
        }else{
            indicator.center = ccp(winSize.width/2, winSize.height/2);
        }
        [indicator startAnimating];
    }
    
    //アイテム情報の取得
    [self getItemInfo];
    
    return self;
}

-(void)getItemInfo
{
    NSSet *set = [NSSet setWithObjects:@"VirginTech4stProject_Ticket10",
                  @"VirginTech4stProject_Ticket20",
                  @"VirginTech4stProject_Ticket30",
                  @"VirginTech4stProject_Ticket50",
                  @"VirginTech4stProject_Ticket100",
                  nil];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    // 無効なアイテムがないかチェック
    if ([response.invalidProductIdentifiers count] > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error",NULL)
                                                        message:NSLocalizedString(@"ItemIdIsInvalid",NULL)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"Ok",NULL)
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    //アイテム情報の取得
    product01=[response.products objectAtIndex:0];// 10set
    product02=[response.products objectAtIndex:2];// 20set
    product03=[response.products objectAtIndex:3];// 30set
    product04=[response.products objectAtIndex:4];// 50set
    product05=[response.products objectAtIndex:1];// 100set
    
    //フレームのスケール取得
    float scale;
    if([GameManager getDevice]==1){  //iPad
        scale=0.55;
    }else if([GameManager getDevice]==2){  //iPhone4
        scale=0.55;
    }else{  //iPhone5,6
        scale=0.6;
    }

    //=================
    // チケット10セット
    //=================
    CCSprite* frame_Item_01=[CCSprite spriteWithSpriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"frame.png"]];
    frame_Item_01.scale=scale;
    frame_Item_01.position=ccp(winSize.width/2-(frame_Item_01.contentSize.width*frame_Item_01.scale)/2,
                               winSize.height/2+frame_Item_01.contentSize.height*frame_Item_01.scale);
    [self addChild:frame_Item_01];
    //画像
    CCSprite* item_01=[CCSprite spriteWithSpriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket10.png"]];
    item_01.scale=1.0;
    item_01.position=ccp(frame_Item_01.contentSize.width/2,frame_Item_01.contentSize.height/2-10);
    [frame_Item_01 addChild:item_01];
    //プロダクトネーム
    CCLabelTTF* lbl_Name_01=[CCLabelTTF labelWithString:
            [NSString stringWithFormat:@"【%@】",product01.localizedTitle]fontName:@"Verdana-Bold" fontSize:20];
    lbl_Name_01.position=ccp(frame_Item_01.contentSize.width/2,
                             frame_Item_01.contentSize.height-lbl_Name_01.contentSize.height-10);
    [frame_Item_01 addChild:lbl_Name_01];
    //説明
    CCLabelTTF* lbl_Descript_01=[CCLabelTTF labelWithString:product01.localizedDescription
                                                   fontName:@"Verdana-Bold" fontSize:12];
    lbl_Descript_01.position=ccp(frame_Item_01.contentSize.width/2,lbl_Name_01.position.y-30);
    [frame_Item_01 addChild:lbl_Descript_01];
    //購入ボタン
    CCButton* btn_Item_01=[CCButton buttonWithTitle:[NSString stringWithFormat:@"%@%@",
                    [product01.priceLocale objectForKey:NSLocaleCurrencySymbol],product01.price] spriteFrame:
                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    btn_Item_01.position=ccp(frame_Item_01.contentSize.width/2,btn_Item_01.contentSize.height/2+30);
    [btn_Item_01 setTarget:self selector:@selector(button01_Clicked:)];
    btn_Item_01.color=[CCColor whiteColor];
    [frame_Item_01 addChild:btn_Item_01];
    
    //=================
    // チケット20セット
    //=================
    CCSprite* frame_Item_02=[CCSprite spriteWithSpriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"frame.png"]];
    frame_Item_02.scale=scale;
    frame_Item_02.position=ccp(frame_Item_01.position.x+frame_Item_02.contentSize.width*frame_Item_02.scale,
                               frame_Item_01.position.y);
    [self addChild:frame_Item_02];
    //画像
    CCSprite* item_02=[CCSprite spriteWithSpriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket20.png"]];
    item_02.scale=1.5;
    item_02.position=ccp(frame_Item_02.contentSize.width/2,frame_Item_02.contentSize.height/2-10);
    [frame_Item_02 addChild:item_02];
    //プロダクトネーム
    CCLabelTTF* lbl_Name_02=[CCLabelTTF labelWithString:
                [NSString stringWithFormat:@"【%@】",product02.localizedTitle]fontName:@"Verdana-Bold" fontSize:20];
    lbl_Name_02.position=ccp(frame_Item_02.contentSize.width/2,
                             frame_Item_02.contentSize.height-lbl_Name_02.contentSize.height-10);
    [frame_Item_02 addChild:lbl_Name_02];
    //説明
    CCLabelTTF* lbl_Descript_02=[CCLabelTTF labelWithString:product02.localizedDescription
                                                   fontName:@"Verdana-Bold" fontSize:12];
    lbl_Descript_02.position=ccp(frame_Item_02.contentSize.width/2,lbl_Name_02.position.y-30);
    [frame_Item_02 addChild:lbl_Descript_02];
    //購入ボタン
    CCButton* btn_Item_02=[CCButton buttonWithTitle:[NSString stringWithFormat:@"%@%@",
                        [product02.priceLocale objectForKey:NSLocaleCurrencySymbol],product02.price] spriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    btn_Item_02.position=ccp(frame_Item_02.contentSize.width/2,btn_Item_02.contentSize.height/2+30);
    [btn_Item_02 setTarget:self selector:@selector(button02_Clicked:)];
    btn_Item_02.color=[CCColor whiteColor];
    [frame_Item_02 addChild:btn_Item_02];
    
    //=================
    // チケット30セット
    //=================
    CCSprite* frame_Item_03=[CCSprite spriteWithSpriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"frame.png"]];
    frame_Item_03.scale=scale;
    frame_Item_03.position=ccp(frame_Item_01.position.x,
                               frame_Item_01.position.y-frame_Item_03.contentSize.height*frame_Item_03.scale);
    [self addChild:frame_Item_03];
    //画像
    CCSprite* item_03=[CCSprite spriteWithSpriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket30.png"]];
    item_03.scale=1.5;
    item_03.position=ccp(frame_Item_03.contentSize.width/2,frame_Item_03.contentSize.height/2-10);
    [frame_Item_03 addChild:item_03];
    //プロダクトネーム
    CCLabelTTF* lbl_Name_03=[CCLabelTTF labelWithString:
                    [NSString stringWithFormat:@"【%@】",product03.localizedTitle]fontName:@"Verdana-Bold" fontSize:20];
    lbl_Name_03.position=ccp(frame_Item_03.contentSize.width/2,
                             frame_Item_03.contentSize.height-lbl_Name_03.contentSize.height-10);
    [frame_Item_03 addChild:lbl_Name_03];
    //説明
    CCLabelTTF* lbl_Descript_03=[CCLabelTTF labelWithString:product03.localizedDescription
                                                   fontName:@"Verdana-Bold" fontSize:12];
    lbl_Descript_03.position=ccp(frame_Item_03.contentSize.width/2,lbl_Name_03.position.y-30);
    [frame_Item_03 addChild:lbl_Descript_03];
    //購入ボタン
    CCButton* btn_Item_03=[CCButton buttonWithTitle:[NSString stringWithFormat:@"%@%@",
                        [product03.priceLocale objectForKey:NSLocaleCurrencySymbol],product03.price] spriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    btn_Item_03.position=ccp(frame_Item_03.contentSize.width/2,btn_Item_03.contentSize.height/2+30);
    [btn_Item_03 setTarget:self selector:@selector(button03_Clicked:)];
    btn_Item_03.color=[CCColor whiteColor];
    [frame_Item_03 addChild:btn_Item_03];
    
    //=================
    // チケット50セット
    //=================
    CCSprite* frame_Item_04=[CCSprite spriteWithSpriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"frame.png"]];
    frame_Item_04.scale=scale;
    frame_Item_04.position=ccp(frame_Item_02.position.x,frame_Item_03.position.y);
    [self addChild:frame_Item_04];
    //画像
    CCSprite* item_04=[CCSprite spriteWithSpriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket50.png"]];
    item_04.scale=1.5;
    item_04.position=ccp(frame_Item_04.contentSize.width/2,frame_Item_04.contentSize.height/2-10);
    [frame_Item_04 addChild:item_04];
    //プロダクトネーム
    CCLabelTTF* lbl_Name_04=[CCLabelTTF labelWithString:
                [NSString stringWithFormat:@"【%@】",product04.localizedTitle]fontName:@"Verdana-Bold" fontSize:20];
    lbl_Name_04.position=ccp(frame_Item_04.contentSize.width/2,
                             frame_Item_04.contentSize.height-lbl_Name_04.contentSize.height-10);
    [frame_Item_04 addChild:lbl_Name_04];
    //説明
    CCLabelTTF* lbl_Descript_04=[CCLabelTTF labelWithString:product04.localizedDescription
                                                   fontName:@"Verdana-Bold" fontSize:12];
    lbl_Descript_04.position=ccp(frame_Item_04.contentSize.width/2,lbl_Name_04.position.y-30);
    [frame_Item_04 addChild:lbl_Descript_04];
    //購入ボタン
    CCButton* btn_Item_04=[CCButton buttonWithTitle:[NSString stringWithFormat:@"%@%@",
                        [product04.priceLocale objectForKey:NSLocaleCurrencySymbol],product04.price] spriteFrame:
                        [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    btn_Item_04.position=ccp(frame_Item_04.contentSize.width/2,btn_Item_04.contentSize.height/2+30);
    [btn_Item_04 setTarget:self selector:@selector(button04_Clicked:)];
    btn_Item_04.color=[CCColor whiteColor];
    [frame_Item_04 addChild:btn_Item_04];
    
    //=================
    // チケット100セット
    //=================
    CCSprite* frame_Item_05=[CCSprite spriteWithSpriteFrame:
                             [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"frame.png"]];
    frame_Item_05.scale=scale;
    frame_Item_05.position=ccp(frame_Item_03.position.x,
                               frame_Item_04.position.y-frame_Item_05.contentSize.height*frame_Item_05.scale);
    [self addChild:frame_Item_05];
    //画像
    CCSprite* item_05=[CCSprite spriteWithSpriteFrame:
                       [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket100.png"]];
    item_05.scale=1.5;
    item_05.position=ccp(frame_Item_05.contentSize.width/2,frame_Item_05.contentSize.height/2-10);
    [frame_Item_05 addChild:item_05];
    //プロダクトネーム
    CCLabelTTF* lbl_Name_05=[CCLabelTTF labelWithString:
                [NSString stringWithFormat:@"【%@】",product05.localizedTitle]fontName:@"Verdana-Bold" fontSize:20];
    lbl_Name_05.position=ccp(frame_Item_05.contentSize.width/2,
                             frame_Item_05.contentSize.height-lbl_Name_05.contentSize.height-10);
    [frame_Item_05 addChild:lbl_Name_05];
    //説明
    CCLabelTTF* lbl_Descript_05=[CCLabelTTF labelWithString:product05.localizedDescription
                                                   fontName:@"Verdana-Bold" fontSize:12];
    lbl_Descript_05.position=ccp(frame_Item_05.contentSize.width/2,lbl_Name_05.position.y-30);
    [frame_Item_05 addChild:lbl_Descript_05];
    //購入ボタン
    CCButton* btn_Item_05=[CCButton buttonWithTitle:[NSString stringWithFormat:@"%@%@",
                    [product05.priceLocale objectForKey:NSLocaleCurrencySymbol],product05.price] spriteFrame:
                    [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    btn_Item_05.position=ccp(frame_Item_05.contentSize.width/2,btn_Item_05.contentSize.height/2+30);
    [btn_Item_05 setTarget:self selector:@selector(button05_Clicked:)];
    btn_Item_05.color=[CCColor whiteColor];
    [frame_Item_05 addChild:btn_Item_05];
    
    /*/チケットイメージ
    CCSprite* ticket01=[CCSprite spriteWithSpriteFrame:
                      [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket.png"]];
    ticket01.position=ccp(30, winSize.height -130);
    ticket01.scale=0.3;
    [self addChild:ticket01];
    
    CCSprite* ticket02=[CCSprite spriteWithSpriteFrame:
                      [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket.png"]];
    ticket02.position=ccp(ticket01.position.x, ticket01.position.y -40);
    ticket02.scale=0.3;
    [self addChild:ticket02];
    
    CCSprite* ticket03=[CCSprite spriteWithSpriteFrame:
                      [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket.png"]];
    ticket03.position=ccp(ticket01.position.x, ticket01.position.y -80);
    ticket03.scale=0.3;
    [self addChild:ticket03];
    
    CCSprite* ticket04=[CCSprite spriteWithSpriteFrame:
                      [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket.png"]];
    ticket04.position=ccp(ticket01.position.x, ticket01.position.y -120);
    ticket04.scale=0.3;
    [self addChild:ticket04];
    
    CCSprite* ticket05=[CCSprite spriteWithSpriteFrame:
                      [[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"ticket.png"]];
    ticket05.position=ccp(ticket01.position.x, ticket01.position.y -160);
    ticket05.scale=0.3;
    [self addChild:ticket05];
    
    //ラベル
    CCLabelTTF* label01=[CCLabelTTF labelWithString:product01.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    label01.position = ccp(ticket01.position.x+110, ticket01.position.y);
    [self addChild:label01];
    
    CCLabelTTF* label02=[CCLabelTTF labelWithString:product02.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    label02.position = ccp(ticket02.position.x+110, ticket02.position.y);
    [self addChild:label02];
    
    CCLabelTTF* label03=[CCLabelTTF labelWithString:product03.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    label03.position = ccp(ticket03.position.x+110, ticket03.position.y);
    [self addChild:label03];
    
    CCLabelTTF* label04=[CCLabelTTF labelWithString:product04.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    label04.position = ccp(ticket04.position.x+110, ticket04.position.y);
    [self addChild:label04];
    
    CCLabelTTF* label05=[CCLabelTTF labelWithString:product05.localizedTitle fontName:@"Verdana-Bold" fontSize:18.0f];
    label05.position = ccp(ticket05.position.x+110, ticket05.position.y);
    [self addChild:label05];
    
    //購入ボタン
    CCButton* button01=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    button01.position = ccp(label01.position.x+130, ticket01.position.y);
    [button01 setTarget:self selector:@selector(button01_Clicked:)];
    button01.scale=0.6;
    [self addChild:button01];
    CCLabelTTF* labelBtn01=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%@",[product01.priceLocale objectForKey:NSLocaleCurrencySymbol],product01.price] fontName:@"Verdana-Italic" fontSize:18.0f];
    labelBtn01.position=ccp(button01.contentSize.width/2,button01.contentSize.height/2);
    labelBtn01.color=[CCColor whiteColor];
    [button01 addChild:labelBtn01];
    
    CCButton* button02=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    button02.position = ccp(label02.position.x+130, ticket02.position.y);
    [button02 setTarget:self selector:@selector(button02_Clicked:)];
    button02.scale=0.6;
    [self addChild:button02];
    CCLabelTTF* labelBtn02=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%@",[product02.priceLocale objectForKey:NSLocaleCurrencySymbol],product02.price] fontName:@"Verdana-Italic" fontSize:18.0f];
    labelBtn02.position=ccp(button02.contentSize.width/2,button02.contentSize.height/2);
    labelBtn02.color=[CCColor whiteColor];
    [button02 addChild:labelBtn02];
    
    CCButton* button03=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    button03.position = ccp(label03.position.x+130, ticket03.position.y);
    [button03 setTarget:self selector:@selector(button03_Clicked:)];
    button03.scale=0.6;
    [self addChild:button03];
    CCLabelTTF* labelBtn03=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%@",[product03.priceLocale objectForKey:NSLocaleCurrencySymbol],product03.price] fontName:@"Verdana-Italic" fontSize:18.0f];
    labelBtn03.position=ccp(button03.contentSize.width/2,button03.contentSize.height/2);
    labelBtn03.color=[CCColor whiteColor];
    [button03 addChild:labelBtn03];
    
    CCButton* button04=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    button04.position = ccp(label04.position.x+130, ticket04.position.y);
    [button04 setTarget:self selector:@selector(button04_Clicked:)];
    button04.scale=0.6;
    [self addChild:button04];
    CCLabelTTF* labelBtn04=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%@",[product04.priceLocale objectForKey:NSLocaleCurrencySymbol],product04.price] fontName:@"Verdana-Italic" fontSize:18.0f];
    labelBtn04.position=ccp(button04.contentSize.width/2,button04.contentSize.height/2);
    labelBtn04.color=[CCColor whiteColor];
    [button04 addChild:labelBtn04];
    
    CCButton* button05=[CCButton buttonWithTitle:@"" spriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]spriteFrameByName:@"buyBtn.png"]];
    button05.position = ccp(label05.position.x+130, ticket05.position.y);
    [button05 setTarget:self selector:@selector(button05_Clicked:)];
    button05.scale=0.6;
    [self addChild:button05];
    CCLabelTTF* labelBtn05=[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%@%@",[product05.priceLocale objectForKey:NSLocaleCurrencySymbol],product05.price] fontName:@"Verdana-Italic" fontSize:18.0f];
    labelBtn05.position=ccp(button05.contentSize.width/2,button05.contentSize.height/2);
    labelBtn05.color=[CCColor whiteColor];
    [button05 addChild:labelBtn05];*/
    
    // インジケータを非表示にする
    if([indicator isAnimating])
    {
        [indicator stopAnimating];
        [indicator removeFromSuperview];
    }
}

- (void)button01_Clicked:(id)sender
{
    [paymane buyProduct:product01];
}
- (void)button02_Clicked:(id)sender
{
    [paymane buyProduct:product02];
}
- (void)button03_Clicked:(id)sender
{
    [paymane buyProduct:product03];
}
- (void)button04_Clicked:(id)sender
{
    [paymane buyProduct:product04];
}
- (void)button05_Clicked:(id)sender
{
    [paymane buyProduct:product05];
}

+(void)ticket_Update
{
    ticketLabel.string=[NSString stringWithFormat:@"×%03d",[GameManager load_Continue_Ticket]];
}

- (void)onTitleClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}


@end
