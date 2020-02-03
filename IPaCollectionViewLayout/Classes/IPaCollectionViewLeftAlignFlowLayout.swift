//
//  IPaCollectionViewLeftAlignFlowLayout.swift
//  IPaCollectionViewLayout
//
//  Created by IPa Chen on 2020/2/3.
//

import UIKit

open class IPaCollectionViewLeftAlignFlowLayout: UICollectionViewFlowLayout {
    var delegate: UICollectionViewDelegateFlowLayout? {
        return self.collectionView?.delegate as? UICollectionViewDelegateFlowLayout
    }
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else {
                return nil
            }

        return attributes.compactMap { (attribute)  in
            if attribute.representedElementKind != nil {
                return attribute
            }
            return self.layoutAttributesForItem(at: attribute.indexPath)
        }
        
    }
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }

        guard let collectionView = self.collectionView else {
            return attributes
        }
        if indexPath.item == 0 {
            //first in section
            let section = attributes.indexPath.section
            let x = self.delegate?.collectionView?(collectionView, layout: self, insetForSectionAt: section).left ?? self.sectionInset.left
            attributes.frame.origin.x = x
            return attributes
        }

        let lastAttribute = self.layoutAttributesForItem(at: IndexPath(item: indexPath.item - 1, section: indexPath.section))
        let lastFrame: CGRect = lastAttribute?.frame ?? CGRect()
        if lastAttribute?.center.y != attributes.center.y {
            //first in row
            let section = attributes.indexPath.section
            let x = self.delegate?.collectionView?(collectionView, layout: self, insetForSectionAt: section).left ?? self.sectionInset.left
            attributes.frame.origin.x = x
            return attributes
        }

        let interItemSpacing: CGFloat = (collectionView.delegate as? UICollectionViewDelegateFlowLayout)?.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt : indexPath.section) ?? self.minimumInteritemSpacing
        let x = lastFrame.maxX + interItemSpacing
        attributes.frame = CGRect(x: x,
                                  y:attributes.frame.origin.y,
                                  width:attributes.frame.width,
                                  height: attributes.frame.height)

        return attributes
        
    }
}
