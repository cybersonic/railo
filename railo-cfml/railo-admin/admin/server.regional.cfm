<!--- <cfset classConfig=createObject("java","railo.runtime.config.ConfigWeb")>
<cfset STRICT=classConfig.SCOPE_STRICT>
<cfset SMALL=classConfig.SCOPE_SMALL>
<cfset STANDART=classConfig.SCOPE_STANDART> --->
<cfset error.message="">
<cfset error.detail="">
<!--- <cfset hasAccess=securityManager.getAccess("setting") EQ ACCESS.YES>

<cfset hasAccess=securityManagerGet("setting","yes")> --->


<cfadmin 
	action="securityManager"
	type="#request.adminType#"
	password="#session["password"&request.adminType]#"
	returnVariable="hasAccess"
	secType="setting"
	secValue="yes">

<!--- 
Defaults --->
<cfparam name="url.action2" default="list">
<cfparam name="form.mainAction" default="none">
<cfparam name="form.subAction" default="none">

<cfif hasAccess>
	<cftry>
		<cfswitch expression="#form.mainAction#">
		<!--- UPDATE --->
		
			<cfcase value="#stText.Buttons.Update#">
				<cfif form.locale EQ "other">
					<cfset form.locale=form.locale_other>
				</cfif>
				
				<cfadmin 
					action="updateRegional"
					type="#request.adminType#"
					password="#session["password"&request.adminType]#"
					
					timezone="#form.timezone#"
					locale="#form.locale#"
					timeserver="#form.timeserver#"
					usetimeserver="#structKeyExists(form,"usetimeserver") and form.usetimeserver#"
					remoteClients="#request.getRemoteClients()#"
					>
			
			</cfcase>
			<!--- reset to server setting --->
			<cfcase value="#stText.Buttons.resetServerAdmin#">
				<cfif form.locale EQ "other">
					<cfset form.locale=form.locale_other>
				</cfif>
				
				<cfadmin 
					action="updateRegional"
					type="#request.adminType#"
					password="#session["password"&request.adminType]#"
					
					timezone=""
					locale=""
					timeserver=""
					usetimeserver=""
					remoteClients="#request.getRemoteClients()#"
					>
			
			</cfcase>
		</cfswitch>
		<cfcatch>
			<cfset error.message=cfcatch.message>
			<cfset error.detail=cfcatch.Detail>
		</cfcatch>
	</cftry>
</cfif>

<cfadmin 
	action="getLocales"
	locale="#stText.locale#"
	returnVariable="locales">
	
<cfadmin 
	action="getTimeZones"
	locale="#stText.locale#"
	returnVariable="timezones">
<cfadmin 
	action="getRegional"
	type="#request.adminType#"
	password="#session["password"&request.adminType]#"
	returnVariable="regional">

<cfquery name="timezones" dbtype="query">
	select * from timezones order by id,display
</cfquery>


<!--- 
Redirtect to entry --->
<cfif cgi.request_method EQ "POST" and error.message EQ "">
	<cflocation url="#request.self#?action=#url.action#" addtoken="no">
</cfif>

<!--- 
Error Output --->
<cfset printError(error)>
<!--- 
Create Datasource --->

<cfoutput>
	<cfif not hasAccess>
		<cfset noAccess(stText.setting.noAccess)>
	</cfif>


		<p>
		<cfif request.adminType EQ "server">
			#stText.Regional.Server#
		<cfelse>
			#stText.Regional.Web#
		</cfif>
		</p>
	
	<cfform onerror="customError" action="#request.self#?action=#url.action#" method="post" class="form-horizontal">
	
		<div class="control-group">
		    <label class="control-label" for="locale">#stText.Regional.Locale#</label>
		    <div class="controls">
		      		<cfif hasAccess>
						<cfset hasFound=false>
						<cfset keys=structSort(locales,'textnocase')>
						<select name="locale" class="large">
							<option selected value=""> --- #stText.Regional.ServerProp[request.adminType]# --- </option>
							 ---><cfloop collection="#keys#" item="i"><cfset key=keys[i]><option value="#key#" <cfif key EQ regional.locale>selected<cfset hasFound=true></cfif>>#locales[key]#</option><!--- 
							 ---></cfloop>
						</select>
					<cfelse>
						<b>#regional.locale#</b>
					</cfif>
					<p class="muted">#stText.Regional.LocaleDescription#</p>
		    </div>
		  </div>
	
		
		<div class="control-group">
		    <label class="control-label" for="timezone">#stText.Regional.TimeZone#</label>
		    <div class="controls">
		      		<cfif hasAccess>
						<select name="timezone" class="large">
							<option selected value=""> --- #stText.Regional.ServerProp[request.adminType]# --- </option>
							<cfoutput query="timezones">
								<option value="#timezones.id#"
								<cfif timezones.id EQ regional.timezone>selected</cfif>>
								#timezones.id# - #timezones.display#</option>
							</cfoutput>
						</select>
					<cfelse>
						<b>#regional.timezone#</b>
					</cfif>
					
					<p class="muted">#stText.Regional.TimeZoneDescription#</p>
		    </div>
		  </div>
		
		<div class="control-group">
		    <label class="control-label" for="TimeServer">#stText.Regional.TimeServer#</label>
		    <div class="controls">
		      	<cfif hasAccess>
					<input type="text" name="timeserver" value="#regional.timeserver#" class="large">
					<br /><input type="checkbox" class="checkbox" name="usetimeserver" <cfif regional.usetimeserver>checked="checked"</cfif> value="true" /> #stText.Regional.useTimeServer#
				<cfelse>
					<b>#regional.timeserver#</b>
					<input type="hidden" name="usetimeserver" value="#regional.usetimeserver#" />
				</cfif>
				<p class="muted">#stText.Regional.TimeServerDescription#</p>

		    </div>
		  </div>
		<cfif hasAccess>
			<cfmodule template="remoteclients.cfm" colspan="2">
		</cfif>
		
		<cfif hasAccess>
			<div class="form-actions">
			 	<input class="button submit btn btn-primary" type="submit" name="mainAction" value="#stText.Buttons.Update#">
				<input class="button reset btn" type="reset" name="cancel" value="#stText.Buttons.Cancel#">
				<cfif request.adminType EQ "web">
					<input class="button submit btn" type="submit" name="mainAction" value="#stText.Buttons.resetServerAdmin#">
				</cfif>
			</div>
		</cfif>
	
		<br>
		<div class="alert alert-info">
			<h4>Current time settings</h4>
			<p>
				#stText.Overview.ServerTime# #lsdateFormat(date:now(),timezone:"jvm")# #lstimeFormat(time:now(),timezone:"jvm")#
				<br>
				#stText.Overview.DateTime# #lsdateFormat(now())# #lstimeFormat(now())#
					
			</p>
		</div>

		
	</cfform>

</cfoutput>