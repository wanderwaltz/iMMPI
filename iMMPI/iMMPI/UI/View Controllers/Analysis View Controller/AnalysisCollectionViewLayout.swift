import UIKit

final class AnalysisCollectionViewLayout: UICollectionViewLayout {
    let rowHeight: CGFloat = 44.0
    let scoreColumnWidth: CGFloat = 80.0
    fileprivate(set) var scaleColumnWidth: CGFloat = 400.0

    fileprivate var cellAttributes: [IndexPath:UICollectionViewLayoutAttributes] = [:]
}


extension AnalysisCollectionViewLayout {
    override func prepare() {
        super.prepare()
        updateScaleColumnWidth()

        var cellAttributes: [IndexPath:UICollectionViewLayoutAttributes] = [:]
        
        defer {
            self.cellAttributes = cellAttributes
        }

        guard let cv = collectionView else {
            return
        }

        let minimumRow = Int(max(0, cv.contentOffset.y) / rowHeight) - 1
        let maximumRow = minimumRow + Int(cv.bounds.height / rowHeight) + 2


        for section in 0..<cv.numberOfSections {
            var rowsSet = IndexSet(integersIn:
                max(0, minimumRow)..<min(cv.numberOfItems(inSection: section), maximumRow)
            )

            rowsSet.insert(0)

            for item in rowsSet {
                let indexPath = IndexPath(item: item, section: section)

                if let attributes = makeLayoutAttributes(forCellAt: indexPath) {
                    cellAttributes[indexPath] = attributes
                }
            }
        }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }


    override var collectionViewContentSize: CGSize {
        guard let cv = collectionView else {
            return .zero
        }

        let width = CGFloat(max(0, cv.numberOfSections - 1)) * scoreColumnWidth + scaleColumnWidth
        let height = CGFloat(cv.numberOfItems(inSection: 0)) * rowHeight

        return CGSize(width: width, height: height)
    }


    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cellAttributes.values.filter({ rect.intersects($0.frame) })
    }


    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = cellAttributes[indexPath] {
            return attributes
        }
        else if let attributes = makeLayoutAttributes(forCellAt: indexPath) {
            cellAttributes[indexPath] = attributes
            return attributes
        }
        else {
            return nil
        }
    }
}


extension AnalysisCollectionViewLayout {
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


    fileprivate func makeLayoutAttributes(forCellAt indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let cv = collectionView else {
            return nil
        }

        switch (indexPath.section, indexPath.row) {
        case (_, 0): return dateHeaderLayoutAttributes(for: cv, at: indexPath)
        case (0, _): return scaleCellLayoutAttributes(for: cv, at: indexPath)
        default: return scoreCellLayoutAttributes(for: cv, at: indexPath)
        }
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
