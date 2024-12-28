//
//  PaperModelView.swift
//  PaperAppV2
//
//  Created by Sothesom on 08/10/1403.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class PaperModelView: ObservableObject {
    // Published properties
    @Published var papers: [PaperMod] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    // Firebase references
    private let db = Firestore.firestore()
    private let storage = Storage.storage().reference()
    
    // MARK: - Fetch Papers
    func fetchPapers(category: PaperMod.PaperCategory? = nil) {
        isLoading = true
        
        var query: Query = db.collection("papers").order(by: "publishDate", descending: true)
        
        if let category = category {
            query = query.whereField("category", isEqualTo: category.rawValue)
        }
        
        query.addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            self.isLoading = false
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let documents = snapshot?.documents else {
                self.errorMessage = "No documents found"
                return
            }
            
            self.papers = documents.compactMap { document -> PaperMod? in
                try? document.data(as: PaperMod.self)
            }
        }
    }
    
    // MARK: - Add Paper
    func addPaper(_ paper: PaperMod, coverImage: UIImage? = nil) {
        isLoading = true
        
        // First upload the image if exists
        if let coverImage = coverImage {
            uploadImage(coverImage) { [weak self] result in
                switch result {
                case .success(let url):
                    var updatedPaper = paper
                    updatedPaper.coverImageURL = url
                    self?.savePaper(updatedPaper)
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.isLoading = false
                }
            }
        } else {
            savePaper(paper)
        }
    }
    
    // MARK: - Helper Methods
    private func savePaper(_ paper: PaperMod) {
        do {
            _ = try db.collection("papers").addDocument(from: paper)
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
    
    private func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
            return
        }
        
        let imageRef = storage.child("paper_images/\(UUID().uuidString).jpg")
        
        imageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            imageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                } else if let url = url {
                    completion(.success(url.absoluteString))
                }
            }
        }
    }
}
