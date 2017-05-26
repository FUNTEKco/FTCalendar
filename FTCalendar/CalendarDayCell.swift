//
import UIKit

class CalendarDayCell: UICollectionViewCell {
    var dayLabel: UILabel!
    var todayMarkView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // todayMarkView
        todayMarkView = UIView()
        todayMarkView.frame.origin = CGPoint.init(x: (self.frame.size.width - 30) / 2, y: (self.frame.size.height - 30) / 2)
        todayMarkView.frame.size = CGSize.init(width: 30, height: 30)
        todayMarkView.backgroundColor = UIColor.clear
        todayMarkView.layer.cornerRadius = 15
        todayMarkView.isHidden = true
        
        self.addSubview(todayMarkView)
        
        // dayLabel
        dayLabel = UILabel()
        dayLabel.frame.origin = CGPoint.init(x: 0, y: 0)
        dayLabel.frame.size = self.frame.size
        dayLabel.textAlignment = .center
        dayLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
        dayLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        dayLabel.backgroundColor = UIColor.clear
        
        self.addSubview(dayLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
