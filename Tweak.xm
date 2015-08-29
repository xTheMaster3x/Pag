#import "Pag.h"

static BOOL enabled;
static BookmarkFavoritesActionButton *PAGButton;

static void reloadPrefs() {
	//NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.xtm3x.pag.plist"];
	enabled = TRUE;//[dict objectForKey:@"enabled"] ? [[dict objectForKey:@"enabled"] boolValue] : YES; 
	//[dict release];
}

static BOOL isURL(NSString *URL) {
    NSURL *candidateURL = [NSURL URLWithString:URL];
    if (candidateURL && candidateURL.scheme && candidateURL.host) {
    	return YES;
	}
	else {
		return NO;
	}
}

//Draw Button
%hook BookmarkFavoritesActionsView
-(id)initWithFrame:(CGRect)frame {
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSString *copiedURL = pasteBoard.string;
    reloadPrefs();
	return (enabled && isURL(copiedURL)) ? %orig(CGRectMake(frame.origin.x,frame.origin.y,frame.size.width,frame.size.height + 44)) : %orig;
}
-(id)init{
    id retval = %orig;
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSString *copiedURL = pasteBoard.string;
    reloadPrefs();
    if (enabled && isURL(copiedURL)) {
        PAGButton = [[%c(BookmarkFavoritesActionButton) alloc] initWithFrame:CGRectMake(0,88,375,44)];
        VibrantLabelView* labelView = MSHookIvar<VibrantLabelView*>(PAGButton, "_label");
        UIImageView* glyphView = MSHookIvar<UIImageView*>(PAGButton, "_iconView");
        CGRect gframe = glyphView.frame;
        glyphView.frame = CGRectMake(gframe.origin.x,gframe.origin.y,20,27);
        glyphView.image = [[UIImage alloc] initWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/PasteNGo.png"];
        CGRect lframe = labelView.frame;
        labelView.frame = CGRectMake(lframe.origin.x,lframe.origin.y,lframe.size.width,21.5);
        labelView.text = @"Paste and Go";
        NSMutableArray* array = MSHookIvar<NSMutableArray*>(self, "_buttons");
        [self addSubview:PAGButton];
        [array addObject:PAGButton];
        [PAGButton release];
        [glyphView.image release];
    }
    return retval;
}
%end

//Make button appear on New Tab Page
%hook BookmarkFavoritesGridView
-(void)layoutSubviews {
    %orig;
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSString *copiedURL = pasteBoard.string;
    reloadPrefs();
    CGRect frame = [[UIScreen mainScreen] bounds];
    BookmarkFavoritesActionsView* actionsView = MSHookIvar<BookmarkFavoritesActionsView*>(self, "_actionsView");
    if (enabled && actionsView.window == nil && isURL(copiedURL)) {
        PAGButton = [[%c(BookmarkFavoritesActionButton) alloc] initWithFrame:CGRectMake(0,0,frame.size.width,44)];
        VibrantLabelView* labelView = MSHookIvar<VibrantLabelView*>(PAGButton, "_label");
        UIImageView* glyphView = MSHookIvar<UIImageView*>(PAGButton, "_iconView");
        PAGButton.backgroundColor = [UIColor whiteColor];
        PAGButton.alpha = 1.0;
        CGRect gframe = glyphView.frame;
        glyphView.frame = CGRectMake(gframe.origin.x,gframe.origin.y,20,27);
        glyphView.image = [[UIImage alloc] initWithContentsOfFile:@"/System/Library/CoreServices/SpringBoard.app/PasteNGo.png"];
        CGRect lframe = labelView.frame;
        labelView.frame = CGRectMake(lframe.origin.x,lframe.origin.y,lframe.size.width,21.5);
        labelView.text = @"Paste and Go";
        [self addSubview:PAGButton];
        [PAGButton release];
        [glyphView.image release];
        UIView* contentView = MSHookIvar<UIView*>(self, "_contentView");
        CGRect frame = contentView.frame;
        contentView.frame = CGRectMake(frame.origin.x,frame.origin.y + 44,frame.size.width,frame.size.height);
    }
}
%end

//Action for button press
%hook BookmarkFavoritesActionButton
- (void)_touchUp:(id)button {
    %orig;
    UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
    NSString *copiedURL = pasteBoard.string;
    if (button == PAGButton) {
        if (isURL(copiedURL)) {
            NSURL *urlToLoad = [NSURL URLWithString:copiedURL];
            [[UIApplication sharedApplication] openURL:urlToLoad];
        }
    }
}
%end