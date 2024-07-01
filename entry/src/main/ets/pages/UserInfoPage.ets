import router from '@ohos.router';
import { TAG } from '../common/Contants';
import UserManager from '../manager/UserManager';
import { UserInfo } from '../model/bean/UserInfo';
import UserRequest from '../model/network/UserRequest';

/**
 * 用户详情和编辑页面
 */
@Entry
@Component
struct UserInfoPage {
  @State isEdit: boolean = false
  @State userInfo: UserInfo = UserManager.getCurUser()

  @Styles
  backStyle(){
    .width(40)
    .height(40)
    .margin(12)
    .padding(8)
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.back_arrow'))
          .backStyle()
          .onClick(() => {
            router.back()
          })

        Text('个人信息')

        if (this.isEdit) {
          Text('保存').margin(12).onClick(() => {
            // 保存编辑后的数据
            this.updateUserInfo()
            this.isEdit = false
          })
        } else {
          Text('编辑').margin(12).fontColor(Color.Red).onClick(() => {
            this.isEdit = true
          })
        }
      }.width('100%').justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)

      Column({ space: 12 }) {
        Stack() {
          Image($r('app.media.ic_user_profile'))
          if (this.isEdit) {
            Text('点击修改').opacity(0.6)
          }
        }.width(120).height(120)

        Text(this.userInfo.phone)
        if (this.isEdit) {
          this.EditUserInfo()
        } else {
          this.ShowUserInfo()
        }
      }.contentStyle()
    }
    .height('100%')
    .width('100%')
  }

  @Styles
  contentStyle(){
    .width('100%').backgroundColor($r('app.color.window_bg')).padding(12).layoutWeight(1)
  }

  /**
   * 展示用户信息
   */
  @Builder
  ShowUserInfo() {
    Column({ space: 12 }) {
      Text(`用户名：${this.userInfo.name}`)
      Text(`年龄：${this.userInfo.age}`)
      Text(`性别：${this.userInfo.male ? '男' : '女'}`)
      Text(`e-Mail：${this.userInfo.email}`)
    }.width('100%')
  }

  @Styles
  editTitleStyle(){
    .width(75)
  }

  /**
   * 编辑用户信息
   */
  @Builder
  EditUserInfo() {
    Column({ space: 12 }) {
      Row() {
        Text('用户名：').editTitleStyle()
        TextInput({ text: this.userInfo.name })
          .type(InputType.USER_NAME)
          .layoutWeight(1)
          .maxLength(20)
          .onChange((value: string) => {
            this.userInfo.name = value
          })
      }.width('80%').justifyContent(FlexAlign.Start)

      Row() {
        Text('年龄：').editTitleStyle()
        TextInput({ text: this.userInfo.age?.toString() })
          .type(InputType.Number)
          .maxLength(3)
          .layoutWeight(1)
          .onChange((value: string) => {
            this.userInfo.age = Number.parseInt(value)
          })
      }.width('80%').justifyContent(FlexAlign.Start)

      Row() {
        Text('性别：').editTitleStyle()
        Text('女').fontSize(10)
        Toggle({ type: ToggleType.Switch, isOn: this.userInfo.male }).onChange(async (value: boolean) => {
          this.userInfo.male = value
        }).margin({ left: 4, right: 4 })
        Text('男').fontSize(10)
      }.width('80%').justifyContent(FlexAlign.Start)

      Row() {
        Text('e-Mail：').editTitleStyle()
        TextInput({ text: this.userInfo.email })
          .type(InputType.Email)
          .layoutWeight(1)
          .maxLength(30)
          .onChange((value: string) => {
            this.userInfo.email = value
          })
      }.width('80%').justifyContent(FlexAlign.Start)
    }.width('100%')
  }

  /**
   * 更新用户信息
   */
  updateUserInfo() {
    UserRequest.userUpdate(this.userInfo)
      .then((userinfo: UserInfo) => {
        UserManager.updateUserInfo(this.userInfo)
      }).catch((error: string) => {
      console.log(TAG, 'UserInfoPage updateUserInfo', error)
    })
  }
}