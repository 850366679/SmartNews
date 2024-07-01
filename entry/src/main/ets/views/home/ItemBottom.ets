/**
 * 列表Item通用底部
 */
@Preview
@Component
export struct ItemBottom {
  @Prop shares: number
  @Prop isShared: boolean
  @Prop comments: number
  @Prop isCommented: boolean
  @Prop likes: number
  @Prop isLiked: boolean
  @Prop collections: number
  @Prop isCollected: boolean
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
      this.IconCountBuilder($r('app.media.share_normal'), $r('app.media.share_selected'), this.shares,
        this.isShared, this.shareClick)
      this.IconCountBuilder($r('app.media.comment_normal'), $r('app.media.comment_selected'), this.comments,
        this.isCommented, this.commentClick)
      this.IconCountBuilder($r('app.media.like_normal'), $r('app.media.like_selected'), this.likes,
        this.isLiked, this.likeClick)
      this.IconCountBuilder($r('app.media.collect_normal'), $r('app.media.collect_selected'),
        this.collections, this.isCollected, this.commentClick)
    }.justifyContent(FlexAlign.SpaceEvenly).width('100%')
  }

  @Builder
  IconCountBuilder(
    normalImgRes: ResourceStr,
    selectImgRes: ResourceStr,
    count: number,
    isSelect: boolean,
    click?: () => void) {
    Row({ space: 2 }) {
      Image(isSelect ? selectImgRes : normalImgRes).width(20).height(20)
      Text(`${count}`).fontColor(isSelect ? Color.Red : Color.Gray)
    }.alignItems(VerticalAlign.Center).onClick(() => click?.())
  }
}