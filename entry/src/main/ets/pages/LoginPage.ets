import router from '@ohos.router'
import { TAG } from '../common/Contants'
import UserManager from '../manager/UserManager'
import { UserInfo } from '../model/bean/UserInfo'
import { UserViewModel } from '../viewmodel/UserViewModel'

/**
 * 用户登录页面
 */
@Entry
@Component
struct LoginPage {
  // 用户名
  @State userName: string = ''
  @State userNameInputError: string = ''
  // 密码
  @State psd: string = ''
  @State psdInputError: string = ''
  @State showPsd: boolean = false
  private vm: UserViewModel = new UserViewModel()

  build() {
    RelativeContainer() {
      Image($r('app.media.back_arrow'))
        .id('iv_back')
        .width(40)
        .height(40)
        .margin(12)
        .padding(8)
        .alignRules({
          left: { anchor: '__container__', align: HorizontalAlign.Start },
          top: { anchor: '__container__', align: VerticalAlign.Top }
        })
        .onClick(() => {
          router.back()
        })

      Column({ space: 24 }) {
        Text('欢迎使用智能新闻').fontColor('#fff').fontSize(22).fontWeight(FontWeight.Bold)
        Text('登录').fontColor('#fff').fontSize(24).fontWeight(FontWeight.Bold)

        TextInput({ placeholder: '请输入电话号码', text: this.userName })
          .fontSize(16)
          .fontColor('#333')
          .width('80%')
          .margin({ top: 100 })
          .contentType(ContentType.PHONE_NUMBER)
          .maxLength(11)
          .showError(this.userNameInputError)
          .onChange((value: string) => {
            this.userName = value
          })
          .onSubmit(() => {
            if (this.userName.length < 11) {
              this.userNameInputError = '请输入正确的账号'
              this.userName = ''
            } else {
              this.userNameInputError = ''
            }
          })

        TextInput({ placeholder: '请输入密码', text: this.psd })
          .fontSize(16)
          .fontColor('#333')
          .width('80%')
          .type(InputType.Password)
          .showPassword(this.showPsd)
          .maxLength(20)
          .showError(this.psdInputError)
          .onChange((value: string) => {
            this.psd = value
          })
          .onSubmit(() => {
            if (this.psd.length < 6) {
              this.psdInputError = '密码不少于6位'
              this.psd = ''
            } else {
              this.psdInputError = ''
            }
          })
          .onSecurityStateChange((isShow: boolean) => {
            this.showPsd = isShow
          })

      }.alignRules({
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        top: { anchor: '__container__', align: VerticalAlign.Top }
      }).margin({ top: 160 })

      Button() {
        Text('登录').fontSize(16).fontColor(Color.White)
      }
      .width('60%')
      .height(40)
      .alignRules({
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
      })
      .backgroundColor('#28A745')
      .margin({ bottom: 60 })
      .onClick(() => {
        this.toLogin()
      })
    }.splashStyle()
  }

  toLogin() {
    if (this.userName.length < 11) {
      this.userNameInputError = '请输入正确的账号'
      return
    }
    if (this.psd.length < 6) {
      this.psdInputError = '密码不少于6位'
      return
    }
    this.vm.toLogin(this.userName, this.psd).then((userInfo: UserInfo) => {
      console.log(TAG, 'LoginPage toLogin success:', JSON.stringify(userInfo))
      UserManager.login(userInfo)
      router.back()
    }).catch((error: string) => {
      console.log(TAG, 'LoginPage toLogin fail:', error)
    })
  }
}

/**
 * 渐变风格
 */
@Styles
function splashStyle() {
  .height('100%')
  .width('100%')
  .linearGradient({
    direction: GradientDirection.Bottom, // 渐变方向
    colors: [[0x333366dd, 0.0], [0x3366dd, 1]] // 数组末尾元素占比小于1时满足重复着色效果
  })
}