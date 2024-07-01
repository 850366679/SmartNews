import { ILoginRequestInfo } from '../bean/request/ILoginRequestInfo'
import { UserInfo } from '../bean/UserInfo'

/**
 * 用户相关的接口
 */
export interface IUserRequest {

  /**
   * 登录
   * @param userName 用户名
   * @param psd 密码
   * @returns 用户对象
   */
  userLogin(info : ILoginRequestInfo): Promise<UserInfo>

  /**
   * 登出
   * @returns 是否成功
   */
  userLogout(id : number): Promise<boolean>

  /**
   * 更新用户信息
   * @returns 用户对象
   */
  userUpdate(info : UserInfo): Promise<UserInfo>
}