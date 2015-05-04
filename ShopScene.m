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
    CCNodeColor *background = [CCNodeColor nodeWithColor:[CCColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:0.8f]];
    [self addChild:background];
    
    //タイトルボタン
    CCButton *titleButton=[CCButton buttonWithTitle:@"[タイトル]" fontName:@"Verdana-Bold" fontSize:15];
    titleButton.position=ccp(winSize.width-titleButton.contentSize.width/2,winSize.height-titleButton.contentSize.height/2);
    [titleButton setTarget:self selector:@selector(onTitleClicked:)];
    [self addChild:titleButton];
    
    //初期化
    paymane = [[PaymentManager alloc]init];
    
    //画像読み込み
    [[CCSpriteFrameCache sharedSpriteFrameCache]removeSpriteFrames];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"shop_default.plist"];
    
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
    
    //チケットイメージ
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
    [button05 addChild:labelBtn05];
    
    
    
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
    ticketLabel.string=[NSString stringWithFormat:@" ×%03d",[GameManager load_Continue_Ticket]];
}

- (void)onTitleClicked:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[TitleScene scene]
                               withTransition:[CCTransition transitionCrossFadeWithDuration:1.0]];
}


@end
