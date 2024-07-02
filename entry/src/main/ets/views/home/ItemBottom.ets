/**
 * 列表Item通用底部
 */
import { SocialInfo } from '../../model/bean/SocialInfo'

@Preview
@Component
export struct ItemBottom {
  @ObjectLink socialInfo: SocialInfo
  // 分享被点击
  shareClick?: () => void
  // 评论被点击
  commentClick?: () => void
  // 喜欢被点击
  likeClick?: () => void
  // 收藏被点击
  collectClick?: () => void

  build() {
    Row() {
      IconCountItem({
        normalImage: $r('app.media.share_normal'),
        SelectImage: $r('app.media.share_selected'),
        count: this.socialInfo.shares,
        isSelect: this.socialInfo.isShared,
        click: () => {
          this.shareClick?.()
        }
      });

      IconCountItem({
        normalImage: $r('app.media.comment_normal'),
        SelectImage: $r('app.media.comment_selected'),
        count: this.socialInfo.comments,
        isSelect: this.socialInfo.isCommented,
        click: this.commentClick
      });

      IconCountItem({
        normalImage: $r('app.media.like_normal'),
        SelectImage: $r('app.media.like_selected'),
        count: this.socialInfo.likes,
        isSelect: this.socialInfo.isLiked,
        click: () => {
          if (this.socialInfo.isLiked) {
            this.socialInfo.likes -= 1
          } else {
            this.socialInfo.likes += 1
          }
          this.socialInfo.isLiked = !this.socialInfo.isLiked
          this.likeClick?.()
        }
      });

      IconCountItem({
        normalImage: $r('app.media.collect_normal'),
        SelectImage: $r('app.media.collect_selected'),
        count: this.socialInfo.collections,
        isSelect: this.socialInfo.isCollected,
        click: () => {
          if (this.socialInfo.isCollected) {
            this.socialInfo.collections -= 1
          } else {
            this.socialInfo.collections += 1
          }
          this.socialInfo.isCollected = !this.socialInfo.isCollected
          this.collectClick?.()
        }
      });
    }.justifyContent(FlexAlign.SpaceEvenly).width('100%')
  }
}

@Component
struct IconCountItem {
  @Prop count: number = 0;
  @Prop isSelect: boolean = false;
  @Prop normalImage: Resource;
  @Prop SelectImage: Resource;
  click?: () => void

  build() {
    Row({ space: 2 }) {
      Image(this.isSelect ? this.SelectImage : this.normalImage).width(20).height(20)
      Text(`${this.count}`).fontColor(this.isSelect ? Color.Red : Color.Gray)
    }.alignItems(VerticalAlign.Center).onClick(() => this.click?.())
  }
}