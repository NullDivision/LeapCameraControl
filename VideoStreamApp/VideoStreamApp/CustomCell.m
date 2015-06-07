//
//  CustomCell.m
//  Zatify
//
//  Created by Maxim Guzun on 4/22/13.
//  Copyright (c) 2013 Maxim Guzun. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
//-------------------------------------------------------------------------------------------------------------------
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
//-------------------------------------------------------------------------------------------------------------------
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//-------------------------------------------------------------------------------------------------------------------
- (int) getHeight
{
    return 0; // TODO in child class
}
//-------------------------------------------------------------------------------------------------------------------
+(NSString *)reuseIdentifier {
    return NSStringFromClass(self);
}
//-------------------------------------------------------------------------------------------------------------------
-(NSString*) reuseIdentifier {
    return [[self class] reuseIdentifier];
}
//-------------------------------------------------------------------------------------------------------------------
+ (id) getCell {
    return [[[NSBundle mainBundle]loadNibNamed:[self reuseIdentifier] owner:self options:nil] objectAtIndex:0];
}
//-------------------------------------------------------------------------------------------------------------------
@end
