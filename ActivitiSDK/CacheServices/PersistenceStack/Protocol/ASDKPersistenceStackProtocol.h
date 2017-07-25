/*******************************************************************************
 * Copyright (C) 2005-2017 Alfresco Software Limited.
 *
 * This file is part of the Alfresco Activiti Mobile SDK.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 ******************************************************************************/

#import <Foundation/Foundation.h>

@class NSPersistentContainer,
NSManagedObjectContext;

typedef void (^ASDKPersistenceTaskBlock) (NSManagedObjectContext *managedObjectContext);
typedef void (^ASDKPersistenceErrorHandlerBlock) (NSError *error);

@protocol ASDKPersistenceStackProtocol <NSObject>

/**
 * Container that encapsulates the Core Data stack.
 */
@property (strong, nonatomic, readonly) NSPersistentContainer *persistentContainer;


/**
 * Initializez, configures and loads a persistence store dedicated to caching and
 * fetching cached data.
 *
 * @param errorHandlerBlock Error reporting block that gets called if the persistence 
 *                          stack cannot be properly set up.
 * @return Initialized instance
 */
- (instancetype)initWithErrorHandler:(ASDKPersistenceErrorHandlerBlock)errorHandlerBlock;


/**
 * Returns managed object context associated with the main queue.
 */
- (NSManagedObjectContext *)viewContext;


/**
 * Creates and returns a private managed object context.
 */
- (NSManagedObjectContext *)backgroundContext;


/**
 * Executes the passed block on the context associated with the main queue.
 *
 * @param taskBlock Block to be executed
 */
- (void)performForegroundTask:(ASDKPersistenceTaskBlock)taskBlock;


/**
 * Executes the passed block on a private managed object context.
 *
 * @param taskBlock Block to be executed.
 */
- (void)performBackgroundTask:(ASDKPersistenceTaskBlock)taskBlock;


/**
 * Persists changes (if there are any) on the view context and rolls back changes
 * if the save operation fails.
 */
- (void)saveContext;

@end
