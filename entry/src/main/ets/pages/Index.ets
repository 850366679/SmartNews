import UserManager from '../manager/UserManager'
import { HomeBuilder } from '../views/HomeBuilder'
import { MeBuilder } from '../views/MeBuilder'
import { VideoBuilder } from '../views/VideoBuilder'
import { COMMON_PREF_NAME, TAG } from '../common/Contants'
import preferencesUtil from '../common/utils/PreferencesUtils'

/**
 * 主页，有三个TAB，分别是首页、视频、我的
 */
@Entry
@Component
struct Index {
  @State currentIndex: number = 0
  // 是否登录
  @State isLogin: boolean = false
  // 账号
  @State userName: string | null | undefined = ''
  // 头像
  @State userImage: string | null | undefined = ''
  // 是否可播放
  @State playEnable: boolean = false
  // 自动播放的开关状态
  private playSwitchOn = false

  async aboutToAppear() {
    this.playSwitchOn =
      await preferencesUtil.getPreferencesValue(COMMON_PREF_NAME, 'is_video_play_open', false) as boolean
    this.refreshPlayEnable()
  }

  /**
   * 刷新是否可播放的状态
   * @param playSwitchOn 自动播放的开关状态
   */
  private async refreshPlayEnable() {
    this.playEnable = this.playSwitchOn && this.currentIndex === 1
  }

  onPageShow(): void {
    this.refreshUserInfo()
  }

  /**
   * 刷新用户信息
   */
  refreshUserInfo() {
    // 登录状态未发生改变
    if (this.isLogin === UserManager.isLogin()
      && this.userName === UserManager.getUserName()
      && this.userImage === UserManager.getUserImage()
    ) {
      return
    }
    this.isLogin = UserManager.isLogin()
    this.userName = UserManager.getUserName()
    this.userImage = UserManager.getUserImage()
  }

  build() {
    Tabs({ barPosition: BarPosition.End }) {
      TabContent() {
        HomeBuilder()
      }
      .tabBar(this.TabBuilder($r('app.media.home_normal'),
        $r('app.media.home_selected'),
        $r('app.string.tab_home'), 0))

      TabContent() {
        VideoBuilder({ playEnable: this.playEnable })
      }.tabBar(this.TabBuilder($r('app.media.video_normal'),
        $r('app.media.video_selected'),
        $r('app.string.tab_video'), 1))

      TabContent() {
        MeBuilder({
          isLogin: this.isLogin,
          userName: this.userName,
          userImage: this.userImage,
          logout: () => {
            UserManager.logout()
            this.refreshUserInfo()
          },
          playsStateChanged: (b) => {
            this.playSwitchOn = b
            this.refreshPlayEnable()
          }
        })
      }.tabBar(this.TabBuilder($r('app.media.mine_normal'),
        $r('app.media.mine_selected'),
        $r('app.string.tab_me'), 2))
    }.onChange(index => {
      this.currentIndex = index
      this.refreshPlayEnable()
    }).scrollable(false)
  }

  @Builder
  TabBuilder(image_normal: ResourceStr, image_selected: ResourceStr, title: ResourceStr, index: number) {
    Column({ space: 2 }) {
      if (this.currentIndex === index) {
        Image(image_selected).width(24).height(24)
      } else {
        Image(image_normal).width(24).height(24)
      }
      Text(title).fontSize(13).fontColor(this.currentIndex === index ? '#36d' : '#666')
    }.justifyContent(FlexAlign.Center)
  }
}