import { VideoInfo } from '../model/bean/VideoInfo'
import DataRequest from '../model/network/DataRequest'

/**
 * 视屏ViewModel
 */

export class VideoViewModel {
  getVideos(): Promise<VideoInfo[]> {
    return DataRequest.getVideos()
  }
}