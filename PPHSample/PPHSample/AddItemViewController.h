//
//  AddItemViewController.h
//  PPHSample
//
//  Created by palavilli on 7/25/12.
//  Copyright (c) 2012 X.commerce Developer Tools. 
//  Please see license.txt
//

#import <UIKit/UIKit.h>

@protocol AddItemViewControllerDelegate;


@interface AddItemViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) id <AddItemViewControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *description;
@property (weak, nonatomic) IBOutlet UITextField *unitPrice;
@property (weak, nonatomic) IBOutlet UITextField *taxName;
@property (weak, nonatomic) IBOutlet UITextField *taxRate;
@property (weak, nonatomic) IBOutlet UITextField *quantity;
- (IBAction)add:(id)sender;
- (IBAction)cancel:(id)sender;
-(void)animateTextField:(UITextField*)textField up:(BOOL)up;

@end

@protocol AddItemViewControllerDelegate <NSObject>

- (void)addItemViewControllerDidCancel:(AddItemViewController *) controller;
- (void)addItemViewControllerDidFinish:(AddItemViewController *) controller name:(NSString *)name description:(NSString *)description taxRate:(NSString *)taxRate unitPrice:(NSString *)unitPrice taxName:(NSString *)taxName quantity:(NSString *)quantity;
@end