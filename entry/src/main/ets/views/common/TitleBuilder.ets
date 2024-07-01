import { router } from '@kit.ArkUI'

/**
 * 标题
 */
@Preview
@Component
export struct TitleBuilder {
  @Prop title : string

  @Styles
  backStyle(){
    .width(40)
    .height(40)
    .margin(12)
    .padding(8)
  }

  build() {
    Row() {
      Image($r('app.media.back_arrow'))
        .backStyle()
        .onClick(() => {
          router.back()
        })
      Text(this.title).layoutWeight(1).padding({ right: 52 })
        .textAlign(TextAlign.Center)
    }.width('100%').justifyContent(FlexAlign.Start)
    .alignItems(VerticalAlign.Center)
  }
}