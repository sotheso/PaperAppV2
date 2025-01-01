//
//import SwiftUI
//
//struct ContentView: View {
//    @AppStorage("isLoggedIn") private var isLoggedIn = false
//    
//    var body: some View {
//        VStack {
//            LogView(isLoggedIn: $isLoggedIn)
//        }
//        .padding()
//        .onAppear {
//            NotificationCenter.default.addObserver(forName: .didSignOut, object: nil, queue: .main) { _ in
//                isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
//            }
//        }
//    }
//}
//
//#Preview {
//    ContentView()
//}
//
//extension Notification.Name {
//    static let didSignOut = Notification.Name("didSignOut")
//}
