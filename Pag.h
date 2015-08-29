#import <UIKit/UIColor.h>

@interface WKWebView : UIView
@end

@interface BookmarkFavoritesActionsView : UIView
@end

@interface SafariWebView : WKWebView
- (id)initWithFrame:(CGRect)arg1 configuration:(id)arg2;
@end

@interface VibrantLabelView : UIView
{
    UILabel *_label;
    NSString *_text;
}

@property(retain, nonatomic) NSString *text;
- (id)initWithFrame:(CGRect)arg1;
@end

@interface BookmarkFavoritesActionButton : UIButton {
    UIImageView *_iconView;
    VibrantLabelView *_label;
}
- (void)_touchDown:(id)arg1;
- (id)initWithFrame:(CGRect)arg1;
@end