//
//  CGKCountryTableViewController.h
//  Cegeka Registration
//
//  Created by Jan Sabbe on 4/11/12.
//
//

#import <UIKit/UIKit.h>

@protocol CGKCountrySelectedDelegate;

@interface CGKCountryTableViewController : UITableViewController
@property id<CGKCountrySelectedDelegate> countrySelectionDelegate;
@end


@protocol CGKCountrySelectedDelegate<NSObject>
@required
- (void) countryController:(CGKCountryTableViewController*) controller didSelectCountry:(NSString*) country;
@end
