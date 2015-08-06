//
//  BOUtility.m
//  Beauteous
//
//  Created by Kenichi Saito on 7/29/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "BOUtility.h"
#import "BOConst.h"
#import "Bolts.h"

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
    
    // NSLog(@"HTML STRING: %@ %@", style, body);
    
    return [NSString stringWithFormat:@"%@%@", style, body];
}

+ (UIColor*)pinkColor
{
    return [UIColor colorWithRed:246 / 255.0 green:36 / 255.0 blue:89 /255.0 alpha:1.0];
}

+ (UIColor*)yellowColor
{
    return [UIColor colorWithRed:236/255.0 green:185/255.0 blue:53/255.0 alpha:1.0];
}

+ (NSArray*)pickUpURLFromString:(NSString *)string
{
    NSError *error = nil;
    NSString *URLPattern = @"(file://|http://|https://){1}[\\w\\.\\-/:]+(jpg|png)";
    NSRegularExpression *regularExpressionForPickOut = [NSRegularExpression regularExpressionWithPattern:URLPattern options:0 error:&error];
    
    NSArray *matchesInString = [regularExpressionForPickOut matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    NSMutableArray *strings = [NSMutableArray array];
    for (int i=0 ; i<matchesInString.count ; i++) {
        NSTextCheckingResult *checkingResult = matchesInString[i];
        NSString *expressionPattern = [string substringWithRange:[checkingResult rangeAtIndex:0]];
        [strings addObject:expressionPattern];
    }
    return strings;
}

+ (void)getQuoteTodayWithBlock:(callback)callback
{
    NSURL *URL = [NSURL URLWithString:@"http://api.theysaidso.com/qod.json"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithURL:URL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (error) {
            NSLog(@"%@", error);
            if (callback) {
                callback(nil, error);
            }
        } else {
            NSLog(@"RESPONSE: %@, DATA: %@", response, data);
            if (callback) {
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
                callback(json, error);
            }
        }
    }];
    
    [task resume];
}

@end
