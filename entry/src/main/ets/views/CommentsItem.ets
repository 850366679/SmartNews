import { CommentInfo } from '../model/bean/CommentInfo'

/**
 * 评论列表Item
 */
@Preview
@Component
export struct CommentsItem {
  @Prop comments: CommentInfo

  build() {
    Row({ space: 8 }) {
      Image($r('app.media.default_user')).width(16).height(16)
      Column({ space: 4 }) {
        Text(`${this.comments.userName}`).lineHeight(16)
        Text(`${this.comments.content}`)
      }.alignItems(HorizontalAlign.Start)
    }.alignItems(VerticalAlign.Top)
    .justifyContent(FlexAlign.Start).width('100%').padding(8)
  }
}