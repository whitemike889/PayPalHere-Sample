//
//  PPHSampleViewController.m
//  PPHSample
//
//  Created by palavilli on 7/25/12.
//  Copyright (c) 2012 X.commerce Developer Tools. 
//  Please see license.txt
//

#import "PPHSampleViewController.h"
#import "AddItemViewController.h"
#import "Invoice.h"

@interface PPHSampleViewController ()<AddItemViewControllerDelegate> 
@end

@implementation PPHSampleViewController
@synthesize PaymentTerms = _PaymentTerms;
@synthesize DiscountPercentage = _DiscountPercentage;
@synthesize CurrencyCode = _CurrencyCode;
@synthesize UniqueID = _UniqueID;
@synthesize MerchantEmail = _MerchantEmail;
@synthesize PayerEmail = _PayerEmail;
@synthesize itemCount = _itemCount;
@synthesize invoice = _invoice;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // show the itemCount
    [self.itemCount setText:[NSString stringWithFormat:@"%d", [self.invoice countOfList]]];
    // set the current timestamp as the unique Invoice ID
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *timeStampObj = [NSNumber numberWithLong:timeStamp];
    [self.UniqueID setText:[timeStampObj stringValue]];
    // set your merchantEmail to prefil the View
    //[self.MerchantEmail setText:@"your-merchant-email"];
}

- (void)viewDidUnload
{
    [self setPaymentTerms:nil];
    [self setDiscountPercentage:nil];
    [self setCurrencyCode:nil];
    [self setUniqueID:nil];
    [self setMerchantEmail:nil];
    [self setPayerEmail:nil];
    [self setItemCount:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.PaymentTerms ||
        theTextField == self.DiscountPercentage ||
        theTextField == self.UniqueID ||
        theTextField == self.MerchantEmail ||
        theTextField == self.PayerEmail ||
        theTextField == self.CurrencyCode) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField 
{ 
    if(textField == self.MerchantEmail || textField == self.PayerEmail) {
        [self animateTextField:textField up:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.MerchantEmail || textField == self.PayerEmail) {
        [self animateTextField:textField up:NO];
    }
}

-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -130; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? movementDistance : -movementDistance); 
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (IBAction)addItem:(id)sender {
    
    AddItemViewController *addItemController = [[AddItemViewController alloc] initWithNibName:@"AddItemViewController" bundle:[NSBundle mainBundle]];
    addItemController.delegate = self;
    self.view.userInteractionEnabled = NO;
    [self presentViewController:addItemController animated:YES completion: nil];
}

- (IBAction)launchPayPalHere:(id)sender {
    
    [self.invoice setPaymentTerms:self.PaymentTerms.text];
    [self.invoice setDiscountPercentage:self.DiscountPercentage.text];
    [self.invoice setCurrencyCode:self.CurrencyCode.text];
    [self.invoice setUniqueID:self.UniqueID.text];
    [self.invoice setMerchantEmail:self.MerchantEmail.text];
    [self.invoice setPayerEmail:self.PayerEmail.text];
    NSLog(@"Invoice Contents: %@", self.invoice.merchantEmail);
    // check if PayPal Here app is installed
	NSURL * pphUrlBaseString = [NSURL URLWithString:@"paypalhere://takePayment"];
	// Check if PayPal Here app is installed
	if ([[UIApplication sharedApplication] canOpenURL:pphUrlBaseString]){
		// yey - PayPal Here app is available - let's build the launch url
        // convert the invoice into a json object
        NSError *e = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.invoice.toDictionary options:0 error:&e];
        NSString *jsonDataStr = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSLog(@"Invoice Object: %@",jsonDataStr);
        NSString *urlEncodedInvoiceObj = [self urlEncode:jsonDataStr];
        
        NSLog(@"URL Encoded Invoice: %@", urlEncodedInvoiceObj);
        // create your return url - this is how the PayPal Here app relaunches your app with payment status
        NSString *returnUrl = @"pphsample://handleReponse?{result}Type={Type}&InvoiceId={InvoiceId}&Tip={Tip}&Email={Email}&TxId={TxId}";
        NSString *urlEncodedReturnUrl = [self urlEncode:returnUrl];        
        // create accepted payment types
        NSString *acceptedPaymentTypes = @"cash,card,paypal";
        NSString *encodedAcceptedPaymentTypes = [self urlEncode:acceptedPaymentTypes]; 

        // assemble the required parameters to launch the PayPal Here app 
        NSString *pphUrlString = [NSString stringWithFormat: @"paypalhere://takePayment?accepted=%@&returnUrl=%@&invoice=%@&step=choosePayment", encodedAcceptedPaymentTypes, urlEncodedReturnUrl, urlEncodedInvoiceObj];
        NSLog(@"PayPal Here Launch URL: %@", pphUrlString);
        NSURL * pphLaunchUrl = [NSURL URLWithString:pphUrlString];
		[[UIApplication sharedApplication] openURL:pphLaunchUrl];
	} else {
        // PayPal Here not installed on this device
        UIActionSheet *sheet = [[UIActionSheet alloc] 
                                initWithTitle:@"PayPal Here app Not Found!"
                                delegate:self
                                cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:nil
                                otherButtonTitles:@"Install from AppStore", nil];
        
        [sheet showFromRect:self.view.bounds inView:self.view animated:YES];
    }
}

- (NSString *)urlEncode:(NSString *)rawStr {
    NSString *encodedStr = (NSString *)CFBridgingRelease(
                                                         CFURLCreateStringByAddingPercentEscapes(
                                                                                                 NULL,
                                                                                                 (__bridge CFStringRef)rawStr,
                                                                                                 NULL,
                                                                                                 (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                 kCFStringEncodingUTF8));
    return encodedStr;
}

- (void)actionSheet:(UIActionSheet *)actionSheet 
clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
	switch (buttonIndex) {
		case 0:
		{
            // launch app store to download: http://itunes.apple.com/us/app/paypal-here/id505911015
			NSLog(@"Sending user to PayPal Here page on Apple appstore");
            NSURL * pphAppStoreUrl = [NSURL URLWithString:@"http://itunes.apple.com/us/app/paypal-here/id505911015"];
            [[UIApplication sharedApplication] openURL:pphAppStoreUrl];
			break;
		}
	}
}

- (void)addItemViewControllerDidCancel:(AddItemViewController *)controller{
    self.view.userInteractionEnabled = YES;
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)addItemViewControllerDidFinish:(AddItemViewController *)controller name:(NSString *)name description:(NSString *)description taxRate:(NSString *)taxRate unitPrice:(NSString *)unitPrice taxName:(NSString *)taxName quantity:(NSString *)quantity {
    if([name length]) {
        [self.invoice addItemWithName:name description:description taxRate:taxRate unitPrice:unitPrice taxName:taxName quantity:quantity];
        NSLog(@"# of items in ItemList: %d", [self.invoice countOfList]);
        [self.itemCount setText:[NSString stringWithFormat:@"%d", [self.invoice countOfList]]];
    }
    self.view.userInteractionEnabled = YES;
    [self dismissModalViewControllerAnimated:YES];
}
@end
