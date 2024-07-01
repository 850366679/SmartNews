import { UserInfo } from '../model/bean/UserInfo'
import UserRequest from '../model/network/UserRequest'

/**
 * 用户ViewModel
 */
export class UserViewModel {
  /**
   * 去登录
   * @param name
   * @param password
   * @returns
   */
  toLogin(name: string, password: string): Promise<UserInfo> {
    return UserRequest.userLogin({ name, password })
  }
}