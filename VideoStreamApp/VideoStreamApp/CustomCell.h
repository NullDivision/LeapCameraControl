//
//  CustomCell.h
//  Zatify
//
//  Created by Maxim Guzun on 4/22/13.
//  Copyright (c) 2013 Maxim Guzun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell{
    UIView  *bgColorView;
}
- (int) getHeight;  // TODO in child class
+ (NSString *)reuseIdentifier;
+ (id) getCell;
@end
