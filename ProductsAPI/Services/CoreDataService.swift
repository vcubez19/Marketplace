//
//  CoreDataService.swift
//  ProductsAPI
//
//  Created by Vincent Cubit on 1/23/24.
//

import Foundation
import UIKit
import CoreData

struct CoreDataService {
  
  static let shared = CoreDataService()
  
  private init() {}
  
  private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  func getSearchHistory() -> [Search]? {
    let fetchRequest: NSFetchRequest<Search> = Search.fetchRequest()
    
    // Newest searches first
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
    
    do {
      let searches = try context.fetch(fetchRequest)
      return searches
    } catch {
      // TODO: Log
      return nil
    }
  }
  
  func saveNewSearch(_ searchText: String) {
    
    guard searchText.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else { return }
    
    let newSearch = Search(context: context)
    
    newSearch.searchText = searchText
    newSearch.created = Date()
    
    context.insert(newSearch)
    
    do {
      try context.save()
    } catch {
      // TODO: Log
    }
  }
  
  func deleteSearch(_ search: Search) -> Bool {
    context.delete(search)

    do {
      try context.save()
      return true
    } catch {
      // TODO: Log
      return false
    }
  }
}
