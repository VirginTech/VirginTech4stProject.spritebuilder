//
//  ShopScene.h
//  VirginTech4stProject
//
//  Created by VirginTech LLC. on 2015/04/14.
//  Copyright 2015年 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <StoreKit/StoreKit.h>
#import "PaymentManager.h"

@interface ShopScene : CCScene <SKProductsRequestDelegate>
{
    UIActivityIndicatorView* indicator;
}

+ (ShopScene *)scene;
- (id)init;

+(void)ticket_Update;

@end
