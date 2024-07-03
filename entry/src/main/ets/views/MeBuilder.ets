import { COMMON_PREF_NAME } from '../common/Contants'
import PreferencesUtil from '../common/utils/PreferencesUtils'
import router from '@ohos.router'
import UserManager from '../manager/UserManager'
import notMa from '../manager/NotificationManager'


/**
 * 我的
 */
@Preview
@Component
export struct MeBuilder {
  /**
   * 通知开关
   */
  @State isNotificationOpen: boolean = false
  /**
   * 自动播放视频开关
   */
  @State isVideoPlayOpen: boolean = false
  // 是否登录
  @Prop isLogin: boolean
  // 账号
  @Prop userName: string | null | undefined
  // 头像
  @Prop userImage: string | null | undefined
  /**
   * 登出事件
   */
  logout?: () => void

  @Styles
  smallIconSize(){
    .width(20).height(20)
  }

  async aboutToAppear() {
    this.isNotificationOpen =
      await PreferencesUtil.getPreferencesValue(COMMON_PREF_NAME, 'is_notification_open', false) as boolean

    this.isVideoPlayOpen =
      await PreferencesUtil.getPreferencesValue(COMMON_PREF_NAME, 'is_video_play_open', false) as boolean
  }

  build() {
    Column({ space: 24 }) {
      this.UserBuilder()
      this.SwitchBuilder()
      this.AboutBuilder()
      if (this.isLogin) {
        Column() {
          this.ButtonsBuilder()
        }.layoutWeight(1).width('100%').justifyContent(FlexAlign.Center)
      }
    }.width('100%').height('100%').backgroundColor($r('app.color.window_bg'))
  }

  /**
   * 用户头部
   */
  @Builder
  UserBuilder() {
    Column() {
      if (this.isLogin) {
        this.UserInformationBuilder()
      } else {
        Button() {
          Text('去登录').fontSize(16).fontColor(Color.White)
        }.width('60%').margin({ top: 60, bottom: 30 }).height(40).onClick(() => {
          this.jumpToLoginPage()
        })
      }
    }.width('100%')
  }

  /**
   * 登录账号用户信息
   */
  @Builder
  UserInformationBuilder() {
    Column() {
      Column({ space: 24 }) {
        if (this.userImage?.startsWith('file')) {
          Image(this.userImage).width(65).height(65).borderRadius(32.5)
        } else {
          Image($r('app.media.ic_user_profile')).width(65).height(65)
        }
        Text(this.userName)
      }.padding(32)

      Column() {
        Row() {
          Text('个人信息')
          Image($r('app.media.arrow_right')).smallIconSize()
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(12)
        .alignItems(VerticalAlign.Center)
        .width('100%')
        .onClick(() => {
          router.pushUrl({ url: 'pages/UserInfoPage' })
        })

        Divider().color(Color.Gray).margin({ left: 10, right: 10 }).height(1)

        Row() {
          Text('我的收藏')
          Image($r('app.media.arrow_right')).smallIconSize()
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .padding(12)
        .alignItems(VerticalAlign.Center)
        .width('100%')
        .onClick(() => {
          router.pushUrl({ url: 'pages/CollectPage' })
        })
      }.width('100%').backgroundColor(Color.White)
    }.width('100%')
  }

  /**
   * 开关
   */
  @Builder
  SwitchBuilder() {
    Column() {
      Row() {
        Text('通知')
        Toggle({ type: ToggleType.Switch, isOn: this.isNotificationOpen }).onChange(async (value: boolean) => {
          notMa.setNotificationSwitch(value)
          this.isNotificationOpen = value
          await PreferencesUtil.putPreferencesValue(COMMON_PREF_NAME, 'is_notification_open', value)
        })
      }.justifyContent(FlexAlign.SpaceBetween)
      .padding(12)
      .alignItems(VerticalAlign.Center).width('100%')

      Divider().color(Color.Gray).margin({ left: 10, right: 10 }).height(1)

      Row() {
        Text('自动播放视频')
        Toggle({ type: ToggleType.Switch, isOn: this.isVideoPlayOpen }).onChange(async (value: boolean) => {
          this.isVideoPlayOpen = value
          await PreferencesUtil.putPreferencesValue(COMMON_PREF_NAME, 'is_video_play_open', value)
        })
      }.justifyContent(FlexAlign.SpaceBetween)
      .padding(12)
      .alignItems(VerticalAlign.Center).width('100%')
    }.backgroundColor(Color.White).width('100%')
  }

  /**
   * 关于
   */
  @Builder
  AboutBuilder() {
    Column() {
      Row() {
        Text('关于')
        Image($r('app.media.arrow_right')).smallIconSize()
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .padding(12)
      .alignItems(VerticalAlign.Center)
      .width('100%')
      .onClick(() => {
        router.pushUrl({ url: 'pages/AboutPage' })
      })
    }.backgroundColor(Color.White).width('100%')
  }

  /**
   * 登出按钮
   */
  @Builder
  ButtonsBuilder() {
    Button() {
      Text('退出登录').fontSize(16).fontColor(Color.White)
    }.width('60%').height(40).backgroundColor(Color.Red).onClick(() => {
      this.logout?.()
    })
  }

  /**
   * 跳转到登录页面
   */
  jumpToLoginPage() {
    router.pushUrl({ url: 'pages/LoginPage' })
  }
}