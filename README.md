ansible-maven-repo
==================

Download artifacts from Maven repositories with [Ansible](http://www.ansible.com/home).

# Prerequisites

Install [JDK and Maven](site.yml) using existing Ansible modules

    ansible-galaxy install geerlingguy.java
    ansible-galaxy install https://github.com/silpion/ansible-maven.git


``` yaml
- hosts: localhost

  roles:
    - { role: ansible-maven }
    - { role: geerlingguy.java }

  vars:
    java_packages:
      - java-1.7.0-openjdk
```

# Example

From [mvn.yml](mvn.yml), download any number of Maven artifacts optionally from different repositories

``` yaml
- hosts: localhost

  vars:
    mvn_artifacts:
      - id: org.apache.maven:maven-core:2.2.1:jar:sources
        dest: /tmp/test.jar
        # params: -U # update snapshots
        # repos:
          # - http://repo1.maven.apache.org/maven2
      
  tasks:
    - name: copy maven artifacts
      command: mvn {{ item.params | default('') }} org.apache.maven.plugins:maven-dependency-plugin:get -Dartifact={{ item.id }} -Ddest={{ item.dest }} -Dtransitive=false -Pansible-maven -DremoteRepositories={{ item.repos | default(['http://repo1.maven.apache.org/maven2']) | join(",") }}
      with_items: mvn_artifacts
```


# Building Docker image

    docker build -t csanchez/ansible-maven .
