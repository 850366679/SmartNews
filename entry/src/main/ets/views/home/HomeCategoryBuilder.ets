import { TAG } from '../../common/Contants'
import { NewsInfo } from '../../model/bean/NewsInfo'
import { NewsCategory } from '../../data/enum/NewsCategory'
import { ItemNews } from './ItemNews'
import dataRequest from '../../model/network/DataRequest'

/**
 * 主页分类页面
 */
@Preview
@Component
export struct HomeCategoryBuilder {
  type: NewsCategory = NewsCategory.RECOMMEND
  @State items: NewsInfo[] = []
  isLoading = false

  aboutToAppear() {
    this.loading()
  }

  loading() {
    this.isLoading = true
    // 请求数据
    dataRequest.getNews(this.type).then(data => {
      this.items = this.items.concat(data)
      this.isLoading = false
    }).catch((reason : Error) => {
      console.log(TAG, reason)
      this.isLoading = false
    })
  }

  build() {
    Column() {
      List({ space: 0 }) {
        ForEach(this.items, (item: NewsInfo, index: number) => {
          ListItem() {
            ItemNews({ newsInfo: item })
          }
        })
      }.width('100%').height('100%').layoutWeight(1).onReachEnd(() => {
        if (!this.isLoading) {
          this.loading()
        }
      })
    }.width('100%').height('100%')
  }
}