//
//  UXKAnimation.h
//  uxkit
//
//  Created by 崔 明辉 on 16/8/17.
//  Copyright © 2016年 YY Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pop/POP.h>

@interface UXKAnimation : NSObject

+ (POPAnimation *)animationWithParams:(NSDictionary *)aniParams
                          aniProperty:(NSString *)aniProperty
                            fromValue:(id)fromValue
                              toValue:(id)toValue;

@end
