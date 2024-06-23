# 공식 Jenkins LTS 이미지를 기반으로 사용
FROM jenkins/jenkins:lts

# 추가 패키지를 설치하기 위해 root 사용자로 전환
USER root

# OpenJDK 11 설치
RUN apt-get update && \
    apt-get install -y openjdk-11-jdk && \
    apt-get clean

# Terraform 설치
RUN apt-get update && \
    apt-get install -y wget gnupg software-properties-common && \
    # HashiCorp의 GPG 키를 다운로드하고 키링에 추가
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg && \
    # 서명 검증을 위해 키링을 지정하여 HashiCorp 저장소 추가
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list && \
    apt-get update && \
    # HashiCorp 저장소에서 Terraform 설치
    apt-get install -y terraform && \
    apt-get clean

# kubectl 설치
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl && \
    chmod +x kubectl && \
    mv kubectl /usr/local/bin/kubectl

# Jenkins 홈 디렉토리에 대한 소유권을 Jenkins 사용자에게 설정
RUN chown -R jenkins:jenkins /var/jenkins_home

# Jenkins 사용자로 다시 전환
USER jenkins

# Jenkins 포트 노출
EXPOSE 8080

# Jenkins 시작
ENTRYPOINT ["/sbin/tini", "--", "/usr/local/bin/jenkins.sh"]
