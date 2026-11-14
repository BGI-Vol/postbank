import SwiftUI

struct RootTabView: View {
    @Environment(AppStore.self) private var store
    @State private var tab = 0

    var body: some View {
        TabView(selection: $tab) {
            HomeView()
                .tabItem { Label("首页", systemImage: tab == 0 ? "house.fill" : "house") }
                .tag(0)

            CreditCardView()
                .tabItem { Label("信用卡", systemImage: tab == 1 ? "creditcard.fill" : "creditcard") }
                .tag(1)

            WealthView()
                .tabItem { Label("财富", systemImage: tab == 2 ? "chart.line.uptrend.xyaxis.circle.fill" : "chart.line.uptrend.xyaxis") }
                .tag(2)

            LifeView()
                .tabItem { Label("生活", systemImage: tab == 3 ? "bag.fill" : "bag") }
                .tag(3)

            MineView()
                .tabItem { Label("我的", systemImage: tab == 4 ? "person.fill" : "person") }
                .tag(4)
        }
        .tint(C.brandGreen)
    }
}