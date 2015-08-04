//
//  BOUtility.m
//  Beauteous
//
//  Created by Kenichi Saito on 7/29/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "BOUtility.h"
#import "BOConst.h"

#import "GHMarkdownParser.h"


@implementation BOUtility

+ (UIFont*)fontTypeBookWithSize:(CGFloat)size
{
    return [UIFont fontWithName:BO_FONT_BOOK size:size];
}

+ (UIFont*)fontTypeHeavyWithSize:(CGFloat)size
{
    return [UIFont fontWithName:BO_FONT_HEAVY size:size];
}

+ (UIStoryboard*)storyboard
{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (UIBarButtonItem*)blankBarButton
{
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:nil
                                                                         action:nil];
    return backBarButtonItem;
}

+ (NSString*)renderHTMLWithString:(NSString*)string
{
    GHMarkdownParser* parser = [[GHMarkdownParser alloc] init];
    parser.options = kGHMarkdownAutoLink;
    parser.githubFlavored = YES;
    
    NSString *rendered = [parser HTMLStringFromMarkdownString:string];
    NSString *body = [NSString stringWithFormat:@"<article class=\"markdown-body\">%@</article>", rendered];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"github-markdown" ofType:@"css"];
    NSURL *url = [NSURL fileURLWithPath:path];
    
    NSString *style = [NSString stringWithFormat:@"<link rel=\"stylesheet\" href=\"%@\">", url];
    
    NSLog(@"HTML STRING: %@ %@", style, body);
    
    return [NSString stringWithFormat:@"%@%@", style, body];
}

@end
