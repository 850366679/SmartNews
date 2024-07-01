import userManager from '../../manager/UserManager';
import { ILoginRequestInfo } from '../bean/request/ILoginRequestInfo';
import { ILogoutRequestInfo } from '../bean/request/ILogoutRequestInfo';
import { UserInfo } from '../bean/UserInfo';
import { URL_USER_LOGIN, USER_LOGOUT, USER_UPDATE } from '../UrlConstants';
import { BaseNetworkModel } from './BaseNetworkModel';
import { IUserRequest } from './IUserRequest';

/**
 * 数据请求实体类
 */
class UserRequest extends BaseNetworkModel implements IUserRequest {
  /**
   * 登录
   * @param userName 用户名
   * @param psd 密码
   * @returns 用户对象
   */
  userLogin(info: ILoginRequestInfo): Promise<UserInfo> {
    return this.postRequest<UserInfo>(URL_USER_LOGIN, info)
  }

  /**
   * 登出
   * @returns 是否成功
   */
  userLogout(id: number): Promise<boolean> {
    let requestInfo: ILogoutRequestInfo = { id: id }
    return this.postRequest<boolean>(USER_LOGOUT, requestInfo)
  }

  /**
   * 更新用户信息
   * @returns 用户对象
   */
  userUpdate(info: UserInfo): Promise<UserInfo> {
    return this.putRequest<UserInfo>(USER_UPDATE, info)
  }
}

const userRequest = new UserRequest()

export default userRequest as IUserRequest