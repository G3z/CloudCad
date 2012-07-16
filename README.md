##Key Features
- CAD application in the browser.(**Early stage WIP**)  
- Design sharing tool.(**Not present**)  
- Design Versioning tool.(**Not present**)  
- Collaborative Design tool.(**Not present**)  

#[Video 000](http://www.youtube.com/watch?v=1vnIxy5GMro)

##Installation
	#clone the stuff...  
    $ git clone git://github.com/G3z/CloudCad.git  
    
    #initialize and update solid in app/assets/javascripts/app/libs/solid  
    $ git submodule update --init --recursive 
    
    #rails initialization...  
    $ cd CloudCad  
    $ bundle install  
    $ rake db:create;rake db:migrate; rake db:seed  
	
    #...FINALLY:
    $ rails s
    #or
    $ rails s -e production
    

##Main Authors
Giacomo **G[3z]** Trezzi  
Fabio **Wezzy** Trezzi

##Made with :
[Backbone.js](http://backbonejs.org/)  
[CSG.js](https://github.com/evanw/csg.js)  
[CoffeeScript](http://jashkenas.github.com/coffee-script/)  
[jQuery](http://www.jquery.com)  
[Rails](http://rubyonrails.org/ )  
[Solid](https://github.com/wezzy/solid)  
[THREECsg.js](http://chandler.prallfamily.com/2011/12/constructive-solid-geometry-with-three-js/)  
[THREE.js](https://github.com/mrdoob/three.js/)  

[docco-husky](https://github.com/mbrevoort/docco-husky) is used for generating the documentation