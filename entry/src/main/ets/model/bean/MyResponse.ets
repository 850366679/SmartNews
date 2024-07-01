/**
 * 请求基础返回体
 */
export class MyResponse<T>{
  code : number = 0 // 返回的状态
  message? : string // 信息
  data? : T // 返回的对象
}