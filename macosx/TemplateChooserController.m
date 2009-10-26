
/**
 * OpenEmulator
 * Mac OS X Template Chooser Controller
 * (C) 2009 by Marc S. Ressl (mressl@umich.edu)
 * Released under the GPL
 *
 * Controls the new document from template window.
 */

#import "TemplateChooserController.h"

@implementation TemplateChooserController

- (id) init
{
	self = [super initWithWindowNibName:@"TemplateChooser"];
	
	if (self)
	{
		templateChooserViewController = [[TemplateChooserViewController alloc] init];
		[templateChooserViewController setDelegate:self];
	}
	
	return self;
}

- (void) dealloc
{
	[super dealloc];
	
	[templateChooserViewController release];
}

- (void) windowDidLoad
{
	[self setWindowFrameAutosaveName:@"TemplateChooser"];
	
	NSView *view = [templateChooserViewController view];
	[fChooserView addSubview:view];
	[view setFrame:[fChooserView bounds]];
	
	[self updateTemplates];
}

- (void) updateTemplates
{
	[templateChooserViewController updateUserTemplates];
	
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	NSString *itemPath = [userDefaults stringForKey:@"OELastTemplate"];
	[templateChooserViewController selectItemWithItemPath:itemPath];
	
	[[self window] center];
}

- (void) showWindow:(id) sender
{
	[self updateTemplates];
	
	[super showWindow:sender];
}

- (void) chooserWasDoubleClicked:(id) sender
{
	[self chooseTemplate:sender];
}

- (IBAction) chooseTemplate:(id) sender
{
	NSString *itemPath = [templateChooserViewController selectedItemPath];
	NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
	[userDefaults setObject:itemPath
					 forKey:@"OELastTemplate"];
	
	NSURL *url = [NSURL fileURLWithPath:itemPath];
	
	[[self window] orderOut:self];
	
	if (url)
	{
		NSError *error;
		if (![fDocumentController openUntitledDocumentFromTemplateURL:url
															  display:YES
																error:&error])
			[[NSAlert alertWithError:error] runModal];
	}
}

@end