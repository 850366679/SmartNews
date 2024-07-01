import notificationManager from '@ohos.notificationManager'
import wantAgent, { WantAgent } from '@ohos.app.ability.wantAgent'
import { TAG } from '../common/Contants'

/**
 * 通知ID
 */
const NOTIFY_ID = 1

/**
 * 通知管理
 */
class NotificationManager {
  private agent: WantAgent | undefined

  constructor() {
    wantAgent.getWantAgent({
      wants: [{
        deviceId: '',
        bundleName: 'com.mix.news',
        abilityName: 'EntryAbility',
        action: '',
        entities: []
      }],
      actionType: wantAgent.OperationType.START_ABILITY,
      requestCode: 2,
      actionFlags: [wantAgent.WantAgentFlags.CONSTANT_FLAG]
    }).then((agent: WantAgent) => {
      this.agent = agent
    })
  }

  /**
   * 设置通知显示或者隐藏
   * @param isOn
   */
  setNotificationSwitch(isOn: boolean) {
    if (isOn) {
      notificationManager.publish(this.createNotificationRequest()).then(() => {
        console.log(TAG, 'NotificationManager setNotificationSwitch success')
      }).catch((reason : Error) => {
        console.log(TAG, 'NotificationManager setNotificationSwitch fail', JSON.stringify(reason))
      })
    } else {
      notificationManager.cancel(NOTIFY_ID)
    }
  }

  /**
   * 创建最新的通知请求
   * @returns
   */
  private createNotificationRequest(): notificationManager.NotificationRequest {
    return {
      id: NOTIFY_ID,
      wantAgent: this.agent,
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
        normal: {
          title: '嫦娥六号返回',
          text: '携带月球背面土特产回来啦',
          additionalText: '点击查看更多'
        }
      }
    }
  }
}

const notMa = new NotificationManager()

export default notMa as NotificationManager