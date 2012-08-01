//
//  AddItemViewController.m
//  PPHSample
//
//  Created by palavilli on 7/25/12.
//  Copyright (c) 2012 X.commerce Developer Tools. 
//  Please see license.txt
//

#import "AddItemViewController.h"

@interface AddItemViewController () 

@end

@implementation AddItemViewController
@synthesize name;
@synthesize description;
@synthesize unitPrice;
@synthesize taxName;
@synthesize taxRate;
@synthesize quantity;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setName:nil];
    [self setDescription:nil];
    [self setUnitPrice:nil];
    [self setTaxName:nil];
    [self setTaxRate:nil];
    [self setQuantity:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.name ||
        theTextField == self.description ||
        theTextField == self.unitPrice ||
        theTextField == self.taxName ||
        theTextField == self.taxRate ||
        theTextField == self.quantity) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField 
{ 
    if(textField == self.taxRate || textField == self.quantity) {
        [self animateTextField:textField up:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.taxRate || textField == self.quantity) {
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

- (IBAction)add:(id)sender {
    [[self delegate] addItemViewControllerDidFinish:self name:self.name.text description:self.description.text taxRate:self.taxRate.text unitPrice:self.unitPrice.text taxName:self.taxName.text quantity:self.quantity.text];
}

- (IBAction)cancel:(id)sender {
    [[self delegate] addItemViewControllerDidCancel:self];
}
@end
