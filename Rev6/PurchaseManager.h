//
//  PurchaseManager.h
//  Rev5
//
//  Created by Bryce Redd on 5/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define MULTIPLAYER_IDENTIFIER @"com.poplobby.multiplayer"

@interface PurchaseManager : NSObject <SKRequestDelegate, SKPaymentTransactionObserver> {
	SEL selector;
	id _delegate;
}

@property(nonatomic, retain) id delegate;
@property(nonatomic) SEL selector;

+(PurchaseManager*) instance;

- (void)purchaseMultiplayer;
- (void)completeTransaction: (SKPaymentTransaction *)transaction;
- (void)restoreTransaction: (SKPaymentTransaction *)transaction;
- (void)failedTransaction: (SKPaymentTransaction *)transaction;

@end
