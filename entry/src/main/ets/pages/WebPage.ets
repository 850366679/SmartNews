import { TitleBuilder } from '../views/common/TitleBuilder'
import { router } from '@kit.ArkUI'
import webview from '@ohos.web.webview'

/**
 * web view页面
 */
@Entry
@Component
struct WebPage {
  // 标题
  @State title: string = ''
  // 显示文件名称
  @State url: string = ''
  // WebView控制器
  controller: webview.WebviewController = new webview.WebviewController();

  aboutToAppear(): void {
    let info = router.getParams() as WebInfo
    this.title = info.title
    this.url = info.webUrl
  }

  build() {
    Column() {
      TitleBuilder({ title: this.title })
      Web({ src: $rawfile(this.url), controller: this.controller, incognitoMode: true })
        .width('100%').layoutWeight(1)
    }
    .height('100%')
    .width('100%')
  }
}

/**
 * 传递的数据类型
 */
interface WebInfo {
  title: string,
  webUrl: string
}