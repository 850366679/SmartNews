import { NewsInfo } from '../../model/bean/NewsInfo'
import { ItemBottom } from '../common/ItemBottom'
import { ItemHeader } from '../common/ItemHeader'
import { router } from '@kit.ArkUI'
import { NewsDetail } from '../../pages/NewsDetailPage'
import { systemShare } from '@kit.ShareKit';
import { uniformTypeDescriptor as utd } from '@kit.ArkData';
import { common, Want, wantConstant } from '@kit.AbilityKit'
import { TAG } from '../../common/Contants'
import DbManager from '../../model/db/DbManager'

/**
 * 新闻Item
 */
@Preview
@Component
export struct ItemNews {
  @State newsInfo: NewsInfo = new NewsInfo()
  private context = getContext(this) as common.UIAbilityContext
  private shareController: systemShare.ShareController | null = null
  // 取消收藏监听
  cancelCollect?: (b: boolean) => void

  aboutToAppear(): void {
    // let a = new systemShare.SharedData({
    //   utd: utd.UniformDataType.PLAIN_TEXT,
    //   content: this.newsInfo.url
    // })
    // this.shareController = new systemShare.ShareController(a)
    // this.shareController.on('dismiss', () => {
    //   // 分享成功
    //   this.shareSuccess()
    // })
  }

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
          this.shareClicked()
        },
        commentClick: () => { // 评论跳转详情
          this.jumpToDetail()
        },
        likeClick: (likes: number, isLiked: boolean) => {
          // 更新数据库
          DbManager.update(this.newsInfo, { 'likes': likes, 'isLiked': isLiked })
        },
        collectClick: async (b) => { // 收藏
          if (b) {
            let a = await DbManager.insertNewsInfo(this.newsInfo)
            return a ? true : false
          } else {
            let num = await DbManager.delete(this.newsInfo)
            this.cancelCollect?.(num ? true : false)
            return true
          }
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

  /**
   * 分享
   */
  shareClicked() {
    // this.shareController?.show(this.context, {
    //   previewMode: systemShare.SharePreviewMode.DETAIL,
    //   selectionMode: systemShare.SelectionMode.SINGLE
    // })
  }

  /**
   * 分享成功，刷新数据
   */
  shareSuccess() {
    console.log(TAG, 'ItemNews shareSuccess share success')
    this.newsInfo.shares += 1
    this.newsInfo.isShared = true
  }
}