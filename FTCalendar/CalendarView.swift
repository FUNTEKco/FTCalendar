import UIKit
protocol CalendarViewDelegate: class {
    func finishDatePicking()
}

class CalendarView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    // Properties
    let arrowImageView = UIImageView()
    let startDateLabel = UILabel()
    let startWeekdayLabel = UILabel()
    let endDateLabel = UILabel()
    let endWeekdayLabel = UILabel()
    let doneButton = UIButton.init(type: .custom)
    let calendarCollectionView = UICollectionView.init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    var startIndexPath: IndexPath?
    var endIndexPath: IndexPath?
    var startDate: Date?
    var endDate: Date?
    
    let mainGreenColor = UIColor(red: (57/255.0), green: (112/255.0), blue: (31/255.0), alpha: 1.0)
    let darkGreenColor = UIColor(red: (29/255.0), green: (61/255.0), blue: (14/255.0), alpha: 1.0)
    let lightGreenColor = UIColor(red: (222/255.0), green: (235/255.0), blue: (97/255.0), alpha: 1.0)
    
    weak var delegate: CalendarViewDelegate?
    
    // MARK: Build View
    func buildView() {
        // background color
        self.backgroundColor = UIColor.white
        
        // corner radius
        let calendarViewPath = UIBezierPath(roundedRect:self.bounds,byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 12.5, height:  12.5))
        let calendarMaskLayer = CAShapeLayer()
        calendarMaskLayer.path = calendarViewPath.cgPath
        self.layer.mask = calendarMaskLayer
        
        // trip  label
        let dateLabelY = self.frame.height * 7 / 128
        let weekdayLabelY = dateLabelY + 26
        let rightLabelX = self.frame.width - 176
        
        self.startDateLabel.frame = CGRect.init(x: 23, y: dateLabelY , width: 150, height: 26)
        self.startDateLabel.text = "啟程"
        self.startDateLabel.textColor = UIColor.black.withAlphaComponent(0.15)
        self.startDateLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        self.startDateLabel.textAlignment = .left
        self.addSubview(self.startDateLabel)
        
        self.startWeekdayLabel.frame = CGRect.init(x: 23, y: weekdayLabelY, width: 150, height: 19)
        self.startWeekdayLabel.text = "點選日期"
        self.startWeekdayLabel.textColor = UIColor.black.withAlphaComponent(0.15)
        self.startWeekdayLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        self.startWeekdayLabel.textAlignment = .left
        self.addSubview(self.startWeekdayLabel)
        
        self.endDateLabel.frame = CGRect.init(x: rightLabelX, y: dateLabelY , width: 150, height: 26)
        self.endDateLabel.text = "回程"
        self.endDateLabel.textColor = UIColor.black.withAlphaComponent(0.15)
        self.endDateLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium)
        self.endDateLabel.textAlignment = .right
        self.addSubview(self.endDateLabel)
        
        self.endWeekdayLabel.frame = CGRect.init(x: rightLabelX, y: weekdayLabelY, width: 150, height: 19)
        self.endWeekdayLabel.text = "點選日期"
        self.endWeekdayLabel.textColor = UIColor.black.withAlphaComponent(0.15)
        self.endWeekdayLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        self.endWeekdayLabel.textAlignment = .right
        self.addSubview(self.endWeekdayLabel)
        
        // arrowImageView
        let arrowWidth = self.frame.width * 9 / 125
        let arrowHeight = arrowWidth * 17 / 27
        let arrowX = (self.frame.width - arrowWidth) / 2
        let arrowY = dateLabelY + 16
        self.arrowImageView.frame = CGRect.init(x: arrowX, y: arrowY, width: arrowWidth, height: arrowHeight)
        self.arrowImageView.image = #imageLiteral(resourceName: "ic_calendar_date")
        self.addSubview(self.arrowImageView)
        
        // weekday bar
        let weekdayHeaderWidth = self.frame.size.width - 46
        let weekdayHeaderY = weekdayLabelY + 41
        let weekdayHeader = UIView.init(frame: CGRect.init(x: 23, y: weekdayHeaderY, width: weekdayHeaderWidth, height: 1))
        weekdayHeader.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        self.addSubview(weekdayHeader)
        
        let weekdayFooter = UIView.init(frame: CGRect.init(x: 23, y: weekdayHeaderY + 40, width: weekdayHeaderWidth, height: 1))
        weekdayFooter.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        self.addSubview(weekdayFooter)
        
        let weekdays = ["日", "一", "二", "三", "四", "五", "六"]
        let weekdayLabelWidth = weekdayHeaderWidth / 7
        for (index, element) in weekdays.enumerated() {
            let weekdayLabel = UILabel.init(frame: CGRect.init(x: 23 + CGFloat(index) * weekdayLabelWidth, y: weekdayHeaderY, width: weekdayLabelWidth, height: 40))
            weekdayLabel.text = element
            weekdayLabel.textColor = UIColor.black.withAlphaComponent(0.8)
            weekdayLabel.textAlignment = .center
            weekdayLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
            self.addSubview(weekdayLabel)
        }
        
        // calendar collectionView
        // collectionView basic setting
        let calendarCollectionViewHeight = self.frame.height - (weekdayHeaderY + 42)
        self.calendarCollectionView.frame = CGRect.init(x: 23, y: weekdayHeaderY + 41, width: weekdayHeaderWidth + 0.1, height: calendarCollectionViewHeight)
        self.calendarCollectionView.backgroundColor = UIColor.white
        self.calendarCollectionView.showsVerticalScrollIndicator = false
        self.calendarCollectionView.allowsSelection = true
        
        // flowLayout
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize.init(width: weekdayLabelWidth, height: weekdayLabelWidth) // cell size
        layout.headerReferenceSize = CGSize.init(width: weekdayHeaderWidth, height: weekdayLabelWidth)
        layout.footerReferenceSize = CGSize.init(width: weekdayHeaderWidth, height: 1.0)
        // register cell
        self.calendarCollectionView.collectionViewLayout = layout
        self.calendarCollectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: "CalendarDayCell")
        // register header
        self.calendarCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,    withReuseIdentifier: "Header")
        // register footer
        self.calendarCollectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind :UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
        // data
        self.prepareCalendarSourceData()
        self.calendarCollectionView.delegate = self
        self.calendarCollectionView.dataSource = self
        
        self.addSubview(self.calendarCollectionView)
        
        // doneButton
        self.doneButton.frame = CGRect.init(x: self.frame.width - 73, y: self.frame.size.height - 73, width: 50, height: 50)
        self.doneButton.setImage(#imageLiteral(resourceName: "btn_calender_done"), for: .normal)
        self.doneButton.addTarget(self, action: #selector(CalendarView.doneButtonPressed), for: .touchUpInside)
        self.addSubview(self.doneButton)
    }
    
    // MARK: Function
    // button
    @objc func doneButtonPressed() {
        self.delegate?.finishDatePicking()
    }
    
    // MARK: UICollectionViewDelegate and DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cellNumbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellNumbers[section]
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind:  String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView = UICollectionReusableView()
        
        let monthLabel = UILabel.init(frame: .zero)
        
        if (kind == UICollectionView.elementKindSectionHeader) {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header", for: indexPath)
            for view in reusableView.subviews {
                view.removeFromSuperview()
            }
            monthLabel.frame.origin = CGPoint.init(x: 0, y: 0)
            monthLabel.frame.size = reusableView.frame.size
            monthLabel.textAlignment = .right
            monthLabel.textColor = UIColor.black.withAlphaComponent(0.8)
            monthLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
            
            let monthDate = months[indexPath.section]
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM, YYYY"
            
            monthLabel.text = dateFormatter.string(from: monthDate)
        } else if (kind == UICollectionView.elementKindSectionFooter) {
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer", for: indexPath)
            
            reusableView.backgroundColor = UIColor.black.withAlphaComponent(0.15)
        }
        reusableView.addSubview(monthLabel)
        
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as! CalendarDayCell
        
        cell.isSelected = true
        
        if (indexPath.row >= firstWeekdays[indexPath.section] - 1) {
            // day label
            cell.dayLabel.text = "\(indexPath.row - firstWeekdays[indexPath.section] + 2)"
            if (indexPath.row - firstWeekdays[indexPath.section] + 2 < dayMark && indexPath.section == 0 ) {
                cell.dayLabel.textColor = UIColor.black.withAlphaComponent(0.15)
            } else {
                cell.dayLabel.textColor = UIColor.black
            }
            // select mark
            if (indexPath == self.startIndexPath || indexPath == self.endIndexPath) {
                cell.dayLabel.textColor = UIColor.white
                cell.todayMarkView.backgroundColor = mainGreenColor
                cell.todayMarkView.isHidden = false
            }  else {
                cell.todayMarkView.backgroundColor = UIColor.clear
                cell.todayMarkView.isHidden = true
            }
            
            if let start = self.startIndexPath, let end = self.endIndexPath {
                if (start.section == end.section) {
                    if (indexPath.section == start.section && indexPath.row > start.row && indexPath.row < end.row){
                        cell.todayMarkView.backgroundColor = lightGreenColor
                        cell.todayMarkView.isHidden = false
                    }
                } else {
                    if (indexPath.section == start.section && indexPath.row > start.row) || (indexPath.section == end.section && indexPath.row < end.row) || (indexPath.section > start.section && indexPath.section < end.section) {
                        cell.todayMarkView.backgroundColor = lightGreenColor
                        cell.todayMarkView.isHidden = false
                    }
                }
            }
            // today mark
            if (indexPath.row - firstWeekdays[indexPath.section] + 2 == dayMark && indexPath.section == 0){
                cell.todayMarkView.layer.borderWidth = 1.0
                cell.todayMarkView.layer.borderColor = UIColor.black.withAlphaComponent(0.15).cgColor
                cell.todayMarkView.isHidden = false
            } else {
                cell.todayMarkView.layer.borderWidth = 0
                cell.todayMarkView.layer.borderColor = UIColor.clear.cgColor
            }
        } else {
            cell.dayLabel.text = ""
            cell.todayMarkView.isHidden = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard (!(indexPath.row - self.firstWeekdays[indexPath.section] + 2 < self.dayMark && indexPath.section == 0 )) else {
            return
        }
        
        let dayCalendar = Calendar.current
        let firstDate = months[indexPath.section]
        let dateNumber = indexPath.row - firstWeekdays[indexPath.section] + 2
        let month = dayCalendar.component(.month, from: firstDate)
        let year = dayCalendar.component(.year, from: firstDate)
        let dateComponents = DateComponents(year: year, month: month, day:dateNumber)
        
        if (self.startIndexPath == nil && self.endIndexPath == nil) {
            self.startIndexPath = indexPath
            self.startDate = dayCalendar.date(from: dateComponents)
        } else if (self.startIndexPath != nil && self.endIndexPath == nil) {
            if (indexPath.section < self.startIndexPath!.section) {
                self.startIndexPath = indexPath
                self.startDate = dayCalendar.date(from: dateComponents)
            } else if (indexPath.section == self.startIndexPath!.section){
                if (indexPath.row > self.startIndexPath!.row) {
                    self.endIndexPath = indexPath
                    self.endDate = dayCalendar.date(from: dateComponents)
                } else {
                    self.startIndexPath = indexPath
                    self.startDate = dayCalendar.date(from: dateComponents)
                }
            } else {
                self.endIndexPath = indexPath
                self.endDate = dayCalendar.date(from: dateComponents)
            }
        } else if (startIndexPath != nil && endIndexPath != nil) {
            self.startIndexPath = indexPath
            self.startDate = dayCalendar.date(from: dateComponents)
            self.endIndexPath = nil
            self.endDate = nil
        }
        
        self.calendarCollectionView.reloadData()
        
        // change date labels
        let monthDateFormatter = DateFormatter()
        monthDateFormatter.dateFormat = "MMM"
        
        let dayDateFormatter = DateFormatter()
        dayDateFormatter.dateFormat = "d"
        
        let weekDateFormatter = DateFormatter()
        weekDateFormatter.dateFormat = "EEEE"
        
        if let date = self.startDate {
            self.startDateLabel.text = "\(monthDateFormatter.string(from: date))\(dayDateFormatter.string(from: date))"
            self.startWeekdayLabel.text = weekDateFormatter.string(from: date)
            self.startDateLabel.textColor = mainGreenColor
            self.startWeekdayLabel.textColor = mainGreenColor
        } else {
            self.startDateLabel.text = "啟程"
            self.startWeekdayLabel.text = "點選日期"
            self.startDateLabel.textColor = UIColor.black.withAlphaComponent(0.15)
            self.startWeekdayLabel.textColor = UIColor.black.withAlphaComponent(0.15)
        }
        
        if let date = self.endDate {
            self.endDateLabel.text = "\(monthDateFormatter.string(from: date))\(dayDateFormatter.string(from: date))"
            self.endWeekdayLabel.text = weekDateFormatter.string(from: date)
            self.endDateLabel.textColor = mainGreenColor
            self.endWeekdayLabel.textColor = mainGreenColor
        } else {
            self.endDateLabel.text = "回程"
            self.endWeekdayLabel.text = "點選日期"
            self.endDateLabel.textColor = UIColor.black.withAlphaComponent(0.15)
            self.endWeekdayLabel.textColor = UIColor.black.withAlphaComponent(0.15)
        }
    }
    
    // MARK: data preparing
    var cellNumbers = Array<Int>.init()
    var firstWeekdays = Array<Int>.init()
    var months = Array<Date>.init()
    var daysNumbers = Array<Int>.init()
    var dayMark = 0
    
    func prepareCalendarSourceData() {
        let today = Date()
        let calendar = NSCalendar.current
        dayMark = calendar.component(.day, from: today)
        
        var counter = 0
        while (counter < 12) {
            let date = Calendar.current.date(byAdding: .month, value: counter, to: Date())!
            numOfCellsOfMonth(date: date)
            counter += 1
        }
    }
    
    func numOfCellsOfMonth(date: Date) {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let dateComponents = DateComponents(year: year, month: month, day:1)
        let firstDate = calendar.date(from: dateComponents)
        let firstWeekday = calendar.component(.weekday, from: firstDate!)
        
        let numOfCells = numDays + firstWeekday - 1
        
        
        cellNumbers.append(numOfCells)
        firstWeekdays.append(firstWeekday)
        months.append(firstDate!)
        daysNumbers.append(numDays)
    }
}
