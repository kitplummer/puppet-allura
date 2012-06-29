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
      package { "solr-common": ensure => installed }
      package { "solr-tomcat": ensure => installed }
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
      package { "python-dev": ensure => installed }
      package { "python-pip": ensure => installed }

      service { "tomcat6":
        ensure => running,
        enable => true
      }

      $tomcat_port = 8893

      file { '/etc/tomcat6/server.xml':
        content => template("allura/tomcat_server.xml.erb"),
        mode => 0644,
        group => "tomcat6",
        require => Package["solr-tomcat"],
        notify => Service["tomcat6"]
      }
      
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

      file { "/var/allura/logs":
        ensure => directory,
        mode => 0777,
      }

      exec { "pip install -r requirements.txt":
        cwd => "/var/allura",
        require => Exec["get_allura"],
        timeout => 1200,
        returns => [0,1],
      }

      exec { "start_taskd":
        cwd => "/var/allura/Allura",
        command => "nohup paster taskd development.ini > /var/allura/logs/taskd.log &",
        require => [File["/var/allura/logs"], Exec["pip install -r requirements.txt"]],
      }

      exec { "init_forge_db":
        cwd => "/var/allura/Allura",
        command => "paster setup-app development.ini",
        require => Exec["start_taskd"],
      }

      exec { "start_forge":
        cwd => "/var/allura/Allura",
        command => "nohup paster serve --daemon development.ini --pid-file=serve.pid --log-file=/var/allura/logs/tg.log &",
        require => [File["/etc/tomcat6/server.xml"],Exec["init_forge_db"],Exec["start_taskd"]],
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
  }

  exec { "sh /tmp/loadout.sh": 
    cwd => "/var/allura",
    creates => "/var/scm/git",
    timeout => 600,
    require => [File["/tmp/loadout.sh"],Exec["get_allura"]]
  }
  # resources
}