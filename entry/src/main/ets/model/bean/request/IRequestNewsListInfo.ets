import { NewsCategory } from '../../../data/enum/NewsCategory'

/**
 * 新闻列表请求对象
 */
export interface IRequestNewsListInfo{
  category: NewsCategory // 类型
}