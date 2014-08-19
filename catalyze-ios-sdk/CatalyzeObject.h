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
 CatalyzeObject is the base class of CatalyzeUser.  It is also the base class for custom
 classes on the catalyze.io API.  A CatalyzeObject is initialized with the name of the custom
 class it is associated with and is the container for an Entry in that class.
 
 CatalyzeObject stores all of the fields in its objectDict.  CatalyzeObject will
 only send fields to the catalyze.io API that have been changed.  See dirtyFields.
 This is in place to save on network traffic size and to increase overall performance
 of the SDK.
 
 **NOTE**
 Unless instantiated for use with a Custom Class, a CatalyzeObject should never be used in 
 place of a CatalyzeUser.  If you are dealing with a user, please use CatalyzeUser.
 */

#import <Foundation/Foundation.h>
#import "CatalyzeConstants.h"

@interface CatalyzeObject : NSObject

#pragma mark Constructors

/** @name Constructors */

/**
 Initializes a CatalyzeObject with a class name.  This class name is used to lookup
 URL routes.  Valid class names are those which are named after a custom class on the
 catalyze.io API.
 
 @param className a valid class name representing the type of CatalyzeObject being created
 @return a newly created CatalyzeObject with the given class name
 @exception NSInvalidArgumentException will be thrown if className is not a valid class name specified in CatalyzeConstants
 */
+ (CatalyzeObject *)objectWithClassName:(NSString *)className;

/**
 Initializes a CatalyzeObject with a class name.  This class name is used to lookup
 URL routes.  Valid class names are those which are named after a custom class on the
 catalyze.io API. The dictionary may contain any key value pairs, such as predefined 
 fields like first_name, last_name or custom fields.
 
 @param className a valid class name representing the type of CatalyzeObject being created
 @param dictionary key value pairs to be stored with the CatalyzeObject on the next network request.
 @return a newly created CatalyzeObject with the given class name and key value pairs stored from the dictionary
 @exception NSInvalidArgumentException will be thrown if className is not a valid class name specified in CatalyzeConstants
 */
+ (CatalyzeObject *)objectWithClassName:(NSString *)className dictionary:(NSDictionary *)dictionary;

/**
 Constructs a new instance of CatalzeObject with the given class name.  See [CatalyzeObject objectWithClassName:]
 
 @param newClassName a valid class name representing the type of CatalyzeObject being created
 @return the newly created instance of CatalyzeObject
 */
- (id)initWithClassName:(NSString *)newClassName;

#pragma mark -
#pragma mark Properties

/** @name Properties */

@property (strong, nonatomic) NSString *className;
@property (strong, nonatomic) NSString *authorId;
@property (strong, nonatomic) NSString *parentId;
@property (strong, nonatomic) NSString *entryId;
@property (strong, nonatomic) NSMutableDictionary *content;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;

#pragma mark -
#pragma mark Create

/** @name Create */

/**
 Creates a new CatalyzeObject on the catalyze.io API.  If this is the parent class of a
 CatalyzeUser, this method should never be called.  This method creates a new custom class entry
 on the catalyze.io API. This method offers no indication as to when the request is completed.  
 If this is necessary, see createInBackgroundWithBlock:
 */
- (void)createInBackground;

/**
 Creates a new custom class entry on the catalyze.io API.  Upon the request's 
 completion, this CatalyzeObject will have all fields updated and save which 
 can be retrieved by calling objectForKey:. Upon request completion, the 
 CatalyzeBooleanResultBlock is executed whether the request succeeded or failed.
 
 @param block the completion block to be executed upon the request's completion. 
 See CatalyzeBooleanResultBlock to tell whether or not the request was successful.
 */
- (void)createInBackgroundWithBlock:(CatalyzeBooleanResultBlock)block;

/**
 Creates a new custom class entry on the catalyze.io API.  Upon the request's
 completion, this CatalyzeObject will have all fields updated and save which
 can be retrieved by calling objectForKey:. The object sent with the selector 
 will be the error of the request or nil of the request was successful.
 
 **NOTE:**
 the selector is performed on the target on the **Main Thread** see [[NSThread mainThread]](http://bit.ly/11Z9D47)
 
 @param target the target to perform the given selector on the **Main Thread** 
 upon the request's completion
 @param selector the selector to be performed on the given target on the **Main Thread** 
 upon the request's completion
 */
- (void)createInBackgroundWithTarget:(id)target selector:(SEL)selector;

- (void)createInBackgroundForUserWithUsersId:(NSString *)usersId;

- (void)createInBackgroundForUserWithUsersId:(NSString *)usersId block:(CatalyzeBooleanResultBlock)block;

- (void)createInBackgroundForUserWithUsersId:(NSString *)usersId target:(id)target selector:(SEL)selector;

#pragma mark -
#pragma mark Save

/** @name Save */

