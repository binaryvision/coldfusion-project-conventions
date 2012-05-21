THIS IS A WORK IN PROGRESS!
===========================

At the moment the only thing that works here are the automatic mappings and
config setup, everything else is a stub for something to be done later.

__NOTE:__ to get the config working, the file
`lib/commons-configuration-1.8.jar` needs to be on the java class path ([http://stubertbear.wordpress.com/2010/01/25/custom-java-libraries-in-coldfusionrailo/](basic guide here)).

##Mappings

Everything in the `mappings/` directory will get setup as a mapping automatically. This greatly helps keep stuff out of the web root that shouldn't be there. "Where do I put this cfc?" You put it in the appropriate mapping, or you create a new mapping for it! Which could be managed in a seperate git repository using git subtree.

Things to know:

* In the example `www/Application.cfc` I've got it so that all mappings are cleared when you run `Application.setupMappings`, so if you reinit, it will also clear any no longer used mappings rather than just overwriting them!

* Some, specifically the binaryvision one, mappings folders will be seperate repositories linked to using git subtree but for now they are not, because I don't yet know how to use git subtree (note it's not submodule).

* I suggest having at the least by default a `mappings\binaryvision` for shared code between projects, and a `mappings\<project>` for project specific code.

##Environment Configuration

We're using the [http://commons.apache.org/configuration/](Apache Commons - Configuration) library for this,
specifically the [http://commons.apache.org/configuration/howto_properties.html](properties file based configuration). Some links to how the syntax for
these look. It's what ANT uses (build.properties) and properties files are
pretty standard Java tool.

Things to know:

* Naming convention is to deliniate keys with periods so for example you might see something like this:
  
<pre>  
    database.username = user
    database.password = pass
</pre>

* In the example `www/Application.cfc` I've setup the properties so they will automatically reload when the local.properties file is updated. So rather than having to restart or reinit when you change the config it should just work, or you might need to `touch local.properties` (don't know what the win equivalent for this is!)

* Properties are immutable! So once a property is set it can't be changed.

* Properties files can be chained together, by adding a special `include` property.

<pre>
	database.username = user
	database.password = pass
    debug = true
    # if you load this properties file, all the properties above get loaded,
    # then it sees the include and loads all the properties inside the file
    # default.properties, and because properties are immutable, if any of the 
    # properties that are already set have also been defined in the included
    # file then they will not be overwritten.
    include = default.properties
</pre>

### How we use it

Taking the last two bullets above into account, imagine a scenario where you have to
manage the configuration for an application between two environments.
Production and Development (like we do with most of our projects). The way you
would setup the configuration for these is to have four properties files in
your config directory, three of which you would keep in version control.

<pre>
    config/
        default.properties
        development.properties
        production.properties
        local.properties
</pre>

### default.properties

This contains the default properties for all environments.

### development.properties

This contains the default properties for the instances of the application
that are running in the development environment, at the end of this file you:

<pre>
    include = default.properties
</pre>

### production.properties

Same as above, but for production.

### local.properties

This is the file that doesn't get added to version control, in this file you
can include one of the environment properties files (development or 
production) and any instance specific overrides. So for example, you might 
stick passwords in here that shouldn't be in version control or paths that
differ for just this machine.
