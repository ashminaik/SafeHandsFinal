import Foundation

struct AnthropicService {

    // MARK: - API Key Rotation
    // Keys are tried in order. If one hits 429 (out of credits) or 401 (invalid),
    // we rotate to the next key and retry automatically. The user never notices.

    // The keys are sourced from `Secrets.groqAPIKeys` which should be
    // defined in a local-only `Secrets.swift` file (see `.gitignore`).
    // This keeps API keys out of the repository.
    private static var apiKeys: [String] {
        // If the developer has created a Secrets.swift with groqAPIKeys,
        // use it. Otherwise fall back to an empty array so the code will
        // fail fast and prompt the developer to add keys.
        return Secrets.groqAPIKeys
    }

    /// Tracks which key to try first. Persists across calls so once a key
    /// is known-dead we start with the working one next time.
    private static var currentKeyIndex: Int = 0

    private static let apiURL = URL(string: "https://api.groq.com/openai/v1/chat/completions")!

    // MARK: - Public API

    static func stream(
        messages: [[String: String]],
        systemPrompt: String
    ) async throws -> AsyncThrowingStream<String, Error> {

        // Build the shared message payload once — only the key changes between retries
        var allMessages: [[String: String]] = [
            ["role": "system", "content": systemPrompt]
        ]
        allMessages.append(contentsOf: messages)

        let body: [String: Any] = [
            "model": "llama-3.3-70b-versatile",
            "stream": true,
            "messages": allMessages
        ]

        let bodyData = try JSONSerialization.data(withJSONObject: body)

        // Try every key starting from the current one. If a key fails with
        // 429 or 401, rotate and retry with the next key. If ALL keys are
        // exhausted, throw the last error so the UI can show it.
        let startIndex = currentKeyIndex
        var lastError: Error?

        for attempt in 0..<apiKeys.count {
            let keyIndex = (startIndex + attempt) % apiKeys.count
            let key = apiKeys[keyIndex]

            let result = await tryStream(apiKey: key, bodyData: bodyData)

            switch result {
            case .success(let stream):
                // This key works — remember it for next time
                currentKeyIndex = keyIndex
                return stream

            case .shouldRotate(let error):
                // 429 or 401 — this key is dead, try the next one
                print("[AnthropicService] Key \(keyIndex + 1)/\(apiKeys.count) failed, rotating...")
                lastError = error
                continue

            case .fatalError(let error):
                // 404, 500, etc. — rotating keys won't help
                throw error
            }
        }

        // All keys exhausted
        print("[AnthropicService] All \(apiKeys.count) API keys exhausted.")
        throw lastError ?? NSError(
            domain: "AnthropicService",
            code: 429,
            userInfo: [NSLocalizedDescriptionKey: "All API keys are out of credits. Please add a new key."]
        )
    }

    // MARK: - Internal

    private enum StreamResult {
        case success(AsyncThrowingStream<String, Error>)
        case shouldRotate(Error)
        case fatalError(Error)
    }

    /// Attempts a single streaming request with one specific API key.
    /// Returns a result that tells the caller whether to use the stream,
    /// rotate to the next key, or give up entirely.
    private static func tryStream(
        apiKey: String,
        bodyData: Data
    ) async -> StreamResult {

        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = bodyData

        do {
            let (bytes, response) = try await URLSession.shared.bytes(for: request)

            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode != 200 {

                // Drain the error body for logging
                var errorBody = ""
                for try await line in bytes.lines {
                    errorBody += line
                }

                let statusCode = httpResponse.statusCode
                print("[AnthropicService] API error \(statusCode): \(errorBody)")

                let detail: String
                switch statusCode {
                case 401:
                    detail = "Invalid API key."
                case 429:
                    detail = "Rate limited or out of credits."
                case 404:
                    detail = "Model not found. Check the model name."
                default:
                    detail = "Server error (\(statusCode))."
                }

                let error = NSError(
                    domain: "AnthropicService",
                    code: statusCode,
                    userInfo: [NSLocalizedDescriptionKey: detail]
                )

                // 429 and 401 are key-specific — rotation can fix them
                if statusCode == 429 || statusCode == 401 {
                    return .shouldRotate(error)
                }

                // Everything else is a problem rotation won't solve
                return .fatalError(error)
            }

            // Status 200 — wrap the byte stream into an AsyncThrowingStream
            let stream = AsyncThrowingStream<String, Error> { continuation in
                Task {
                    do {
                        for try await line in bytes.lines {
                            try Task.checkCancellation()

                            guard line.hasPrefix("data: ") else { continue }
                            let jsonString = String(line.dropFirst(6))
                            guard jsonString != "[DONE]" else {
                                continuation.finish()
                                return
                            }

                            if let data = jsonString.data(using: .utf8),
                               let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                               let choices = json["choices"] as? [[String: Any]],
                               let delta = choices.first?["delta"] as? [String: Any],
                               let text = delta["content"] as? String {
                                continuation.yield(text)
                            }
                        }
                        continuation.finish()
                    } catch {
                        continuation.finish(throwing: error)
                    }
                }
            }

            return .success(stream)

        } catch {
            // Network error — not key-related, don't rotate
            return .fatalError(error)
        }
    }
}
