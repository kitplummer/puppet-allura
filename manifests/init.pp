# Class: allura
#
#
class allura {
  
  exec { "get_allura": 
    command => "git clone git://git.code.sf.net/p/allura/git.git allura",
    cwd => "/var",
    creates => '/var/allura'
  }

  exec { "update_allura":
    onlyif => '/usr/bin/test -f /var/allura',
    command => 'git pull',
    cwd => "/var/allura",
  }

  case $operatingsystem {
    ubuntu: {
      package { "mongodb-server": ensure => installed }
      package { "mongodb-clients": ensure => installed }
      package { "git-core": ensure => installed }
      package { "subversion": ensure => installed }
      package { "python-svn": ensure => installed }
      package { "default-jre-headless": ensure => installed }
      package { "libssl-dev": ensure => installed }
      package { "libldap2-dev": ensure => installed }
      package { "libsasl2-dev": ensure => installed }
      package { "libjpeg8-dev": ensure => installed }
      package { "zlib1g-dev": ensure => installed }
      package { "python-pip": ensure => installed }

      file { '/usr/lib/x86_64-linux-gnu/libz.so':
        ensure => link,
        target => '/usr/lib/libz.so',
        require => Package["zlib1g-dev"]
      }
      file { '/usr/lib/x86_64-linux-gnu/libjpeg.so':
        ensure => link,
        target => '/usr/lib/libjpeg.so',
        require => Package["libjpeg8-dev"]
      } 

      include python::dev
      include python::venv    

      python::venv::isolate { "/usr/local/venv/allura": 
        require => Exec["get_allura"],
        requirements => "/var/allura/requirements.txt",
      }



    }
    centos: {
      # 10gen Yum repo
      yumrepo { "10gen":
        baseurl => "http://downloads-distro.mongodb.org/repo/redhat/os/x86_64",
        descr => "10gen Mongo repo",
        enabled => 1,
        gpgcheck => 0
      }
      package { "mongo-10gen": ensure => installed, require => Yumrepo["10gen"]}
      package { "mongo-server-10gen": ensure => installed, require => Yumrepo["10gen"]}
    }
  }

  file { "/tmp/loadout.sh":
    mode => 0755,
    owner => root,
    group => root,
    source => "puppet:///modules/allura/loadout.sh",  
  } -> 
  exec { "sh /tmp/loadout.sh": 
    cwd => "/var/allura",
    creates => "/var/scm/git",
    timeout => 600,
  }
  # resources
}