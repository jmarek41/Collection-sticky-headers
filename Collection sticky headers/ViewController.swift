//
//  ViewController.swift
//  Collection sticky headers
//
//  Created by Jakub Marek on 25/02/2019.
//  Copyright © 2019 MySpectroom. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionViewSections = 3
    let itemsInSection = 6
    var readyToLazyLoad = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
    }
}

extension ViewController: UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return collectionViewSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if kind == UICollectionView.elementKindSectionHeader {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionHeader", for: indexPath)
        } else {
            return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionFooter", for: indexPath)
        }
    }
}

extension ViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        // Lazy load
        if readyToLazyLoad && indexPath.section >= collectionView.numberOfSections - 1
        {
            readyToLazyLoad = false
            collectionViewSections += 3
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.collectionView.performBatchUpdates({
                    self.collectionView.insertSections(IndexSet(integersIn: self.collectionView.numberOfSections...self.collectionViewSections - 1))
                }, completion: { finished in
                    self.readyToLazyLoad = true
                })
            }
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let width = (collectionView.bounds.width < collectionView.bounds.height) ? collectionView.bounds.width/2 - 0.5 : collectionView.bounds.width/3 - 1
        return CGSize(width: width, height: width) // Ratio 1:1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 1, left: 0, bottom: 70, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return (section == collectionView.numberOfSections - 1) ? CGSize(width: collectionView.frame.width, height: 64) : CGSize.zero
    }
}
