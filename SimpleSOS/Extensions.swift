//
//  extensions.swift
//  SimpleSOS
//
//  Created by Jonas Gamburg on 10/05/2021.
//

import UIKit


//MARK: - CALayer
extension CALayer {
    func roundCorners(to radius: CornerRadiusStyle, smoothCorners: Bool = true) {
        switch radius {
        case .rounded:
            cornerRadius = min(bounds.height/2, bounds.width/2)
        case .custom(let rad):
            cornerRadius = rad
        case .other(let view):
            cornerRadius = view.layer.cornerRadius
        }
        
        guard bounds.width != bounds.height else { return }
        if smoothCorners, #available(iOS 13.0, *) {
            cornerCurve = .continuous
        }
    }
}


//MARK: - UIStackView
extension UIColor {
    static var softRed     = UIColor(red: 250/255, green: 80/255, blue: 80/255, alpha: 1)
    static var darkRed     = UIColor(red: 224/255, green: 43/255, blue: 43/255, alpha: 1)
    static var brightGreen = UIColor(red: 11/255, green: 235/255, blue: 184/255, alpha: 1)
}

//MARK: - UILabel
extension UILabel {
    convenience init(text: String, font: UIFont, textColor: UIColor, tamic: Bool) {
        self.init()
        self.text      = text
        self.font      = font
        self.textColor = textColor
        self.translatesAutoresizingMaskIntoConstraints = tamic
    }
}

//MARK: - UIStackView
extension UIStackView {
    convenience init(views: [UIView] = [], axis: NSLayoutConstraint.Axis, spacing: CGFloat = 0, alignment: UIStackView.Alignment, distribution: UIStackView.Distribution = .fill, tamic: Bool) {
        
        if !(views.isEmpty) {
            self.init(arrangedSubviews: views)
            
        }
        
        self.init(arrangedSubviews: views)
        self.axis         = axis
        self.spacing      = spacing
        self.alignment    = alignment
        self.distribution = distribution
        self.translatesAutoresizingMaskIntoConstraints = tamic
    }
    
    func addArrangedViews(views: UIView...) {
        views.forEach {
            addArrangedSubview($0)
        }
    }
}



//MARK: - UIButton
extension UIButton {
    func setSFSymbol(iconName: String, size: CGFloat, weight: UIImage.SymbolWeight,
                     scale: UIImage.SymbolScale, tintColor: UIColor, backgroundColor: UIColor) {
        
        let symbolConfiguration = UIImage.SymbolConfiguration(pointSize: size, weight: weight, scale: scale)
        let buttonImage         = UIImage(systemName: iconName, withConfiguration: symbolConfiguration)
        self.tintColor          = tintColor
        self.backgroundColor    = backgroundColor
        self.setImage(buttonImage, for: .normal)
    }
}



//MARK: - UIView
extension UIView {
    
    func addShadow(withOpactiy opacity: Float, andColor color: UIColor, andRadius radius: CGFloat, andOffset offset: CGSize) {
        layer.shadowOpacity = opacity
        layer.shadowColor   = color.cgColor
        layer.shadowRadius  = radius
        layer.shadowOffset  = offset
    }
    
    func fix(in container: UIView, padding: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: container.topAnchor, constant: padding.top),
            bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -padding.bottom),
            leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: padding.left),
            trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -padding.right)
        ])
    }
    
    func fix(in container: UIView, belowView view: UIView, withTopPadding padding: CGFloat = 0, andHeight height: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.bottomAnchor, constant: padding),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            heightAnchor.constraint(equalToConstant: height)
        ])
    }
    
    func fix(in container: UIView, belowView view: UIView, withTopPadding padding: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(self)
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: view.bottomAnchor, constant: padding),
            leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func getEstimatedFrame(forText text: String) -> CGRect {
        let size = CGSize(width: frame.width / 2, height: 1000)
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options:  [.usesFontLeading, .usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil)
        
        return estimatedFrame
    }
}
