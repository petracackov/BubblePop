import UIKit

@IBDesignable
class AppButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            refresh()
        }
    }
    @IBInspectable var fullyRounded: Bool = false {
        didSet {
            refresh()
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0.0  {
        didSet {
            refresh()
        }
    }
    @IBInspectable var borderColor: UIColor = .clear {
        didSet {
            refresh()
        }
    }
    
    @IBInspectable var shadowColor: UIColor? = nil {
        didSet {
            refresh()
        }
    }
    @IBInspectable var shadowWidth: CGFloat = 0.0 {
        didSet {
            refresh()
        }
    }
    @IBInspectable var shadowHeight: CGFloat = 0.0 {
        didSet {
            refresh()
        }
    }
    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet {
            refresh()
        }
    }
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        didSet {
            refresh()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let animationsenabled = UIView.areAnimationsEnabled
        UIView.setAnimationsEnabled(false)
        refresh()
        UIView.setAnimationsEnabled(animationsenabled)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if fullyRounded {
            layer.cornerRadius = min(bounds.height, bounds.width)*0.5
        } else {
            layer.cornerRadius = cornerRadius
        }
        refresh()
    }
    
    override var frame: CGRect {
        didSet {
            if fullyRounded {
                layer.cornerRadius = min(bounds.height, bounds.width)*0.5
            } else {
                layer.cornerRadius = cornerRadius
            }
        }
    }
    
    func refresh() {
        if fullyRounded {
            layer.cornerRadius = min(bounds.height, bounds.width)*0.5
        } else {
            layer.cornerRadius = cornerRadius
        }
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowWidth, height: shadowHeight)
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius

        titleLabel?.textColor = isEnabled
            ? .white
            : .gray
    }
    
}
