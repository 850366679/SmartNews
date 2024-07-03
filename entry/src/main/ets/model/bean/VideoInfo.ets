import { SocialInfo } from './SocialInfo'

/**
 * 视频
 */
@Observed
export class VideoInfo extends SocialInfo {
   title?: string // 标题
   abstract?: string // 摘要
   subtitle?: string // 副标题
   date?: number // 发布时间
   author?: string // 发布作者
   authorImg?: string // 用户头像
   videoUrl?: string // 视频链接
   detailUrl?: string // 详情链接
   type?: number // 类型
   content1?: string // 评论1
   content2?: string // 评论2
   isVideo: boolean = true // 不是视频
}