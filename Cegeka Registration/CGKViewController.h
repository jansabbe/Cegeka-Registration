//
//  CGKViewController.h
//  Cegeka Registration
//
//  Created by Jan Sabbe on 11/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGKCountryTableViewController.h"


@interface CGKViewController : UIViewController <
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    CGKCountrySelectedDelegate,
    UITextFieldDelegate>


@end