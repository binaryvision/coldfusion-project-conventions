<cfcomponent>

    <cffunction
        name="onApplicationStart">
        <cfset setupMappings()>
        <cfset setupConfig("../config/local.properties")>
    </cffunction>

    <cffunction
        name="onRequestStart">
        <cfif structKeyExists(url, "reinit")>
            <cfset onApplicationStart()>
        </cfif>

        <cfif application.config.getBoolean("debug", "false")>
            <cfset addServerAddressToResponseHeaders()>
        </cfif>
    </cffunction>

    <!---
        Custom Functions
    --->

    <cffunction
        name="setupConfig">
        <cfargument
            name="propertiesFile"
            type="string"
            required="yes">
        <cfset application.config = (
            createObject(
                "java", 
                "org.apache.commons.configuration.PropertiesConfiguration"
            ).init(expandPath(propertiesFile))
        )>

        <cfset application.config.setReloadingStrategy(
            createObject(
                "java",
                "org.apache.commons.configuration.reloading.FileChangedReloadingStrategy"
            ).init()
        )>
    </cffunction>

    <cffunction
        name="setupMappings">
        <!---
            Everything under the project mappings directory gets setup as a
            mapping automatically.
        --->

        <cfset this.mappings = structNew()>
        <cfdirectory
            name="local.mappings"           
            type="dir"                  
            action="list"              
            directory="../mappings">
        <cfloop
            query="mappings">
            <cfset this.mappings["/#name#"] = "#directory#/#name#">
        </cfloop>
    </cffunction>

    <cffunction
        name="addServerAddressToResponseHeaders"
        returnType="void">
        <!---
            So you can know which load balanced server you are on by looking
            at the response headers.
        --->

        <cfset var localhost = createObject("java", "java.net.InetAddress").localhost>

        <cfheader
            name="_host_name"
            value="#localhost.getHostName()#">
        <cfheader
            name="_host_address"
            value="#localhost.getHostAddress()#">
    </cffunction>

</cfcomponent>
