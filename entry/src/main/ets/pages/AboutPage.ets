import { router } from '@kit.ArkUI'
import { bundleManager } from '@kit.AbilityKit'
import { TAG } from '../common/Contants'
import { TitleBuilder } from '../views/common/TitleBuilder'

@Extend(Text)
function blueUnderLine() {
  .fontSize(16)
  .fontColor(Color.Blue)
  .decoration({ type: TextDecorationType.Underline })
}

/**
 * 关于页面
 */
@Entry
@Component
struct AboutPage {
  @State versionName: string = ''

  @Styles
  backStyle(){
    .width(40)
    .height(40)
    .margin(12)
    .padding(8)
  }

  async aboutToAppear() {
    bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
      .then(bundleInfo => {
        this.versionName = bundleInfo.versionName
      }).catch((reason: Error) => {
      console.log(TAG, `Index aboutToAppear getBundleInfoForSelf error :${JSON.stringify(reason)}`)
    })
  }

  build() {
    Column() {
      TitleBuilder({title : '关于'})

      Column({ space: 12 }) {
        Column({ space: 10 }) {
          Image($r("app.media.app_icon")).width(100)
          Text($r('app.string.EntryAbility_label')).fontColor('#333').fontSize(32).fontWeight(FontWeight.Bold)
          Text(`Version ${this.versionName}`)
            .fontSize(14)
            .fontColor('#333')
            .decoration({ type: TextDecorationType.Underline })
        }.layoutWeight(1).justifyContent(FlexAlign.Center)

        Row() {
          Text('隐私条款')
            .blueUnderLine()
            .onClick(() => {
              router.pushUrl({
                url: 'pages/WebPage',
                params: {
                  title: '隐私条款',
                  webUrl: 'privacy.html',
                }
              })
            })
          Text(' & ')
          Text('法律声明')
            .blueUnderLine()
            .onClick(() => {
              router.pushUrl({
                url: 'pages/WebPage',
                params: {
                  title: '法律声明',
                  webUrl: 'agreement.html',
                }
              })
            })
        }
        .padding({ bottom: 30 })
      }.layoutWeight(1).width('100%')
      .backgroundColor($r('app.color.window_bg'))
      .padding(12)
    }
    .height('100%')
    .width('100%')
  }
}