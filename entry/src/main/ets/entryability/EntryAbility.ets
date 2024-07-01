import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import PreferencesUtils from '../common/utils/PreferencesUtils'
import { COMMON_PREF_NAME } from '../common/Contants';
import { TAG } from '../common/Contants'
import { MMKV } from '@tencent/mmkv';

/**
 * 整个应用的入口
 */
export default class EntryAbility extends UIAbility {

  async onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onCreate');
    // 需要使用await， 并在onCreate方法上加上async
    await PreferencesUtils.loadPreferences(this.context, COMMON_PREF_NAME)
    MMKV.initialize(this.context.getApplicationContext())
  }

  onDestroy(): void {
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onDestroy');
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onWindowStageCreate');

    windowStage.loadContent('pages/WelcomePage', (err) => {
      if (err.code) {
        hilog.error(0x0000, TAG, 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
        return;
      }
      hilog.info(0x0000, TAG, 'Succeeded in loading the content.');
    });
  }

  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, TAG, '%{public}s', 'Ability onBackground');
  }
}
