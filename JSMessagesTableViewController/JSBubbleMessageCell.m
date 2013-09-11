//
//  JSBubbleMessageCell.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//  http://www.hexedbits.com
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#define AVATAR_SPACE 44.0
#import "JSBubbleMessageCell.h"
#import "UIColor+JSMessagesView.h"
#import <QuartzCore/QuartzCore.h>
#import <JGAFImageCache.h>
@interface JSBubbleMessageCell()

@property (strong, nonatomic) JSBubbleView *bubbleView;
@property (strong, nonatomic) UILabel *timestampLabel;



- (void)setup;
- (void)configureTimestampLabel;
- (void)configureWithStyle:(JSBubbleMessageStyle)style timestamp:(BOOL)hasTimestamp;

@end



@implementation JSBubbleMessageCell

#pragma mark - Initialization
- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    self.imageView.image = nil;
    self.imageView.hidden = YES;
    self.textLabel.text = nil;
    self.textLabel.hidden = YES;
    self.detailTextLabel.text = nil;
    self.detailTextLabel.hidden = YES;
}

- (void)configureTimestampLabel
{
    self.timestampLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f,
                                                                    4.0f,
                                                                    self.bounds.size.width,
                                                                    14.5f)];
    self.timestampLabel.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
    self.timestampLabel.backgroundColor = [UIColor clearColor];
    self.timestampLabel.textAlignment = NSTextAlignmentCenter;
    self.timestampLabel.textColor = [UIColor messagesTimestampColor];
    self.timestampLabel.shadowColor = [UIColor whiteColor];
    self.timestampLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.timestampLabel.font = [UIFont boldSystemFontOfSize:11.5f];
    
    [self.contentView addSubview:self.timestampLabel];
    [self.contentView bringSubviewToFront:self.timestampLabel];
}

- (void)configureWithStyle:(JSBubbleMessageStyle)style timestamp:(BOOL)hasTimestamp
{
      
    self.bubbleView = [[JSBubbleView alloc] initWithFrame:CGRectZero
                                              bubbleStyle:style];
    
    self.bubbleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.contentView addSubview:self.bubbleView];
    [self.contentView sendSubviewToBack:self.bubbleView];
    
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    JSBubbleMessageStyle style = self.bubbleView.style;

    CGFloat bubbleY = 0.0f;
    
    if(NO) {
        [self configureTimestampLabel];
        bubbleY = 14.0f;
    }
    
    
    
    
    CGRect full_frame = CGRectMake(0.0f,
                                   bubbleY,
                                   self.contentView.frame.size.width,
                                   self.contentView.frame.size.height - self.timestampLabel.frame.size.height);
    
    
    CGRect bubble_frame = full_frame;
    if (self.show_avatars && (style == JSBubbleMessageStyleIncomingDefault || style == JSBubbleMessageStyleIncomingSquare)){
        
        
        bubble_frame = CGRectMake(bubble_frame.origin.x +  AVATAR_SPACE, bubble_frame.origin.y, bubble_frame.size
                                  .width-AVATAR_SPACE, bubble_frame.size.height);
        
       
        
        
        self.avatar.hidden = NO;
        
        CGRect avatar_frame = full_frame;
        
        avatar_frame.size.width = AVATAR_SPACE;
       
        avatar_frame.origin.y = avatar_frame.size.height - AVATAR_SPACE;
        avatar_frame.origin.x = avatar_frame.origin.x + 2.0;
        avatar_frame.size.height = AVATAR_SPACE;
        
        
        avatar_frame = CGRectInset(avatar_frame, 4.0, 4.0);
        self.avatar.frame = avatar_frame;
        
    }else{
        _avatar.hidden = YES;
    }
    
    self.bubbleView.frame = bubble_frame;
    
    

    
}

- (id)initWithBubbleStyle:(JSBubbleMessageStyle)style hasTimestamp:(BOOL)hasTimestamp reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self) {
        [self setup];
        [self configureWithStyle:style timestamp:hasTimestamp];
    }
    return self;
}

- (id)initWithBubbleStyle:(JSBubbleMessageStyle)style
             hasTimestamp:(BOOL)hasTimestamp
                   avatar:(NSURL *)avatar_url
                 username:(NSString *)username
          reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [self initWithBubbleStyle:style hasTimestamp:hasTimestamp reuseIdentifier:reuseIdentifier];
    if (self) {
        _avatar_url = avatar_url;
        _username = username;
    }
    return self;
}

#pragma mark - Setters
- (void)setBackgroundColor:(UIColor *)color
{
    [super setBackgroundColor:color];
    [self.contentView setBackgroundColor:color];
    [self.bubbleView setBackgroundColor:color];
}

#pragma mark - Message Cell
- (void)setMessage:(NSString *)msg
{
    self.bubbleView.text =msg;
    
                           //setVersion:<#(NSInteger)#>] msg;
}

- (void)setTimestamp:(NSDate *)date
{
    self.timestampLabel.text = [NSDateFormatter localizedStringFromDate:date
                                                              dateStyle:NSDateFormatterMediumStyle
                                                              timeStyle:NSDateFormatterShortStyle];
}


#pragma mark - Avatar 

-(UIImageView *)avatar{
    if (!_avatar){
        _avatar = [[UIImageView alloc] initWithFrame:CGRectZero];
        _avatar.layer.cornerRadius = 2.0;
        _avatar.layer.shadowColor = [UIColor blackColor].CGColor;
        _avatar.layer.shadowOpacity = 0.4;
        _avatar.layer.shadowOffset = CGSizeMake(0.5, 0.5);
        _avatar.layer.shadowRadius = 1.0;
        _avatar.backgroundColor = [UIColor whiteColor];
    }
    
    [self.contentView addSubview:_avatar];
    return _avatar;
}

-(void)setAvatar_url:(NSURL *)avatar_url{
    _avatar_url =  avatar_url;
    if (self.avatar_url){
        self.show_avatars = YES;
        [[JGAFImageCache sharedInstance] imageForURL:[avatar_url absoluteString] completion:^(UIImage *image) {
            self.avatar.image = image;
        }];

    }else{
        self.avatar.image = nil;
        self.show_avatars = NO;
    }
    
}
-(void)setUsername:(NSString *)username{
    _username = username;
    if (self.bubbleView.style == JSBubbleMessageStyleIncomingDefault || self.bubbleView.style == JSBubbleMessageStyleIncomingSquare)
        self.bubbleView.author = username;
    else
        self.bubbleView.author = nil;
}
@end