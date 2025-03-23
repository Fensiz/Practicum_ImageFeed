//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Симонов Иван Дмитриевич on 16.02.2025.
//

import Foundation

extension URLSession {
	func data(
		for request: URLRequest,
		completion: @escaping (Result<Data, ServiceError>) -> Void
	) -> URLSessionTask {
		let fulfillCompletionOnTheMainThread: (Result<Data, ServiceError>) -> Void = { result in
			if case let .failure(error) = result {
				ServiceError.log(error: error)
			}
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

extension URLSession {
	func objectTask<T: Decodable>(
		for request: URLRequest,
		completion: @escaping (Result<T, ServiceError>) -> Void
	) -> URLSessionTask {
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		let task = data(for: request) { result in
			switch result {
				case .success(let data):
					do {
						let decodedData: T = try decoder.decode(T.self, from: data)
						completion(.success(decodedData))
					} catch {
						completion(.failure(.decodingError(data, error)))
					}
				case .failure(let error):
					completion(.failure(error))
			}
		}
		return task
	}
}
