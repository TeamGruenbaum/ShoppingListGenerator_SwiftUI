import XCTest
@testable import ShoppingListGenerator;
import CoreData;

class CoreDataLayerTests: XCTestCase
{
    func testCoreDataLayer()
    {
        XCTAssertEqual(CoreDataLayer.instance.persistentContainer.name, "DataModel");
    }
}
