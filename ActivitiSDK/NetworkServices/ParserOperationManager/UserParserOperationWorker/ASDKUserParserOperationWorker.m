/*******************************************************************************
 * Copyright (C) 2005-2018 Alfresco Software Limited.
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

#import "ASDKUserParserOperationWorker.h"

// Constants
#import "ASDKNetworkServiceConstants.h"

// Model
#import "ASDKModelPaging.h"
#import "ASDKModelUser.h"

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

@implementation ASDKUserParserOperationWorker

#pragma mark -
#pragma mark ASDKParserOperationWorker Protocol

- (void)parseContentDictionary:(NSDictionary *)contentDictionary
                        ofType:(NSString *)contentType
           withCompletionBlock:(ASDKParserCompletionBlock)completionBlock
                         queue:(dispatch_queue_t)completionQueue {
    NSParameterAssert(contentDictionary);
    NSParameterAssert(contentType);
    NSParameterAssert(completionBlock);
    
    if ([CREATE_STRING(ASDKUserParserContentTypeUserList) isEqualToString:contentType]) {
        NSError *parserError = nil;
        ASDKModelPaging *paging = nil;
        NSArray *userList = nil;
        Class pagingClass = ASDKModelPaging.class;
        
        if ([self validateJSONPropertyMappingOfClass:pagingClass
                               withContentDictionary:contentDictionary
                                               error:&parserError]) {
            paging = [MTLJSONAdapter modelOfClass:ASDKModelPaging.class
                               fromJSONDictionary:contentDictionary
                                            error:&parserError];
            userList = [MTLJSONAdapter modelsOfClass:ASDKModelUser.class
                                                fromJSONArray:contentDictionary[kASDKAPIJSONKeyData]
                                                        error:&parserError];
        }
        
        dispatch_async(completionQueue, ^{
            completionBlock(userList, parserError, paging);
        });
    }
}

- (NSArray *)availableServices {
    return @[CREATE_STRING(ASDKUserParserContentTypeUserList)];
}

@end
