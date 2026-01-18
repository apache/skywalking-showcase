#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
import os

import requests
from flask import Flask, jsonify, request

app = Flask(__name__)


@app.route('/health', methods=['GET'])
def health():
    return 'OK'


@app.route('/rcmd', methods=['GET'])
def application():
    headers = {}
    for key in [
        'x-b3-traceid',
        'x-b3-spanid',
        'x-b3-parentspanid',
        'x-b3-sampled',
        'x-b3-flags',
    ]:
        val = request.headers.get(key)
        if val is not None:
            headers[key] = request.headers[key]

    songsResponse = requests.get('http://songs/songs', headers=headers)
    songs = songsResponse.json()
    ratingResponse = requests.get('http://rating/rating', headers=headers)
    ratings = ratingResponse.json()

    # combine ratings to songs
    ratings_dict = {}
    for rating_data in ratings:
        song_id = rating_data['id']
        ratings_dict[song_id] = rating_data['rating']
    for song_data in songs:
        song_id = song_data['id']
        rating = ratings_dict.get(song_id)
        if rating is not None:
            song_data['rating'] = rating

    return jsonify(songs)


if __name__ == '__main__':
    PORT = os.getenv('PORT', 80)
    app.run(host='0.0.0.0', port=PORT)
