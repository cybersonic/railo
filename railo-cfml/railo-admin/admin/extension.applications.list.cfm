<cfset hasAccess=true />
<cfset data=getData(providers,err)>

<cfset existing=struct() />

<!--- if user declined the agreement, show a msg --->
<cfif structKeyExists(session, "extremoved")>
	<cfoutput>
		<div class="warning">
			#stText.ext.msgafternotagreed#
		</div>
	</cfoutput>
	<cfset structDelete(session, "extremoved", false) />
</cfif>

<cfoutput>

<!--- make a nice structure of the existing items --->

	<cfscript>
		MyExtensions = {};

		loop from="1" to="#extensions.recordcount#" index="x"{
			q= QuerySlice(extensions, x,1);
			MyExtensions[q.id] = q;
		}

		//Need to find out if MyExtensions are not in the develivered extensions, if so we add to 
		MissingExtensions = {}; //Todo

	</cfscript>

<cfif isQuery(data)>

	<ul class="thumbnails">
		<cfset itemcount="1">
		<cfset columns = "5">
		<cfoutput query="data" group="uid">
			<cfset info=data.info>
			<cfif (data.type EQ "all" or data.type EQ request.adminType or (data.type EQ "" and "web" EQ request.adminType)) 
			and (
				session.extFilter.filter2 eq ""
				or doFilter(session.extFilter.filter2,data.label,false)
				or doFilter(session.extFilter.filter2,data.category,false)
				or doFilter(session.extFilter.filter2,info.title,false)
			)
			>
				<cfset link="#request.self#?action=#url.action#&action2=detail&uid=#data.uid#">
				<cfset dn=getDumpNail(data.image,130,50)>
				<cfset iconText = "Install">
				<cfset labelClass = "label-info">

				<!--- check if there is a price --->
				<cfif data.price GT 0>
					<cfset iconText = "Buy $" & data.price>
					<cfset labelClass = "label-success">


				</cfif>

				<!--- check whether we have it installed already! If we do, we should either view ur update --->
				<cfif isExetensionInstalled(data.id)>

					<cfset currentExtension = MyExtensions[data.id]>
					<cfset iconText = "Installed">
					<cfset labelClass = "">

					<cfif currentExtension.version LT data.version>
						<cfset iconText = "Upgrade">
						<cfset labelClass = "label-success">						

					</cfif>

				</cfif>

				<!--- actual display starts now --->

				<li class="span2">

					<div class="thumbnail  well" style="min-height:240px;">
						
						<cfif len(dn)>
							<img  data-src="holder.js/200x100" src="#dn#" alt="#stText.ext.extThumbnail#"/>
						</cfif>
						
						<div class="caption">
							<p class="text-center"><b tutle="#data.label#"><a href="#link#" title="#stText.ext.viewdetails#">#cut(data.label,30)#</a></b></p>
							<p class="text-center"><a href="#link#" title="#stText.ext.viewdetails#"><span class="label #labelClass#">&nbsp; #iconText# &nbsp;</span></a>
							
							<span class="badge badge-inverse">v. #cut(data.version,6)#</span>
							<p>#cut(data.description,120)#</p>
							<cfif Len(data.category)>
								<p class="muted">#cut(data.category,30)#</p>	
							</cfif>
						</p>

							

						</div>
						
					</div>
				</li>

				<cfif itemcount MOD columns EQ 0>
					</ul>
					<ul class="thumbnails">
				</cfif>
				
				<!---
				<a href="#link#" class="thumbnail"  title="#stText.ext.viewdetails#">
      				<img data-src="holder.js/300x200" alt="">
    			</a>

				<div class="extensionthumb">
					<a href="#link#" title="#stText.ext.viewdetails#">
						<div class="extimg">
							<cfif len(dn)>
								<img src="#dn#" alt="#stText.ext.extThumbnail#" />
							</cfif>
						</div>
						<b title="#data.label#">#cut(data.label,30)#</b><br />
						#cut(data.category,30)#
					</a>
				</div>

				</li>
				--->
			<cfset itemcount++>
			</cfif>

			
		</cfoutput>

	</ul>

</cfif>


<cfscript>
	
	function isExetensionInstalled(extId){
		
		if(structKeyExists(MyExtensions, extId)){
			return true;
		}
		return false;
	}

</cfscript>

</cfoutput>

<!---

<cfif extensions.recordcount>
	<cfoutput>
		<!--- Installed Applications --->
		<h2>#stText.ext.installed#</h2>
		<div class="itemintro">#stText.ext.installeddesc#</div>

		<div class="filterform">
			<cfform onerror="customError" action="#request.self#?action=#url.action#" method="post">
				<ul>
					<li>
						<label for="filter">#stText.search.searchterm#:</label>
						<input type="text" name="filter" id="filter" class="txt" value="#session.extFilter.filter#" />
					</li>
					<li>
						<input type="submit" class="button submit btn btn-primary" name="mainAction" value="#stText.buttons.filter#" />
					</li>
				</ul>
				<div class="clear"></div>
			</cfform>
		</div>
		
		<div class="extensionlist">
			<cfloop query="extensions">
				<cfset uid=createId(extensions.provider,extensions.id)>
				<cfset existing[uid]=true>
				<cfif session.extFilter.filter neq "">
					<cftry>
						<cfset prov=getProviderData(extensions.provider)>
						<cfset provTitle=prov.info.title>
						<cfcatch>
							<cfset provTitle="">
						</cfcatch>
					</cftry>
				</cfif>
				
				<cfif 
				session.extFilter.filter eq ""
				or doFilter(session.extFilter.filter,extensions.label,false)
				or doFilter(session.extFilter.filter,extensions.category,false)
				or doFilter(session.extFilter.filter,provTitle,false)
				>
					<cfset link="#request.self#?action=#url.action#&action2=detail&uid=#uid#">
					<cfset dn=getDumpNail(extensions.image,130,50)>
					<cfset hasUpdate=updateAvailable(extensions)>
					<div class="extensionthumb">
						<a href="#link#" title="#stText.ext.viewdetails#">
							<div class="extimg">
								<cfif len(dn)>
									<img src="#dn#" alt="#stText.ext.extThumbnail#" />
								</cfif>
							</div>
							<b title="#extensions.label#">#cut(extensions.label,30)#</b><br />
							#cut(extensions.category,30)#
							<cfif hasUpdate>
								<br /><span class="CheckError">#stText.ext.updateavailable#</span>
							</cfif>
						</a>
					</div>
				</cfif>
			</cfloop>
			<div class="clear"></div>
		</div>
	</cfoutput>
