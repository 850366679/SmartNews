import { NewsInfo } from '../bean/NewsInfo'
import { CommentInfo } from '../bean/CommentInfo'
import { VideoInfo } from '../bean/VideoInfo'
import { ICommentsListRequestInfo } from '../bean/request/ICommentsListRequestInfo'
import { NewsCategory } from '../../data/enum/NewsCategory'

/**
 * 获取数据的接口
 */
export interface IDataRequest {

  /**
   * 获取新闻列表
   * @param type 请求体
   * @returns
   */
  getNews(type: NewsCategory): Promise<NewsInfo[]>

  /**
   * 根据ID获取评论列表
   * @param info 请求体
   * @returns
   */
  getComments(info: ICommentsListRequestInfo): Promise<CommentInfo[]>

  /**
   * 获取视频列表
   * @returns
   */
  getVideos(): Promise<VideoInfo[]>

}