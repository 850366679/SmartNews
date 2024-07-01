import { NewsCategory } from '../data/enum/NewsCategory'
import { HomeCategoryBuilder } from './home/HomeCategoryBuilder'
/**
 * 主页
 */
@Preview
@Component
export struct HomeBuilder {
  build() {
    Tabs({ barPosition: BarPosition.Start }) {
      TabContent() {
        HomeCategoryBuilder({ type: NewsCategory.RECOMMEND })
      }.tabBar('推荐')

      TabContent() {
        HomeCategoryBuilder({ type: NewsCategory.HOT })
      }.tabBar('热榜')

      TabContent() {
        HomeCategoryBuilder({ type: NewsCategory.SCIENCE })
      }.tabBar('科技')

      TabContent() {
        HomeCategoryBuilder({ type: NewsCategory.SPORTS })
      }.tabBar('体育')

      TabContent() {
        HomeCategoryBuilder({ type: NewsCategory.FOOD })
      }.tabBar('美食')
    }
  }
}