</cfif>
--->
<!---  Not Installed Applications --->
<cfoutput>

<!---
<cfif isQuery(data)>
	<div class="extensionlist">
		<cfoutput query="data" group="uid">
			<cfset info=data.info>
			<cfif !StructKeyExists(existing,data.uid)
			and (data.type EQ "all" or data.type EQ request.adminType or (data.type EQ "" and "web" EQ request.adminType)) 
			and (
				session.extFilter.filter2 eq ""
				or doFilter(session.extFilter.filter2,data.label,false)
				or doFilter(session.extFilter.filter2,data.category,false)
				or doFilter(session.extFilter.filter2,info.title,false)
			)
			>
				<cfset link="#request.self#?action=#url.action#&action2=detail&uid=#data.uid#">
				<cfset dn=getDumpNail(data.image,130,50)>
				<div class="extensionthumb">
					<a href="#link#" title="#stText.ext.viewdetails#">
						<div class="extimg">
							<cfif len(dn)>
								<img src="#dn#" alt="#stText.ext.extThumbnail#" />
							</cfif>
						</div>
						<b title="#data.label#">#cut(data.label,30)#</b><br />
						#cut(data.category,30)#
					</a>
				</div>
			</cfif>
		</cfoutput>
		<div class="clear"></div>
	</div>
</cfif>
--->



	<h2>#stText.ext.notInstalled#</h2>
	<div class="itemintro">#stText.ext.notInstalleddesc#</div>

	<div class="filterform">
		<cfform onerror="customError" action="#request.self#?action=#url.action#" method="post">
			<ul>
				<li>
					<label for="filter2">#stText.search.searchterm#:</label>
					<input type="text" name="filter2" id="filter2" class="txt" value="#session.extFilter.filter2#" />
				</li>
				<li>
					<input type="submit" class="button submit btn btn-primary" name="mainAction" value="#stText.buttons.filter#" />
				</li>
			</ul>
			<div class="clear"></div>
		</cfform>
	</div>
</cfoutput>

<cfif isQuery(data)>
	<div class="extensionlist">
		<cfoutput query="data" group="uid">
			<cfset info=data.info>
			<cfif !StructKeyExists(existing,data.uid)
			and (data.type EQ "all" or data.type EQ request.adminType or (data.type EQ "" and "web" EQ request.adminType)) 
			and (
				session.extFilter.filter2 eq ""
				or doFilter(session.extFilter.filter2,data.label,false)
				or doFilter(session.extFilter.filter2,data.category,false)
				or doFilter(session.extFilter.filter2,info.title,false)
			)
			>
				<cfset link="#request.self#?action=#url.action#&action2=detail&uid=#data.uid#">
				<cfset dn=getDumpNail(data.image,130,50)>
				<div class="extensionthumb">
					<a href="#link#" title="#stText.ext.viewdetails#">
						<div class="extimg">
							<cfif len(dn)>
								<img src="#dn#" alt="#stText.ext.extThumbnail#" />
							</cfif>
						</div>
						<b title="#data.label#">#cut(data.label,30)#</b><br />
						#cut(data.category,30)#
					</a>
				</div>
			</cfif>
		</cfoutput>
		<div class="clear"></div>
	</div>
</cfif>

<!--- upload own extension --->
<cfoutput>
	<h2>#stText.ext.uploadExtension# (experimental)</h2>
	<div class="itemintro">#stText.ext.uploadExtensionDesc#</div>
	<cfif structKeyExists(url, 'noextfile')>
		<div class="error">
			#stText.ext.nofileuploaded#
		</div>
	</cfif>
	<cfif structKeyExists(url, 'addedRe')>
		<div class="error">
			Deployed Railo Extension, see deploy.log for details.
		</div>
	</cfif>
	<cfform onerror="customError" action="#request.self#?action=#url.action#&action2=upload" method="post" enctype="multipart/form-data">
		<input type="hidden" name="mainAction" value="uploadExt" />
		<table class="tbl maintbl">
			<tbody>
				<tr>
					<th scope="row">#stText.ext.extzipfile#</th>
					<td><input type="file" class="txt file" name="extfile" id="extfile" /></td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<td>&nbsp;</td>
					<td>
						<input type="submit" class="button submit btn btn-primary" value="#stText.ext.upload#" />
					</td>
				</tr>
			</tfoot>
		</table>
	</cfform>
</cfoutput>