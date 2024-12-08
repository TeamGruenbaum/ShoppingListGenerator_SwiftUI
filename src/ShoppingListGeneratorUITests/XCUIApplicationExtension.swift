import XCTest

extension XCUIApplication
{
    func setStepperValue(accessibilityIdentifier:String, currentValue:Int, targetValue:Int)->Void
    {
        guard self.steppers[accessibilityIdentifier].exists else
        {
            XCTFail("Stepper with accessibilityIdentifier \"\(accessibilityIdentifier)\" does not exist");
            return;
        }
        
        let tapTimes:Int=targetValue-currentValue;
        
        if(tapTimes==0){return}
        
        for _ in 1...(abs(tapTimes))
        {
            if(tapTimes>0)
            {
                self.steppers[accessibilityIdentifier].coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5)).tap()
            }
            else
            {
                self.steppers[accessibilityIdentifier].coordinate(withNormalizedOffset: CGVector(dx: 0.4, dy: 0.5)).tap()
            }
        }
    }
}
