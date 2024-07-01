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
  isLoading = false // 加载中

  aboutToAppear(): void {
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
        ForEach(this.videos, (item: VideoInfo) => {
          ListItem() {
            ItemVideo({ item: item }).width('100%')
          }
        })
      }.width('100%').height('100%').layoutWeight(1).onReachEnd(() => {
        if (!this.isLoading) {
          this.loading()
        }
      })
    }.width('100%').height('100%')
  }
}