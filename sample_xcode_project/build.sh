#!/bin/bash
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

if [[ -z $PROJECT_DIR ]]; then
  echo "Cannot be run directly, only as part of Xcode."
  exit 1
fi

# Work around a change to script environment variables in XCode 10.
export arch=$ARCHS

cd "$PROJECT_DIR/.."

# Get the PATH variable from outside of XCode, so that the scripts can find depot_tools
# Pass -i to trick .bashrc files into thinking this is interactive (since many
# scripts won't do anything in non-interactive modes).  -c takes priority and
# will only execute this command.
export PATH=$(bash -li -c 'echo $PATH'):$(zsh -li -c 'echo $PATH')

# Determine configuration options and framework path.
CONFIG_FLAGS="--ios --disable-demo --disable-tests"
if [[ $EFFECTIVE_PLATFORM_NAME == "-iphoneos" ]]; then
  CONFIG_PATH="./out/sample_xcode_project_ios"
  CONFIG_FLAGS+=" --cpu arm64"
else
  CONFIG_PATH="./out/sample_xcode_project_ios_sim"
fi
if [[ $CONFIGURATION == "Release" ]]; then
  CONFIG_PATH+="_release"
  CONFIG_FLAGS+=" --release"
fi
echo "Using $CONFIG_PATH!"

# Create the framework.
if [[ ! -d "$CONFIG_PATH" ]]; then
  mkdir -p "$CONFIG_PATH"
  (cd "$CONFIG_PATH" && ../../configure $CONFIG_FLAGS)
fi
(cd "$CONFIG_PATH" && ../../build.py)

# Copy the correct framework into that path.
rm -rf ./sample_xcode_project/*.framework
mv "$CONFIG_PATH"/ShakaPlayerEmbedded.framework \
    "$CONFIG_PATH"/ShakaPlayerEmbedded.FFmpeg.framework \
    ./sample_xcode_project/
