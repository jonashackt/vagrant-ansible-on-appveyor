# vagrant-ansible-on-travisci

[![Build status](https://ci.appveyor.com/api/projects/status/i7865icuuhd6457s?svg=true)](https://ci.appveyor.com/project/jonashackt/vagrant-ansible-on-appveyor)

Example project showing how to install and use Vagrant on TravisCI and how to use a Ansible playbook to connect to the running Vagrant Box inside Travis


## Why Vagrant on a CI system?

I´d really want to test bigger Infrastructure-as-Code projects like https://github.com/jonashackt/kubernetes-the-ansible-way and therefore need Vagrant running on a CI system (I don´t want to setup or host the CI system myself).

And no, Docker-in-Docker won´t suffice here!

## Why not TravisCI (or CircleCI)?

Problem is: my beloved TravisCI doesn´t support Vagrant - see https://stackoverflow.com/questions/31828555/using-vagrant-on-cloud-ci-services

I really tested it out, just have a look into the first commits of this repository, you should find some links to Travis. Especially tried to switch all possible environments (see https://docs.travis-ci.com/user/reference/overview/#virtualisation-environment-vs-operating-system), but sadly none worked for me. Here´s the `.travis.yml` I ended up ([which didn´t work](https://travis-ci.org/jonashackt/vagrant-ansible-on-travisci/builds/456418110)):

```yaml
language: python
python: "2.7"

# virtualization environment (see https://docs.travis-ci.com/user/reference/overview/#virtualisation-environment-vs-operating-system)
# using the newest available Ubuntu on Travis
dist: xenial

# Install ansible
addons:
  apt:
    packages:
    - python-pip
    - linux-headers-generic
    - virtualbox-dkms
    - virtualbox

install:
  # Install ansible
  - pip install ansible
  # Check ansible version
  - ansible --version
  # Create ansible.cfg with correct roles_path
  - printf '[defaults]\nroles_path=../' >ansible.cfg
  - sudo dpkg-reconfigure virtualbox-dkms
  - sudo dpkg-reconfigure virtualbox
  - VBoxManage --version
  # Download Vagrant
  - sudo wget -nv https://releases.hashicorp.com/vagrant/2.2.1/vagrant_2.2.1_x86_64.deb
  # Install Vagrant package
  - sudo dpkg -i vagrant_2.2.1_x86_64.deb

script:
  - vagrant up
  - ansible-playbook playbook.yml -i hosts --syntax-check
  - ansible-playbook playbook.yml -i hosts

``` 
 
Main thing was this blog: https://www.lewuathe.com/travisci/vagrant/vagrant-in-travisci.html But I think it never worked in it´s just a perk.

Then I switched over to CircleCI, because I found some gists (https://github.com/critical-alert/circleci-vagrant/blob/master/circle.yml and https://gist.github.com/masutaka/2adfc24c8c220be292ea). Here´s my `circle.yml`:

```yaml
dependencies:
  cache_directories:
  - ~/.vagrant.d
  - ~/tmp
  pre:
  - |
    mkdir -p ~/tmp
    cd ~/tmp
    VERSION=2.2.1
    if [ ! -f vagrant_${VERSION}_x86_64.deb ]; then
      wget -nv https://releases.hashicorp.com/vagrant/${VERSION}/vagrant_${VERSION}_x86_64.deb
    fi
    sudo dpkg -i vagrant_${VERSION}_x86_64.deb

  - pip install ansible

test:
  pre:
  - vagrant up
  - ansible-playbook playbook.yml -i hosts --syntax-check
  - ansible-playbook playbook.yml -i hosts
  post:
  - vagrant destroy -f

```

But that [didn´t work either](https://circleci.com/gh/jonashackt/vagrant-ansible-on-travisci/1) - and CircleCI seems to have switched to Docker-based builds with it´s version 2 - so this configuration is legacy.

In the end I overlooked this comment here: https://stackoverflow.com/questions/31828555/using-vagrant-on-cloud-ci-services#comment71887941_32191959 and I started to test [AppVeyor](https://www.appveyor.com/), which I already heard from... Seems to be somehow Microsofty, but if it would be really capable of spinning up Vagrant boxes, I would run over with flying flags.


## Vagrant on AppVeyor

Good resources: 

https://help.appveyor.com/discussions/problems/1247-vagrant-not-working-inside-appveyor

https://ci.appveyor.com/project/tknerr/vagrant-appveyor-testing/history

[Ubuntu Image specs on AppVeyor](https://www.appveyor.com/docs/linux-images-software/)

[appveyor.yml Reference](https://www.appveyor.com/docs/appveyor-yml/)

