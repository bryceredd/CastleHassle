//
//  PurchaseManager.m
//  Rev5
//
//  Created by Bryce Redd on 5/28/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "PurchaseManager.h"

@implementation PurchaseManager

@synthesize delegate=_delegate, selector;

static PurchaseManager* _instance = nil;

+(PurchaseManager*) instance {
	if(_instance) { return _instance; }
	
	return _instance = [[self alloc] init];
}

-(void) purchaseMultiplayer {
	/// VALIDATE WITH ITUNES ///
	SKPayment *payment = [SKPayment paymentWithProductIdentifier:MULTIPLAYER_IDENTIFIER];
	[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
	[[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc]  
						  initWithTitle:@"iTunes did not validate. Multiplayer not purchased."  
						  message:nil  
						  delegate:self  
						  cancelButtonTitle:nil  
						  otherButtonTitles:@"OK", nil]; 
	[alert show];
	[alert release];
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
	for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    }
}

- (void)completeTransaction: (SKPaymentTransaction *)transaction {
	
	// save multiplayer as 1
	[self.delegate performSelector:selector];
	
	// Remove the transaction from the payment queue.
	[[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	
}

- (void)restoreTransaction: (SKPaymentTransaction *)transaction {	
	
	// save multiplayer as 1
	[self.delegate performSelector:selector];
	
	// Remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)failedTransaction: (SKPaymentTransaction *)transaction {
	    if (transaction.error.code != SKErrorPaymentCancelled) {
        
		UIAlertView *alert = [[UIAlertView alloc]  
							  initWithTitle:@"iTunes did not validate. Multiplayer not purchased."  
							  message:nil  
							  delegate:self  
							  cancelButtonTitle:nil  
							  otherButtonTitles:@"OK", nil]; 
		[alert show];
		[alert release];
    }
	
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
	
}

- (void)startTransaction:(SKProduct *)prod {
	
}


@end
