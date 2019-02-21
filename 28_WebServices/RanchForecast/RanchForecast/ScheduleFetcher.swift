//
//  ScheduleFetcher.swift
//  RanchForecast
//
//  Created by Jason Zheng on 6/1/16.
//  Copyright © 2016 Jason Zheng. All rights reserved.
//

import Foundation

class ScheduleFetcher {
  enum FetchCoursesResult {
    case Succeed([Course])
    case Failed(NSError)
  }
  let session: URLSession
  init() {
    let config = URLSessionConfiguration.default
    session = URLSession(configuration: config)
  }
  
    func fetchCourses(completionHandler: @escaping ((FetchCoursesResult) -> Void)) -> Void {
        let url = NSURL(string: "https://bookapi.bignerdranch.com/courses.json")!
        let request = URLRequest(url: url as URL)
        let task = session.dataTask(with: request) { [unowned self] (data, response, error) in
            var fetchCourseResult: FetchCoursesResult
            if data == nil {
                fetchCourseResult = FetchCoursesResult.Failed(error! as NSError)
            } else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    fetchCourseResult = self.parseCoursesFrom(data: data! as NSData)
                } else {
                    fetchCourseResult = FetchCoursesResult.Failed (
                        self.errorWithCode(code: 2, localizedDescription: "Http response status code: \(httpResponse.statusCode)."))
                }

            } else {
                fetchCourseResult = FetchCoursesResult.Failed(
                    self.errorWithCode(code: 1, localizedDescription: "Invalid response."))
            }
//            OperationQueue.main.addOperation {
//                completionHandler(fetchCourseResult)
//            }
            DispatchQueue.main.async {
                completionHandler(fetchCourseResult)
            }
        }
        task.resume()
    }
  
  func parseCoursesFrom(data: NSData) -> FetchCoursesResult {
    var fetchError: NSError?
    do {
        if let json = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? NSDictionary {
        if let coursesDict = json["courses"] as? [NSDictionary] {
          var courses = [Course]()
          
          for dict in coursesDict {
            if let course = parseCourseFrom(dict: dict) {
              courses.append(course)
            }
          }
          
          return FetchCoursesResult.Succeed(courses)
        } else {
            fetchError = errorWithCode(code: 4, localizedDescription: "Failed to courses dictionary.")
        }
      }
      
    } catch {
        fetchError = errorWithCode(code: 4, localizedDescription: "Failed to generate JSON object.")
    }
    
    return FetchCoursesResult.Failed(fetchError!)
  }
  
  func parseCourseFrom(dict: NSDictionary) -> Course? {
    var course: Course?
    if let title = dict["title"] as? String, let urlString = dict["url"] as? String, let upcoming = dict["upcoming"] as? [NSDictionary] {
        if let url = NSURL(string: urlString), let startDateString = upcoming.first?["start_date"] as? String {
            let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: startDateString) {
                course = Course(title: title, url: url, nextStartDate: date as NSDate)
        }
      }
    }
    return course
  }
  
  func errorWithCode(code: Int, localizedDescription: String) -> NSError {
    return NSError(domain: "ScheduleFetcher", code: code,
                   userInfo: [NSLocalizedDescriptionKey: localizedDescription])
  }
}
