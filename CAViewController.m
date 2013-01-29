//
//  CAViewController.m
//  AddressBook_iOS6_releaseNote
//
//  Created by Global Logic on 28/01/13.
//  Copyright (c) 2013 Celestix. All rights reserved.
//

#import "CAViewController.h"
#import <AddressBook/AddressBook.h>

@interface CAViewController ()

@end

@implementation CAViewController
@synthesize numberOfSmiths = _numberOfSmiths;

void AddressBookUpdated(ABAddressBookRef addressBook, CFDictionaryRef info, void *context) {

    ABAddressBookRevert(addressBook);
    CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex nPeople = ABAddressBookGetPersonCount(addressBook);

    for ( int i = 0; i < nPeople; i++ )
    {
        ABRecordRef person = CFArrayGetValueAtIndex( allPeople, i );
        NSString *name = (NSString *)ABRecordCopyValue(person, kABPersonFirstNameProperty);
        NSLog(@"%@",name);
    }
};

- (void)viewDidLoad
{ //viewDidLoad
    [super viewDidLoad];
    CFErrorRef myError = NULL;
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, &myError);
    
    switch (ABAddressBookGetAuthorizationStatus()) {
        case kABAuthorizationStatusNotDetermined: {
            NSLog(@"kABAuthorizationStatusNotDetermined");
            ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                // First time access.
                AddressBookUpdated(addressBookRef, nil, self);
                CFRelease(addressBookRef);
            }); }
            break;
        case kABAuthorizationStatusRestricted:{
            NSLog(@"kABAuthorizationStatusRestricted");
        }
            break;
        case kABAuthorizationStatusDenied:
            NSLog(@"kABAuthorizationStatusDenied");
            break;
        case kABAuthorizationStatusAuthorized:{
            NSLog(@"kABAuthorizationStatusAuthorized");
            AddressBookUpdated(addressBookRef, nil, self);
            CFRelease(addressBookRef);
            break;
        }}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
