import { NewsInfo } from '../model/bean/NewsInfo'
import { SocialInfo } from '../model/bean/SocialInfo'
import { VideoInfo } from '../model/bean/VideoInfo'
import DbManager from '../model/db/DbManager'
import { TitleBuilder } from '../views/common/TitleBuilder'
import { ItemNews } from '../views/home/ItemNews'
import { ItemVideo } from '../views/home/ItemVideo'

/**
 * 收藏
 */
@Entry
@Component
struct CollectPage {
  @State items: SocialInfo[] = []

  aboutToAppear(): void {
    DbManager.queryAll().then((data) => {
      this.items = this.items.concat(data)
    })
  }

  /**
   * 取消收藏后刷新当前数据
   * @param b
   * @param item
   */
  cancelCollect(b: boolean, item: SocialInfo) {
    if (!b) {
      return
    }
    let index = this.items.indexOf(item)
    this.items.splice(index, 1)
  }

  build() {
    Column() {
      TitleBuilder({ title: '我的收藏' })
      List({ space: 6 }) {
        ForEach(this.items, (item: SocialInfo) => {
          ListItem() {
            if (!item.isVideo) {
              ItemNews({
                newsInfo: item as NewsInfo, cancelCollect: (b) => {
                  this.cancelCollect(b, item)
                }
              })
            } else {
              ItemVideo({
                item: item as VideoInfo, cancelCollect: (b) => {
                  this.cancelCollect(b, item)
                }
              })
            }
          }
        })
      }.width('100%').height('100%').layoutWeight(1).backgroundColor($r('app.color.window_bg'))
    }
    .height('100%')
    .width('100%')
  }
}