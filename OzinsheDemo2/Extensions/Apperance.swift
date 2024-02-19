//  Apperance.swift
//https://github.com/AsetB/ios-snapkit-guidelines.git

import UIKit

/// Протокол для основных числовых констант для верстки содержащий цвета, альфы и прочее
public protocol Appearance {}

/// Содержит основные базовые числовые константы
extension Appearance {
    /// Нулевой значение
    public var zero: Int { 0 }
}

/// Обертка для Appearance совместимых типов
public struct AppearanceWrapper<Base>: Appearance {
    private let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

/// Протокол описывающий которому должны конформить совместимы с Appearance типами
public protocol AppearanceCompatible: AnyObject {}

extension AppearanceCompatible {
    /// Предоставляет namespace обертку для Appearance совместимых типов.
    public var appearance: AppearanceWrapper<Self> { AppearanceWrapper(self) }
}

extension UIView: AppearanceCompatible {}
extension UIViewController: AppearanceCompatible {}

//- MARK: - Colors and Fonts

extension Appearance {
    var transparent: UIColor { UIColor(named: "transparent")! }
    var FFFFFF: UIColor { UIColor(named: "FFFFFF")! }
    var FFFFFF_111827: UIColor { UIColor(named: "FFFFFF - 111827")! }
    var FFFFFF_1C2431: UIColor { UIColor(named: "FFFFFF - 1C2431")! }
    var F9FAFB_111827: UIColor { UIColor(named: "F9FAFB - 111827")! }
    var F8EEFF_1C2431: UIColor { UIColor(named: "F8EEFF - 1C2431")! }
    var F3F4F6_374151: UIColor { UIColor(named: "F3F4F6 - 374151")! }
    var D1D5DB_1C2431: UIColor { UIColor(named: "D1D5DB - 1C2431")! }
    var c374151_F9FAFB: UIColor { UIColor(named: "374151 - F9FAFB")! }
    var c111827_FFFFFF: UIColor { UIColor(named: "111827 - FFFFFF")! }
    var c1C2431_E5E7EB: UIColor { UIColor(named: "1C2431 - E5E7EB")! }
    var textFieldBorderColor: CGColor { UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor }
    var textFieldErrorBorderColor: CGColor { UIColor(red: 255/255, green: 64/255, blue: 43/255, alpha: 1.0).cgColor }
    var textFieldActiveBorderColor: CGColor { UIColor(red: 229/255, green: 235/255, blue: 240/255, alpha: 1.0).cgColor }
    
    var mainTitleFont:UIFont { UIFont(name: "SFProDisplay-Bold", size: 24)! }
    var boldFont14:UIFont { UIFont(name: "SFProDisplay-Bold", size: 14)! }
    var boldFont16:UIFont { UIFont(name: "SFProDisplay-Bold", size: 16)! }
    var semiboldFont12:UIFont { UIFont(name: "SFProDisplay-Semibold", size: 12)! }
    var semiboldFont14:UIFont { UIFont(name: "SFProDisplay-Semibold", size: 14)! }
    var semiboldFont16:UIFont { UIFont(name: "SFProDisplay-SemiBold", size: 16)! }
    var medium500Font12:UIFont { UIFont(name: "SFProDisplay-Medium", size: 12)! }
    var medium500Font14:UIFont { UIFont(name: "SFProDisplay-Medium", size: 14)! }
    var medium500Font16:UIFont { UIFont(name: "SFProDisplay-Medium", size: 16)! }
    var regular400Font12:UIFont { UIFont(name: "SFProDisplay-Regular", size: 14)! }
    var regular400Font14:UIFont { UIFont(name: "SFProDisplay-Regular", size: 14)! }
    var regular400Font16:UIFont { UIFont(name: "SFProDisplay-Regular", size: 16)! }
    
    var buttonCornerRadius: CGFloat { 12 }
    var textFieldCornerRadius: CGFloat { 12 }
    var imagesCornerRadius: CGFloat { 8 }
    var capsuleCornerRadius: CGFloat { 8 }
    var backViewCornerRadius: CGFloat { 32 }
}
