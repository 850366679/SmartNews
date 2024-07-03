import { MMKV } from '@tencent/mmkv'
import { UserInfo } from '../model/bean/UserInfo'
import DbManager from '../model/db/DbManager'

const KEY_USER_ID = 'key_user_save_id'
const KEY_USER_NAME = 'key_user_save_name'
const KEY_USER_GENDER = 'key_user_save_gender'
const KEY_USER_AGE = 'key_user_save_age'
const KEY_USER_EMAIL = 'key_user_save_email'
const KEY_USER_IMAGE = 'key_user_save_image_url'
const KEY_USER_PHONE = 'key_user_save_phone'
const KEY_USER_STATUS = 'key_user_save_status'
const KEY_USER_TOKEN = 'key_user_save_token'

/**
 * 用户信息管理类
 */
class UserManager implements IUserManager {
  /**
   * mmvk 数据存储
   */
  private mmkv: MMKV
  /**
   * 正在登录的用户
   */
  private curUser?: UserInfo

  constructor() {
    this.mmkv = MMKV.defaultMMKV()

    // 初始化用户数据
    this.curUser = new UserInfo()
    this.curUser.id = this.mmkv.decodeInt32(KEY_USER_ID, -1)
    if (!this.isLogin()) {
      return
    }
    this.curUser.name = this.mmkv.decodeString(KEY_USER_NAME)
    this.curUser.male = this.mmkv.decodeBool(KEY_USER_GENDER)
    this.curUser.age = this.mmkv.decodeInt32(KEY_USER_AGE)
    this.curUser.email = this.mmkv.decodeString(KEY_USER_EMAIL)
    this.curUser.imageUrl = this.mmkv.decodeString(KEY_USER_IMAGE)
    this.curUser.phone = this.mmkv.decodeString(KEY_USER_PHONE)
    this.curUser.status = this.mmkv.decodeInt32(KEY_USER_STATUS)
    this.curUser.token = this.mmkv.decodeString(KEY_USER_TOKEN)
  }

  /**
   * 是否登录
   * @returns
   */
  isLogin(): boolean {
    let id = this.curUser?.id
    id = id ? id : -1
    return id > 0
  }

  /**
   * 获取用户ID
   * @returns
   */
  getId(): number | null | undefined {
    return this.curUser?.id
  }

  /**
   * 获取用户名称
   * @returns
   */
  getUserName(): string | null | undefined {
    return this.curUser?.name
  }

  /**
   * 获取用户头像
   * @returns
   */
  getUserImage(): string | null | undefined {
    return this.curUser?.imageUrl
  }

  logout(): void {
    this.curUser = new UserInfo()
    this.curUser.id = -1
    this.mmkv.encodeInt32(KEY_USER_ID, -1)
    this.mmkv.encodeString(KEY_USER_NAME, '')
    this.mmkv.encodeInt32(KEY_USER_AGE, -1)
    this.mmkv.encodeString(KEY_USER_EMAIL, '')
    this.mmkv.encodeString(KEY_USER_IMAGE, '')
    this.mmkv.encodeString(KEY_USER_PHONE, '')
    this.mmkv.encodeInt32(KEY_USER_STATUS, -1)
    this.mmkv.encodeString(KEY_USER_TOKEN, '')
    DbManager.deleteAll().then(() => {
      // do nothing
    })
  }

  /**
   * 设置当前账号
   * @param info
   */
  login(info: UserInfo) {
    this.curUser = info
    this.saveUserData(info)
  }

  /**
   * 存储当前用户数据
   * @param info
   */
  private saveUserData(info: UserInfo) {
    this.mmkv.encodeInt32(KEY_USER_ID, info.id)
    this.mmkv.encodeString(KEY_USER_NAME, info.name)
    this.mmkv.encodeBool(KEY_USER_GENDER, info.male)
    this.mmkv.encodeInt32(KEY_USER_AGE, info.age)
    this.mmkv.encodeString(KEY_USER_EMAIL, info.email)
    this.mmkv.encodeString(KEY_USER_IMAGE, info.imageUrl)
    this.mmkv.encodeString(KEY_USER_PHONE, info.phone)
    this.mmkv.encodeInt32(KEY_USER_STATUS, info.status)
    this.mmkv.encodeString(KEY_USER_TOKEN, info.token)
  }

  getCurUser(): UserInfo {
    let u = new UserInfo()
    u.imageUrl = this.curUser?.imageUrl
    u.phone = this.curUser?.phone
    u.name = this.curUser?.name
    u.age = this.curUser?.age
    u.male = this.curUser?.male
    u.email = this.curUser?.email
    return u
  }

  updateUserInfo(info: UserInfo): void {
    info.id = this.curUser?.id
    info.phone = this.curUser?.phone
    info.status = this.curUser?.status
    info.token = this.curUser?.token
    this.curUser = info
    this.saveUserData(info)
  }

  /**
   * 修改头像
   * @param uri
   */
  saveAvatarImage(uri: string): void {
    if (this.curUser === null) {
      return
    }
    this.curUser!!.imageUrl = uri
    this.mmkv.encodeString(KEY_USER_IMAGE, uri)
  }
}

const userManager = new UserManager()

export default userManager as IUserManager

/**
 * 接口
 */
interface IUserManager {
  /**
   * 用户ID
   * @returns
   */
  getId(): number | null | undefined

  /**
   * 是否正在登录
   * @returns
   */
  isLogin(): boolean

  /**
   * 获取用户名
   * @returns
   */
  getUserName(): string | null | undefined

  /**
   * 获取用户头像
   * @returns
   */
  getUserImage(): string | null | undefined

  /**
   * 设置当前用户
   * @param info
   */
  login(info: UserInfo): void

  /**
   * 登出
   */
  logout(): void

  /**
   * 获取当前全部用户信息
   * @returns
   */
  getCurUser(): UserInfo

  /**
   * 更新用户信息
   * @param info
   */
  updateUserInfo(info: UserInfo): void

  /**
   * 修改头像
   * @param uri
   */
  saveAvatarImage(uri: string): void
}