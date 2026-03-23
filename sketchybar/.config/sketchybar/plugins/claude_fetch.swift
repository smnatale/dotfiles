#!/usr/bin/env swift
import Foundation

let cookieFile = NSString(string: "~/.config/sketchybar/claude_cookie").expandingTildeInPath
guard let cookie = try? String(contentsOfFile: cookieFile, encoding: .utf8).trimmingCharacters(in: .whitespacesAndNewlines) else {
    print("{\"error\": \"no cookie file\"}")
    exit(1)
}

// Extract org ID from cookie
var orgId: String?
for part in cookie.components(separatedBy: ";") {
    let trimmed = part.trimmingCharacters(in: .whitespaces)
    if trimmed.hasPrefix("lastActiveOrg=") {
        orgId = trimmed.replacingOccurrences(of: "lastActiveOrg=", with: "")
        break
    }
}

guard let org = orgId else {
    print("{\"error\": \"no org id\"}")
    exit(1)
}

let urlString = "https://claude.ai/api/organizations/\(org)/usage"
guard let url = URL(string: urlString) else {
    print("{\"error\": \"bad url\"}")
    exit(1)
}

var request = URLRequest(url: url)
request.httpMethod = "GET"
request.setValue(cookie, forHTTPHeaderField: "Cookie")
request.setValue("*/*", forHTTPHeaderField: "Accept")
request.setValue("application/json", forHTTPHeaderField: "Content-Type")
request.setValue("https://claude.ai", forHTTPHeaderField: "Origin")
request.setValue("https://claude.ai", forHTTPHeaderField: "Referer")
request.setValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36", forHTTPHeaderField: "User-Agent")

let semaphore = DispatchSemaphore(value: 0)

URLSession.shared.dataTask(with: request) { data, response, error in
    defer { semaphore.signal() }

    if let error = error {
        print("{\"error\": \"\(error.localizedDescription)\"}")
        return
    }

    guard let http = response as? HTTPURLResponse, http.statusCode == 200, let data = data else {
        let code = (response as? HTTPURLResponse)?.statusCode ?? 0
        print("{\"error\": \"http \(code)\"}")
        return
    }

    guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
        print("{\"error\": \"parse error\"}")
        return
    }

    let session = (json["five_hour"] as? [String: Any])?["utilization"] as? Double ?? 0
    let weekly = (json["seven_day"] as? [String: Any])?["utilization"] as? Double ?? 0

    print("{\"session\": \(Int(session)), \"weekly\": \(Int(weekly))}")
}.resume()

semaphore.wait()
