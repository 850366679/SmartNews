import { TitleBuilder } from '../views/common/TitleBuilder'
import { webview } from '@kit.ArkWeb';
import { router } from '@kit.ArkUI';
import { NewsInfo } from '../model/bean/NewsInfo';
import { CommentInfo } from '../model/bean/CommentInfo';
import dataRequest from '../model/network/DataRequest';
import { TAG } from '../common/Contants';
import { CommentsItem } from '../views/CommentsItem';
import { ItemBottom } from '../views/common/ItemBottom';
import { VideoInfo } from '../model/bean/VideoInfo';
import { SocialInfo } from '../model/bean/SocialInfo';
import DbManager from '../model/db/DbManager';

/**
 * 新闻详情页面
 */
@Entry
@Component
struct NewsDetailPage {
  // WebView控制器
  controller: webview.WebviewController = new webview.WebviewController();
  @State detailInfo: SocialInfo = new SocialInfo()
  @State items: CommentInfo[] = []
  isLoading = false
  private newsId: number = -1
  @State isVideo: boolean = false

  aboutToAppear(): void {
    let data = router.getParams() as NewsDetail
    this.isVideo = data.isVideo
    if (this.isVideo) {
      this.detailInfo = data.data as VideoInfo
    } else {
      this.detailInfo = data.data as NewsInfo
    }
    this.newsId = this.detailInfo.id ? this.detailInfo.id : 1
    this.items.push(new CommentInfo(-1))
    this.loading()
  }

  loading() {
    this.isLoading = true
    // 请求数据
    dataRequest.getComments({ newsId: this.newsId }).then(data => {
      this.items = this.items.concat(data)
      this.isLoading = false
    }).catch((reason: Error) => {
      console.log(TAG, reason)
      this.isLoading = false
    })
  }

  build() {
    Column() {
      TitleBuilder({ title: this.isVideo ? '视频详情' : '新闻详情' })
      List() {
        ForEach(this.items, (item: CommentInfo) => {
          ListItem() {
            if (item.id === -1) {
              Column({ space: 5 }) {
                Web({
                  src: $rawfile(this.isVideo ? 'video.html' : 'news.html'),
                  controller: this.controller,
                  incognitoMode: true
                })
                  .width('100%')
                Text(`评论 ${this.items.length - 1}`).padding({ left: 10 })
                  .fontSize(16)
              }.width('100%').alignItems(HorizontalAlign.Start)
            } else {
              CommentsItem({ comments: item })
            }
          }
        })
      }
      .width('100%')
      .layoutWeight(1)
      .margin({ bottom: 12 })
      .scrollBarColor(Color.Transparent)
      .onReachEnd(() => {
        if (!this.isLoading) {
          this.loading()
        }
      })

      // 底部状态
      ItemBottom({
        socialInfo: this.detailInfo,
        shareClick: () => {
          // 功能缺失
        },
        commentClick: () => {

        },
        likeClick: (likes: number, isLiked: boolean) => {
          // 更新数据库
          DbManager.update(this.detailInfo, { 'likes': likes, 'isLiked': isLiked })
        },
        collectClick: async (b) => { // 收藏
          if (b) {
            if (!this.isVideo) {
              let a = await DbManager.insertNewsInfo(this.detailInfo as NewsInfo)
              return a ? true : false
            } else {
              let a = await DbManager.insertVideoInfo(this.detailInfo as VideoInfo)
              return a ? true : false
            }
          } else {
            await DbManager.delete(this.detailInfo)
            return true
          }
        },
      })
    }
    .height('100%')
    .width('100%')
  }
}

export interface NewsDetail {
  isVideo: boolean
  data: object
}