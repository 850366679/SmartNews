import { SocialInfo } from './SocialInfo'

/**
 * 新闻
 */
@Observed
export class NewsInfo extends SocialInfo {
  title?: string // 标题
  category?: string // 分类同请求的分类
  type: number = 0 // UI类型
  abstract?: string // 摘要
  subtitle?: string // 副标题
  date?: number // 发布时间
  author?: string // 发布作者
  authorImg?: string // 用户头像
  url?: string // 新闻详情链接
}