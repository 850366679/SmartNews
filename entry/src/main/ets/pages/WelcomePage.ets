import bundleManager from '@ohos.bundle.bundleManager'
import router from '@ohos.router'
import common from '@ohos.app.ability.common'
import { UserPrivacyPolicyDialog } from '../dialog/UserPrivacyPolicyDialog'
import { COMMON_PREF_NAME, TAG } from '../common/Contants'
import PreferencesUtil from '../common/utils/PreferencesUtils'

/**
 * 启动页面
 * 也是入口页面
 * 显示loading
 * loading结束判断是否显示过用户协议弹窗
 * 没显示过：则显示，同意后跳转到主页，不同意则退出应用
 * 显示过：直接跳转到主页中去
 */
@Entry
@Component
struct WelcomePage {
  context = getContext(this) as common.UIAbilityContext
  @State versionName: string = ''
  @State mProgress: number = 0
  intervalID: number = -1
  dialogController = new CustomDialogController({
    builder: UserPrivacyPolicyDialog({
      onAccept: () : void => this.onAccept(),
      onDIsAccept: (): void => this.existApp()
    })
  })

  async aboutToAppear() {
    bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION)
      .then(bundleInfo => {
        this.versionName = bundleInfo.versionName
      }).catch((reason : Error) => {
      console.log(TAG, `Index aboutToAppear getBundleInfoForSelf error :${JSON.stringify(reason)}`)
    })
  }

  onPageShow() {
    // 开始重置并计时
    this.mProgress = 0
    this.intervalID = setInterval(async () => {
      this.mProgress += 1
      // 取消计时器
      if (this.mProgress >= 100) {
        this.stopLoading()
        console.log(TAG, 'show dialog' + this.mProgress)
        /**
         * 检测是否弹过隐私协议框
         * 弹过且同意了则直接进入主页
         * 没有则弹出提示窗让用户同意
         */
        let showGuideDialogEnable: boolean =
          await PreferencesUtil.getPreferencesValue(COMMON_PREF_NAME, 'show_guide_dialog', true) as boolean
        if (showGuideDialogEnable) {
          this.dialogController.open()
        } else {
          this.jumpMainPage()
        }
      }
    }, 10)
  }

  onPageHide() {
    this.stopLoading()
  }

  /**
   * 停止加载
   */
  stopLoading() {
    if (this.intervalID >= 0) {
      clearInterval(this.intervalID)
      this.intervalID = -1
    }
    this.dialogController.close()
  }

  // 同意，跳转首页
  onAccept(): void {
    // 同意过，下次不要再提醒了
    PreferencesUtil.putPreferencesValue(COMMON_PREF_NAME, 'show_guide_dialog', false)
    this.jumpMainPage()
  }

  // 退出应用
  existApp() {
    this.context.terminateSelf()
  }

  /**
   * 跳转到主页
   */
  jumpMainPage() {
    router.replaceUrl({ url: 'pages/Index' })
  }

  build() {
    Stack() {
      // 中心logo
      this.CenterView()
      // 版本号以及加载进度条
      this.VersionNameAndProgress()
    }.splashStyle()
  }

  // 中心logo
  @Builder
  CenterView() {
    Column() {
      Image($r('app.media.icon')).width(100)
      Text($r('app.string.EntryAbility_label')).fontColor('#fff').fontSize(32).fontWeight(FontWeight.Bold)
    }
  }

  @Builder
  VersionNameAndProgress() {
    Column({ space: 16 }) {
      Blank()
      Progress({
        value: this.mProgress,
        total: 100,
        type: ProgressType.Linear
      }).width(200)
      if (this.versionName) {
        Text(`Version ${this.versionName}`)
          .fontSize(12)
          .fontColor('#fff')
          .decoration({ type: TextDecorationType.Underline })
      }
    }.height('100%').padding(20)
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