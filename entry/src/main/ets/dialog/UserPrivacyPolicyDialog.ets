@Preview
@CustomDialog
export struct UserPrivacyPolicyDialog {
  controller: CustomDialogController
  onAccept?: () => void
  onDIsAccept?: () => void

  build() {
    Column({ space: 10 }) {
      Text($r('app.string.welcome_use_app')).fontColor('#333').fontSize(22).fontWeight(FontWeight.Bold)
      Text($r('app.string.user_privacy_policy_tips'))
      Button() {
        Text('同意').fontColor('#fff')
      }.width(140).height(40).backgroundColor(Color.Green).onClick(() => {
        this.onAccept?.()
        this.controller.close()
      })

      Button() {
        Text('不同意').fontColor('#999')
      }.width(140).height(40).backgroundColor('#223366dd').onClick(() => {
        this.onDIsAccept?.()
        this.controller.close()
      })
    }
    .width('100%')
    .backgroundColor('#fff')
    .borderRadius(10)
    .padding(10)
  }
}