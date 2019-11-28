import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        title = "Reproduct samples"
        let stackView = UIStackView()
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.backgroundColor = .cyan

        let contentInsetsSample = UIButton()
        contentInsetsSample.setTitle("1. LayoutGroup.contentInsets", for: .normal)
        contentInsetsSample.setTitleColor(.black, for: .normal)
        contentInsetsSample.addTarget(self, action: #selector(openLayoutGroupContentInsetsSample), for: .touchUpInside)

        stackView.addArrangedSubview(contentInsetsSample)
    }

    @objc func openLayoutGroupContentInsetsSample() {
        let vc = LayoutGroupContentInsetsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
