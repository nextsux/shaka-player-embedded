// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#ifndef SHAKA_EMBEDDED_MEDIA_APPLE_VIDEO_RENDERER_H_
#define SHAKA_EMBEDDED_MEDIA_APPLE_VIDEO_RENDERER_H_

#include <VideoToolbox/VideoToolbox.h>

#include <memory>

#include "../macros.h"
#include "renderer.h"

namespace shaka {
namespace media {

/**
 * Defines a video renderer that renders to a CGImageRef.
 *
 * @ingroup media
 */
class SHAKA_EXPORT AppleVideoRenderer final : public VideoRenderer {
 public:
  AppleVideoRenderer();
  ~AppleVideoRenderer() override;

  /** @return The current video fill mode. */
  VideoFillMode fill_mode() const;

  /**
   * Renders the current video frame to a new image.  This will return nullptr
   * while seeking or if the current frame is the same as the previous call.
   * In these cases, the previous drawn frame should be kept.
   *
   * This follows the CREATE rule.
   */
  CGImageRef Render();


  void SetPlayer(const MediaPlayer* player) override;
  void Attach(const DecodedStream* stream) override;
  void Detach() override;

  struct VideoPlaybackQuality VideoPlaybackQuality() const override;
  bool SetVideoFillMode(VideoFillMode mode) override;

 private:
  class Impl;
  std::shared_ptr<Impl> impl_;
};

}  // namespace media
}  // namespace shaka

#endif  // SHAKA_EMBEDDED_MEDIA_APPLE_VIDEO_RENDERER_H_