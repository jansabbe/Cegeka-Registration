//
//  CGKViewController.m
//  Cegeka Registration
//
//  Created by Jan Sabbe on 11/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CGKViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SaveRegistration.h"

@interface CGKViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageview;
@property (weak, nonatomic) IBOutlet UIButton *countryButton;
@property (weak, nonatomic) IBOutlet UILabel *registrationFeedbackLabel;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureOnImage;

@property (weak, nonatomic) IBOutlet UILabel *tapToTakePhotoLabel;
@property (weak) UIPopoverController* countryPopoverController;
@end

@implementation CGKViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //http://shitmores.blogspot.be/2011/05/how-to-create-photo-frame-effect.html
    CALayer *layer = self.photoImageview.layer;
    [layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [layer setBorderWidth:4.0f];
    [layer setShadowColor: [[UIColor blackColor] CGColor]];
    [layer setShadowOpacity:0.7f];
    [layer setShadowOffset: CGSizeMake(1, 2)];
    [layer setShadowRadius:2.0];
    [self.photoImageview setClipsToBounds:NO];
    
    self.nameTextfield.delegate = self;
    self.emailTextfield.delegate = self;
    
    [self clear];
}

- (IBAction) clear {
    self.nameTextfield.text = @"";
    self.emailTextfield.text = @"";
    self.photoImageview.image = [UIImage imageNamed:@"photo"];
    self.tapToTakePhotoLabel.hidden = NO;
    [self.countryButton setTitle:@"Belgium" forState:UIControlStateNormal];
    self.registrationFeedbackLabel.hidden = YES;
    [self setAllEnabled:YES];
    [self.nameTextfield becomeFirstResponder];
    [self disableSaveIfNotEverythingFilledIn];
}

- (IBAction)saveRegistration {
    self.registrationFeedbackLabel.hidden = NO;
    [self setAllEnabled:NO];
    
    [SaveRegistration saveRegistrationWithName:self.nameTextfield.text
                                         email:self.emailTextfield.text
                                       country:self.countryButton.currentTitle
                                         photo:self.photoImageview.image];
    
    [self performSelector:@selector(clear) withObject:self afterDelay:3];
}


# pragma mark - Enter in text fields

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.nameTextfield) {
        [self.emailTextfield becomeFirstResponder];
    } else {
        [self.emailTextfield resignFirstResponder];
    }
    return YES;
}


# pragma mark - Profile photo

- (IBAction)imageTapped:(id)sender {

    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    cameraUI.allowsEditing = YES;
    
    cameraUI.delegate = self;
    
    [self presentViewController:cameraUI animated:YES completion:NULL];
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    UIImage *image = (UIImage *) [info objectForKey:UIImagePickerControllerEditedImage];
    self.photoImageview.image = image;
    self.tapToTakePhotoLabel.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:NULL];
    [self disableSaveIfNotEverythingFilledIn];
}

# pragma mark - Country selection

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"selectCountry"]) {
        self.countryPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        CGKCountryTableViewController* controller = segue.destinationViewController;
        controller.countrySelectionDelegate = self;
    }
}

- (void) countryController:(CGKCountryTableViewController*) controller didSelectCountry:(NSString*) country {
    [self.countryPopoverController dismissPopoverAnimated:YES];
    self.countryPopoverController = nil;
    [self.countryButton setTitle:country forState:UIControlStateNormal];
}

#pragma mark - Auto disabling
- (void) setAllEnabled:(BOOL) enabled {
    self.saveButton.enabled = enabled;
    self.nameTextfield.enabled = enabled;
    self.emailTextfield.enabled = enabled;
    
    if (enabled) {
        self.nameTextfield.textColor = [UIColor blackColor];
        self.emailTextfield.textColor = [UIColor blackColor];
    } else {
        self.nameTextfield.textColor = [UIColor lightGrayColor];
        self.emailTextfield.textColor = [UIColor lightGrayColor];
    }
    
    self.countryButton.enabled = enabled;
    self.tapGestureOnImage.enabled = enabled;
}


- (void) disableSaveIfNotEverythingFilledIn {
    BOOL allFilledIn = [self.nameTextfield.text length] > 0
        && [self.emailTextfield.text length] > 0
        && self.tapToTakePhotoLabel.hidden;
    self.saveButton.enabled = allFilledIn;
}

- (IBAction)textfieldChanged {
    [self disableSaveIfNotEverythingFilledIn];
}

@end