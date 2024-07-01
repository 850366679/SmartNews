/**
 * 新闻
 */
@Observed
export class NewsInfo {
  id?: number // 新闻Id
  title?: string // 标题
  category?: string // 分类同请求的分类
  type: number = 0 // UI类型
  abstract?: string // 摘要
  subtitle?: string // 副标题
  shares: number = 0 // 分享数量
  isShared: boolean = false // 是否分享过
  comments: number = 0 // 评论数量
  isCommented: boolean = false // 是否评论过
  likes: number = 0 // 喜欢数量
  isLiked: boolean = false // 是否喜欢过
  collections: number = 0 // 收藏数量
  isCollected: boolean = false // 是否收藏过
  date?: number // 发布时间
  author?: string // 发布作者
  authorImg?: string // 用户头像
  url?: string // 新闻详情链接
}