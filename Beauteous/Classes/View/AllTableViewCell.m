//
//  AllTableViewCell.m
//  Beauteous
//
//  Created by Kenichi Saito on 8/4/15.
//  Copyright (c) 2015 Kenichi Saito. All rights reserved.
//

#import "AllTableViewCell.h"

@implementation AllTableViewCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setDate:(Note *)note
{
    self.titleLabel.text = note.title;
    self.bodyLabel.attributedText = [self createBodyStringWithNote:note];
    
    NSLog(@"%@", [self pickUpURLFromString:note.htmlString]);
}

- (NSMutableAttributedString*)createBodyStringWithNote:(Note*)note
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat  = @"yyyy/MM/dd";
    NSAttributedString *dateAttrString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ", [df stringFromDate:note.updated_at]] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor], NSFontAttributeName: [UIFont fontWithName:@"Avenir-LightOblique" size:12]}];
    
    NSMutableAttributedString *bodyAttrString = [[NSMutableAttributedString alloc] initWithString:note.planeString];
    
    NSMutableAttributedString *bodyString = [[NSMutableAttributedString alloc] init];
    [bodyString appendAttributedString:dateAttrString];
    [bodyString appendAttributedString:bodyAttrString];
    
    NSLog(@"BODY STRING : %@", bodyString);
    
    return bodyString;
}

- (NSArray *)pickUpURLFromString:(NSString *)string {
    
    //--------------------------------------------------------------------------------
    // 検索
    //--------------------------------------------------------------------------------
    
    // 文字列抽出用の正規表現オブジェクトを生成する
    NSError *error = nil;
    NSString *URLPattern = @"(file://|http://|https://){1}[\\w\\.\\-/:]+";
    NSRegularExpression *regularExpressionForPickOut = [NSRegularExpression regularExpressionWithPattern:URLPattern options:0 error:&error];
    
    // 検索対象の文字列の中から正規表現にマッチした件数分の結果を取得
    NSArray *matchesInString = [regularExpressionForPickOut matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    // 検索結果を配列に入れる
    NSMutableArray *strings = [NSMutableArray array];
    for (int i=0 ; i<matchesInString.count ; i++) {
        NSTextCheckingResult *checkingResult = matchesInString[i];
        NSString *expressionPattern = [string substringWithRange:[checkingResult rangeAtIndex:0]];
        [strings addObject:expressionPattern];
    }
    return strings;
}

@end
