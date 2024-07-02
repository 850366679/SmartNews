import { SocialInfo } from './SocialInfo'

/**
 * 视频
 */
@Observed
export class VideoInfo extends SocialInfo {
  public id?: number // 新闻Id
  public title?: string // 标题
  public abstract?: string // 摘要
  public subtitle?: string // 副标题
  public date?: number // 发布时间
  public author?: string // 发布作者
  public authorImg?: string // 用户头像
  public videoUrl?: string // 视频链接
  public detailUrl?: string // 详情链接
  public type?: string // 类型
  public content1?: string // 评论1
  public content2?: string // 评论2
}