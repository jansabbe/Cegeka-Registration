//
//  SaveRegistration.m
//  Cegeka Registration
//
//  Created by Jan Sabbe on 4/11/12.
//
//

#import "SaveRegistration.h"
#import "UIImage+Resize.h"

@implementation SaveRegistration

+ (void) saveRegistrationWithName:(NSString*) name
                            email:(NSString*) email
                          country:(NSString*) country
                            photo:(UIImage*) photo {
    
    NSMutableArray* registrations = [self getOrCreateRegistrationsArray];
    NSString* imageFileName = [NSString stringWithFormat:@"photo%d.jpg", [registrations count]];
    [registrations addObject: @{@"name": name, @"email": email, @"country": country, @"photo": imageFileName}];
    [self saveRegistrationsAsJson:registrations];
    
    UIImage *resizedImage = [photo resizedImage:CGSizeMake(250.0f, 250.0f) interpolationQuality:kCGInterpolationMedium];
    NSData *jpegPhoto = [NSData dataWithData:UIImageJPEGRepresentation(resizedImage, 0.8f)];
    NSString *filePath = [[self documentPath] stringByAppendingPathComponent:imageFileName];
    [jpegPhoto writeToFile:filePath atomically:YES]; //Write the file
}


+ (NSString*) documentPath {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *registrationsPath = [documentsDirectory stringByAppendingPathComponent:@"/Registrations"];
    NSString *dataPath = [registrationsPath stringByAppendingPathComponent:@"/data"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:YES attributes:nil error:NULL];
        
        NSString *htmlInDocuments = [registrationsPath stringByAppendingPathComponent:@"registrations.html"];
        NSString *htmlBundled = [[NSBundle mainBundle] pathForResource:@"registrations" ofType:@"html"];
        [[NSFileManager defaultManager] copyItemAtPath:htmlBundled toPath:htmlInDocuments error:NULL];
    }
    return dataPath;
}

+ (NSMutableArray*) getOrCreateRegistrationsArray {
    NSString *filePath = [[self documentPath] stringByAppendingPathComponent:@"registrations.json"];
    NSError *error = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        return [NSMutableArray array];
    }
    
    NSMutableArray* result =  [NSJSONSerialization JSONObjectWithData: [NSData dataWithContentsOfFile:filePath]
                                                              options:NSJSONReadingMutableContainers
                                                                error:&error];
    if (error) {
        NSLog(@"Error occurred while converting from json: %@", error);
    }
    return result;
}

+ (void) saveRegistrationsAsJson:(NSMutableArray*) array {
    NSError *error = nil;
    NSString *filePath = [[self documentPath] stringByAppendingPathComponent:@"registrations.json"];
    NSData *data = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    if (error) {
        NSLog(@"Error occurred while converting to json: %@", error);
    }
    [data writeToFile:filePath atomically:YES];
}

@end
