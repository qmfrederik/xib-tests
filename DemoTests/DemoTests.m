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

- (void)testExample {
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
