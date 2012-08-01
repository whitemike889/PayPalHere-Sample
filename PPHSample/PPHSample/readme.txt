Files to look for code:

PPHSampleAppDelegate.m : contains the "handleOpenURL" method to handle the response back from the PayPal Here app after a payment (success/failed/cancelation)
PPHSampleViewController.h/m: main view controllers for the sample view to handle the invoice input and respond to button clicks.
    - addItem: method adds a newly create Item object to the item list
    - launchPayPalHere: method converts the Invoice object into a json string, constructs the PayPal Here App launch url and invokes it.
Item.h/m & Invoice.h/m: implementations for Invoice and Item objects. Note the toDictionary: method that converts the native objects into Dictionaries that can be converted to JSON using NSJSONSerialization package.