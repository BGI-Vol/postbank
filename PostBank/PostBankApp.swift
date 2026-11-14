import SwiftUI

@main
struct PostBankApp: App {
    // 必须用 shared：EditableAmount 通过 AppStore.shared 改余额，
    // 若这里新建实例，两处会指向不同对象导致数据不同步
    @State private var store = AppStore.shared

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(store)
                .preferredColorScheme(.light)
        }
    }
}