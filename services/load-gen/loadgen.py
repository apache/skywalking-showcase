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
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.common.by import By
from selenium.common.exceptions import NoSuchElementException

url = os.getenv('URL', 'http://frontend/index.html')

options = ChromeOptions()
options.add_argument("--headless")
driver = webdriver.Chrome(options=options)

while True:
    print(f'Sending traffic to {url}')
    # noinspection PyBroadException
    try:
        driver.get(url)
        # Click the send button
        try:
            send_button = driver.find_element(By.ID, "sendButton")
            send_button.click()
        except NoSuchElementException:
            print("Send button not found")
        # Click the quote button
        try:
            quote_button = driver.find_element(By.ID, "quoteButton")
            quote_button.click()
        except NoSuchElementException:
            print("Quote button not found")
    except Exception as e:
        print(f"Error: {e}")
        traceback.print_exc()
        break
    # Wait a moment on the page
    time.sleep(30)
    
    # Close the page (navigate to blank page)
    print("Closing page...")
    driver.get("about:blank")
    
    # Wait while page is closed
    time.sleep(30)
