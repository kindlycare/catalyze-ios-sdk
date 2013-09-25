/*
 * Copyright (C) 2013 catalyze.io, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

/**
A CatalyzeUser is used to represent Users on the catalyze.io API.
 
Since there can only be one User logged into the system at a time, the static
method [CatalyzeUser currentUser] is provided to access this User from
anywhere in your code.

The currentUser is set by making the following call:
 
    [CatalyzeUser logIn];

To get and save pre-defined information for the currentUser, it would look like this:
 
    NSString *firstName = [[CatalyzeUser currentUser] firstName];
    [[CatalyzeUser currentUser] setLastName:@"Appleseed"];

Or to get and save custom fields on the currentUser, it would look like this:

    NSString *preferredPharmacy = [[CatalyzeUser currentUser] extraForKey:@"preferred_pharmacy];
    [[CatalyzeUser currentUser] setExtra:@"1234 5th Street, Milwaukee, WI, 53202" forKey:@"preferred_pharmacy"];
 
*/

#import <Foundation/Foundation.h>
#import "CatalyzeConstants.h"
#import "CatalyzeObject.h"

typedef enum {
    CatalyzeUserGenderFemale,
    CatalyzeUserGenderMale,
    CatalyzeUserGenderUndifferentiated
} CatalyzeUserGender;

@interface CatalyzeUser : CatalyzeObject<NSCoding>

/** @name Conversions */

/**
 Converts a given CatalyzeUserGender to its string representation.
 
 @param gender the CatalyzeUserGender enum to be converted into a string
 @return the string representation of the given CatalyzeUserGender enum
 */
+ (NSString *)genderToString:(CatalyzeUserGender)gender;

/**
 Converts a given string into a CatalyzeUserGender enum.
 
 @param genderString the string representing a CatalyzeUserGender to be converted
 @return the CatalyzeUserGender enum specified by the given string
 */
+ (CatalyzeUserGender)stringToGender:(NSString *)genderString;

/** @name Current User */

/**
 @return The current CatalyzeUser
 */
+ (CatalyzeUser *)currentUser;

/** @name User */

/**
 Logout clears all locally stored information about the User including session information 
 and tells the API to destroy your session token.
 */
- (void)logout;

/**
 @return YES if the CatalyzeUser has been logged in and has a valid session, otherwise NO
 */
- (BOOL)isAuthenticated;

/** @name Initializers */

/**
 This is a convenience method for alloc init'ing a new CatalyzeUser.  This CatalyzeUser
 is **not** the currentUser and is **not** logged in automatically.  Before saving this user
 to the catalyze.io API the firstName and lastName **must** be set.
 
 Usage:
 
    CatalyzeUser *newUser = [CatalyzeUser user];
    [newUser setFirstName:@"John"];
    [newUser setLastName:@"Appleseed"];
 
 @return A new instance of CatalyzeUser
 */
+ (CatalyzeUser *)user;

#pragma mark - LogIn

/** @name LogIn */

/**
 For logging into the catalyze.io API, you must launch a browser and follow the step outlined
 in the catalyze.io API documentation.  This method is used for log in and sign up.  A browser is
 launched and after successful authentication, brought back to the application.  For this to work
 properly, ensure that your iOS callback URL Scheme was set in your 
 application:didFinishLaunchingWithOptions: method.
 */
+ (void)logIn;

/** @name Extras */

/**
 On the catalyze.io API every User has a set of Extras specific to an application. These extras are
 any other values stored with the User that are not validated by the API but simply stored and 
 returned when needed.
 
 @param key the key to look for an extra stored on this CatalyzeUser
 @return an extra value stored on this CatalyzeUser
 */
- (id)extraForKey:(NSString *)key;

/**
 @param extra the value to store as an Extra on this CatalyzeUser
 @param key the key to save the given extra value under for this CatalyzeUser
 */
- (void)setExtra:(id)extra forKey:(NSString *)key;

