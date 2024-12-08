import XCTest

extension XCUIElement
{
    func clearAndEnterText(text:String)
    {
        guard let stringValue = self.value as? String else
        {
            XCTFail("Tried to clear and enter text into a non string value");
            return;
        }

        self.tap(withNumberOfTaps: 4, numberOfTouches: 1)
        self.typeText(String(repeating: XCUIKeyboardKey.delete.rawValue, count: 1))
        self.typeText(text)
    }
}
