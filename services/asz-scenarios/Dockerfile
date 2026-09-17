# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

# The scenarios the showcase's asz feed picks from, as an image. They are too large to ride in the Helm
# release: Helm keeps a release, chart files and rendered manifest together, in one Secret of at most 1 MiB.
# The build context is the scenario directory, deploy/platform/config/asz/scenarios.
FROM busybox:1.36

COPY --chmod=0444 *.yaml /scenarios/
