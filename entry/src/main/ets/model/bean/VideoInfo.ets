/**
 * 视频
 */
@Observed
export class VideoInfo {
  public id?: number // 新闻Id
  public title?: string // 标题
  public abstract?: string // 摘要
  public subtitle?: string // 副标题
  public shares: number = 0 // 分享数量
  public isShared: boolean = false // 是否分享过
  public comments: number = 0 // 评论数量
  public isCommented: boolean = false // 是否评论过
  public likes: number = 0 // 喜欢数量
  public isLiked: boolean = false // 是否喜欢过
  public collections: number = 0 // 收藏数量
  public isCollected: boolean = false // 是否收藏过
  public date?: number // 发布时间
  public author?: string // 发布作者
  public authorImg?: string // 用户头像
  public videoUrl?: string // 视频链接
  public detailUrl?: string // 详情链接
  public type?: string // 类型
  public content1?: string // 评论1
  public content2?: string // 评论2
}