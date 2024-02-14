//
//  OnboardingViewController.swift
//  OzinsheDemo2
//
//  Created by Aset Bakirov on 12.02.2024.
//

import SnapKit
import UIKit

class OnboardingViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //- MARK: - Local outlets
    lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let height = view.frame.size.height
        let width = view.frame.size.width
        layout.itemSize = CGSize(width: width, height: height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        collectionView.register(SlidesCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = UIColor(named: "FFFFFF - 111827")
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    // - MARK: - PageControl
    var pageControl = UIPageControl(frame: CGRectMake(138.67, 654, 126, 26))
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
        }
    }
    
    func configurePageControl() {
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor(red: 209/255, green: 213/255, blue: 219/255, alpha: 1)
        pageControl.currentPageIndicatorTintColor = UIColor(red: 179/255, green: 118/255, blue: 247/255, alpha: 1)
        pageControl.setIndicatorImage(UIImage(named: "RectanglePC"), forPage: currentPage)
        }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.setIndicatorImage(UIImage(named: "RectanglePC"), forPage: currentPage)
        for i in 0..<pageControl.numberOfPages {
            if i != pageControl.currentPage {
                pageControl.setIndicatorImage(nil, forPage: i)
            }
        }
    }
    
    //- MARK: - Data
    var slidesArray = [Slides(image: "firstSlide", centerLabel: "ÖZINŞE-ге қош келдің!", textLabel: """
                              Фильмдер, телехикаялар, ситкомдар, 
                              анимациялық жобалар, телебағдарламалар
                              мен реалити-шоулар, аниме және тағы
                              басқалары
                              """), 
                       Slides(image: "secondSlide", centerLabel: "ÖZINŞE-ге қош келдің!", textLabel: """
                                           Кез келген құрылғыдан қара
                                           Сүйікті фильміңді қосымша төлемсіз
                                           телефоннан, планшеттен, ноутбуктан қара
                                           """), 
                       Slides(image: "thirdSlide", centerLabel: "ÖZINŞE-ге қош келдің!", textLabel: """
                                                        Тіркелу оңай. Қазір тіркел де қалаған
                                                        фильміңе қол жеткіз
                                                        """)]
    
    //- MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "FFFFFF - 111827")
        configurePageControl()
        setupViews()
        setupConstraints()
    }
    
    //- MARK: - Views
    func setupViews() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
    }
    
    //- MARK: - Constraints
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(654)
        }
    }
    
    //- MARK: - Collection View - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slidesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SlidesCollectionViewCell
        cell.setupCell(slides: slidesArray[indexPath.item])
        if indexPath.row != 2 {
            cell.nextButton.isHidden = true
        }
        if indexPath.row == 2 {
            cell.skipButton.isHidden = true
        }
        return cell
    }
}
