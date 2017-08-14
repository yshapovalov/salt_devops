dependencies:
  pkg.installed:
    - pkgs:
      - python
      - git
      - libyaml-dev
      - libffi-dev
      - python-dev
      - python-pip
      - qemu
      - qemu-utils
      - libvirt-bin
      - libvirt-dev
      - vlan
      - bridge-utils
      - ebtables
      - pm-utils
      - genisoimage
      - libsqlite3-0

installed virtualenv libvirt-python:
  pip.installed:
    - names:
      - virtualenv
      - libvirt-python

load my custom module:
  module.run:
    - name: saltutil.sync_all
    - refresh: True

create kvm pool:
  module.run:
    - name: kvm_pool.create

create devops-venv:
  virtualenv.managed:
    - name: /home/jenkins/devops
    - cwd: /home/jenkins/devops
    - pip_upgrade: True

install-devops:
  pip.installed:
    - name: git+https://github.com/openstack/fuel-devops.git@3.0.5
    - bin_env: /home/jenkins/devops
    - upgrade: True

setup-db:
  environ.setenv:
    - value:
        DEVOPS_DB_NAME: /home/jenkins/fuel-devops.sqlite
        DEVOPS_DB_ENGINE: "django.db.backends.sqlite3"
    - update_minion: True

. /home/jenkins/devops/bin/activate && dos-manage.py migrate:
  cmd.run
