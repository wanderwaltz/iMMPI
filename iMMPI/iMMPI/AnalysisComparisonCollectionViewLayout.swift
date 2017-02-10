import UIKit

final class AnalysisComparisonCollectionViewLayout: UICollectionViewLayout {
    let rowHeight: CGFloat = 44.0
    let scoreColumnWidth: CGFloat = 80.0
    fileprivate(set) var scaleColumnWidth: CGFloat = 400.0

    fileprivate var cellAttributes: [IndexPath:UICollectionViewLayoutAttributes] = [:]
}


extension AnalysisComparisonCollectionViewLayout {
    override func prepare() {
        super.prepare()
        updateScaleColumnWidth()

        var cellAttributes: [IndexPath:UICollectionViewLayoutAttributes] = [:]
        var supplementaryAttributes: [IndexPath:UICollectionViewLayoutAttributes] = [:]

        defer {
            self.cellAttributes = cellAttributes
        }

        guard let cv = collectionView else {
            return
        }

        for section in 0..<cv.numberOfSections {
            for item in 0..<cv.numberOfItems(inSection: section) {
                let indexPath = IndexPath(item: item, section: section)

                switch (section, item) {
                case (_, 0): cellAttributes[indexPath] = dateHeaderLayoutAttributes(for: cv, at: indexPath)
                case (0, _): cellAttributes[indexPath] = scaleCellLayoutAttributes(for: cv, at: indexPath)
                default: cellAttributes[indexPath] = scoreCellLayoutAttributes(for: cv, at: indexPath)
                }
            }
        }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }


    override var collectionViewContentSize: CGSize {
        return cellAttributes.values.reduce(CGRect.zero, { $0.union($1.frame) }).size
    }


    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttributes.values.filter({ rect.intersects($0.frame) })
    }


    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttributes[indexPath]
    }
}


extension AnalysisComparisonCollectionViewLayout {
    fileprivate func updateScaleColumnWidth() {
        let minimumWidth: CGFloat = 400.0

        guard let cv = collectionView else {
            scaleColumnWidth = minimumWidth
            return
        }

        let width = cv.bounds.width
        let scoresCount = max(1, cv.numberOfSections-1)

        scaleColumnWidth = max(minimumWidth, width - CGFloat(scoresCount) * scoreColumnWidth)
    }


    fileprivate func x(forSection section: Int) -> CGFloat {
        return scaleColumnWidth + CGFloat(section-1) * scoreColumnWidth
    }


    fileprivate func x(forPinnedSectionIn collectionView: UICollectionView) -> CGFloat {
        return max(0, collectionView.contentOffset.x + collectionView.contentInset.left)
    }


    fileprivate func y(forRow row: Int) -> CGFloat {
        return CGFloat(row) * rowHeight
    }

    fileprivate func y(forPinnedRowIn collectionView: UICollectionView) -> CGFloat {
        return max(0, collectionView.contentOffset.y + collectionView.contentInset.top)
    }


    fileprivate func scaleCellLayoutAttributes(for collectionView: UICollectionView, at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

            attributes.frame = CGRect(
                x: x(forPinnedSectionIn: collectionView),
                y: y(forRow: indexPath.row),
                width: scaleColumnWidth,
                height: rowHeight
            )

            attributes.zIndex = 1

            return attributes
    }


    fileprivate func scoreCellLayoutAttributes(for collectionView: UICollectionView, at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

            attributes.frame = CGRect(
                x: x(forSection: indexPath.section),
                y: y(forRow: indexPath.row),
                width: scoreColumnWidth,
                height: rowHeight
            )

            attributes.zIndex = 0

            return attributes
    }


    fileprivate func dateHeaderLayoutAttributes(for collectionView: UICollectionView, at indexPath: IndexPath)
        -> UICollectionViewLayoutAttributes {
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let isScaleHeader = indexPath.section == 0

            attributes.frame = CGRect(
                x: isScaleHeader ? x(forPinnedSectionIn: collectionView) : x(forSection: indexPath.section),
                y: y(forPinnedRowIn: collectionView),
                width: isScaleHeader ? scaleColumnWidth : scoreColumnWidth,
                height: rowHeight
            )

            attributes.zIndex = isScaleHeader ? 3 : 2

            return attributes
    }
}
