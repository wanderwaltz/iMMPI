import XCTest
@testable import iMMPI

final class DatePickerViewControllerTests: XCTestCase {
    func testThat__it_has_current_date_by_default() {
        let currentDate = Date()
        let controller = DatePickerViewController(nibName: nil, bundle: nil)

        let distanceFromCurrentDate = abs(controller.date.timeIntervalSince(currentDate))

        // Assume tolerance of one second is enough
        XCTAssertLessThan(distanceFromCurrentDate, 1.0)
    }

    func testThat__it_allows_setting_date() {
        let controller = DatePickerViewController(nibName: nil, bundle: nil)
        let expectedDate = Date(timeIntervalSince1970: 123)

        controller.date = expectedDate

        XCTAssertEqual(controller.date, expectedDate)
    }

    func testThat__its_view_size_is_equal_to_its_preferred_content_size() {
        let controller = DatePickerViewController(nibName: nil, bundle: nil)

        XCTAssertEqual(controller.view.bounds.size, controller.preferredContentSize)
    }

    func testThat__it_notifies_its_delegate_when_date_picker_sends_value_changed_event() {
        let controller = DatePickerViewController(nibName: nil, bundle: nil)
        let delegate = TestDelegate()

        var receivedController: DatePickerViewController?
        var receivedDate: Date?

        delegate.handler = {
            receivedController = $0
            receivedDate = $1
        }

        controller.delegate = delegate

        let datePicker = controller.view.subviews.first as? UIDatePicker
        XCTAssertNotNil(datePicker)

        controller.date = Date(timeIntervalSince1970: 456)
        datePicker?.sendActions(for: .valueChanged)

        XCTAssertTrue(receivedController === controller)
        XCTAssertEqual(receivedDate, controller.date)
    }

    final class TestDelegate: DatePickerViewControllerDelegate {
        var handler: (DatePickerViewController, Date) -> Void = { _, _ in }

        func datePickerViewController(_ datePickerViewController: DatePickerViewController, didSelect date: Date) {
            handler(datePickerViewController, date)
        }
    }
}
