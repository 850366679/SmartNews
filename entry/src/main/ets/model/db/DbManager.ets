import { Context } from '@kit.AbilityKit'
import relationalStore from '@ohos.data.relationalStore'
import { TAG } from '../../common/Contants'
import { NewsInfo } from '../bean/NewsInfo'
import { SocialInfo } from '../bean/SocialInfo'
import { VideoInfo } from '../bean/VideoInfo'
import { IDbManager } from './IDbManager'

// 数据库名字
const DB_NAME = 'smart_news_database.db'
// 收藏表的名字
const COLLECT_TABLE_NAME = 'CollectTable'

/**
 * 数据库管理器
 */
class DbManager implements IDbManager {
  private myRdbStore: relationalStore.RdbStore | null = null

  /**
   * 初始化DB
   * @param context
   */
  init(context: Context) {
    relationalStore.getRdbStore(context,
      { name: DB_NAME, securityLevel: relationalStore.SecurityLevel.S1 })
      .then((dbStore: relationalStore.RdbStore) => {
        this.myRdbStore = dbStore
        this.createTable(this.myRdbStore)
      }).catch((reason: object) => {
      // 创建数据库异常
      console.log(TAG, 'DbManager init fail', JSON.stringify(reason))
    })
  }

  /**
   * 创建表
   * @param myRdbStore
   */
  private createTable(myRdbStore: relationalStore.RdbStore) {
    const sql = `CREATE TABLE IF NOT EXISTS ${COLLECT_TABLE_NAME} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
    netId INTEGER NOT NULL DEFAULT 0,
    title TEXT,
    type INTEGER NOT NULL DEFAULT 0,
    abstract TEXT,
    subtitle TEXT,
    date INTEGER,
    author TEXT,
    authorImg TEXT,
    url TEXT,
    shares INTEGER NOT NULL DEFAULT 0,
    isShared BOOLEAN NOT NULL DEFAULT FALSE,
    comments INTEGER NOT NULL DEFAULT 0,
    isCommented BOOLEAN NOT NULL DEFAULT FALSE,
    likes INTEGER NOT NULL DEFAULT 0,
    isLiked BOOLEAN NOT NULL DEFAULT FALSE,
    collections INTEGER NOT NULL DEFAULT 0,
    isCollected BOOLEAN NOT NULL DEFAULT FALSE,
    isVideo BOOLEAN NOT NULL DEFAULT FALSE
    )`
    myRdbStore.executeSql(sql)
  }

  /**
   * 新增新闻
   * @param info
   * @returns
   */
  insertNewsInfo(info: NewsInfo): Promise<number> | null {
    return this.insert({
      'netId': info.id ? info.id : 0,
      'title': info.title ? info.title : '',
      'type': info.type ? info.type : 0,
      'abstract': info.abstract ? info.abstract : '',
      'subtitle': info.subtitle ? info.subtitle : '',
      'date': info.date ? info.date : 0,
      'author': info.author ? info.author : '',
      'authorImg': info.authorImg ? info.authorImg : '',
      'url': info.url ? info.url : '',
      'shares': info.shares ? info.shares : 0,
      'isShared': info.isShared ? info.isShared : false,
      'comments': info.comments ? info.comments : 0,
      'isCommented': info.isCommented ? info.isCommented : false,
      'likes': info.likes ? info.likes : 0,
      'isLiked': info.isLiked ? info.isLiked : false,
      'collections': info.collections ? info.collections + 1 : 1,
      'isCollected': true,
      'isVideo': false,
    })
  }

  /**
   * 新增视频
   * @param info
   * @returns
   */
  insertVideoInfo(info: VideoInfo): Promise<number> | null {
    return this.insert({
      'netId': info.id ? info.id : 0,
      'title': info.title ? info.title : '',
      'type': info.type ? info.type : 0,
      'abstract': info.abstract ? info.abstract : '',
      'subtitle': info.subtitle ? info.subtitle : '',
      'date': info.date ? info.date : 0,
      'author': info.author ? info.author : '',
      'authorImg': info.authorImg ? info.authorImg : '',
      'url': info.videoUrl ? info.videoUrl : '',
      'shares': info.shares ? info.shares : 0,
      'isShared': info.isShared ? info.isShared : false,
      'comments': info.comments ? info.comments : 0,
      'isCommented': info.isCommented ? info.isCommented : false,
      'likes': info.likes ? info.likes : 0,
      'isLiked': info.isLiked ? info.isLiked : false,
      'collections': info.collections ? info.collections + 1 : 1,
      'isCollected': true,
      'isVideo': true,
    })
  }

  /**
   * 新增
   * @param info
   * @returns
   */
  private insert(info: relationalStore.ValuesBucket): Promise<number> | null {
    if (this.myRdbStore === null) {
      return null
    }
    return this.myRdbStore.insert(COLLECT_TABLE_NAME, info)
  }

  /**
   * 更新
   * @param data
   * @returns
   */
  update(info: SocialInfo, data: relationalStore.ValuesBucket): Promise<number> {
    return new Promise(async (resolve, reject) => {
      if (this.myRdbStore === null) {
        reject('myRdbStore is null')
        return
      }
      let infos = await this.queryByNameId(info)
      if (infos.length > 0) {
        let j = 0
        for (const i of infos) {
          let p = new relationalStore.RdbPredicates(COLLECT_TABLE_NAME)
          p.equalTo('id', i.dbId)
          await this.myRdbStore.update(data, p)
          j++
        }
        resolve(j)
      } else {
        reject(`don't find ${info.id} in ${COLLECT_TABLE_NAME}`)
      }
    })
  }

