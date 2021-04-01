//
//  Copyright © 2021 HBR. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController {
    
    @IBOutlet weak var loadingView: LoadingView!
    @IBOutlet weak var viewFailure: ErrorView!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: TopRatedMoviesPresenting?
    
    private var movies: [MovieViewModel] = []
    private var onDataRequired: (() -> Void)?
    private var onItemSelected: ((MovieViewModel, UINavigationController) -> Void)?
    
    /// An enum that describes different type of supplementary cells that this view have
    private enum SupplementaryCellType {
        case none
        case loading
        case failure(String)
        case loadMore
        
        static func ==(a: SupplementaryCellType, b: SupplementaryCellType) -> Bool {
            switch (a,b) {
            case (.none, .none), (.loading, .loading), (.loadMore, .loadMore), (.failure(_), .failure(_)):
                return true
            default:
                return false
            }
        }
    }
    private var supplementaryCellType: SupplementaryCellType = .loadMore
    
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        supplementaryCellType == .none ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return movies.count
        default:
            return supplementaryCellType == .none ? 0 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let queuedCell = tableView.dequeueReusableCell(withIdentifier: MoviesTableViewCell.cellIdentifier, for: indexPath)
            guard let cell = queuedCell as? MoviesTableViewCell else { return UITableViewCell() }
            
            cell.configure(movie: movies[indexPath.row])
            return cell
        } else {
            return getSupplementaryCell(indexPath: indexPath)
        }
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
        tableView.register(ActionedButtonTableViewCell.self, forCellReuseIdentifier: ActionedButtonTableViewCell.cellIdentifier)
        tableView.register(ProgressIndicatorTableViewCell.self, forCellReuseIdentifier: ProgressIndicatorTableViewCell.cellIdentifier)
        tableView.register(LoadingFailureTableViewCell.self, forCellReuseIdentifier: LoadingFailureTableViewCell.cellIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 35
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = .zero
        tableView.tableHeaderView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 0.1))
        tableView.sectionHeaderHeight = 0.1
        tableView.sectionFooterHeight = 0.1

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
    
    private func getSupplementaryCell(indexPath: IndexPath) -> UITableViewCell {
        switch supplementaryCellType {
        case .loadMore:
            let queuedCell = tableView.dequeueReusableCell(withIdentifier: ActionedButtonTableViewCell.cellIdentifier, for: indexPath)
            guard let cell = queuedCell as? ActionedButtonTableViewCell else { return queuedCell }
            
            cell.configure(title: localized("mainPage.buttons.loadMore"),
                           actionTask: { [weak self] in self?.onDataRequired?() })
            return cell
        case .failure(let message):
            let queuedCell = tableView.dequeueReusableCell(withIdentifier: LoadingFailureTableViewCell.cellIdentifier, for: indexPath)
            guard let cell = queuedCell as? LoadingFailureTableViewCell else { return queuedCell }
            
            cell.configure(title: localized("mainPage.buttons.retry"),
                           message: message,
                           actionTask: { [weak self] in self?.onDataRequired?() })
            return cell
        case .loading:
            return tableView.dequeueReusableCell(withIdentifier: ProgressIndicatorTableViewCell.cellIdentifier, for: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    private func showProgressView() {
        tableView.isHidden = true
        viewFailure.isHidden = true
        loadingView.isHidden = false
    }
    
    private func hideProgressView() {
        loadingView.isHidden = true
    }
    
    private func showData(movies: [MovieViewModel]) {
        hideProgressView()
                
        //update data
        self.movies = movies
        tableView.reloadData()//TODO: take care of empty data
        
        //config view visibility
        tableView.isHidden = false
        
        // show load more for next page
        setLoadMoreAsSupplementaryCell()
    }
    
    private func showErrorMessage(message: String) {
        viewFailure.updatedMessage(message: message)
        
        viewFailure.isHidden = false
        tableView.isHidden = true
        loadingView.isHidden = true
    }
    
    private func setLoadMoreAsSupplementaryCell() {
        supplementaryCellType = .loadMore
        tableView.reloadData()
    }
    
    private func setLoadingMoreAsSupplementaryCell() {
        supplementaryCellType = .loading
        tableView.reloadData()
    }
    
    private func setErrorCellAsSupplementaryCell(errorMessage: String) {
        supplementaryCellType = .failure(errorMessage)
        tableView.reloadData()
        tableView.scrollToRow(at: .init(row: 0, section: 1), at: .bottom, animated: true)
    }
    
    private func clearSupplementaryCell() {
        supplementaryCellType = .none
        tableView.reloadData()
    }
}
