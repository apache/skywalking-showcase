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
import os
import time
import traceback

from selenium import webdriver
from selenium.webdriver.firefox.options import Options as FirefoxOptions

url = os.getenv('URL', 'http://app')

options = FirefoxOptions()
options.add_argument("--headless")
driver = webdriver.Firefox(options=options)

while True:
    print(f'Sending traffic to {url}')
    # noinspection PyBroadException
    try:
        driver.get(url)
    except Exception:
        traceback.print_exc()
    finally:
        time.sleep(10)