/**
 Saves this CatalyzeObject in the background.  Only dirty fields are sent to the 
 catalyze.io API and saved.  This method offers no indication as to whether or not 
 the request completed, succeeded, or failed.  If this is neccessary, see 
 saveInBackgroundWithBlock:.
 */
- (void)saveInBackground;

/**
 Saves this CatalyzeObject in the background.  Only dirty fields are sent to the
 catalyze.io API and saved.  Upon completion of the request, the CatalyzeBooleanResultBlock 
 is executed whether the request succeeded or failed.  To tell if the request succeeded 
 or not, see CatalyzeBooleanResultBlock
 
 @param block the completion block to be executed upon the request's completion
 */
- (void)saveInBackgroundWithBlock:(CatalyzeBooleanResultBlock)block;

/**
 Saves this CatalyzeObject in the background.  Only dirty fields are sent to the
 catalyze.io API and saved.  Upon completion of the request, the given selector 
 will be performed on the given target.  The object sent with the selector is the 
 error of the request, or nil if the request was successful.
 
 **NOTE:**
 the selector is performed on the target on the **Main Thread** see [[NSThread mainThread]](http://bit.ly/11Z9D47)
 
 @param target the target to perform the given selector on the **Main Thread** 
 upon the request's completion
 @param selector the selector to be performed on the given target on the **Main Thread** 
 upon the request's completion
 */
- (void)saveInBackgroundWithTarget:(id)target selector:(SEL)selector;

#pragma mark -
#pragma mark Retrieve

/** @name Retrieve */

/**
 Retrieves this CatalyzeObject in the background.  Mostly used for objects that have
 an id but no data.  This method offers no indication as to whether or not the request 
 completed, succeeded, or failed. If this is necessary see retriveInBackgroundWithBlock:.  
 Upon completion, this CatalyzeObject will have its objectDict updated with all of the 
 keys received from the catalyze.io API.
 */
- (void)retrieveInBackground;

/**
 Retrieves this CatalyzeObject in the background.  Mostly used for objects that have
 an id but no data.  Upon completion of the request the CatalyzeObjectResultBlock will 
 be executed whether or not the request completed, succeeded, or failed.  Upon completion, 
 this CatalyzeObject will have its objectDict updated with all of the keys received 
 from the catalyze.io API and this CatalyzeObject is sent back in the completion block as well.
 
 @param block the completion block to be executed upon the request's completion
 */
- (void)retrieveInBackgroundWithBlock:(CatalyzeObjectResultBlock)block;

/**
 Retrieves this CatalyzeObject in the background.  Mostly used for objects that have
 an id but no data.  Upon completion of the request the given selector will be performed 
 on the target whether or not the request completed, succeeded, or failed.  Upon 
 completion, this CatalyzeObject will have its objectDict updated with all of the keys 
 received from the catalyze.io API and this CatalyzeObject is sent back as the object 
 of the selector.
 
 **NOTE:**
 The selector is performed on the target on the **Main Thread** see
 [[NSThread mainThread]](http://bit.ly/11Z9D47)
 
 @param target the target to perform the given selector on the **Main Thread** 
 upon the request's completion
 @param selector the selector to be performed on the given target on the **Main Thread** 
 upon the request's completion
 */
- (void)retrieveInBackgroundWithTarget:(id)target selector:(SEL)selector;

#pragma mark -
#pragma mark Delete

/** @name Delete */

/**
 Deletes this CatalyzeObject in the background from the catalyze.io API.  This 
 method offers no indication as to whether or not the request completed,
 succeeded, or failed. If this is necessary see deleteInBackgroundWithBlock:.  
 Upon completion, this CatalyzeObject will have nothing stored in its objectDict
 and should be discarded and set to nil.
 */
- (void)deleteInBackground;

/**
 Deletes this CatalyzeObject in the background.  Upon completion of the request
 the CatalyzeObjectResultBlock will be executed whether or not the request
 completed, succeeded, or failed.  Upon completion, this CatalyzeObject
 will have nothing stored in its objectDict and should be discarded and set to nil.
 
 @param block the completion block to be executed upon the request's completion
 */
- (void)deleteInBackgroundWithBlock:(CatalyzeBooleanResultBlock)block;

/**
 Deletes this CatalyzeObject in the background.  Upon completion of the request
 the given selector will be performed on the target whether or not the request
 completed, succeeded, or failed.  Upon completion, this CatalyzeObject
 will have nothing stored in its objectDict and should be discarded and set to nil.
 
 **NOTE:**
 The selector is performed on the target on the **Main Thread** see
 [[NSThread mainThread]](http://bit.ly/11Z9D47)
 
 @param target the target to perform the given selector on the **Main Thread**
 upon the request's completion
 @param selector the selector to be performed on the given target on the **Main Thread**
 upon the request's completion
 */
- (void)deleteInBackgroundWithTarget:(id)target selector:(SEL)selector;

@end
