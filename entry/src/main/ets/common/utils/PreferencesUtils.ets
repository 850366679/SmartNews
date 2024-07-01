import preferences from '@ohos.data.preferences'
import { TAG } from '../Contants'
import { Context } from '@kit.AbilityKit'

/**
 * Preferences 工具类
 * 轻量级数据化存储工具
 */
class PreferencesUtil {
  prefMap: Map<string, preferences.Preferences> = new Map()

  /**
   * 加载Preferences
   * @param context 上下文
   * @param name 名字
   */
  async loadPreferences(context: Context, name: string) {
    try {
      let pref = await preferences.getPreferences(context, name)
      this.prefMap.set(name, pref)
      console.log(TAG, `loadPreferences success name:${name}`)
    } catch (e) {
      console.log(TAG, `loadPreferences fail name:${name}`, JSON.stringify(e))
    }
  }

  /**
   * 存储数据
   * @param name Preferences名字
   * @param key 键
   * @param value 值
   */
  async putPreferencesValue(name: string, key: string, value: preferences.ValueType) {
    if (!this.prefMap.has(name)) {
      console.log(TAG, `putPreferencesValue fail, preferences[${name}] uninit`)
      return
    }
    try {
      let pref: preferences.Preferences | undefined = this.prefMap.get(name)
      await pref?.put(key, value)
      // 刷盘
      await pref?.flush()
      console.log(TAG, `putPreferencesValue success, [${name}.${key} = ${value}]`)
    } catch (e) {
      console.log(TAG, `putPreferencesValue fail, [${name}.${key} = ${value}]`, JSON.stringify(e))
    }
  }

  /**
   * 获取数据
   * @param name Preferences名字
   * @param key 键
   * @param defaultValue 默认值
   * @returns 返回结果
   */
  async getPreferencesValue(name: string, key: string, defaultValue?: preferences.ValueType) {
    if (!this.prefMap.has(name)) {
      console.log(TAG, `getPreferencesValue fail, preferences[${name}] uninit`)
      return defaultValue
    }
    try {
      let pref: preferences.Preferences | undefined = this.prefMap.get(name)
      let value = await pref?.get(key, defaultValue)
      console.log(TAG, `getPreferencesValue success, [${name}.${key} = ${value}]`)
      return value
    } catch (e) {
      console.log(TAG, `getPreferencesValue fail, [${name}.${key}]`, JSON.stringify(e))
    }
    return defaultValue
  }
}

const preferencesUtil = new PreferencesUtil()

export default preferencesUtil as PreferencesUtil