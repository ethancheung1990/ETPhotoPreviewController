//
//  NSObject+Category.m
//  MyProject
//
//  Created by Ethan on 14-3-5.
//  Copyright (c) 2014年 ethan. All rights reserved.
//

#import "NSObject+Category.h"
#import <objc/runtime.h>
#import <objc/objc-auto.h>

static char __logDeallocAssociatedKey__;
@interface LogDealloc : NSObject
@property (nonatomic, copy) NSString *message;
@end

@implementation LogDealloc
- (void)dealloc
{
    NSLog(@"dealloc :%@",self.message);
}
@end

@implementation NSObject (Category)


- (NSString *)classString
{
    return NSStringFromClass([self class]);
}


- (void)associateValue:(id)value withKey:(void *)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN);
}

- (void)weakAssoicateVaule:(id)value withKey:(void *)key
{
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (id)accociatedVauleForKey:(void *)key
{
    return objc_getAssociatedObject(self, key);
}

- (BOOL)isVauleForKeyPath:(NSString *)keyPath equalToVaule:(id)value
{
    if ([keyPath length] > 0)
    {
        id objectValue = [self valueForKeyPath:keyPath];
        return ([objectValue isEqual:value] || ((objectValue == nil) && (value == nil)));
    }
    return NO;
}

- (BOOL)isVauleForKeyPath:(NSString *)keyPath identicalToVaule:(id)value
{
    if ([keyPath length] > 0)
    {
        return ([self valueForKeyPath:keyPath] == value);
    }
    return NO;
}

+ (NSDictionary *)propertyAttributes
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    unsigned int count = 0;
    objc_property_t *properies = class_copyPropertyList(self, &count);
    
    for (int i = 0  ; i < count; i ++)
    {
        objc_property_t property = properies[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        NSString *attribute = [NSString stringWithUTF8String:property_getAttributes(property)];
        [dictionary setObject:attribute forKey:name];
    }
    free(properies);
    
    if ([dictionary count] > 0) {
        return dictionary;
    }
    return nil;
}

- (void)logOnDealloc
{
    if (objc_getAssociatedObject(self, &__logDeallocAssociatedKey__) == nil)
    {
        LogDealloc *log = [[LogDealloc alloc] init];
        log.message = NSStringFromClass(self.class);
        objc_setAssociatedObject(self, &__logDeallocAssociatedKey__, log, OBJC_ASSOCIATION_RETAIN);
    }
}


- (void)encodeWithCoder:(NSCoder *)encoder {
	Class cls = [self class];
	while (cls != [NSObject class]) {
		unsigned int numberOfIvars = 0;
		Ivar* ivars = class_copyIvarList(cls, &numberOfIvars);
		for(const Ivar* p = ivars; p < ivars+numberOfIvars; p++){
			Ivar const ivar = *p;
			const char *type = ivar_getTypeEncoding(ivar);
			NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
			id value = [self valueForKey:key];
			if (value) {
				switch (type[0]) {
					case _C_STRUCT_B: {
						NSUInteger ivarSize = 0;
						NSUInteger ivarAlignment = 0;
						NSGetSizeAndAlignment(type, &ivarSize, &ivarAlignment);
						NSData *data = [NSData dataWithBytes:(const char *)(__bridge void *)(self) + ivar_getOffset(ivar)
                                                      length:ivarSize];
						[encoder encodeObject:data forKey:key];
					}
						break;
					default:
						[encoder encodeObject:value
                                       forKey:key];
						break;
				}
			}
		}
        free(ivars);
		cls = class_getSuperclass(cls);
	}
}

- (id)initWithCoder:(NSCoder *)decoder {
	self = [self init];
	
	if (self) {
		Class cls = [self class];
		while (cls != [NSObject class]) {
			unsigned int numberOfIvars = 0;
			Ivar* ivars = class_copyIvarList(cls, &numberOfIvars);
			
			for(const Ivar* p = ivars; p < ivars+numberOfIvars; p++){
				Ivar const ivar = *p;
				const char *type = ivar_getTypeEncoding(ivar);
				NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
				id value = [decoder decodeObjectForKey:key];
				if (value) {
					switch (type[0]) {
						case _C_STRUCT_B: {
							NSUInteger ivarSize = 0;
							NSUInteger ivarAlignment = 0;
							NSGetSizeAndAlignment(type, &ivarSize, &ivarAlignment);
							NSData *data = [decoder decodeObjectForKey:key];
							char *sourceIvarLocation = (char*)(__bridge void *)(self)+ ivar_getOffset(ivar);
							[data getBytes:sourceIvarLocation length:ivarSize];
						}
							break;
						default:
							[self setValue:[decoder decodeObjectForKey:key]
                                    forKey:key];
							break;
					}
				}
			}
            free(ivars);
			cls = class_getSuperclass(cls);
		}
	}
	
	return self;
}

@end
