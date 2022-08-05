import SnapKit
import UIKit

class ViewController: UIViewController {
    
    lazy var imageView: UIImageView = {
       let _imageView = UIImageView()
        _imageView.contentMode  = .scaleAspectFit
        return _imageView
    }()
    
    lazy var stackView: UIStackView = {
        let _stackView = UIStackView(arrangedSubviews: [imageView])
        _stackView.axis = .vertical
        return _stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        LocalPhotoService.fetchLatestPhotos(forCount: 1) {[weak self] result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                self?.imageView.image = image
            case .failure(let error):
                print(error)
            }
        }
    }

    
    private func setupViews() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.backgroundColor = .blue
    }

}
