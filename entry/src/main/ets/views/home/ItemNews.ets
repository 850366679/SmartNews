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
  @ObjectLink newsInfo: NewsInfo

  /**
   * 跳转至详情
   */
  jumpToDetail() {
    let info : NewsDetail = {isVideo : false, data : this.newsInfo}
    router.pushUrl({ url: 'pages/NewsDetailPage', params : info })
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
        shares: this.newsInfo.shares,
        isShared: this.newsInfo.isShared,
        comments: this.newsInfo.comments,
        isCommented: this.newsInfo.isCommented,
        likes: this.newsInfo.likes,
        isLiked: this.newsInfo.isLiked,
        collections: this.newsInfo.collections,
        isCollected: this.newsInfo.isCollected,
        shareClick: () => {
          if (this.newsInfo.isShared) {
            this.newsInfo.shares -= 1
          } else {
            this.newsInfo.shares += 1
          }
          this.newsInfo.isShared = !this.newsInfo.isShared
        },
        commentClick: () => {
          this.jumpToDetail()
        },
        likeClick: () => {
          if (this.newsInfo.isLiked) {
            this.newsInfo.likes -= 1
          } else {
            this.newsInfo.likes += 1
          }
          this.newsInfo.isLiked = !this.newsInfo.isLiked
        },
        collectClick: () => {
          if (this.newsInfo.isCollected) {
            this.newsInfo.collections -= 1
          } else {
            this.newsInfo.collections += 1
          }
          this.newsInfo.isCollected = !this.newsInfo.isCollected
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