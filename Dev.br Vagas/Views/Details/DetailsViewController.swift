//
//  DetailsViewControlller.swift
//  recrutamento-ios
//
//  Created by Paulo José on 16/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

class DetailsViewControlller: UIViewController {
    
    let issue: Issue
    
    var userImageUseCase: UserImageUseCase?
    
    var onSave: (() -> Void)?
    
    var contentView: DetailsView?
    
    init(issue: Issue) {
        self.issue = issue
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentView = DetailsView(frame: .zero, issue: issue)
        contentView?.onSave = self.onSave
        self.view = contentView
        
        self.userImageUseCase = UserImageUseCase(gateway: ApiManager(), presenter: self)
        
        guard let avatar_url = issue.user?.avatar_url,
           let userImageUserCase = userImageUseCase else { return }
        
        userImageUserCase.fetchUserImage(with: avatar_url)
    }
}

extension DetailsViewControlller: UserImagePresenter {
    func presentUserImage(result: ImageFetchResult<Data>) {
        switch result {
        case let .sucess(data):
            guard let image = UIImage(data: data) else { return }
            contentView?.avatarImageView.image = image
        case .failure(_):
            print()
        }
    }
}
