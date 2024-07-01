import { NewsCategory } from '../../data/enum/NewsCategory';
import { CommentInfo } from '../bean/CommentInfo';
import { NewsInfo } from '../bean/NewsInfo';
import { ICommentsListRequestInfo } from '../bean/request/ICommentsListRequestInfo';
import { IRequestNewsListInfo } from '../bean/request/IRequestNewsListInfo';
import { VideoInfo } from '../bean/VideoInfo';
import { URL_GET_COMMENTS, URL_GET_NEWS, URL_GET_VIDEOS } from '../UrlConstants';
import { BaseNetworkModel } from './BaseNetworkModel';
import { IDataRequest } from './IDataRequest';

/**
 * 数据请求实体类
 */
class DataRequest extends BaseNetworkModel implements IDataRequest {
  /**
   * 获取新闻列表
   * @param type 类型
   * @returns
   */
  getNews(type: NewsCategory): Promise<NewsInfo[]> {
    let requestInfo: IRequestNewsListInfo = { category: type }
    return this.getRequest<NewsInfo[]>(URL_GET_NEWS, requestInfo)
  }

  /**
   * 根据ID获取评论列表
   * @param id
   * @returns
   */
  getComments(info: ICommentsListRequestInfo): Promise<CommentInfo[]> {
    return this.getRequest<CommentInfo[]>(URL_GET_COMMENTS, info)
  }

  /**
   * 获取视频列表
   * @returns
   */
  getVideos(): Promise<VideoInfo[]> {
    return this.getRequest<VideoInfo[]>(URL_GET_VIDEOS)
  }
}

const dataRequest = new DataRequest()

export default dataRequest as IDataRequest