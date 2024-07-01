import axios, { AxiosError, AxiosResponse } from '@ohos/axios'
import { TAG } from '../../common/Contants'
import { MyResponse } from '../bean/MyResponse'

/**
 * 网络请求的Base类
 */
export abstract class BaseNetworkModel {
  /**
   * GET 请求
   * @param url 请求链接
   * @param params 请求参数， 可以为空
   * @returns 返回
   */
  getRequest<T>(url: string, params?: object): Promise<T> {
    return new Promise((resolve, reject) => {
      axios.get<MyResponse<T>, AxiosResponse<MyResponse<T>>, null>(
        url, { params: params }
      ).then((resp: AxiosResponse<MyResponse<T>>) => {
        console.log(TAG, JSON.stringify(resp))
        if (resp.status === 200) {
          let response = resp.data
          if (response.code === 200 && response.data != null) {
            resolve(response.data)
            return
          }
        }
        reject('请求失败 code != 200')
      }).catch((reason: AxiosError) => {
        reject(`请求失败 ${JSON.stringify(reason)}`)
      })
    })
  }

  /**
   * POST 请求
   * @param url 请求链接
   * @param params 请求参数
   * @returns 返回请求结果
   */
  postRequest<T>(url: string, params?: object): Promise<T> {
    return new Promise((resolve, reject) => {
      axios.post<string, AxiosResponse<MyResponse<T>>, object>(
        url, params
      ).then((resp: AxiosResponse<MyResponse<T>>) => {
        console.log(TAG, JSON.stringify(resp))
        if (resp.status === 200) {
          let response = resp.data
          if (response.code === 200 && response.data != null) {
            resolve(response.data)
            return
          }
        }
        reject('请求失败 code != 200')
      }).catch((reason: AxiosError) => {
        reject(`请求失败 ${JSON.stringify(reason)}`)
      })
    })
  }

  /**
   * PUT更新请求
   * @param url 请求链接
   * @param params 请求参数
   * @returns 返回请求结果
   */
  putRequest<T>(url: string, params?: object): Promise<T> {
    return new Promise((resolve, reject) => {
      axios.put<string, AxiosResponse<MyResponse<T>>, object>(
        url, params
      ).then((resp: AxiosResponse<MyResponse<T>>) => {
        console.log(TAG, JSON.stringify(resp))
        if (resp.status === 200) {
          let response = resp.data
          if (response.code === 200 && response.data != null) {
            resolve(response.data)
            return
          }
        }
        reject('请求失败 code != 200')
      }).catch((reason: AxiosError) => {
        reject(`请求失败 ${JSON.stringify(reason)}`)
      })
    })
  }
}