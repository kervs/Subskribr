//
//  ProfileEditViewController.m
//  Subskribr
//
//  Created by Kervins Valcourt on 2/2/15.
//  Copyright (c) 2015 EastoftheWestEnd. All rights reserved.
//

#import "ProfileEditViewController.h"

@interface ProfileEditViewController () <UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (strong,nonatomic)UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (nonatomic,strong) UIImagePickerController *picker;

@end

@implementation ProfileEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.saveButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:self.saveButton];
    self.picker = [[UIImagePickerController alloc] init];
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
}

- (IBAction)changePicturePressed:(id)sender {

    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Picture Option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"Take a Photo",
                            @"Choose Existing Photo",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (popup.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self takePhoto];
                    break;
                case 1:
                    [self chooseExistingPhoto];
                    break;
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    
}

- (void)takePhoto {
    [self.picker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentViewController:self.picker animated:YES completion:nil];
}

- (void)chooseExistingPhoto {
    [self.picker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:self.picker animated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info  {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.profilePicture setImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)saveButtonPressed:(id)sender {
    return;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
