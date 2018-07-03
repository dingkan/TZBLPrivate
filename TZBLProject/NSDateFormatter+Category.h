//
//  NSDateFormatter+Category.h
//  XCSX
//
//  Created by hcsx on 2017/8/23.
//  Copyright © 2017年 hcsx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Category)
+ (id)dateFormatter;
+ (id)dateFormatterWithFormat:(NSString *)dateFormat;

+ (id)defaultDateFormatter;/*yyyy-MM-dd HH:mm:ss*/

@end
