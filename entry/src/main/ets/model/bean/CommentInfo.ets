/**
 * 评论
 */
export class CommentInfo {
  public id?: number // ID
  public userAvatar?: string // 头像
  public userName?: string // 用户名称
  public content?: string // 评论的内容
  public createTime?: number // 创建时间

  constructor(id: number) {
    this.id = id
  }
}