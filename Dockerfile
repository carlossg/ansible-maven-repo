FROM ansible/centos7-ansible:stable

RUN yum install -y tar

# Install Java module
RUN ansible-galaxy install geerlingguy.java

# Install Maven module
RUN ansible-galaxy install https://github.com/silpion/ansible-maven.git

# Add playbooks to the Docker image
COPY site.yml /

# Run Ansible to install JDK and Maven
RUN ansible-playbook site.yml -c local

# cache Maven plugin dependencies
RUN mvn org.apache.maven.plugins:maven-dependency-plugin:get || true

# The maven execution
# COPY mvn.yml /
# RUN ansible-playbook -v mvn.yml -c local
