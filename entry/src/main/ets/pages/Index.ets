import { NavigationService } from '../core/services/NavigationService';
import { TrackerService } from '../core/services/TrackerService';
import { HomePage } from './HomePage';
import { SetMacroPage } from './SetMacroPage';
import { HistoryPage } from './HistoryPage';


@Entry
@Component
struct Index {
  @State trackerService: TrackerService = TrackerService.instance();
  context: UIContext = this.getUIContext();

  async aboutToAppear(): Promise<void> {
    await this.trackerService.init(this.context.getApplicationContext());
    this.trackerService.setHeader(this.context);
    NavigationService.getInstance().pageInfos.pushPath({ name: 'HomePage' });
  }

  @Builder
  routeMap(name: string) {
    NavDestination() {
      if (name === 'HomePage') {
        HomePage();
      } else if (name === 'SetMacroPage') {
        SetMacroPage()
      } else if (name === 'HistoryPage') {
        HistoryPage()
      }
    }.hideTitleBar(true)
  }

  build() {
    Navigation(NavigationService.getInstance().pageInfos) {
      RelativeContainer()
    }
    .onNavBarStateChange((e) => {
      if (NavigationService.getInstance().pageInfos.getAllPathName().length === 0) {
        NavigationService.getInstance().pageInfos.pushPath({ name: 'HomePage' });
      }
    })
    .navDestination(this.routeMap)
    .ignoreLayoutSafeArea()
    .hideTitleBar(true)
  }
}
