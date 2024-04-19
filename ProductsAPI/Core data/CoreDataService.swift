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
  
  private let searchesLimit: Int = 30
  
  func getSearchHistory() -> [Search]? {
    let fetchRequest: NSFetchRequest<Search> = Search.fetchRequest()
    
    // Newest searches first
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
    
    do {
      let searches = try context.fetch(fetchRequest)
      return searches
    } catch {
//      Log.error("Failed to fetch Search models from Core Data. Error: \(error)")
      return nil
    }
  }
  
  func saveNewSearch(_ searchText: String) {
    
    guard searchText.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 else { return }
    
    guard !searchExists(search: searchText) else { return }
    
    guard canHaveMoreInstances(entityName: "Search", limit: searchesLimit) else { return }
    
    let newSearch = Search(context: context)
    
    newSearch.searchText = searchText
    newSearch.created = Date()
    
    context.insert(newSearch)
    
    do {
      try context.save()
    } catch {
//      Log.warning("Failed to save a new search to Core Data. Error: \(error)")
    }
  }
  
  func deleteSearch(_ search: Search) -> Bool {
    context.delete(search)

    do {
      try context.save()
      return true
    } catch {
//      Log.error("Failed to delete a Search model from Core Data. Error: \(error)")
      return false
    }
  }
  
  private func searchExists(search: String) -> Bool {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Search")
    fetchRequest.predicate = NSPredicate(format: "searchText == %@", search)
    let res = try! context.fetch(fetchRequest)
    
    return res.count > 0 ? true : false
  }
  
  private func canHaveMoreInstances(entityName: String, limit: Int) -> Bool {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    let count = try? context.count(for: fetchRequest)

    if let count = count, count < limit {
      return true
    } else {
      return false
    }
  }
}
