//
//  DemoTests.m
//  DemoTests
//
//  Created by Frederik Carlier on 24/04/2024.
//

#import <XCTest/XCTest.h>

@interface DemoTests : XCTestCase

@end

@implementation DemoTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

// menu item encoding uses NSKeyEquivModMask, with no byte shift
- (void)testMenuItemEncoding {
    NSMenuItem* item = [[NSMenuItem alloc] init];
    item.keyEquivalentModifierMask = NSShiftKeyMask;
    NSNumber* encodedKeyMask = [self getEncodedKeyMask:item withKey:@"NSKeyEquivModMask"];
    
    XCTAssertNotNil(encodedKeyMask);
    XCTAssertEqual([encodedKeyMask intValue], NSShiftKeyMask);
}

// button cell encoding uses NSButtonFlags2, with a 8-bit left shift
- (void)testButtonCellEncoding {
    int mask = NSShiftKeyMask;
    
    NSButtonCell* item = [[NSButtonCell alloc] init];
    item.keyEquivalent = @"A";
    item.keyEquivalentModifierMask = mask;
    NSNumber* encodedKeyMask = [self getEncodedKeyMask:item withKey:@"NSButtonFlags2"];
    
    XCTAssertNotNil(encodedKeyMask);
    NSLog(@"Got 0x%x; expecting 0x%x", [encodedKeyMask intValue], mask << 8);
    XCTAssertEqual(([encodedKeyMask intValue] & NSEventModifierFlagDeviceIndependentFlagsMask << 8), mask << 8);
}


- (NSNumber*)getEncodedKeyMask:(id)item withKey:(NSString*) key {
    NSKeyedArchiver* archiver =[[NSKeyedArchiver alloc] init];
    [archiver encodeRootObject:item];
    [archiver finishEncoding];
    
    NSData* data = [archiver encodedData];
    NSError* error;
    NSDictionary* archive = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListImmutable format:nil error:&error];
    
    NSArray* topLevelObjects = [archive objectForKey:@"$objects"];
    
    NSDictionary* dict;
    
    for (id element in topLevelObjects) {
        if ([element isKindOfClass:[NSDictionary class]]) {
            dict = (NSDictionary*)element;
            
            if ([[dict allKeys] containsObject:key]) {
                break;
            } else {
                dict = nil;
            }
        }
    }
    
    if (dict == nil) {
        return nil;
    }
    
    return [dict valueForKey:key];
}

- (void)testXibLoading {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    NSArray* topLevelObjects;
    BOOL success = [[NSBundle mainBundle] loadNibNamed:@"MainMenu" owner:nil topLevelObjects:&topLevelObjects];
    XCTAssertTrue(success);
    
    NSMenu* menu;
    NSMatrix* matrix;
    
    for (id element in topLevelObjects) {
        if ([element isKindOfClass:[NSMenu class]]) {
            menu = (NSMenu*)element;
        }
        
        if ([element isKindOfClass:[NSMatrix class]]) {
            matrix = (NSMatrix*)element;
        }
    }

    XCTAssertNotNil(menu);
    XCTAssertNotNil(matrix);
    
    //
    // Test NSMenuItem
    //

    // Empty <modifierMask key="keyEquivalentModifierMask"/> node
    XCTAssertEqual([[menu itemAtIndex:0] keyEquivalentModifierMask], 0);
    // <modifierMask key="keyEquivalentModifierMask" shift="YES"/>
    XCTAssertEqual([[menu itemAtIndex:1] keyEquivalentModifierMask], NSShiftKeyMask);
    // <modifierMask key="keyEquivalentModifierMask" command="YES"/>
    XCTAssertEqual([[menu itemAtIndex:2] keyEquivalentModifierMask], NSCommandKeyMask);
    // <modifierMask key="keyEquivalentModifierMask" option="YES"/>
    XCTAssertEqual([[menu itemAtIndex:3] keyEquivalentModifierMask], NSAlternateKeyMask);
    // No modifierMask element
    XCTAssertEqual([[menu itemAtIndex:4] keyEquivalentModifierMask], NSCommandKeyMask);
    // No modifierMask element and no keyEquivalent attribute
    XCTAssertEqual([[menu itemAtIndex:5] keyEquivalentModifierMask], NSCommandKeyMask);
    
    // no modfierMask
    XCTAssertEqual([[menu itemAtIndex:6] keyEquivalentModifierMask], NSCommandKeyMask);
    // empty modifierMask
    XCTAssertEqual([[menu itemAtIndex:7] keyEquivalentModifierMask], 0);
    // explicit modifier mask
    XCTAssertEqual([[menu itemAtIndex:8] keyEquivalentModifierMask], NSCommandKeyMask);

    //
    // Test NSButtonCell
    //
    NSArray* cells = [matrix cells];
    XCTAssertEqual([[cells objectAtIndex:0] keyEquivalentModifierMask], NSCommandKeyMask | NSShiftKeyMask);
    XCTAssertEqual([[cells objectAtIndex:1] keyEquivalentModifierMask], 0);
    
    // Unlike NSMenuItem, the default for NSButtonCell is 0
    XCTAssertEqual([[cells objectAtIndex:2] keyEquivalentModifierMask], 0);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