/**
 @param key the key to look for an extra under that should be removed when found
 */
- (void)removeExtraForKey:(NSString *)key;

/** @name User Id */

/**
 @return the unique identifier of the CatalyzeUser on the catalyze.io API.  This will be set if the 
 user has been authenticated, otherwise if no network request has been made, this will most likely 
 be nil.
 */
- (NSString *)userId;

/**
 @param userId the unique identifier of the CatalyzeUser on the catalyze.io API.  
 Used when you have the userId and want to retrieve information about a CatalyzeUser.
 */
- (void)setUserId:(NSString *)userId;

/** @name Username */

/**
 @return the username of the CatalyzeUser
 */
- (NSString *)username;

/**
 This method should never be called by a developer, it is simply for constructing a User from
 a saved archive or network call. The username is set through successful authentication.
 
 @param username the valid username to be set.
 @exception NSInvalidArgumentException will be thrown if the username is not in a valid email format
 */
- (void)setUsername:(NSString *)username;

/** @name First Name */

/**
 @return the firstName of the CatalyzeUser
 */
- (NSString *)firstName;

/**
 @param firstName the new first name to be set on the CatalyzeUser
 */
- (void)setFirstName:(NSString *)firstName;

/** @name Last Name */

/**
 @return the lastName of the CatalyzeUser
 */
- (NSString *)lastName;

/**
 @param lastName the new last name to be set on the CatalyzeUser
 */
- (void)setLastName:(NSString *)lastName;

/** @name Street */

/**
 @return the street of the CatalyzeUser with the format 1234 5th Street
 */
- (NSString *)street;

/**
 @param street the new street to be set on the CatalyzeUser.
 */
- (void)setStreet:(NSString *)street;

/** @name City */

/**
 @return the city of the CatalyzeUser, such as "Milwaukee"
 */
- (NSString *)city;

/**
 @param city the name of the city to set
 */
- (void)setCity:(NSString *)city;

/** @name State */

/**
 @return the two letter abbreviation of the state of the CatalyzeUser, such as WI
 */
- (NSString *)state;

/**
 @param state the two letter abbreviation of the name of the state to set
 */
- (void)setState:(NSString *)state;

/** @name Zip Code */

/**
 @return the zipCode of the CatalyzeUser
 */
- (NSString *)zipCode;

/**
 @param zipCode the new zipCode to be set on the CatalyzeUser.
 */
- (void)setZipCode:(NSString *)zipCode;

/** @name Country */

/**
 @return the country of the CatalyzeUser
 */
- (NSString *)country;

/**
 @param country the new country to be set on the CatalyzeUser.
 */
- (void)setCountry:(NSString *)country;

/** @name Address */

/**
 @return the complete address of the CatalyzeUser of the form 1234 5th Street, Milwaukee, WI, 53202, US
 */
- (NSString *)address;

/** @name Birth Date */

/**
 @return the birthDate of the CatalyzeUser
 */
- (NSDate *)birthDate;

/**
 @param birthDate the new birth date to be set on the CatalyzeUser.  
 */
- (void)setBirthDate:(NSDate *)birthDate;

/** @name Age */

/**
 @return the age of the CatalyzeUser
 */
- (NSNumber *)age;

/**
 @param age the age to be set on the CatalyzeUser
 */
- (void)setAge:(NSNumber *)age;

/** @name Gender */

/**
 @return the gender of the CatalyzeUser, one of CatalyzeUserGender enums
 */
- (CatalyzeUserGender)gender;

/**
 @param gender the CatalyzeUserGender enum to be set on the CatalyzeUser
 */
- (void)setGender:(CatalyzeUserGender)gender;

/** @name Phone Number */

/**
 @return the phone number of the CatalyzeUser
 */
- (NSString *)phoneNumber;

/**
 @param phoneNumber the new phone number to be set on the CatalyzeUser
 */
- (void)setPhoneNumber:(NSString *)phoneNumber;

@end
