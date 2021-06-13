import Foundation
import Localization
import HTMLComposing
import Analysis

extension HtmlReportGenerator {
    public static let overall = try? HtmlReportGenerator(
        title: Strings.Report.overall
    ) { result in
        return .ul(
            attributes: ["class": "analysis"],
            content: generateList(
                for: result,
                scoreFormatter: .default,
                startingFrom: 0
            )
            .html
        )
    }

    public static let brief = try? HtmlReportGenerator(
        title: Strings.Report.brief
    ) { result in
        return .ul(
            attributes: ["class": "analysis"],
            content: generateList(
                for: result,
                scoreFormatter: .filtered,
                startingFrom: 0
            )
            .html
        )
    }
}

private func generateList(
    for result: AnalysisResult,
    scoreFormatter: ComputedScoreFormatter,
    startingFrom index: Int
) -> (html: [Html], lastIndex: Int) {
    var list: [Html] = []

    var i = index

    let initialNesting = result.scales[index].identifier.nesting

    while i < result.scales.count {
        let scale = result.scales[i]
        let nesting = scale.identifier.nesting

        var scaleHtml = generateItem(for: scale, scoreFormatter: scoreFormatter)

        defer {
            list.append(.li(attributes: ["class": "depth\(nesting)"], content: scaleHtml))
        }

        if i + 1 < result.scales.count {
            let nextNesting = result.scales[i+1].identifier.nesting

            if nextNesting < initialNesting {
                break
            }
            else if nextNesting > initialNesting {
                let sublist = generateList(for: result, scoreFormatter: scoreFormatter, startingFrom: i+1)
                scaleHtml.append(.ul(content: sublist.html))
                i = sublist.lastIndex
            }
        }

        i += 1
    }

    return (list, i)
}

private func generateItem(
    for scale: BoundScale,
    scoreFormatter: ComputedScoreFormatter
) -> [Html] {
    return [
        scale.index > 0 ? .tag("index", content: .content("\(scale.index).")) : .empty,
        .tag("text", content: .content(scale.title)),
        .tag("score", content: .content(scoreFormatter.format(scale.score)))
    ]
}
