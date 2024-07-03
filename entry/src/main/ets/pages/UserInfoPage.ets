import router from '@ohos.router';
import { TAG } from '../common/Contants';
import UserManager from '../manager/UserManager';
import { UserInfo } from '../model/bean/UserInfo';
import UserRequest from '../model/network/UserRequest';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { fileIo } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import PermissionManager from '../manager/PermissionManager';
import { common } from '@kit.AbilityKit';

/**
 * 用户详情和编辑页面
 */
@Entry
@Component
struct UserInfoPage {
  @State isEdit: boolean = false
  @State userInfo: UserInfo = UserManager.getCurUser()
  private photoSelectOptions: photoAccessHelper.PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
  private photoViewPicker = new photoAccessHelper.PhotoViewPicker();

  aboutToAppear(): void {
    // 过滤选择媒体文件类型为IMAGE
    this.photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
    // 选择媒体文件的最大数目
    this.photoSelectOptions.maxSelectNumber = 1;
  }

  /**
   * 点击了选择头像
   */
  private async pickAvatarImg() {
    let hasPermission = await PermissionManager.checkPermissions()
    if (hasPermission) {
      this.realPickImage()
    } else {
      let requested = await PermissionManager.reqPermissionsFromUser(getContext(this) as common.UIAbilityContext)
      if (requested) {
        this.realPickImage()
      }
    }
  }

  /**
   * 真正的去选择图片
   */
  private realPickImage() {
    this.photoViewPicker.select(this.photoSelectOptions)
      .then((photoSelectResult: photoAccessHelper.PhotoSelectResult) => {
        // 保存头像路径
        let uri = photoSelectResult.photoUris?.[0]
        if (uri) {
          this.userInfo.imageUrl = uri
        }
      })
      .catch((err: BusinessError) => {
        console.log(TAG, 'UserInfoPage, pickAvatarImg', JSON.stringify(err))
      })
  }

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
          if (this.userInfo.imageUrl?.startsWith('file')) {
            Image(this.userInfo.imageUrl)
              .onClick(() => {
                // 编辑状态才处理点击事件
                if (this.isEdit) {
                  this.pickAvatarImg()
                }
              }).borderRadius(60)
          } else {
            Image($r('app.media.ic_user_profile'))
              .onClick(() => {
                // 编辑状态才处理点击事件
                if (this.isEdit) {
                  this.pickAvatarImg()
                }
              })
          }
          if (this.isEdit) {
            Text('点击修改').opacity(0.6).onClick(() => {
              this.pickAvatarImg()
            })
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