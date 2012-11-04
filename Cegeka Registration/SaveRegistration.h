//
//  SaveRegistration.h
//  Cegeka Registration
//
//  Created by Jan Sabbe on 4/11/12.
//
//

#import <Foundation/Foundation.h>

@interface SaveRegistration : NSObject

+ (void) saveRegistrationWithName:(NSString*) name
                            email:(NSString*) email
                          country:(NSString*) country
                            photo:(UIImage*) photo;
@end
