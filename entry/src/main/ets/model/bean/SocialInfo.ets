/**
 * 新闻&视频基类
 */
@Observed
export class SocialInfo {
  id?: number // 新闻Id
  shares: number = 0 // 分享数量
  isShared: boolean = false // 是否分享过
  comments: number = 0 // 评论数量
  isCommented: boolean = false // 是否评论过
  likes: number = 0 // 喜欢数量
  isLiked: boolean = false // 是否喜欢过
  collections: number = 0 // 收藏数量
  isCollected: boolean = false // 是否收藏过
  dbId?: number = -1 // 数据库ID
  isVideo : boolean = false // 是否是视频
}