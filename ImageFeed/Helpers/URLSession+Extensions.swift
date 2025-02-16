//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 16.02.2025.
//

import Foundation

extension URLSession {
	enum NetworkError: Error {
		case httpStatusCode(Int)
		case urlRequestError(Error)
		case urlSessionError
	}
	func data(
		for request: URLRequest,
		completion: @escaping (Result<Data, NetworkError>) -> Void
	) -> URLSessionTask {
		let fulfillCompletionOnTheMainThread: (Result<Data, NetworkError>) -> Void = { result in
			DispatchQueue.main.async {
				completion(result)
			}
		}

		let task = dataTask(with: request, completionHandler: { data, response, error in
			if let error {
				fulfillCompletionOnTheMainThread(.failure(.urlRequestError(error)))
			} else if
				let data,
				let response,
				let statusCode = (response as? HTTPURLResponse)?.statusCode
			{
				if 200 ..< 300 ~= statusCode {
					fulfillCompletionOnTheMainThread(.success(data))
				} else {
					fulfillCompletionOnTheMainThread(.failure(.httpStatusCode(statusCode)))
				}
			} else {
				fulfillCompletionOnTheMainThread(.failure(.urlSessionError))
			}
		})

		return task
	}
}
