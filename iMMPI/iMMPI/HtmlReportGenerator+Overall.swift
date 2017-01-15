import Foundation

extension HtmlReportGenerator {
    static let overall = try! HtmlReportGenerator({ record, analyser in
        analyser.computeScores(forRecord: record)
        return .ul(attributes: ["class": "analysis"],
                   content: generateList(for: record, analyser: analyser, startingFrom: 0).html)
    })
}


fileprivate func generateList(for record: TestRecordProtocol, analyser: Analyzer, startingFrom index: Int) -> (html: [Html], lastIndex: Int) {
    var list: [Html] = []

    var i = index

    let initialDepth = analyser.depthOfGroup(at: index)

    while i < analyser.groupsCount {
        let group = analyser.group(at: i)!
        let depth = analyser.depthOfGroup(at: i)

        var groupHtml = generateItem(for: group, at: group.index(forRecord: record))

        defer {
            list.append(.li(attributes: ["class": "depth\(depth)"], content: groupHtml))
        }

        if i + 1 < analyser.groupsCount {
            let nextDepth = analyser.depthOfGroup(at: i + 1)

            if nextDepth < initialDepth {
                break
            }
            else if nextDepth > initialDepth {
                let sublist = generateList(for: record, analyser: analyser, startingFrom: i + 1)
                groupHtml.append(.ul(content: sublist.html))
                i = sublist.lastIndex
            }
        }

        i += 1
    }

    return (list, i)
}


fileprivate func generateItem(for group: AnalyzerGroup, at index: Int) -> [Html] {
    return [
        index > 0 ? .tag("index", content: .content("\(index).")) : .empty,
        .tag("text", content: .content(group.name)),
        .tag("score", content: .content(group.readableScore()))
    ]
}
