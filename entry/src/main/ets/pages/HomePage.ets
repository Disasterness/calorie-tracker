import { ComponentContent } from '@kit.ArkUI';
import { NavigationService } from '../core/services/NavigationService';
import { TrackerService } from '../core/services/TrackerService';
import { MacroModel } from '../core/models/MacroModel';


@Component
export struct HomePage {
  @State trackerService: TrackerService = TrackerService.instance();

  build() {
    List({ initialIndex: 0 }) {
      ListItem() {
        MacroItem({
          color: $r('app.color.kcal_menu_item_color'),
          title: 'Calorie',
          current: this.trackerService.currentMacroModel.kcal,
          target: this.trackerService.targetMacroModel.kcal
        })
      };

      ListItem() {
        MacroItem({
          color: $r('app.color.protein_menu_item_color'),
          title: 'Protein',
          current: this.trackerService.currentMacroModel.protein,
          target: this.trackerService.targetMacroModel.protein
        })
      };

      ListItem() {
        MacroItem({
          color: $r('app.color.fat_menu_item_color'),
          title: 'Fat',
          current: this.trackerService.currentMacroModel.fat,
          target: this.trackerService.targetMacroModel.fat
        })
      };

      ListItem() {
        MacroItem({
          color: $r('app.color.carb_menu_item_color'),
          title: 'Carbs',
          current: this.trackerService.currentMacroModel.carbs,
          target: this.trackerService.targetMacroModel.carbs
        })
      }

      ListItem() {
        Button('History')
          .onClick(() => {
            NavigationService.getInstance().pageInfos.pushPath({ name: 'HistoryPage' })
          })
          .backgroundColor(Color.Transparent)
          .border({ width: 1, color: Color.White })
          .margin({ top: 10 })
          .alignSelf(ItemAlign.Center)
      }
    }
    .height('100%')
    .width('100%')
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [[$r('app.color.base_background_gradient_start'), 0.0],
        [$r('app.color.base_background_gradient_end'), 1]]
    })
    .alignListItem(ListItemAlign.Center)
  }
}

@Component
struct MacroItem {
  color: ResourceColor = Color.Black;
  title: string = '';
  @Prop current: number = 0;
  @Prop target: number = 0;

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontSize($r(`app.float.menu_item_font_size`))
          .fontColor(Color.White)
          .textAlign(TextAlign.End)
          .fontWeight(FontWeight.Bold)
          .textShadow({
            radius: 0.01,
            color: Color.Black,
            offsetX: 0,
            offsetY: 0
          })
          .lineHeight(18);
        Text(`${this.current} / ${this.target}`)
          .fontSize($r(`app.float.menu_item_font_size`))
          .fontColor(Color.White)
          .textAlign(TextAlign.End)
          .fontWeight(FontWeight.Bold)
          .textShadow({
            radius: 0.01,
            color: Color.Black,
            offsetX: 0,
            offsetY: 0
          })
          .lineHeight(18)

      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row() {
        Text(this.target - this.current > 0 ? `${this.target - this.current} left` : "Goal reached")
          .fontSize(10)
          .fontColor(Color.White)
          .opacity(0.8)
      }
      .justifyContent(FlexAlign.End)
      .width('100%')
    }
    .width('80%')
    .borderRadius(6)
    .margin({ bottom: 8 })
    .padding({
      left: 8,
      right: 8,
      top: 4,
      bottom: 4
    })
    .backgroundColor(this.color)
    .onClick(() => {
      NavigationService.getInstance().arg = this.title;
      NavigationService.getInstance().pageInfos.pushPath({ name: 'SetMacroPage' })
    })
  }
}
