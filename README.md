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

---

Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.