  /**
   * 删除
   * @param info
   * @returns
   */
  delete(info: SocialInfo): Promise<number> {
    return new Promise(async (resolve, reject) => {
      if (this.myRdbStore === null) {
        console.log(TAG, 'myRdbStore is null')
        resolve(0)
        return
      }
      let infos = await this.queryByNameId(info)
      if (infos.length > 0) {
        let j = 0
        for (const i of infos) {
          let p = new relationalStore.RdbPredicates(COLLECT_TABLE_NAME)
          p.equalTo('id', i.dbId)
          await this.myRdbStore.delete(p)
          j++
        }
        resolve(j)
      } else {
        console.log(TAG, `don't find ${info.id} in ${COLLECT_TABLE_NAME}`)
        resolve(0)
      }
    })
  }

  /**
   * 根据名字和ID查询当权数据库是否存在改数据，并返回
   */
  private queryByNameId(info: SocialInfo): Promise<SocialInfo[]> {
    return new Promise((resolve, reject) => {
      if (this.myRdbStore === null) {
        resolve([])
        return
      }
      let netId: number | undefined
      let title: string | undefined
      let createDate: number | undefined
      if (!info.isVideo) {
        netId = info.id
        title = (info as NewsInfo).title
        createDate = (info as NewsInfo).date
      } else {
        netId = info.id
        title = (info as VideoInfo).title
        createDate = (info as VideoInfo).date
      }
      let p = new relationalStore.RdbPredicates(COLLECT_TABLE_NAME)
      p.equalTo('netId', netId)
      p.equalTo('title', title)
      p.equalTo('date', createDate)
      this.myRdbStore.query(p).then((result: relationalStore.ResultSet) => {
        try {
          resolve(this.translateResultSet(result))
        } catch (e) {
          console.log(TAG, `myRdbStore query fail, ${JSON.stringify(e)}}`)
          resolve([])
        }
      }).catch((error: object) => {
        console.log(TAG, `myRdbStore query fail, ${JSON.stringify(error)}}`)
        resolve([])
      })
    })
  }

  /**
   * 查询全部收藏
   */
  queryAll(): Promise<SocialInfo[]> {
    return new Promise((resolve, reject) => {
      if (this.myRdbStore === null) {
        reject('myRdbStore is null')
        return
      }
      let p = new relationalStore.RdbPredicates(COLLECT_TABLE_NAME)
      this.myRdbStore.query(p).then((result: relationalStore.ResultSet) => {
        try {
          resolve(this.translateResultSet(result))
        } catch (e) {
          reject(`myRdbStore query fail, ${JSON.stringify(e)}}`)
        }
      }).catch((error: object) => {
        reject(`myRdbStore query fail, ${JSON.stringify(error)}}`)
      })
    })
  }

  /**
   * 解析数据
   * @param result
   * @returns
   */
  private translateResultSet(result: relationalStore.ResultSet): SocialInfo[] {
    let a: SocialInfo[] = []
    while (!result.isAtLastRow) {
      result.goToNextRow()
      let dbId = result.getLong(result.getColumnIndex('id'))
      let id = result.getLong(result.getColumnIndex('netId'))
      let title = result.getString(result.getColumnIndex('title'))
      let subtitle = result.getString(result.getColumnIndex('subtitle'))
      let type = result.getLong(result.getColumnIndex('type'))
      let abstract = result.getString(result.getColumnIndex('abstract'))
      let date = result.getLong(result.getColumnIndex('date'))
      let author = result.getString(result.getColumnIndex('author'))
      let url = result.getString(result.getColumnIndex('url'))
      let shares = result.getLong(result.getColumnIndex('shares'))
      let isShared = result.getLong(result.getColumnIndex('isShared'))
      let comments = result.getLong(result.getColumnIndex('comments'))
      let isCommented = result.getLong(result.getColumnIndex('isCommented'))
      let likes = result.getLong(result.getColumnIndex('likes'))
      let isLiked = result.getLong(result.getColumnIndex('isLiked'))
      let collections = result.getLong(result.getColumnIndex('collections'))
      let isCollected = result.getLong(result.getColumnIndex('isCollected'))
      let isVideo = result.getLong(result.getColumnIndex('isVideo'))
      if (isVideo) { // 视频
        let videoInfo: VideoInfo = {
          id,
          title,
          subtitle,
          type: type,
          abstract,
          date,
          author,
          videoUrl: url,
          shares,
          isShared: isShared ? true : false,
          comments,
          isCommented: isCommented ? true : false,
          likes,
          isLiked: isLiked ? true : false,
          collections,
          isCollected: isCollected ? true : false,
          dbId,
          isVideo: isVideo ? true : false
        }
        a.push(videoInfo)
      } else { // 新闻
        let newsInfo: NewsInfo = {
          id,
          title,
          subtitle,
          type,
          abstract,
          date,
          author,
          url,
          shares,
          isShared: isShared ? true : false,
          comments,
          isCommented: isCommented ? true : false,
          likes,
          isLiked: isLiked ? true : false,
          collections,
          isCollected: isCollected ? true : false,
          dbId,
          isVideo: isVideo ? true : false
        }
        a.push(newsInfo)
      }
    }
    return a
  }

  /**
   * 删除全部
   */
  async deleteAll(): Promise<void> {
    if (this.myRdbStore === null) {
      return
    }
    let p = new relationalStore.RdbPredicates(COLLECT_TABLE_NAME)
    p.inAllDevices()
    await this.myRdbStore.delete(p)
  }
}

const dbManager = new DbManager()

export default dbManager as IDbManager