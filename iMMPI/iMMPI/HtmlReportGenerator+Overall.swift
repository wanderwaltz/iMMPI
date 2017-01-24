import Foundation

extension HtmlReportGenerator {
    static let overall = try? HtmlReportGenerator(title: Strings.Report.overall) { record, scales in
        return .ul(attributes: ["class": "analysis"],
                   content: generateList(for: record, scales: scales, startingFrom: 0).html)
    }
}


fileprivate func generateList(for record: TestRecordProtocol, scales: [BoundScale], startingFrom index: Int) -> (html: [Html], lastIndex: Int) {
    var list: [Html] = []

    var i = index

    let initialNesting = scales[index].identifier.nesting

    while i < scales.count {
        let scale = scales[i]
        let nesting = scale.identifier.nesting

        var scaleHtml = generateItem(for: scale)

        defer {
            list.append(.li(attributes: ["class": "depth\(nesting)"], content: scaleHtml))
        }

        if i + 1 < scales.count {
            let nextNesting = scales[i+1].identifier.nesting

            if nextNesting < initialNesting {
                break
            }
            else if nextNesting > initialNesting {
                let sublist = generateList(for: record, scales: scales, startingFrom: i+1)
                scaleHtml.append(.ul(content: sublist.html))
                i = sublist.lastIndex
            }
        }

        i += 1
    }

    return (list, i)
}


fileprivate func generateItem(for scale: BoundScale) -> [Html] {
    return [
        scale.index > 0 ? .tag("index", content: .content("\(scale.index).")) : .empty,
        .tag("text", content: .content(scale.title)),
        .tag("score", content: .content(scale.score))
    ]
}
