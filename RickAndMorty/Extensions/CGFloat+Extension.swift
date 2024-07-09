import UIKit

extension CGFloat {

    var fitW: CGFloat {
        return self * screenSize.width / designSize.width
    }

    var fitH: CGFloat {
        return self * screenSize.height / designSize.height
    }

    private var screenSize: CGSize { UIScreen.main.bounds.size }
    private var designSize: CGSize { CGSize(width: 393, height: 852) }
}
