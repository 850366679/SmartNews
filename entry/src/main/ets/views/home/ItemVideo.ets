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
        shareClick: () => { // 分享，分享成功后加1，再次分享继续加1
          // if (this.item.isShared) {
          //   this.item.shares -= 1
          // } else {
          //   this.item.shares += 1
          // }
          // this.item.isShared = !this.item.isShared
        },
        commentClick: () => { // 评论跳转详情
          this.jumpToDetail()
        },
        collectClick: () => { // 收藏

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