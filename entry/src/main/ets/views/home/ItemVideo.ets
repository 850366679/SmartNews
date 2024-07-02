import { VideoInfo } from '../../model/bean/VideoInfo'
import { ItemBottom } from './ItemBottom'
import { ItemHeader } from './ItemHeader'
import { router } from '@kit.ArkUI'
import { NewsDetail } from '../../pages/NewsDetailPage'

/**
 * 视频Item
 */
@Preview
@Component
export struct ItemVideo {
  @State item: VideoInfo = new VideoInfo()

  /**
   * 跳转至详情
   */
  jumpToDetail() {
    let info: NewsDetail = { isVideo: true, data: this.item }
    router.pushUrl({ url: 'pages/NewsDetailPage', params: info })
  }

  build() {
    Column({ space: 8 }) {
      ItemHeader({
        avatarImg: this.item.authorImg,
        userName: this.item.author,
        createDate: this.item.date,
        title: this.item.abstract,
        subtitle: this.item.subtitle,
        jumpToDetail: () => {
          this.jumpToDetail()
        }
      })
      this.showVideo()

      ItemBottom({
        socialInfo: this.item,
        shareClick: () => {
          if (this.item.isShared) {
            this.item.shares -= 1
          } else {
            this.item.shares += 1
          }
          this.item.isShared = !this.item.isShared
        },
        commentClick: () => {
          this.jumpToDetail()
        },
        likeClick: () => {
          if (this.item.isLiked) {
            this.item.likes -= 1
          } else {
            this.item.likes += 1
          }
          this.item.isLiked = !this.item.isLiked
        },
        collectClick: () => {
          if (this.item.isCollected) {
            this.item.collections -= 1
          } else {
            this.item.collections += 1
          }
          this.item.isCollected = !this.item.isCollected
        },
      })

      Divider().color(Color.Gray)
    }.margin({ left: 16, right: 16 })
  }

  @Builder
  showVideo() {
    Video({ src: $rawfile('video4.mp4') }).height(200)
  }
}