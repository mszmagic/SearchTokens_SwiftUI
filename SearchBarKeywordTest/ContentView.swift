//
//  ContentView.swift
//  SearchBarKeywordTest
//
//  Created by Shunzhe on 2022/01/30.
//

import SwiftUI
import UIKit
import Combine

struct ContentView: View {
    
    /// Variables used by `SearchView`
    @State private var searchText: String = ""
    @State private var searchTokens: [UISearchToken]
    
    init(searchTokens: [UISearchToken]) {
        self._searchTokens = .init(initialValue: searchTokens)
    }
    
    var body: some View {
        Form {
            Section {
                Text("Search term: \(searchText)")
                Text("Search tokens: \(searchTokens.getTokenNames().description)")
            }
        }.overlay(
            SearchBar(searchText: $searchText, searchTokens: $searchTokens).frame(width: 0, height: 0)
        )
    }
    
}

extension UISearchToken {
    // Each UISearchToken contains a represented object. The object can be an identifier.
    func getTokenWithIdentifier(_ identifier: String) -> UISearchToken {
        self.representedObject = identifier
        return self
    }
}

extension Array where Element == UISearchToken {
    func getTokenNames() -> [String] {
        var combinedNames: [String] = []
        for item in self {
            if let identifier = item.representedObject as? String {
                combinedNames.append(identifier)
            }
        }
        return combinedNames
    }
}

class NavBarEmbeddedSearch: UIViewController {
    
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.parent?.navigationItem.searchController = searchController
    }
    
}

fileprivate struct SearchBar: UIViewControllerRepresentable {
    
    @Binding var searchText: String
    @Binding var searchTokens: [UISearchToken]
    
    init(searchText: Binding<String>, searchTokens: Binding<[UISearchToken]>) {
        self._searchText = searchText
        self._searchTokens = searchTokens
    }
    
    func makeUIViewController(context: Context) -> NavBarEmbeddedSearch {
        
        let controller = NavBarEmbeddedSearch()
        
        controller.searchController.searchResultsUpdater = context.coordinator
        
        controller.searchController.searchBar.searchTextField.tokens = searchTokens
        
        return controller
    }
    
    func updateUIViewController(_ controller: NavBarEmbeddedSearch, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(searchText: $searchText, searchTokens: $searchTokens)
    }
    
    class Coordinator: NSObject, UISearchResultsUpdating {
        
        @Binding var searchText: String
        @Binding var searchTokens: [UISearchToken]
        
        init(searchText: Binding<String>, searchTokens: Binding<[UISearchToken]>) {
            self._searchText = searchText
            self._searchTokens = searchTokens
        }
        
        func updateSearchResults(for searchController: UISearchController) {
            guard let text = searchController.searchBar.text else { return }
            self.searchText = text
            self.searchTokens = searchController.searchBar.searchTextField.tokens
        }
    }
    
}
