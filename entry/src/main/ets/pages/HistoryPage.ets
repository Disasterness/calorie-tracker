import { ArcList, ArcListItem } from '@kit.ArkUI';
import { TrackerService } from '../core/services/TrackerService';
import { HistoryRecord } from '../core/models/HistoryRecord';

@Entry
@Component
export struct HistoryPage {
  @State trackerService: TrackerService = TrackerService.instance();

  build() {
    Column() {
      Text("Last 7 Days")
        .fontSize(20)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 10 })

      ArcList() {
        ForEach(this.trackerService.history, (item: HistoryRecord, index: number) => {
          ArcListItem() {
            Column() {
              Text(item.date)
                .fontSize(16)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bold)
              Row() {
                Text(`Kcal: ${item.macros.kcal}`)
                  .fontSize(12)
                  .fontColor(Color.White)
                  .margin({ right: 5 })
                Text(`P: ${item.macros.protein}`)
                  .fontSize(12)
                  .fontColor(Color.White)
                  .margin({ right: 5 })
                Text(`F: ${item.macros.fat}`)
                  .fontSize(12)
                  .fontColor(Color.White)
                  .margin({ right: 5 })
                Text(`C: ${item.macros.carbs}`)
                  .fontSize(12)
                  .fontColor(Color.White)
              }
            }
            .width('80%')
            .padding(10)
            .backgroundColor('#33000000')
            .borderRadius(10)
            .margin({ bottom: 5 })
          }
        }, (item: HistoryRecord) => item.date)
      }
      .height('100%')
      .width('100%')
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
