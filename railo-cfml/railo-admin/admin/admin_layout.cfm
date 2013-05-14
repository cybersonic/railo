<cfif thistag.executionmode EQ "end" or not thistag.hasendtag>

	<cfparam name="session.railo_admin_lang" default="en">
	<cfset variables.stText = application.stText[session.railo_admin_lang] />
	<cfparam name="attributes.navigation" default="">
	<cfparam name="attributes.title" default="">
	<cfparam name="attributes.content" default="">
	<cfparam name="attributes.right" default="">
	<cfparam name="attributes.width" default="780">

	<cfscript>
		ad=request.adminType;
		hasNavigation=len(attributes.navigation) GT 0;
		home=request.adminType&".cfm"
		if(structKeyExists(url,'action'))homeQS="?action="&url.action;
		else homeQS="";
	</cfscript>
	<cfset request.mode="full">
	
<cfcontent reset="yes" /><!DOCTYPE html><cfoutput>
<html>
<head>
	<title>Railo #ucFirst(request.adminType)# Administrator</title>
	<cfparam name="attributes.onload" default="">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<script src="resources/js/jquery-1.7.2.min.js.cfm?id=#getTickCount()#" type="text/javascript"></script>
	<script src="resources/js/jquery.blockUI.js.cfm?id=#getTickCount()#" type="text/javascript"></script>
	<script src="resources/js/admin.js.cfm?id=#getTickCount()#" type="text/javascript"></script>
	<script src="resources/bootstrap/js/bootstrap.js.cfm?id=#getTickCount()#" type="text/javascript"></script>
	<link href="resources/bootstrap/css/bootstrap.css.cfm?id=#getTickCount()#"  rel="stylesheet" media="screen" />
	<link href="resources/bootstrap/css/bootstrap-responsive.css.cfm?id=#getTickCount()#"  rel="stylesheet" media="screen" />
	<link href="resources/bootstrap/css/railo.css.cfm?id=#getTickCount()#"  rel="stylesheet" media="screen" />
</head>
<body id="body" class="admin-#request.adminType# #request.adminType#<cfif application.adminfunctions.getdata('fullscreen') eq 1> full</cfif>" onload="#attributes.onload#">
	
