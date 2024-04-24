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
    
    for (id element in topLevelObjects) {
        if ([element isKindOfClass:[NSMenu class]]) {
            menu = (NSMenu*)element;
            break;
        }
    }

    XCTAssertNotNil(menu);
    NSMenuItem* item1 = [menu itemAtIndex:0];
    NSMenuItem* item2 = [menu itemAtIndex:1];
    NSMenuItem* item3 = [menu itemAtIndex:2];
    NSMenuItem* item4 = [menu itemAtIndex:3];
    
    XCTAssertEqual([item1 keyEquivalentModifierMask], 0);
    XCTAssertEqual([item2 keyEquivalentModifierMask], NSShiftKeyMask);
    XCTAssertEqual([item3 keyEquivalentModifierMask], NSCommandKeyMask);
    XCTAssertEqual([item4 keyEquivalentModifierMask], NSAlternateKeyMask);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
