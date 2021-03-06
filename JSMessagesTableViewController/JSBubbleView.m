//
//  JSBubbleView.m
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

#import "JSBubbleView.h"
#import "JSMessageInputView.h"
#import "NSString+JSMessagesView.h"

#define kMarginTop 8.0f
#define kMarginBottom 4.0f
#define kPaddingTop 4.0f
#define kPaddingBottom 8.0f
#define kBubblePaddingRight 35.0f

@interface JSBubbleView()

- (void)setup;
- (BOOL)styleIsOutgoing;

@end



@implementation JSBubbleView

@synthesize style;
@synthesize text;

#pragma mark - Initialization
- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
}

- (id)initWithFrame:(CGRect)frame bubbleStyle:(JSBubbleMessageStyle)bubbleStyle
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
        self.style = bubbleStyle;
    }
    return self;
}

#pragma mark - Setters
- (void)setStyle:(JSBubbleMessageStyle)newStyle
{
    style = newStyle;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)newText
{
    text = newText;
    [self setNeedsDisplay];
}

-(void)setAuthor:(NSString *)author{
    _author = author;
    [self setNeedsDisplay];
}
#pragma mark - Drawing
- (void)drawRect:(CGRect)frame
{
    
    NSString *author_text =[NSString stringWithFormat:@"%@ said:",self.author];
    CGSize author_size = CGSizeZero;
    if (self.author){
        author_size = [self textSizeForAuthor:author_text];
    }
    
	UIImage *image = [JSBubbleView bubbleImageForStyle:self.style];
    CGSize bubbleSize = [self bubbleSizeForText:self.text];
    
 	CGRect bubbleFrame = CGRectMake(([self styleIsOutgoing] ? self.frame.size.width - bubbleSize.width : 0.0f),
                                    kMarginTop,
                                    MAX(bubbleSize.width,author_size.width +kBubblePaddingRight),
                                    bubbleSize.height + author_size.height);
    
	[image drawInRect:bubbleFrame];
   
    
    CGFloat textX = (CGFloat)image.leftCapWidth - 3.0f + ([self styleIsOutgoing] ? bubbleFrame.origin.x : 0.0f);
    if (self.author){
        CGRect author_rect = CGRectMake(textX,
                                        kPaddingTop + kMarginTop,
                                        author_size.width,
                                        author_size.height );
        
        [author_text drawInRect:author_rect withFont:[JSBubbleView authorFont] lineBreakMode:NSLineBreakByTruncatingMiddle alignment:NSTextAlignmentLeft];
        
           }
    
	CGSize textSize = [self textSizeForText:self.text];
	
    CGRect textFrame = CGRectMake(textX,
                                  kPaddingTop + kMarginTop + author_size.height,
                                  textSize.width,
                                  textSize.height);
    
    
   // UIBezierPath *p = [UIBezierPath bezierPathWithRect:textFrame];
   // [p stroke];
    
	[self.text drawInRect:textFrame
                 withFont:[JSBubbleView font]
            lineBreakMode:NSLineBreakByWordWrapping
                alignment:NSTextAlignmentLeft];
}

#pragma mark - Bubble view
- (BOOL)styleIsOutgoing
{
    return (self.style == JSBubbleMessageStyleOutgoingDefault
            || self.style == JSBubbleMessageStyleOutgoingDefaultGreen
            || self.style == JSBubbleMessageStyleOutgoingSquare);
}

+ (UIImage *)bubbleImageForStyle:(JSBubbleMessageStyle)style
{
    switch (style) {
        case JSBubbleMessageStyleIncomingDefault:
            return [[UIImage imageNamed:@"messageBubbleGray"] stretchableImageWithLeftCapWidth:23 topCapHeight:15];
        case JSBubbleMessageStyleIncomingSquare:
            return [[UIImage imageNamed:@"bubbleSquareIncoming"] stretchableImageWithLeftCapWidth:25 topCapHeight:15];
            break;
            break;
        case JSBubbleMessageStyleOutgoingDefault:
            return [[UIImage imageNamed:@"messageBubbleBlue"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
            break;
        case JSBubbleMessageStyleOutgoingDefaultGreen:
            return [[UIImage imageNamed:@"messageBubbleGreen"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
            break;
        case JSBubbleMessageStyleOutgoingSquare:
            return [[UIImage imageNamed:@"bubbleSquareOutgoing"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
            break;
    }
    
    return nil;
}

+(UIFont *)authorFont{
    return [UIFont italicSystemFontOfSize:10.0];
}
+ (UIFont *)font
{
    return [UIFont systemFontOfSize:16.0f];
}



+ (CGSize)textSizeForText:(NSString *)txt font:(UIFont *)font viewWidth:(CGFloat)width
{
    width = width * 0.65f;
    CGFloat height = 2000.0;
    CGSize ret = [txt sizeWithFont:font
                 constrainedToSize:CGSizeMake(width, height)
                     lineBreakMode:NSLineBreakByWordWrapping];
    return ret;
}
+ (CGSize)textSizeForText:(NSString *)txt viewWidth:(CGFloat)width{
    return [JSBubbleView textSizeForText:txt font:[JSBubbleView font] viewWidth:width];
}
- (CGSize)textSizeForText:(NSString *)txt{
    return [JSBubbleView textSizeForText:txt font:[JSBubbleView font] viewWidth:self.bounds.size.width];
}

+ (CGSize)textSizeForAuthor:(NSString *)txt viewWidth:(CGFloat)width{
    return [self textSizeForText:txt font:[JSBubbleView authorFont] viewWidth:width];
}


- (CGSize)textSizeForAuthor:(NSString *)txt{
    return [JSBubbleView textSizeForText:txt font:[JSBubbleView authorFont] viewWidth:self.bounds.size.width];
}

- (CGSize)bubbleSizeForText:(NSString *)txt
{
	CGSize textSize = [self textSizeForText:txt];
	return CGSizeMake(textSize.width + kBubblePaddingRight,
                      textSize.height + kPaddingTop + kPaddingBottom);
}


+ (CGSize)bubbleSizeForText:(NSString *)txt viewWidth:(CGFloat)width
{
	CGSize textSize = [JSBubbleView textSizeForText:txt viewWidth:width];
    
	return CGSizeMake(textSize.width + kBubblePaddingRight,
                      textSize.height + kPaddingTop + kPaddingBottom);
}

+ (CGFloat)cellHeightForText:(NSString *)txt viewWidth:(CGFloat)width
{
    return [JSBubbleView bubbleSizeForText:txt viewWidth:width].height + kMarginTop + kMarginBottom;
}


- (CGFloat)cellHeightForText:(NSString *)txt
{
    return [self bubbleSizeForText:txt].height + kMarginTop + kMarginBottom;
}

+ (int)maxCharactersPerLine
{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 33 : 109;
}

+ (int)numberOfLinesForMessage:(NSString *)txt
{
    return (txt.length / [JSBubbleView maxCharactersPerLine]) + 1;
}

@end