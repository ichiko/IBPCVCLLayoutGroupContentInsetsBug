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

        let boundarySample = UIButton()
        boundarySample.setTitle("2. BoundarySupplementaryItem.align", for: .normal)
        boundarySample.setTitleColor(.black, for: .normal)
        boundarySample.addTarget(self, action: #selector(openBoundarySupplementarySample), for: .touchUpInside)
        stackView.addArrangedSubview(boundarySample)
    }

    @objc func openLayoutGroupContentInsetsSample() {
        let vc = LayoutGroupContentInsetsViewController()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func openBoundarySupplementarySample() {
        let vc = BoundarySupplementaryItemViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
