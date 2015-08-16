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
#import "FlickrKit.h"

@implementation BOUtility

+ (UIFont*)fontTypeBookWithSize:(CGFloat)size
{
    return [UIFont fontWithName:BO_FONT_BOOK size:size];
}

+ (UIFont*)fontTypeHeavyWithSize:(CGFloat)size
{
    return [UIFont fontWithName:BO_FONT_HEAVY size:size];
}

+ (UIFont*)fontTypeMediumWithSize:(CGFloat)size
{
    return [UIFont fontWithName:BO_FONT_MEDIUM size:size];
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
    NSString *URLPattern = @"(file://|http://|https://){1}[\\w\\.\\-/:]+(jpg|png|gif)";
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

+ (UIImage *)screenShotScrollView:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointZero animated:NO];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    
    UIImage *image = nil;
    
    UIGraphicsBeginImageContextWithOptions(scrollView.contentSize, YES, 2.0);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil){
        return image;
    }
    
    return nil;
}

+ (NSData *)convertImageToPDF:(UIImage *)image
{
    return [BOUtility convertImageToPDF: image withResolution: 96];
}

+ (NSData *)convertImageToPDF:(UIImage *)image withResolution:(double)resolution
{
    return [BOUtility convertImageToPDF: image withHorizontalResolution: resolution verticalResolution: resolution];
}

+ (NSData *)convertImageToPDF:(UIImage *)image
     withHorizontalResolution:(double)horzRes
           verticalResolution:(double)vertRes
{
    if ((horzRes <= 0) || (vertRes <= 0)) {
        return nil;
    }
    
    double pageWidth = image.size.width * image.scale * 72 / horzRes;
    double pageHeight = image.size.height * image.scale * 72 / vertRes;
    
    NSMutableData *pdfFile = [[NSMutableData alloc] init];
    CGDataConsumerRef pdfConsumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)pdfFile);
    // The page size matches the image, no white borders.
    CGRect mediaBox = CGRectMake(0, 0, pageWidth, pageHeight);
    CGContextRef pdfContext = CGPDFContextCreate(pdfConsumer, &mediaBox, NULL);
    
    CGContextBeginPage(pdfContext, &mediaBox);
    CGContextDrawImage(pdfContext, mediaBox, [image CGImage]);
    CGContextEndPage(pdfContext);
    CGContextRelease(pdfContext);
    CGDataConsumerRelease(pdfConsumer);
    
    return pdfFile;
}

+ (CGRect)screenSize
{
    return [UIScreen mainScreen].bounds;
}

+ (BOOL)checkDevice
{
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return YES;
    }
    
    return NO;
}

+ (void)interestingImageFromFlickrWithCallback:(Callback)callback
{
    FlickrKit *fk = [FlickrKit sharedFlickrKit];
    FKFlickrInterestingnessGetList *interesting = [[FKFlickrInterestingnessGetList alloc] init];
    [fk call:interesting completion:^(NSDictionary *response, NSError *error) {
        // Note this is not the main thread!
        if (response) {
            NSMutableArray *photoURLs = [NSMutableArray array];
            NSLog(@"%@", response);
            for (NSDictionary *photoData in [response valueForKeyPath:@"photos.photo"]) {
                
                NSDictionary *dic = @{@"URL": [fk photoURLForSize:FKPhotoSizeLarge1024 fromPhotoDictionary:photoData],
                                      @"Title": photoData[@"title"]
                                      };
                
                [photoURLs addObject:dic];
            }
            
            callback(photoURLs, error);
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // Any GUI related operations here
//            });
        }
    }];
}

@end
