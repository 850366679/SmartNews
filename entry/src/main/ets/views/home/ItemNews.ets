import { NewsInfo } from '../../model/bean/NewsInfo'
import { ItemBottom } from './ItemBottom'
import { ItemHeader } from './ItemHeader'
import { router } from '@kit.ArkUI'
import { NewsDetail } from '../../pages/NewsDetailPage'

/**
 * 新闻Item
 */
@Preview
@Component
export struct ItemNews {
  @State newsInfo: NewsInfo = new NewsInfo()

  /**
   * 跳转至详情
   */
  jumpToDetail() {
    let info: NewsDetail = { isVideo: false, data: this.newsInfo }
    router.pushUrl({ url: 'pages/NewsDetailPage', params: info })
  }

  build() {
    Column({ space: 8 }) {
      ItemHeader({
        avatarImg: this.newsInfo.authorImg,
        userName: this.newsInfo.author,
        createDate: this.newsInfo.date,
        title: this.newsInfo.abstract,
        subtitle: this.newsInfo.subtitle,
        jumpToDetail: () => {
          this.jumpToDetail()
        }
      })

      this.ShowImage()

      ItemBottom({
        socialInfo: this.newsInfo,
        shareClick: () => { // 分享，分享成功后加1，再次分享继续加1
          // if (this.newsInfo.isShared) {
          //   this.newsInfo.shares -= 1
          // } else {
          //   this.newsInfo.shares += 1
          // }
          // this.newsInfo.isShared = !this.newsInfo.isShared
        },
        commentClick: () => { // 评论跳转详情
          this.jumpToDetail()
        },
        collectClick: () => { // 收藏

        },
      })

      Divider().color(Color.Gray).margin({ top: 10 })
    }.width('100%').padding(12).backgroundColor('#fff')
  }

  @Builder
  ShowImage() {
    if (this.newsInfo.type === 1) {
      Image($r('app.media.big_image')).height(200).onClick(() => {
        this.jumpToDetail()
      })
    } else if (this.newsInfo.type === 2) {
      Row({ space: 6 }) {
        Image($r('app.media.three_image1')).height('100%').layoutWeight(1)
        Image($r('app.media.three_image2')).height('100%').layoutWeight(1)
        Image($r('app.media.three_image3')).height('100%').layoutWeight(1)
      }
      .height(120)
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
      .onClick(() => {
        this.jumpToDetail()
      })
    } else {
      Row().height(2)
    }
  }
}