<div class="navbar">
	  <div class="navbar-inner">
	    <a class="brand" href="#home#">Railo (replace with logo)</a>
	    <ul class="nav">
			<cfset serverActiveclass = request.adminType EQ "server" ? "active" : "">
			<cfset webActiveclass = request.adminType EQ "web" ? "active" : "">
			<li class="divider-vertical"></li>
			<li class="#serverActiveclass#"><a href="server.cfm#homeQS#">Server Administrator</a></li>
			
			
			<!--- are we logged in and in the server admin? Then we can go and list all the other contexts! --->
				<cfif hasNavigation AND request.adminType EQ "server" AND StructKeyExists(session, "password"&request.adminType)>
					<cfadmin 
						action="getContexts"
						type="#request.adminType#"
						password="#session["password"&request.adminType]#"
						returnVariable="rst">

				<li class="#webActiveclass#"><a href="web.cfm#homeQS#">Web Administrator</a></li>

				<li class="#webActiveclass# dropdown"><a href="web.cfm#homeQS#" id="webAdminLink"  role="button" class="dropdown-toggle" data-toggle="dropdown"><b class="caret"></b></a>

					<ul class="dropdown-menu" role="menu" aria-labelledby="webAdminLink">
						<cfloop query="rst">
							<cfset label = rst.label>

								
							
							<cfif Len(rst.url)>
								<li role="presentation"><a href="#rst.url#/railo-context/admin/web.cfm" role="menuitem">#rst.label# #rst.url#</a></li>				
							<cfelse>
								<li role="presentation" class="disabled"><a href="##" role="menuitem">#rst.label# (#rst.path#)></a></li>
							
							</cfif>
							
						</cfloop>
					</ul>
				</li>
				<cfelse>
					<li class="#webActiveclass#">
					<a href="web.cfm#homeQS#">Web Administrator</a>
					</li>
				</cfif>
			
	    </ul>
		<cfif hasNavigation>
		<ul class="nav pull-right">
			<!--- here goes favourites --->
			<cfparam name="url.action" default="" />
			<cfset pageIsFavorite = application.adminfunctions.isFavorite(url.action) />
			<li class="dropdown">
				
				<cfif url.action eq "">
					<a href="##" class="favorite" title="Go to your favorite pages" role="button" class="dropdown-toggle tooltipMe" data-toggle="dropdown">Favorites <b class="caret"></b></a>
				<cfelseif pageIsFavorite>
					<a href="#request.self#?action=internal.savedata&action2=removefavorite&favorite=#url.action#" class="favorite" title="Remove this page from your favorites">Favorites</a>
				<cfelse>
					<a href="#request.self#?action=internal.savedata&action2=addfavorite&favorite=#url.action#" class="favorite_inactive" title="Add this page to your favorites">Favorites</a>
				</cfif>
				<ul class="dropdown-menu" role="menu" aria-labelledby="dLabel">
					<cfif attributes.favorites neq "">
						#attributes.favorites#
					<cfelse>
						<li class="favtext"><i>No items yet.<br />Go to a page you use often, and click on "Favorites" to add it here.</i></li>
					</cfif>
				</ul>
				
				<!--
				<a href="##" id="favouritesdrop" role="button" class="dropdown-toggle tooltipMe" data-toggle="dropdown" title="Go to your favorite pages">Favorites<b class="caret"></b></a>
				-->
				
			</li>
			<li><a href="#request.self#?action=logout">#variables.stText.help.logout#</a></li>
		</ul>
		</cfif>
		
		<!---

			<!--- Favorites --->

			<div id="favorites" class="dropdown">
				<cfif url.action eq "">
					<a href="##" class="favorite tooltipMe" title="Go to your favorite pages">Favorites</a>
				<cfelseif pageIsFavorite>
					<a href="#request.self#?action=internal.savedata&action2=removefavorite&favorite=#url.action#" class="favorite tooltipMe" title="Remove this page from your favorites">Favorites</a>
				<cfelse>
					<a href="#request.self#?action=internal.savedata&action2=addfavorite&favorite=#url.action#" class="tooltipMe favorite_inactive" title="Add this page to your favorites">Favorites</a>
				</cfif>
				<ul>
					<cfif attributes.favorites neq "">
						#attributes.favorites#
					<cfelse>
						<li class="favtext"><i>No items yet.<br />Go to a page you use often, and click on "Favorites" to add it here.</i></li>
					</cfif>
				</ul>
			</div>
		</cfif>
		--->
		
		
		<cfif hasNavigation>
			<form method="get" action="#cgi.SCRIPT_NAME#" class="navbar-form pull-right" >
				<input type="hidden" name="action" value="admin.search" />
				<input type="text" class="search-query" name="q" size="15" id="navsearch" placeholder="#stText.buttons.search#" />
				<!--- <button type="submit" class="btn btn-mini btn-search" title="#stText.buttons.search#"><span>#stText.buttons.search#</span></button> --->
 			</form>
		</cfif>
	  </div>
</div> <!-- end .navbar -->


<div class="container-fluid">
	<cfif hasNavigation>
	
			<div class="row-fluid">
				<div class="span3">
					#attributes.navigation#
				</div> <!--- end .span3 --->
				<div class="span9"> <!--- content starts here --->
					<ul class="breadcrumb">
						 <li><a href="#home#">Home</a> <span class="divider">/</span></li>
						<cfif structKeyExists(request,'subTitle')>
							<li>#attributes.title# <span class="divider">/</span></li>

							<li>#request.subTitle#</li>
						<cfelse>
							<cfset counter = 1>
							<cfloop list="#attributes.title#" delimiters="-" index="t">
								<li>#Trim(t)#<cfif counter LT ListLen(attributes.title, "-")> <span class="divider">/</span></cfif></li>			
								<cfset counter++>
							</cfloop>

							 
						</cfif>
					</ul>
					<h1>#attributes.title#<cfif structKeyExists(request,'subTitle')> - #request.subTitle#</cfif></h1>
						#thistag.generatedContent#
				</div> <!--- end .span9 --->
		</div>  <!--- end .row --->

	
	<cfelse><!--- we are in the login page --->	
		<cfsavecontent variable="newStyle">
			<style>
			body {
		        background-color: ##f5f5f5;
		      }
		</style>
		</cfsavecontent>
		<cfhtmlhead text="#newStyle#">
		#thistag.generatedContent#
	</cfif>
</div> <!--- end .container --->	

<footer class="footer">
	<div class="container-fluid">
			&copy; #year(Now())#
			<a href="http://www.getrailo.com" target="_blank">The Railo Company Limited, London, England</a>.
			All Rights Reserved. <br>

		
	</div>
</footer>	
	
	
</body>
</html>
</cfoutput>
	<cfset thistag.generatedcontent="">
</cfif>

<cfparam name="url.showdebugoutput" default="no">
<cfsetting showdebugoutput="#url.showdebugoutput#">