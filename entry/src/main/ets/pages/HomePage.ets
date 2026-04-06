import { ArcList, ArcListItem, ArcListAttribute, ArcListItemAttribute, ComponentContent } from '@kit.ArkUI';
import { NavigationService } from '../core/services/NavigationService';
import { TrackerService } from '../core/services/TrackerService';


@Entry
@Component
export struct HomePage {
  @State trackerService: TrackerService = TrackerService.instance();

  @Builder
  singleMenuItem(color: ResourceColor, title: string, currentMacro: string, target: string) {
    const remaining = Number(target) - Number(currentMacro);
    const remainingText = remaining > 0 ? `${remaining} left` : "Goal reached";

    Column() {
      Row() {
        Text(title)
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
      Text(`${currentMacro} / ${target}`)
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
        Text(remainingText)
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
    .backgroundColor(color)
    .onClick(() => {
      NavigationService.getInstance().arg = title;
      NavigationService.getInstance().pageInfos.pushPath({ name: 'SetMacroPage' })
    })

  }

  build() {
    ArcList({ initialIndex: 0, header: this.trackerService.header }) {
      ArcListItem() {
        this.singleMenuItem($r('app.color.kcal_menu_item_color'), 'Calorie',
          this.trackerService.currentMacroModel.kcal.toString(),
          this.trackerService.targetMacroModel.kcal.toString(),);
      };

      ArcListItem() {
        this.singleMenuItem($r('app.color.protein_menu_item_color'), 'Protein',
          this.trackerService.currentMacroModel.protein.toString(),
          this.trackerService.targetMacroModel.protein.toString(),);
      };

      ArcListItem() {
        this.singleMenuItem($r('app.color.fat_menu_item_color'), 'Fat',
          this.trackerService.currentMacroModel.fat.toString(), this.trackerService.targetMacroModel.fat.toString(),);
      };

      ArcListItem() {
        this.singleMenuItem($r('app.color.carb_menu_item_color'), 'Carbs',
          this.trackerService.currentMacroModel.carbs.toString(),
          this.trackerService.targetMacroModel.carbs.toString(),);
      }

      ArcListItem() {
        Button('History')
          .onClick(() => {
            NavigationService.getInstance().pageInfos.pushPath({ name: 'HistoryPage' })
          })
          .backgroundColor(Color.Transparent)
          .border({ width: 1, color: Color.White })
          .margin({ top: 10 })
      }
    }
    .height('100%')
    .width('100%')
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [[$r('app.color.base_background_gradient_start'), 0.0],
        [$r('app.color.base_background_gradient_end'), 1]]
    })
  }
}
