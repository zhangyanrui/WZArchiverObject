//
//  WZArchiverObject.m
//  Will Zhang
//
//  继承这个类 从而使得子类可序列化  此类通过runTime实现了NSCoding协议
//
//  Created by Will Zhang on 15-1-15.
//
//  Licensed under the Apache License, Version 2.0 (the "License"); you may not
//  use this file except in compliance with the License.  You may obtain a copy
//  of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
//  WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
//  License for the specific language governing permissions and limitations under
//  the License.
//

#import "HAArchiverObject.h"
#import <objc/runtime.h>

@implementation WZArchiverObject

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        unsigned int outCount;
        objc_property_t *properties = class_copyPropertyList([self class], &outCount);
        for (int i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            NSString *strPropertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            NSString *strPropertyPrivateName = [@"_" stringByAppendingString:strPropertyName];
            id idDecoderValue = [aDecoder decodeObjectForKey:strPropertyName];
            if (idDecoderValue) {
                //NSLog(@"%@:%@", strPropertyPrivateName, idDecoderValue);
                [self setValue:idDecoderValue forKeyPath:strPropertyPrivateName];
            }
        }
        
        free(properties);
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *strPropertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        id idValue = [self valueForKey:strPropertyName];
        if (idValue) {
            //NSLog(@"%@:%@", strPropertyName, idValue);
            [aCoder encodeObject:idValue forKey:strPropertyName];
        }
    }
    
    free(properties);
}

@end
