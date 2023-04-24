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

# Check prerequisites

ifeq ($(filter feature-elasticsearch,$(features)),feature-elasticsearch)
ifeq ($(filter feature-postgresql,$(features)),feature-postgresql)
ERROR := only one of `elasticsearch` and `postgresql` can be enabled
endif
endif

ifneq ($(filter feature-elasticsearch,$(features)),feature-elasticsearch)
ifneq ($(filter feature-postgresql,$(features)),feature-postgresql)
ERROR := either `elasticsearch` or `postgresql` must be enabled
endif
endif

ifneq ($(filter feature-elasticsearch,$(features)),feature-elasticsearch)
ifeq ($(filter feature-elasticsearch-monitor,$(features)),feature-elasticsearch-monitor)
ERROR := although `elasticsearch-monitor` does not require `elasticsearch` as storage, but in showcase we use the ElasticSearch used by SkyWalking itself to be monitored, so please enable `elasticsearch` as well.
endif
endif

ifdef ERROR
$(error $(ERROR))
endif
