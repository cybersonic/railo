<cfparam name="cookie.railo_admin_lang" default="en">
<cfset session.railo_admin_lang = cookie.railo_admin_lang>
<cfparam name="languages" default="#{en:'English',de:'Deutsch'}#">

<cfoutput>
	
	<cfform name="login" action="#request.self#" method="post" class="form-signin"><!--- onerror="customError"--->
		<h2 class="form-signin-heading">New Password</h2>
		
		<!--- Password  --->
		<cfinput type="password" name="new_password" value="" passthrough='autocomplete="off"'
			class="xlarge" required="yes" message="#stText.Login.PasswordMissing#" placeholder="#stText.Login.Password#" />
		
		<!--- Password Confirm --->
		<cfinput type="password" name="new_password_re" value="" passthrough='autocomplete="off"'
			class="xlarge" required="yes" message="#stText.Login.RetypePasswordMissing#" placeholder="#stText.Login.RetypePassword#" />
				
		<!--- Language  --->
		<div>
		 <label>#stText.Login.language# </label>
			<cfset aLangKeys = structKeyArray(languages)>
			<cfset arraySort(aLangKeys, "text")>

			<select name="lang" class="medium">
				<cfloop from="1" to="#arrayLen(aLangKeys)#" index="iKey">
					<cfset key = aLangKeys[iKey]>
					<option value="#key#" <cfif key EQ session.railo_admin_lang>selected</cfif>>#languages[key]#</option>
				</cfloop>
			</select>
		</div>

		<!--- RememberMe --->
		<label>#stText.Login.rememberMe#</label>
	
			<select name="rememberMe" class="medium">
				<cfloop list="s,d,ww,m,yyyy" index="i">
					<option value="#i#"<cfif i eq form.rememberMe> selected</cfif>>#stText.Login[i]#</option>
				</cfloop>
			</select>
        </label>
		
		<div>
        <input class="button submit btn btn-large btn-primary" type="submit" name="submit" value="#stText.Buttons.Submit#">
		</div>
	</cfform>
</cfoutput>