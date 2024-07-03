import { relationalStore } from '@kit.ArkData'
import { NewsInfo } from '../bean/NewsInfo'
import { SocialInfo } from '../bean/SocialInfo'
import { VideoInfo } from '../bean/VideoInfo'

export interface IDbManager {

  /**
   * 初始化
   * @param context
   */
  init(context: Context): void

  /**
   * 新增新闻
   * @param info
   * @returns
   */
  insertNewsInfo(info: NewsInfo): Promise<number> | null

  /**
   * 新增视频
   * @param info
   * @returns
   */
  insertVideoInfo(info: VideoInfo): Promise<number> | null

  /**
   * 更新
   * @param data
   * @returns
   */
  update(info: SocialInfo, data: relationalStore.ValuesBucket): Promise<number>

  /**
   * 删除
   * @param info
   * @returns
   */
  delete(info: SocialInfo): Promise<number>

  /**
   * 查询全部缓存对象
   * @returns
   */
  queryAll(): Promise<SocialInfo[]>
}