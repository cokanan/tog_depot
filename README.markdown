Depot
===========

File management system for TOG:Community framework.

Included functionality
---------------------- 

* File management
* Folder management
* Filesize and disk cuota configuration
* Tag system
* File and folder privacity
* Abuse report
* And more...

Resources
=========

Plugin requirements
-------------------

In case you haven't got any of them installed previously, you'll need the following plugins on your application:

* paperclip
* tog_core
* [seo\_urls](http://github.com/tog/tog/wikis/3rd-party-plugins-seo_urls)

Follow each link above for a short installation guide incase you have to install them.

Installing plugin as a gem
--------------------------

* Run the following if you haven't already:
<pre>
gem sources -a http://gems.github.com
</pre>

* Install the gem:
<pre>
sudo gem install dms-tog_depot
</pre>

Installing plugin from source
-----------------------------

* Install plugin form source:
<pre>
ruby script/plugin install git://github.com/dms/tog_depot.git
</pre>

* Add Depot's routes to your application's config/routes.rb
<pre>
map.routes_from_plugin 'tog_depot'
</pre>

* Add plugin static resources to public app:
<pre>
rake tog:plugins:copy_resources
</pre>

* Generate installation migration:
<pre>
ruby script/generate migration install_tog_depot
</pre>

* With the following content:
<pre>
class InstallTogDepot < ActiveRecord::Migration
   def self.up
      migrate_plugin "tog_depot", 3
   end
   def self.down
      migrate_plugin "tog_depot", 0
   end
end
</pre>

* And finally...
<pre>rake db:migrate</pre> 


More
-------
Released under the MIT license

[http://dmsti.es](http://dmsti.es)

DMS, Desarrollo de Medios y Sistemas. 
