import { abilityAccessCtrl, bundleManager, common, Permissions } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

// 访问图片的权限
const permissions: Array<Permissions> = ['ohos.permission.READ_IMAGEVIDEO'];

/**
 * 权限控制管理
 */
class PermissionManager {
  async checkPermissionGrant(permission: Permissions): Promise<abilityAccessCtrl.GrantStatus> {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;
    // 获取应用程序的accessTokenID
    let tokenId: number = 0;
    try {
      let bundleInfo: bundleManager.BundleInfo =
        await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
      let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
      tokenId = appInfo.accessTokenId;
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`Failed to get bundle info for self. Code is ${err.code}, message is ${err.message}`);
    }
    // 校验应用是否被授予权限
    try {
      grantStatus = await atManager.checkAccessToken(tokenId, permission);
    } catch (error) {
      const err: BusinessError = error as BusinessError;
      console.error(`Failed to check access token. Code is ${err.code}, message is ${err.message}`);
    }
    return grantStatus;
  }

  /**
   * 检查权限是否已经申请
   * @returns
   */
  async checkPermissions(): Promise<boolean> {
    return new Promise(async (resolve) => {
      let grantStatus = await this.checkPermissionGrant(permissions[0]);
      if (grantStatus === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED) {
        // 已经授权，可以继续访问目标操作
        resolve(true)
      } else {
        // 申请麦克风权限
        resolve(false)
      }
    })
  }

  /**
   * 申请图片权限
   * @param permissions
   * @param context
   * @returns
   */
  reqPermissionsFromUser(context: common.UIAbilityContext): Promise<boolean> {
    return new Promise((resolve) => {
      let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
      // requestPermissionsFromUser会判断权限的授权状态来决定是否唤起弹窗
      atManager.requestPermissionsFromUser(context, permissions).then((data) => {
        let grantStatus: Array<number> = data.authResults;
        let length: number = grantStatus.length;
        for (let i = 0; i < length; i++) {
          if (grantStatus[i] === 0) {
            resolve(true)
          } else {
            resolve(false)
            // 用户拒绝授权，提示用户必须授权才能访问当前页面的功能，并引导用户到系统设置中打开相应的权限
            return;
          }
        }
        // 授权成功
        resolve(true)
      }).catch((err: BusinessError) => {
        console.error(`Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`);
        resolve(false)
      })
    })
  }
}

const permissionManager = new PermissionManager()

export default permissionManager as PermissionManager