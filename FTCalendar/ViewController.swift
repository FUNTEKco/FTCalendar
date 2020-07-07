import UIKit

class ViewController: UIViewController, CalendarViewDelegate {
    
    // Layout
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var calendarPickerButton: UIButton!
    let calendarBackgroundView = UIView()
    let calendarView = CalendarView()
    let calendarHidePosition = CGPoint.init(x: 0, y: UIScreen.main.bounds.height)
    let calendarShowPosition = CGPoint.init(x: 0, y: UIScreen.main.bounds.height * 155 / 677)
    
    // Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // calendar background view
        calendarBackgroundView.frame = self.view.frame
        calendarBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        self.view.addSubview(calendarBackgroundView)
        calendarBackgroundView.isHidden = true
        let calendarDismissTapRecognizer = UITapGestureRecognizer.init(target: self
            , action: #selector(self.hideCalendar))
        self.calendarBackgroundView.addGestureRecognizer(calendarDismissTapRecognizer)
        
        // calendarView
        self.calendarView.frame.size = CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 512 / 375)
        self.calendarView.frame.origin = self.calendarHidePosition
        self.calendarView.buildView()
        self.calendarView.delegate = self
        self.view.addSubview(calendarView)
    }

    @IBAction func calendarPicker(_ sender: Any) {
        self.showCalendar()
    }
    
    // MARK: Calendar Fucnctions
    func showCalendar(){
        self.view.endEditing(true)
        
        self.calendarBackgroundView.isHidden = false
        UIView.animate(withDuration: 0.5, animations: {
            self.calendarView.frame.origin = self.calendarShowPosition
        })
    }
    @objc func hideCalendar() {
        self.calendarBackgroundView.isHidden = true
        
        UIView.animate(withDuration: 0.5, animations: {
            self.calendarView.frame.origin = self.calendarHidePosition
        })
    }
    // calendar delegate function
    func finishDatePicking() {
        self.hideCalendar()
        guard (self.calendarView.startDate != nil && self.calendarView.endDate != nil) else {
            self.dateLabel.text = "--"
            return
        }
        let monthDateFormatter = DateFormatter()
        monthDateFormatter.dateFormat = "MMM"
        let dayDateFormatter = DateFormatter()
        dayDateFormatter.dateFormat = "d"
        let yearDateFormatter = DateFormatter()
        yearDateFormatter.dateFormat = "yyyy"
        
        let startDateString = "\(monthDateFormatter.string(from: self.calendarView.startDate!))\(dayDateFormatter.string(from: self.calendarView.startDate!))"
        let endDateString = "\(monthDateFormatter.string(from: self.calendarView.endDate!))\(dayDateFormatter.string(from: self.calendarView.endDate!))"
        let yearString = yearDateFormatter.string(from: self.calendarView.startDate!)
        
        self.dateLabel.text = "\(startDateString) - \(endDateString), \(yearString)"
    }

}

