//
//  ViewController.h
//  lndtest
//
//  Created by Chris on 13/1/18.
//  Copyright © 2018 IndieSquare. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^messageBlock)(NSError* error, NSString*response);
@interface ViewController : UIViewController
typedef void (^completionBlock)(NSError* error);
 @property (nonatomic, weak) IBOutlet UITextField *tf;
 @property (nonatomic, weak) IBOutlet UITextField *pr;
@property (nonatomic, weak) IBOutlet UITextField *oc;
@end

