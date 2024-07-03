/**
 * 评论弹窗
 */
@Preview
@CustomDialog
export struct InputCommentDialog {
  controller: CustomDialogController
  commit?: (s: string) => void
  @State contentStr: string = ''

  build() {
    Column({ space: 10 }) {
      Text('评论')
      // TODO 待优化 多行显示
      TextInput({ placeholder: '请输入', text: this.contentStr })
        .onChange((value) => {
          this.contentStr = value
        })
        .fontColor('#333')
        .fontSize(14)
        .maxLength(100)
        .maxLines(5)
        .lineHeight(16)
        .height(90)
        .textAlign(TextAlign.Start)
      Row({ space: 20 }) {
        Button() {
          Text('取消').fontColor(Color.White).fontSize(16)
        }.height(40).layoutWeight(1).backgroundColor(Color.Gray)
        .onClick(() => {
          this.controller.close()
        })

        Button() {
          Text('发布').fontColor(Color.White).fontSize(16)
        }.height(40).layoutWeight(1).backgroundColor(Color.Green)
        .onClick(() => {
          this.commit?.(this.contentStr)
          this.controller.close()
        })
      }.width('100%').justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .backgroundColor('#fff')
    .borderRadius(10)
    .padding(10)
  }
}