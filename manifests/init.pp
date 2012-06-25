# Class: allura
#
#
class allura {

  case $operatingsystem {
    ubuntu: {
      package { "mongodb-server": ensure => installed }
      package { "mongodb-clients": ensure => installed }
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
  # resources
}