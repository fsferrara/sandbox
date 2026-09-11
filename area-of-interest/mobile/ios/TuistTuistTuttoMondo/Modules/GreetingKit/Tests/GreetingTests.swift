import Testing
@testable import GreetingKit

struct GreetingTests {
    @Test
    func messageGreetsTheWorld() {
        #expect(Greeting.message == "Tuist Tuist... tutto il mondo!")
    }
}
