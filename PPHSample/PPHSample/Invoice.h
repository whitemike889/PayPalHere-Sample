//
//  Invoice.h
//  PPHSample
//
//  Created by Praveen Alavilli on 7/28/12.
//  Copyright X.commerce Developer Tools. 
//  Please see license.txt
//

#import <Foundation/Foundation.h>

//
//  Invoice object to store invoice data
//  for more information about the Invoice object, please refer to
//  https://cms.paypal.com/us/cgi-bin/?cmd=_render-content&content_ID=developer/e_howto_api_CreateInvoice
// 
@interface Invoice : NSObject

@property (nonatomic, copy) NSString *paymentTerms;
@property (nonatomic, copy) NSString *discountPercentage;
@property (nonatomic, copy) NSString *currencyCode;
@property (nonatomic, copy) NSString *uniqueID;
@property (nonatomic, copy) NSString *merchantEmail;
@property (nonatomic, copy) NSString *payerEmail; // payerEmail is optional, PayPal Here app will fill the value
@property (nonatomic, copy) NSMutableArray *itemList;

- (NSInteger) countOfList;
- (Invoice *)objectInListAtIndex:(NSInteger)theIndex;
- (void)addItemWithName:(NSString *)itemName description:(NSString *)description taxRate:(NSString *)taxRate unitPrice:(NSString *)unitPrice taxName:(NSString *)taxName quantity:(NSString *)quantity;
- (NSDictionary *)toDictionary;
@end
