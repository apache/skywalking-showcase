FROM apache/skywalking-python:0.7.0-grpc-py3.9

WORKDIR /workspace

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY src .

CMD python app.py
