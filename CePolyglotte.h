//
//  CePolyglotte.h
//
//  Created by Renaud Pradenc on 31/01/12.
//

#import <Foundation/Foundation.h>

@protocol CePolyglotteDelegate

// This method must be implemented by the delegate. 
// Return the name of the strings file (without the .strings extension) which stores localized strings for this nib.
- (NSString *) localizedStringsFile;

@end


@interface CePolyglotte : NSObject
{
    IBOutlet id <CePolyglotteDelegate> delegate;
    IBOutlet NSView *topLevelView;
    IBOutlet NSMenu *topLevelMenu;
    IBOutlet NSWindow *topLevelWindow;
}

@property (nonatomic, assign) IBOutlet id <CePolyglotteDelegate> delegate;
@property (nonatomic, assign) IBOutlet NSView *topLevelView;
@property (nonatomic, assign) IBOutlet NSMenu *topLevelMenu;
@property (nonatomic, assign) IBOutlet NSWindow *topLevelWindow;


@end
