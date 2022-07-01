FROM python:3.9-slim

WORKDIR /usr/src/app

COPY requirements.txt .

COPY . .

CMD ["python", "app.py"]
