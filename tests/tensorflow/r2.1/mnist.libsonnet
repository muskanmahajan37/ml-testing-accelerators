# Copyright 2020 Google LLC
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

local common = import "common.libsonnet";
local tpus = import "templates/tpus.libsonnet";
local gpus = import "templates/gpus.libsonnet";

{
  local mnist = common.ModelGardenTest {
    modelName: "mnist",
    command: [
      "python3",
      "official/vision/image_classification/mnist_main.py",
      "--data_dir=$(MNIST_DIR)",
      "--model_dir=$(MODEL_DIR)",
    ],
  },
  local functional = common.Functional {
    command+: [
      "--train_epochs=10",
      "--epochs_between_evals=10",
    ],
  },
  local v2_8 = {
    accelerator: tpus.v2_8,
    command+: [
      "--distribution_strategy=tpu",
      "--batch_size=1024",
    ],
  },
  local v3_8 = {
    accelerator: tpus.v3_8,
    command+: [
      "--distribution_strategy=tpu",
      "--batch_size=2048",
    ],
  },

  configs: [
    mnist + v2_8 + functional,
    mnist + v3_8 + functional,
  ],
}
