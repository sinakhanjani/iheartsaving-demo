//
//  IntroViewController.swift
//  IHeartSaving
//
//  Created by erfan on 7/13/1398 AP.
//  Copyright © 1398 EtudeTeam. All rights reserved.
//

import UIKit

class collectionViewCellCustom: UICollectionViewCell {

    let text = UILabel()
    let imageView = ImageView()
    let logo = ImageView(image: UIImage(named: "logo_white"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logo.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 60).isActive = true
        logo.contentMode = .scaleAspectFit
        text.textAlignment = .center
        text.textColor = .white
        text.font = UIFont.systemFont(ofSize: 17)
        let stack = UIStackView(arrangedSubviews: [logo,imageView, text])
        text.numberOfLines = 0
        imageView.contentMode = .scaleAspectFit
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .fill
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 8
        stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
        stack.topAnchor.constraint(equalTo: topAnchor, constant: 32).isActive = true
        stack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setContent(title: String, image: UIImage) {
        text.text = title
        imageView.image = image
    }
}
class IntroViewController: UIViewController {

    @IBAction func nextBtnPressed(_ sender: UIButton) {
        if sender.currentTitle == "Done" {
            DAL.setShowCase()
            dismiss(animated: true, completion: nil)
            return
        }
        if current < images.count - 1 {
            current += 1
            collectionView.scrollToItem(at: IndexPath(row: current, section: 0), at: .centeredHorizontally, animated: true)
            pageControl.currentPage = current
        }
        if current == images.count - 1 {
            sender.setTitle("Done", for: .normal)
            sender.setImage(nil, for: .normal)
            skipBtn.setTitle("", for: .normal)
        } else {
            sender.setTitle("", for: .normal)
            sender.setImage(UIImage(named: "130884"), for: .normal)
            skipBtn.setTitle("Skip", for: .normal)
        }
    }
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skipBtn: UIButton!
    @IBAction func skipBtnPressed(_ sender: UIButton) {
        DAL.setShowCase()
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(collectionViewCellCustom.self, forCellWithReuseIdentifier: "collectionViewCellCustom")
    }
    var current = 0
    var images = ["intro1","intro2","intro3","intro4","intro5"]
    var textes = ["Find a coupon that you want to use","When purchasing or ordering, show the vendor that I Heart Saving coupon your're going to use","Present the coupon to the vendor upon paying for the product/service","Vendor will press REDEEM on the app","Coupon will now show the words"]
}
extension IntroViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: view.bounds.height - 45)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        pageControl.currentPage = Int(x / view.frame.width)
        current = Int(x / view.frame.width)
        if current == images.count - 1 {
            nextBtn.setTitle("Done", for: .normal)
            nextBtn.setImage(nil, for: .normal)
            skipBtn.setTitle("", for: .normal)
        } else {
            nextBtn.setTitle("", for: .normal)
            nextBtn.setImage(UIImage(named: "130884"), for: .normal)
            skipBtn.setTitle("Skip", for: .normal)
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCellCustom", for: indexPath) as? collectionViewCellCustom else { return UICollectionViewCell() }
        cell.setContent(title: textes[indexPath.row], image: UIImage(named: images[indexPath.row])!)
        return cell
    }
}
