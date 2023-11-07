import Foundation
import ArgumentParser
import SwiftCSV

@main
struct LocalizableParser: ParsableCommand {
    static var configuration: CommandConfiguration = .init(
        abstract: "多语言文案 CSV 文件转 Localizable.strings 文件"
    )
    
    @Argument(help: "需要转换的 CSV 文件路径")
    var filePath: String
    
    @Option(name: .shortAndLong, help: "多语言文本 key 的前缀, 格式为\"[prefix-第一列文案]\", 建议使用版本号, 默认为空")
    var prefix: String = ""
    
    mutating func run() throws {
        guard FileManager.default.fileExists(atPath: filePath),
              filePath.hasSuffix(".csv"),
              let csv = try? CSV<Enumerated>(url: URL(fileURLWithPath: filePath))
        else {
            print("请提供正确 CSV 格式的文件🌚")
            return
        }
        
        let header = csv.header.filter { !$0.isEmpty }
        var dict = [String: String]()
        for row in csv.rows {
            let actualRow = row.filter { !$0.isEmpty }
            guard !actualRow.isEmpty else { continue }
            guard actualRow.count == header.count else {
                print("提供的数据不完整...")
                return
            }
            guard actualRow != header else { continue }
            
            var key = actualRow[0].trimmingCharacters(in: .whitespacesAndNewlines)
            key = !prefix.isEmpty ? "\"[\(prefix)-\(key)]\"" : "\"[\(key)]\""
            
            for index in 0..<actualRow.count {
                let value = actualRow[index].trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "xxx", with: "%@")
                let output = key + " = \"\(value)\";\n"
                if let old = dict[header[index]] {
                    dict[header[index]] = old + output
                } else {
                    dict[header[index]] = output
                }
            }
        }
        
        guard !dict.isEmpty else {
            print("请提供有实质内容的文件🫠")
            return
        }
        
        do {
            let directoryUrl = URL(fileURLWithPath: filePath)
                                    .deletingLastPathComponent()
                                    .appendingPathComponent("Localizable.generated", isDirectory: true)
            try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true)
            dict.forEach { (key, value) in
                let path = directoryUrl.appendingPathComponent("Localizable-\(key).strings", isDirectory: false).path
                if FileManager.default.createFile(atPath: path, contents: value.data(using: .utf8)) {
                    print("生成文件: \(path)")
                } else {
                    print("生成文件: \(path) 失败!!!")
                }
            }
        } catch(let error) {
            print("生成 Localizable.strings 文件失败...")
            print("错误: \(error.localizedDescription)")
        }
    }
}
