import UIKit

class HeaderFooterView: UICollectionReusableView {
    static let reuseIdentifier = "headerAndFooter"
    private var titleLable: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }

    var title: String? {
        get { return titleLable.text }
        set { titleLable.text = newValue }
    }

    private func configure() {
        titleLable = UILabel()
        titleLable.tintColor = .black
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLable)
        titleLable.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLable.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

        backgroundColor = .lightGray
    }
}
