import { ArcList, ArcListItem } from '@kit.ArkUI';
import { NavigationService } from '../core/services/NavigationService';
import { TrackerService } from '../core/services/TrackerService';

@Entry
@Component
struct SetMacroPage {
  context: UIContext = this.getUIContext()
  @State gaugeValue: number = 0;
  @State gaugeTargetValue: number = 0;
  @State showWarningText: boolean = false;
  @State isSettingTarget: boolean = false;

  aboutToAppear(): void {
    const arg = NavigationService.getInstance().arg;
    if (arg === 'Calorie') {
      this.gaugeValue = this.getRelatedValue() / 100;
      this.gaugeTargetValue = this.getRelatedTargetValue() / 100;
    } else {
      this.gaugeValue = this.getRelatedValue() / 10;
      this.gaugeTargetValue = this.getRelatedTargetValue() / 10;
    }
  }

  isButtonActive(): boolean {
    return this.gaugeValue <= this.gaugeTargetValue
  }

  getRelatedValue(): number {
    const arg = NavigationService.getInstance().arg;
    switch (arg) {
      case 'Calorie':
        return TrackerService.instance().currentMacroModel.kcal;
      case 'Protein':
        return TrackerService.instance().currentMacroModel.protein;
      case 'Fat':
        return TrackerService.instance().currentMacroModel.fat;
      case 'Carbs':
        return TrackerService.instance().currentMacroModel.carbs;
      default:
        return 0;
    }
  }

  getRelatedTargetValue(): number {
    const arg = NavigationService.getInstance().arg;
    switch (arg) {
      case 'Calorie':
        return TrackerService.instance().targetMacroModel.kcal;
      case 'Protein':
        return TrackerService.instance().targetMacroModel.protein;
      case 'Fat':
        return TrackerService.instance().targetMacroModel.fat;
      case 'Carbs':
        return TrackerService.instance().targetMacroModel.carbs;
      default:
        return 0;
    }
  }

  setParameters() {
    const arg = NavigationService.getInstance().arg;
    switch (arg) {
      case 'Calorie':
        TrackerService.instance().currentMacroModel.kcal = this.getProperValue(this.gaugeValue);
        TrackerService.instance().targetMacroModel.kcal = this.getProperValue(this.gaugeTargetValue);
        break;
      case 'Protein':
        TrackerService.instance().currentMacroModel.protein = this.getProperValue(this.gaugeValue);
        TrackerService.instance().targetMacroModel.protein = this.getProperValue(this.gaugeTargetValue);
        break;
      case 'Fat':
        TrackerService.instance().currentMacroModel.fat = this.getProperValue(this.gaugeValue);
        TrackerService.instance().targetMacroModel.fat = this.getProperValue(this.gaugeTargetValue);
        break;
      case 'Carbs':
        TrackerService.instance().currentMacroModel.carbs = this.getProperValue(this.gaugeValue);
        TrackerService.instance().targetMacroModel.carbs = this.getProperValue(this.gaugeTargetValue);
        break;
      default:
        break;
    }
  }

  getProperValue(value: number): number {
    const arg = NavigationService.getInstance().arg;
    if (arg === 'Calorie') {
      return (value * 100);
    } else {
      return (value * 10);
    }
  }

  quickAdd(amount: number) {
    const arg = NavigationService.getInstance().arg;
    if (arg === 'Calorie') {
      this.gaugeValue += amount / 100;
    } else {
      this.gaugeValue += amount / 10;
    }
  }

  build() {
    Gauge({ value: this.gaugeValue, min: 0, max: this.gaugeTargetValue }) {
      ArcList({ initialIndex: 0 }) {
        ArcListItem() {
           Text(NavigationService.getInstance().arg)
             .fontSize(20)
             .fontColor(Color.White)
             .fontWeight(FontWeight.Bold)
             .margin({ bottom: 10 })
        }

        ArcListItem() {
          Row() {
             Text(this.isSettingTarget ? "Target: " : "Current: ")
                .fontColor(Color.White)
             Text(this.getProperValue(this.isSettingTarget ? this.gaugeTargetValue : this.gaugeValue).toString())
                .fontSize(24)
                .fontColor(Color.White)
                .fontWeight(FontWeight.Bold)
          }
        }

        if (!this.isSettingTarget) {
          ArcListItem() {
            Row() {
              Button("+1")
                .onClick(() => this.quickAdd(1))
                .margin(2)
              Button("+5")
                .onClick(() => this.quickAdd(5))
                .margin(2)
              if (NavigationService.getInstance().arg === 'Calorie') {
                Button("+50")
                  .onClick(() => this.quickAdd(50))
                  .margin(2)
                Button("+100")
                  .onClick(() => this.quickAdd(100))
                  .margin(2)
              }
            }
          }
        }

        ArcListItem() {
          Slider({ style: SliderStyle.InSet, value: this.isSettingTarget ? this.gaugeTargetValue : this.gaugeValue })
            .showSteps(true)
            .selectedColor($r('app.color.gauge'))
            .onChange((value: number) => {
              if (this.isSettingTarget) {
                this.gaugeTargetValue = value;
              } else {
                this.gaugeValue = value;
              }
            }).margin({ bottom: 10, right: 30, left: 30 });
        };

        ArcListItem() {
           Button(this.isSettingTarget ? "Switch to Intake" : "Switch to Target")
             .onClick(() => { this.isSettingTarget = !this.isSettingTarget })
             .backgroundColor(Color.Transparent)
             .border({ width: 1, color: Color.White })
        }

        ArcListItem() {
          Column() {
            Row() {
              Text('Save')
                .fontSize(18)
                .fontColor(Color.White)
                .textAlign(TextAlign.End)
                .lineHeight(18)
                .fontWeight(FontWeight.Bold)
            }
            .linearGradient({
              direction: GradientDirection.Right,
              colors: [[$r('app.color.gradient_target_button_start'), 0.0],
                [$r('app.color.gradient_target_button_end'), 1]]
            })
            .borderRadius(6)
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .width('70%')
            .height('65px')
            .onClick(async () => {
              this.setParameters();
              await TrackerService.instance().syncToPersistence();
              TrackerService.instance().setHeader(this.getUIContext());
              NavigationService.getInstance().pageInfos.clear();
              NavigationService.getInstance().pageInfos.pushPath({ name: 'HomePage' });
            })
          }
        }
      }
    }
    .colors($r('app.color.gauge'))
    .width('100%')
    .height('100%')
    .indicator(null)
    .strokeWidth(18)
    .trackShadow({ radius: 3, offsetX: 3, offsetY: 3 })
    .value(this.gaugeValue)
    .align(Alignment.Center)
    .linearGradient({
      direction: GradientDirection.Bottom,
      colors: [[$r('app.color.base_background_gradient_start'), 0.0],
        [$r('app.color.base_background_gradient_end'), 1]]
    })
  }
}
