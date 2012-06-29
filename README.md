Puppet module for deploying Allura.

This module currently installs and starts MongoDB and Solr from packages, not much in the way of configuration options.  It'd be good to turn all the config files into templates which could be manipulated from manifests.

The launching of the Python stuff is hacky at best.  It works, but doesn't treat anything as a system daemon.  I'll probably look into turning both the taskd and serve stuff for TurboGears into real system managed services (somehow).

I've built this using Vagrant.  You can get Allura up in a vagrant box easily:

1. Just add this to your Vagrantfile:

```
config.vm.provision :puppet do |puppet|
	puppet.manifests_path = "manifests"
    puppet.manifest_file  = "allura.pp"
    puppet.module_path = "modules"
end
```

2. Then create a ```manifests``` and ```modules``` subdirectory next to the Vagrantfile.

3. From the ```modules``` directory, clone the puppet-allura code into it:

```
git clone https://github.com/kitplummer/puppet-allura.git allura
```

4. ```vagrant reload``` <- will restart the VM.