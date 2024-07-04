import { VideoInfo } from '../../model/bean/VideoInfo'
import { ItemBottom } from '../common/ItemBottom'
import { ItemHeader } from '../common/ItemHeader'
import { router } from '@kit.ArkUI'
import { NewsDetail } from '../../pages/NewsDetailPage'
import DbManager from '../../model/db/DbManager'
import { TAG } from '../../common/Contants'

/**
 * 视频Item
 */
@Preview
@Component
export struct ItemVideo {
  @State item: VideoInfo = new VideoInfo()
  // 取消收藏监听
  cancelCollect?: (b: boolean) => void
  // 播放控制器
  private controller: VideoController | undefined;
  // 自身的Index
  @Prop mIndex: number
  // 中心的Index
  @Prop currentCenterItem: number
  // 是否可播放
  @Prop playEnable: boolean
  // 正在播放
  private isPlaying: boolean = false

  aboutToAppear(): void {
    // 初始化播放控制器
    this.controller = new VideoController()
  }

  /**
   * 自动播放视频
   */
  private startPlay() {
    // 不是自动播放
    if (!this.playEnable) {
      this.stopPlay()
      return
    }
    // 当前Item不在中间
    if (this.currentCenterItem !== this.mIndex) {
      this.stopPlay()
      return
    }
    if (this.isPlaying) {
      return
    }
    this.isPlaying = true
    this.controller?.start()
  }

  /**
   * 停止播放
   */
  private stopPlay() {
    if (!this.isPlaying) {
      return
    }
    this.isPlaying = false
    this.controller?.stop()
  }

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
      Row() {
        Checkbox().width(0.01).height(0.01).opacity(0)
          .select(this.playEnable).onChange(() => {
          console.log(TAG, 'Checkbox change!!!!')
          this.startPlay()
        })
        Checkbox().width(0.01).height(0.01).opacity(0)
          .select(this.currentCenterItem === this.mIndex).onChange(() => {
          console.log(TAG, 'Checkbox change!!!!')
          this.startPlay()
        })
      }

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
        likeClick: (likes: number, isLiked: boolean) => {
          // 更新数据库
          DbManager.update(this.item, { 'likes': likes, 'isLiked': isLiked })
        },
        collectClick: async (b) => { // 收藏
          if (b) {
            let a = await DbManager.insertVideoInfo(this.item)
            return a ? true : false
          } else {
            let num = await DbManager.delete(this.item)
            this.cancelCollect?.(num ? true : false)
            return true
          }
        },
      })

      Divider().color(Color.Gray)
    }.margin({ left: 16, right: 16 })
  }

  @Builder
  showVideo() {
    Video({ src: $rawfile('video4.mp4'), controller: this.controller }).height(200)
  }
}