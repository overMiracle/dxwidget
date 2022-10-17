#import "DxwidgetPlugin.h"
#if __has_include(<dxwidget/dxwidget-Swift.h>)
#import <dxwidget/dxwidget-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "dxwidget-Swift.h"
#endif

@implementation DxwidgetPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDxwidgetPlugin registerWithRegistrar:registrar];
}
@end
