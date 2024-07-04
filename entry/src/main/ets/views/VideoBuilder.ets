import { TAG } from '../common/Contants'
import { VideoInfo } from '../model/bean/VideoInfo'
import { VideoViewModel } from '../viewmodel/VideoViewModel'
import { ItemVideo } from './home/ItemVideo'

/**
 * 视频列表页面
 */
@Preview
@Component
export struct VideoBuilder {
  @State videos: VideoInfo[] = []
  private vm = new VideoViewModel()
  private isLoading = false // 加载中
  // 当前正中心的item的index
  @State currentCenterItem: number = -1
  // 是否自动播放
  @Prop playEnable: boolean

  async aboutToAppear() {
    this.loading()
  }

  loading() {
    this.isLoading = true
    // 请求数据
    this.vm.getVideos().then(data => {
      this.videos = this.videos.concat(data)
      this.isLoading = false
    }).catch((error: string) => {
      console.log(TAG, 'VideoBuilder', error)
      this.isLoading = false
    })
  }

  build() {
    Column() {
      List({ space: 6 }) {
        ForEach(this.videos, (item: VideoInfo, index: number) => {
          ListItem() {
            ItemVideo({
              item: item,
              mIndex: index,
              currentCenterItem: this.currentCenterItem,
              playEnable: this.playEnable
            }).width('100%')
          }
        })
      }
      .width('100%')
      .height('100%')
      .layoutWeight(1)
      .onReachEnd(() => {
        if (!this.isLoading) {
          this.loading()
        }
      })
      .onScrollIndex((start : number, end : number, center: number) => {
        console.log(TAG, `onScrollIndex ${center}`)
        if (this.currentCenterItem === center) {
          return
        }
        // 设置当前中心的Item，表示其可以进行自动播放
        this.currentCenterItem = center
      })
    }.width('100%').height('100%')
  }
}