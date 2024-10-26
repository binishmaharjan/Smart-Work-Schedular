import CalendarKit
import ComposableArchitecture
import NavigationBarFeature
import SettingsFeature
import SharedUIs
import SwiftUI

@ViewAction(for: Schedule.self)
public struct ScheduleView: View {
    public init(store: StoreOf<Schedule>) {
        self.store = store
    }
    
    @Bindable public var store: StoreOf<Schedule>
    @State private var sheetHeight: CGFloat = .zero
    @State private var needsToCreateNewDays = false
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    
    public var body: some View {
        NavigationStack {
            VStack {
                weekdays()
                .padding(.bottom, 8)

                calendarPanel()
            }
            .padding(.top, 50) // Takes space for navigation bar
            .padding(.top, 8)
            .background(#color("background"))
            .overlay(navigationBar)
        }
        .onAppear { send(.onAppear) }
        .sheet(
            item: $store.scope(state: \.destination?.calendarMode, action: \.destination.calendarMode),
            content: calendarMode(store:)
        )
        .fullScreenCover(
            item: $store.scope(state: \.destination?.settings, action: \.destination.settings),
            content: SettingsView.init(store:)
        )
        .onChange(of: store.currentPage, initial: false) { _, newValue in
            // create week if the page reaches first/last page
            if newValue == 0 || newValue == (store.schedulePanels.count - 1) {
                needsToCreateNewDays = true
            }
        }
    }
}

// MARK: Views
extension ScheduleView {
    private var navigationBar: some View {
        NavigationBarView(
            store: store.scope(state: \.navigationBar, action: \.navigationBar)
        )
    }
    
    @ViewBuilder
    private func weekdays() -> some View {
        LazyVGrid(columns: columns) {
            ForEach(store.weekdays, id: \.self) { weekday in
                Text(weekday)
            }
        }
        .font(.customSubheadline)
        .foregroundStyle(#color("text_color"))
    }
    
    @ViewBuilder
    private func calendarPanel() -> some View {
        TabView(selection: $store.currentPage) {
            ForEach(
                Array(store.scope(state: \.schedulePanels, action: \.schedulePanels).enumerated()),
                id: \.element.id
            ) { index, schedulePanelStore in
                schedulePanel(for: schedulePanelStore)
                    .tag(index)
                    .background {
                        GeometryReader { proxy in
                            let minX = proxy.frame(in: .global).minX
                            
                            Color.clear
                                .preference(key: OffsetPreferenceKey.self, value: minX)
                                .onPreferenceChange(OffsetPreferenceKey.self) { value in
                                    // when offset reaches 0 and if createWeek is toggled  then
                                    // simply generate next set of dates
                                    if value == 0 && needsToCreateNewDays {
                                        send(.scrollEndReached)
                                        needsToCreateNewDays = false
                                    }
                                }
                        }
                    }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    private func schedulePanel(for store: StoreOf<SchedulePanel>) -> some View {
        switch store.displayMode {
        case .month:
            return AnyView(MonthPanelView(store: store))
            
        case .week:
            return AnyView(MonthPanelView(store: store))
            
        case .day:
            return AnyView(
                VStack {
                    Text("Day View")
                    ForEach(store.displayDays) { day in
                        Text(day.formatted(.calendarDay))
                    }
                }
            )
        }
    }
    
    private func calendarMode(store: StoreOf<CalendarMode>) -> some View {
        CalendarModeView(store: store)
            .overlay {
                GeometryReader { geometry in
                    Color.clear.preference(
                        key: InnerHeightPreferenceKey.self,
                        value: geometry.size.height
                    )
                }
            }
            .onPreferenceChange(InnerHeightPreferenceKey.self) { newHeight in
                sheetHeight = newHeight
            }
            .presentationDetents([.height(sheetHeight)])
    }
}

#Preview {
    ScheduleView(
        store: .init(
            initialState: .init(),
            reducer: Schedule.init
        )
    )
}

/* PageViewController Example
import UIKit
PageViewController(
    pages: pages.map { page in
        page
            .cornerRadius(8, corners: .allCorners)
            .appShadow(opacity: 0.08)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .inset(by: 0.5)
                    .stroke(Color.app(.mainWhite), lineWidth: 1)
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.bottom, 12)
    },
    currentPage: $currentPage
)

struct PageViewController<Page: View>: UIViewControllerRepresentable {
    let pages: [Page]
    @Binding var currentPage: Int

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal
        )
        pageViewController.view.backgroundColor = .clear
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator

        return pageViewController
    }

    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            [context.coordinator.controllers[currentPage]],
            direction: .forward,
            animated: true
        )
    }

    final class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        let parent: PageViewController
        let controllers: [UIViewController]

        init(_ pageViewController: PageViewController) {
            parent = pageViewController
            controllers = parent.pages.map { UIHostingController(rootView: $0) }

            controllers.forEach {
                $0.view.backgroundColor = .clear
            }
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController
        ) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            return controllers[index - 1]
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController
        ) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            return controllers[index + 1]
        }

        func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool
        ) {
            if completed, let visibleViewController = pageViewController.viewControllers?.first, let index = controllers.firstIndex(of: visibleViewController) {
                parent.currentPage = index
            }
        }
    }
}
*/
