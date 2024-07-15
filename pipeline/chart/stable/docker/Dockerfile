# Docker Hub에서 공식 Python 이미지를 사용합니다
FROM python:3.9-slim

# 작업 디렉토리를 설정합니다
WORKDIR /app

# 현재 디렉토리 내용을 컨테이너의 /app에 복사합니다
COPY . /app

# requirements.txt에 명시된 필요한 패키지를 설치합니다
RUN pip install --no-cache-dir -r requirements.txt

# 이 컨테이너 외부에서 사용할 수 있도록 포트 5000을 엽니다
EXPOSE 5000

# 환경 변수를 정의합니다
ENV NAME World

# 컨테이너가 시작될 때 app.py를 실행합니다
CMD ["python", "app.py"]
