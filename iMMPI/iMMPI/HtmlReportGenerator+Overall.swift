import Foundation

extension HtmlReportGenerator {
    static let overall = try? HtmlReportGenerator(title: Strings.Report.overall) { record, analyser in
        return .ul(attributes: ["class": "analysis"],
                   content: generateList(for: record, analyser: analyser, startingFrom: 0).html)
    }
}


fileprivate func generateList(for record: TestRecordProtocol, analyser: Analyser, startingFrom index: Int) -> (html: [Html], lastIndex: Int) {
    var list: [Html] = []

    var i = index

    let initialNesting = analyser.scales[index].identifier.nesting

    while i < analyser.scales.count {
        let scale = analyser.scales[i]
        let nesting = scale.identifier.nesting

        var scaleHtml = generateItem(for: scale, record: record)

        defer {
            list.append(.li(attributes: ["class": "depth\(nesting)"], content: scaleHtml))
        }

        if i + 1 < analyser.scales.count {
            let nextNesting = analyser.scales[i+1].identifier.nesting

            if nextNesting < initialNesting {
                break
            }
            else if nextNesting > initialNesting {
                let sublist = generateList(for: record, analyser: analyser, startingFrom: i+1)
                scaleHtml.append(.ul(content: sublist.html))
                i = sublist.lastIndex
            }
        }

        i += 1
    }

    return (list, i)
}


fileprivate func generateItem(for scale: AnalysisScale, record: TestRecordProtocol) -> [Html] {
    let index = scale.index.value(for: record)
    return [
        index > 0 ? .tag("index", content: .content("\(index).")) : .empty,
        .tag("text", content: .content(scale.title)),
        .tag("score", content: .content(scale.formatter.format(scale.score.value(for: record))))
    ]
}
