//
//  CePolyglotte.m
//
//  Created by Renaud Pradenc on 31/01/12.
//

#import "CePolyglotte.h"

@interface CePolyglotte ( /* Private methods */ )

- (void) _translateView:(NSView *)view;
- (void) _translateMenu:(NSMenu *)menu;
- (void) _translateMenuItems:(NSArray *)menuItems;
- (void) _translateWindow:(NSWindow *)window;
- (void) _translateToolbar:(NSToolbar *)toolbar;
- (NSString *) _translationForKey:(NSString *)key;

@end

@implementation CePolyglotte

// MARK: Properties
@synthesize delegate;
@synthesize topLevelView;
@synthesize topLevelMenu;
@synthesize topLevelWindow;

// MARK: Translation
- (void )awakeFromNib
{    
    if(topLevelView)
        [self _translateView:topLevelView];
    
    if(topLevelMenu)
        [self _translateMenu:topLevelMenu];
    
    if(topLevelWindow)
        [self _translateWindow:topLevelWindow];
}

- (void) _translateView:(NSView *)view
{
    
    // NSBox, NSButton: title property
    if([view isKindOfClass:[NSBox class]] 
       || [view isKindOfClass:[NSButton class]])
    {
        NSString *key = [(id)view title];
        [(id)view setTitle:[self _translationForKey:key]];
    }
    
    // NSTextField: stringValue property
    else if([view isKindOfClass:[NSTextField class]])
    {
        NSString *key = [(id)view stringValue];
        if(![key isEqualToString:@""])  // The text might be set by bindings
            [(id)view setStringValue:[self _translationForKey:key]];       
    }
    
    // NSSegmentedControl
    else if([view isKindOfClass:[NSSegmentedControl class]])
    {    
        NSInteger segmentCount = [(NSSegmentedControl *)view segmentCount];
        NSInteger segmentIndex;
        for(segmentIndex = 0; segmentIndex < segmentCount; segmentIndex++)
        {
            NSString *key = [(NSSegmentedControl *)view labelForSegment:segmentIndex];
            [(NSSegmentedControl *)view setLabel:[self _translationForKey:key] 
                                      forSegment:segmentIndex];
        }
    }
    
    // NSTableView
    else if([view isKindOfClass:[NSTableView class]])
    {
        NSTableView *table = (NSTableView *)view;
        
        for(NSTableColumn *column in table.tableColumns)
        {
            NSTableHeaderCell *headerCell = column.headerCell;
            NSString *key = headerCell.title;
            headerCell.title = [self _translationForKey:key];
        }
    }
    
    // Tooltip
    if(view.toolTip)
    {
        view.toolTip = [self _translationForKey:view.toolTip];
    }
    
    // Recursively translate its subviews
    for(NSView *subview in view.subviews)
    {
        [self _translateView:subview];
    }
}

- (void) _translateMenu:(NSMenu *)menu
{
    // Translate the title
    menu.title = [self _translationForKey:menu.title];
    
    [self _translateMenuItems:menu.itemArray];
}

- (void) _translateMenuItems:(NSArray *)menuItems
{
    for(NSMenuItem *item in menuItems)
    {
        item.title = [self _translationForKey:item.title];
        
        // Recursively translate submenus of the menu item
        if([item hasSubmenu])
        {
            NSMenu *submenu = item.submenu;
            submenu.title = [self _translationForKey:submenu.title];
            [self _translateMenuItems:submenu.itemArray];
        }
    }    
}


- (void) _translateWindow:(NSWindow *)window
{
    // Translate the tile
    window.title = [self _translationForKey:window.title];
    
    // Translate the content view and its subviews
    [self _translateView:window.contentView];
    
    if(window.toolbar)
        [self _translateToolbar:window.toolbar];
}


- (void) _translateToolbar:(NSToolbar *)toolbar
{
    for(NSToolbarItem *item in toolbar.items)
    {
        item.label = [self _translationForKey:item.label];
        item.paletteLabel = [self _translationForKey:item.paletteLabel];
    }
}


// When no translation is found, the key is returned, so the object keeps its current title
- (NSString *) _translationForKey:(NSString *)key
{
    NSString *translation = [[NSBundle mainBundle] localizedStringForKey:key value:key table:[delegate localizedStringsFile]];
    
    return translation;
}


@end
