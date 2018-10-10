//
//  VFFromTheDepositTableViewCell.m
//  VFly
//
//  Created by Hcar on 2018/5/16.
//  Copyright © 2018年 VFly. All rights reserved.
//

#import "VFFromTheDepositTableViewCell.h"

@interface VFFromTheDepositTableViewCell() <UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webV;

@end

@implementation VFFromTheDepositTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //加载本地html文件
        NSString* path = [[NSBundle mainBundle] pathForResource:@"fromTheDeposit" ofType:@"html"];
        NSURL* url = [NSURL fileURLWithPath:path];
        
        NSURLRequest* request = [NSURLRequest requestWithURL:url];
        _webV =[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 100)];
        _webV.delegate = self;
        [self addSubview:_webV];
        [_webV loadRequest:request];
    }
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    CGFloat webViewHeight=[webView.scrollView contentSize].height;
    webView.scrollView.scrollEnabled = NO;
    CGRect newFrame = webView.frame;
    newFrame.size.height = webViewHeight;
    webView.height = webViewHeight;
    if ([self.delegate respondsToSelector:@selector(VFFromTheDepositTableViewCell:)]) {
        [self.delegate VFFromTheDepositTableViewCell:webViewHeight];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
