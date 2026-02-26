//
//  PokemonCardListViewController.swift
//  PokemonCard
//
//  Created by Agil Febrianistian on 26/02/26.
//

import UIKit
import SDWebImage
import NVActivityIndicatorView

final class PokemonCardListViewController: UIViewController {
    
    private let viewModel = PokemonCardListViewModel()
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var notFoundView: UIView!
    
    private lazy var activityIndicatorView: NVActivityIndicatorView = {
        let indicator = NVActivityIndicatorView(
            frame: .zero,
            type: .ballRotate,
            color: .yellow
        )
        return indicator
    }()
 
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        layout.estimatedItemSize = .zero
        return layout
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        reloadData()
    }
    
    private func setupUI() {
        title = "Pokemon Card"
        
        activityIndicatorView.padding = 10
        activityIndicatorView.backgroundColor = .gray.withAlphaComponent(0.3)
        self.view.addSubview(activityIndicatorView)
        
        setupCollectionView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        activityIndicatorView.frame = CGRect(x: cardCollectionView.frame.origin.x,
                                             y: cardCollectionView.frame.origin.y,
                                             width: cardCollectionView.bounds.size.width,
                                             height: cardCollectionView.bounds.size.height)
    }
    
    private func setupCollectionView() {
        cardCollectionView.collectionViewLayout = flowLayout
        cardCollectionView.register(UINib(nibName: "PokemonCardCell", bundle: nil),
                                    forCellWithReuseIdentifier: "PokemonCardCell")
    }
    
    private func bindViewModel() {
        
        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            isLoading ?  self?.activityIndicatorView.startAnimating() :  self?.activityIndicatorView.stopAnimating()
        }
        
        viewModel.onDataUpdated = { [weak self] in
            self?.notFoundView.isHidden = true
            self?.cardCollectionView.reloadData()
        }
        
        viewModel.onShowAlert = { [weak self] error in
            self?.cardCollectionView.reloadData()
            self?.showAlert(title: "", message: error.message ?? "")
        }
        
        viewModel.onEmptyResult = { [weak self] in
            self?.notFoundView.isHidden = false
        }
    }
    
    func reloadData() {
        activityIndicatorView.startAnimating()
        viewModel.fetchNext()
    }
}

extension PokemonCardListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCardCell", for: indexPath) as! PokemonCardCell
        cell.configure(with: viewModel.items[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PokemonCardDetailViewController") as? PokemonCardDetailViewController
        vc?.pokemon = viewModel.items[indexPath.item]
        navigationController?.pushViewController(vc!, animated: true)
        
    }
}

extension PokemonCardListViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.bounds.height

        if offsetY > contentHeight - height * 1.5 {
            viewModel.fetchNext()
        }
    }
}

extension PokemonCardListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView( _ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath ) -> CGSize {

        let columns: CGFloat = 2
        let spacing: CGFloat = flowLayout.minimumInteritemSpacing
        let inset = flowLayout.sectionInset

        let availableWidth = collectionView.bounds.width - inset.left - inset.right - spacing * (columns - 1)

        let width = floor(availableWidth / columns)
        let height = floor(width * 1.4)

        return CGSize(width: width, height: height)
    }

}

extension PokemonCardListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.search(name: searchBar.text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        viewModel.search()
    }
}

