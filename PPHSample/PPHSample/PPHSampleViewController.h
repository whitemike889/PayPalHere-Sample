//
//  PPHSampleViewController.h
//  PPHSample
//
//  Created by palavilli on 7/25/12.
//  Copyright (c) 2012 X.commerce Developer Tools. 
//  Please see license.txt
//

#import <UIKit/UIKit.h>

@class Invoice;

@interface PPHSampleViewController : UIViewController <UITextFieldDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextField *PaymentTerms;
@property (weak, nonatomic) IBOutlet UITextField *DiscountPercentage;
@property (weak, nonatomic) IBOutlet UITextField *CurrencyCode;
@property (weak, nonatomic) IBOutlet UITextField *UniqueID;
@property (weak, nonatomic) IBOutlet UITextField *MerchantEmail;
@property (weak, nonatomic) IBOutlet UITextField *PayerEmail;
@property (weak, nonatomic) IBOutlet UILabel *itemCount;
@property (strong, nonatomic) Invoice *invoice;

- (IBAction)addItem:(id)sender;
- (IBAction)launchPayPalHere:(id)sender;

-(void)animateTextField:(UITextField*)textField up:(BOOL)up;
@end
