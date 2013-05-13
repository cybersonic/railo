<cfsetting showdebugoutput="no">
<cfsilent>
		
	<cfapplication name='__RAILO_STATIC_CONTENT' sessionmanagement='#false#' clientmanagement='#false#' applicationtimeout='#createtimespan( 1, 0, 0, 0 )#'>
	
	<cfset mimetype = "text/css" />
	<cfset etag = hash( getCurrentTemplatePath() & '-' & Server.Railo.Version ) />

	<cfheader name='Expires' value='#getHttpTimeString( now() + 100 )#'>
	<cfheader name='Cache-Control' value='max-age=#86400 * 100#'>		
	<cfheader name='ETag' value='#etag#'>
	
	<cfif len( CGI.HTTP_IF_NONE_MATCH ) && ( CGI.HTTP_IF_NONE_MATCH == '#etag#' )>

		<!--- etag matches, return 304 !--->
		<cfheader statuscode='304' statustext='Not Modified'>
		<cfcontent reset='#true#' type='#mimetype#'><cfabort>
	</cfif>
	
	<!--- file was not cached; send the data --->
	<cfcontent reset="yes" type="#mimetype#" />
	
	<!--- PK: this style tag is here, so my editor color-codes the content underneath. (it won't get outputted) --->
	<style type="text/css">
	
</cfsilent><!---

--->
/* favorites in main title bar */
#favorites {
	float:right;
	width: 100px;
	height: 29px;
	margin: 0px;
	border-left:1px solid #cdcdcd;
	text-align:left;
}
#favorites:hover, #favorites:hover ul {
	display: block;
	background-color: #ddd;
}
#favorites ul {
	display: none;
	border:1px solid #cdcdcd;
	width:200px;
	position: absolute;
	z-index: 2;
	background-color: #e6e6e6;
	margin: 0px 75px 0 -101px;
	padding: 0px;
	text-align: left;
	border-radius: 0px 0px 5px 5px;
	overflow: hidden;
}
#favorites li {
	list-style: none;
	border-top: 1px solid #ccc;
	padding: 0;
	margin: 0;
}
#favorites li:first-child {
	border-top: 0px;
}
#favorites li.favtext {
	padding: 5px;
}
#favorites li.favorite a {
	background:url(../img/star_icon_small.png.cfm) no-repeat 6px;
	padding: 10px 5px 10px 22px;
	display: block;
}
#favorites li.favorite a:hover {
	background-color: #ccc;
}
#favorites > a {
	height:29px;
	z-index:3;
	background:url(../img/star_icon.png.cfm) no-repeat 13px;
	padding-left: 35px;
	display: block;
	line-height: 29px;
}
#favorites > a.favorite_inactive {
	background-image: url(../img/star_icon_grey.png.cfm);
}

.footer {
	text-align: center;
	padding: 30px 0;
	margin-top: 50px;
	border-top: 1px solid #e5e5e5;
	background-color: #f5f5f5;
}