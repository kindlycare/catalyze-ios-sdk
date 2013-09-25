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

#import <UIKit/UIKit.h>

#import "CatalyzeUser.h"
#import "CatalyzeHTTPManager.h"
#import "Catalyze.h"

#define kEncodeKeyPhoneNumber @"phone_number"
#define kEncodeKeyGender @"gender"
#define kEncodeKeyAge @"age"
#define kEncodeKeyBirthDate @"birth_date"
#define kEncodeKeyCountry @"country"
#define kEncodeKeyZipCode @"zip_code"
#define kEncodeKeyState @"state"
#define kEncodeKeyCity @"city"
#define kEncodeKeyStreet @"street"
#define kEncodeKeyLastName @"last_name"
#define kEncodeKeyFirstName @"first_name"
#define kEncodeKeyUserId @"user_id"
#define kEncodeKeyUsername @"username"

@interface CatalyzeUser()

@end

@implementation CatalyzeUser

static CatalyzeUser *currentUser;

+ (NSString *)genderToString:(CatalyzeUserGender)gender {
    switch (gender) {
        case CatalyzeUserGenderFemale:
            return @"female";
        case CatalyzeUserGenderMale:
            return @"male";
        case CatalyzeUserGenderUndifferentiated:
            return @"undifferentiated";
    }
}

+ (CatalyzeUserGender)stringToGender:(NSString *)genderString {
    if ([genderString isEqualToString:[CatalyzeUser genderToString:CatalyzeUserGenderFemale]]) {
        return CatalyzeUserGenderFemale;
    } else if ([genderString isEqualToString:[CatalyzeUser genderToString:CatalyzeUserGenderMale]]) {
        return CatalyzeUserGenderMale;
    } else if ([genderString isEqualToString:[CatalyzeUser genderToString:CatalyzeUserGenderUndifferentiated]]) {
        return CatalyzeUserGenderUndifferentiated;
    } else {
        [[NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%@ is not a valid gender. Must be \"female\", \"male\", or \"undifferentiated\"",genderString] userInfo:nil] raise];
        return 0;
    }
}

- (id)init {
    self = [super initWithClassName:kCatalyzeUser];
    [self setObject:[NSMutableDictionary dictionary] forKey:@"extras"];
    self.httpManager = [[CatalyzeHTTPManager alloc] init];
    [self initCurrentUser];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[self phoneNumber] forKey:kEncodeKeyPhoneNumber];
    [aCoder encodeObject:[CatalyzeUser genderToString:[self gender]] forKey:kEncodeKeyGender];
    [aCoder encodeObject:[self age] forKey:kEncodeKeyAge];
    [aCoder encodeObject:[self birthDate] forKey:kEncodeKeyBirthDate];
    [aCoder encodeObject:[self country] forKey:kEncodeKeyCountry];
    [aCoder encodeObject:[self zipCode] forKey:kEncodeKeyZipCode];
    [aCoder encodeObject:[self state] forKey:kEncodeKeyState];
    [aCoder encodeObject:[self city] forKey:kEncodeKeyCity];
    [aCoder encodeObject:[self street] forKey:kEncodeKeyStreet];
    [aCoder encodeObject:[self lastName] forKey:kEncodeKeyLastName];
    [aCoder encodeObject:[self firstName] forKey:kEncodeKeyFirstName];
    [aCoder encodeObject:[self userId] forKey:kEncodeKeyUserId];
    [aCoder encodeObject:[self username] forKey:kEncodeKeyUsername];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        [self setPhoneNumber:[aDecoder decodeObjectForKey:kEncodeKeyPhoneNumber]];
        [self setGender:[CatalyzeUser stringToGender:[aDecoder decodeObjectForKey:kEncodeKeyGender]]];
        [self setAge:[aDecoder decodeObjectForKey:kEncodeKeyAge]]; 
        [self setBirthDate:[aDecoder decodeObjectForKey:kEncodeKeyBirthDate]];
        [self setCountry:[aDecoder decodeObjectForKey:kEncodeKeyCountry]];
        [self setZipCode:[aDecoder decodeObjectForKey:kEncodeKeyZipCode]];
        [self setState:[aDecoder decodeObjectForKey:kEncodeKeyState]];
        [self setCity:[aDecoder decodeObjectForKey:kEncodeKeyCity]];
        [self setStreet:[aDecoder decodeObjectForKey:kEncodeKeyStreet]];
        [self setLastName:[aDecoder decodeObjectForKey:kEncodeKeyLastName]];
        [self setFirstName:[aDecoder decodeObjectForKey:kEncodeKeyFirstName]];
        [self setUserId:[aDecoder decodeObjectForKey:kEncodeKeyUserId]];
        [self setUsername:[aDecoder decodeObjectForKey:kEncodeKeyUsername]];
    }
    return self;
}

- (void)logout {
    [self.httpManager doGet:[NSString stringWithFormat:@"%@/%@/auth/signout",kCatalyzeBaseURL,[Catalyze applicationId]] block:^(int status, NSDictionary *response, NSError *error) {
        if (!error) {
            currentUser = nil;
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString *archivePath = [documentsDirectory stringByAppendingPathComponent:@"currentuser.archive"];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:archivePath error:nil];
        } else {
            NSLog(@"Logout unsuccessful");
        }
    }];
}

