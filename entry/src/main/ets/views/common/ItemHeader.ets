/**
 * Item的公共头部
 */
@Preview
@Component
export struct ItemHeader {
  @Prop avatarImg: string // 头像
  @Prop userName: string // 用户名称
  @Prop createDate: number // 创建时间
  @Prop title: string // 正标题
  @Prop subtitle: string // 副标题
  jumpToDetail? : () => void

  build() {
    Column({space : 8}) {
      Row({ space: 6 }) {
        Image($r('app.media.default_user')).width(16).height(16)
        Text(`${this.userName}`)
        Text(`${formatDate(this.createDate)}`)
      }.width('100%').justifyContent(FlexAlign.Start).alignItems(VerticalAlign.Center)

      Text(`${this.title}`)
        .width('100%')
        .fontWeight(FontWeight.Bold)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)

      Text(`${this.subtitle}`)
        .width('100%')
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(10)
    }
    .onClick(() => this.jumpToDetail?.())
  }
}

/**
 * 转换时间
 * @param timestamp
 * @returns
 */
function formatDate(timestamp: number): string {
  const date = new Date(timestamp);
  const year = date.getFullYear();
  const month = (date.getMonth() + 1).toString().padStart(2, '0');
  const day = date.getDate().toString().padStart(2, '0');
  return `${year}-${month}-${day}`;
}