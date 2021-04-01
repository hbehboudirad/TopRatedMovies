//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var viewFailure: ErrorView!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: TopRatedMoviesPresenting?
    
    private var movies: [MoviesViewModel] = []
    private var onDataRequired: (() -> Void)?
    private var onItemSelected: ((MoviesViewModel, UINavigationController) -> Void)?
    
    override func loadView() {
        super.loadView()
        configureNavigationBar()
        configureSubViews()
        showProgressView()
        setupBinding()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onDataRequired?()
    }    
}

// MARK: - Selector
extension MoviesViewController {
    @objc func didTapErrorButton() {
        onDataRequired?()
    }
}

// MARK: - TableView
extension MoviesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let queuedCell = tableView.dequeueReusableCell(withIdentifier: MoviesTableViewCell.cellIdentifier, for: indexPath)
        guard let cell = queuedCell as? MoviesTableViewCell else { return UITableViewCell() }
        
        cell.configure(movie: movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let navigationController = self.navigationController else { return }
        onItemSelected?(movies[indexPath.row], navigationController)
    }
}

// MARK: - Private
extension MoviesViewController {
    
    private func configureNavigationBar() {
        self.navigationItem.largeTitleDisplayMode = .always
        self.title = localized("mainPage.title")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
    }
    
    private func configureSubViews()  {
        view.backgroundColor = .foundation
        
        //progress view
        loadingView.messageLabel.text = localized("mainPage.labels.loading")

        //daily view
        Styles.container(tableView)
        tableView.register(MoviesTableViewCell.self, forCellReuseIdentifier: MoviesTableViewCell.cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 35
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = .zero
        tableView.tableHeaderView = UIView.init(frame: .init(x: 0, y: 0, width: 0, height: Spacer.xlg))

        //error view
        viewFailure.actionButton.setTitle(localized("mainPage.buttons.retry"), for: .normal)
        viewFailure.actionButton.addTarget(self, action: #selector(didTapErrorButton), for: .touchUpInside)
    }
    
    private func setupBinding() {
        onDataRequired = presenter?.bind(
            onLoadingStarted: showProgressView,
            onDataLoaded: showData,
            onLoadingFailed: showErrorMessage,
            onLoadingMoreData: setLoadingMoreAsSupplementaryCell,
            onMoreDataAdded: showData,
            onLoadingMoreDataFailed: setErrorCellAsSupplementaryCell,
            onLoadingAllDataFinished: clearSupplementaryCell
        )
    }
    
    private func showProgressView() {
        tableView.isHidden = true
        viewFailure.isHidden = true
        loadingView.isHidden = false
    }
    
    private func hideProgressView() {
        loadingView.isHidden = true
    }
    
    private func showData(movies: [MoviesViewModel]) {
        hideProgressView()
                
        //update data
        self.movies = movies
        tableView.reloadData()//TODO: take care of empty data
        
        //config view visibility
        tableView.isHidden = false
    }
    
    private func showErrorMessage(message: String) {
        viewFailure.updatedMessage(message: message)
        
        viewFailure.isHidden = false
        tableView.isHidden = true
        loadingView.isHidden = true
    }
    
    private func setLoadMoreAsSupplementaryCell() {
        
    }
    
    private func setLoadingMoreAsSupplementaryCell() {
        
    }
    
    private func setErrorCellAsSupplementaryCell(errorMessage: String) {
        
    }
    
    private func clearSupplementaryCell() {
        
    }
}