- (BOOL)isAuthenticated {
    return ([self userId] == nil && [[self userId] isEqualToString:@""]);
}

+ (CatalyzeUser *)user {
    return [[CatalyzeUser alloc] init];
}

#pragma mark - Current User

+ (CatalyzeUser *)currentUser {
    return currentUser;
}

- (void)initCurrentUser {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [documentsDirectory stringByAppendingPathComponent:@"currentuser.archive"];
    
    currentUser = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
}

+ (void)saveCurrentUser {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [documentsDirectory stringByAppendingPathComponent:@"currentuser.archive"];
    [NSKeyedArchiver archiveRootObject:currentUser toFile:archivePath];
}

#pragma mark - LogIn

+ (void)logIn {
    currentUser = [CatalyzeUser user];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]) {
        [[CatalyzeUser currentUser] retrieveInBackgroundWithBlock:^(CatalyzeObject *object, NSError *error) {
            if (error) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Authorization"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [CatalyzeUser logIn];
            } else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@://?authorized=true&userId=%@&new=false&sessionToken=%@",[Catalyze URLScheme],[[CatalyzeUser currentUser] userId],[[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]]]];
            }
        }];
    } else {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:[NSString stringWithFormat:@"googlechromes://api.catalyze.io/v1/%i/auth/signin?callbackUri=%@://",[[Catalyze applicationId] intValue],[Catalyze URLScheme]]]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"googlechromes://api.catalyze.io/v1/%i/auth/signin?callbackUri=%@://",[[Catalyze applicationId] intValue],[Catalyze URLScheme]]]];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.catalyze.io/v1/%i/auth/signin?callbackUri=%@://",[[Catalyze applicationId] intValue],[Catalyze URLScheme]]]];
        }
    }
}

#pragma mark - Extras

- (id)extraForKey:(NSString *)key {
    return [[self objectForKey:@"extras"] objectForKey:key];
}

- (void)setExtra:(id)extra forKey:(NSString *)key {
    //avoid setting nil, since we cant set nil anyways
    if (extra) {
        [self setObject:[NSMutableDictionary dictionaryWithDictionary:((NSDictionary *)[self objectForKey:@"extras"])] forKey:@"extras"];
        [((NSMutableDictionary *)[self objectForKey:@"extras"]) setObject:extra forKey:key];
    }
}

- (void)removeExtraForKey:(NSString *)key {
    [[self objectForKey:@"extras"] removeObjectForKey:key];
}

#pragma mark - Getters and Setters

- (NSString *)username {
    return [self objectForKey:@"username"];
}

- (void)setUsername:(NSString *)username {
    [self setObject:username forKey:@"username"];
}

- (NSString *)userId {
    return [self objectForKey:@"id"];
}

- (void)setUserId:(NSString *)userId {
    [self setObject:userId forKey:@"id"];
}

- (NSString *)firstName {
    return [self objectForKey:@"firstName"];
}

- (void)setFirstName:(NSString *)firstName {
    [self setObject:firstName forKey:@"firstName"];
}

- (NSString *)lastName {
    return [self objectForKey:@"lastName"];
}

- (void)setLastName:(NSString *)lastName {
    [self setObject:lastName forKey:@"lastName"];
}

- (NSString *)street {
    return [self objectForKey:@"street"];
}

- (void)setStreet:(NSString *)street {
    [self setObject:street forKey:@"street"];
}

- (NSString *)city {
    return [self objectForKey:@"city"];
}

- (void)setCity:(NSString *)city {
    [self setObject:city forKey:@"city"];
}

- (NSString *)state {
    return [self objectForKey:@"state"];
}

- (void)setState:(NSString *)state {
    [self setObject:state forKey:@"state"];
}

- (NSString *)zipCode {
    return [self objectForKey:@"zipCode"];
}

- (void)setZipCode:(NSString *)zipCode {
    [self setObject:zipCode forKey:@"zipCode"];
}

- (NSString *)country {
    return [self objectForKey:@"country"];
}

- (void)setCountry:(NSString *)country {
    [self setObject:country forKey:@"country"];
}

- (NSString *)address {
    return [NSString stringWithFormat:@"%@, %@, %@, %@, %@",[self street],[self city],[self state],[self zipCode], [self country]];
}

- (NSDate *)birthDate {
    return [self objectForKey:@"dateOfBirth"];
}

- (void)setBirthDate:(NSDate *)birthDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [self setObject:[dateFormatter stringFromDate:birthDate] forKey:@"dateOfBirth"];
}

- (NSNumber *)age {
    return [self objectForKey:@"age"];
}

- (void)setAge:(NSNumber *)age {
    [self setObject:age forKey:@"age"];
}

- (CatalyzeUserGender)gender {
    return [CatalyzeUser stringToGender:[self objectForKey:@"gender"]];
}

- (void)setGender:(CatalyzeUserGender)gender {
    [self setObject:[CatalyzeUser genderToString:gender] forKey:@"gender"];
}

- (NSString *)phoneNumber {
    return [self objectForKey:@"phoneNumber"];
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    [self setObject:phoneNumber forKey:@"phoneNumber"];
}

@end
