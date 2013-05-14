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

div.classpaths {
	font-family:"Courier New",Courier,monospace;
	font-size: 10px;
	overflow:auto;
	max-height:100px;
	border:1px solid #333;
}


/* percentage bars: <div class="percentagebar"><div style="width:60%"></div></div> */
div.percentagebar {
	height:13px;
	font-size: 10px;
	border:1px solid #999;
	background-color: #d6eed4;
	position: relative;
}
div.percentagebar div {
	height:100%;
	overflow:hidden;
	font-size: 10px;
	background-color:#eee2d4;
	border-right:1px solid #999;
	padding-left:2px;
}
div.percentagebar span {
	position: absolute;
	top:0px;
	left:3px;
	height:100%;
	font-size: 10px;
}
}

div.percentagebar span {
	position: absolute;
 	top:0px;
 	left:3px;
 	height:100%;
 	font-size: 10px;
}

/*
Sign in form
*/
.form-signin {
        max-width: 300px;
        padding: 19px 29px 29px;
        margin: 0 auto 20px;
        background-color: #fff;
        border: 1px solid #e5e5e5;
        -webkit-border-radius: 5px;
           -moz-border-radius: 5px;
                border-radius: 5px;
        -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.05);
           -moz-box-shadow: 0 1px 2px rgba(0,0,0,.05);
                box-shadow: 0 1px 2px rgba(0,0,0,.05);
      }
      .form-signin .form-signin-heading,
      .form-signin .checkbox {
        margin-bottom: 10px;
      }
      .form-signin input[type="text"],
      .form-signin input[type="password"] {
        font-size: 16px;
        height: auto;
        margin-bottom: 15px;
        padding: 7px 9px;
      }

.footer {
	text-align: center;
	padding: 30px 0;
	margin-top: 50px;
	border-top: 1px solid #e5e5e5;
	background-color: #f5f5f5;
}

/* 
	TABLES
*/


/* tables */
table {empty-cells:show;}
td, th {
	padding:3px;
	vertical-align:top;
}
th {/* like .tblHead */
	background-color:#f2f2f2;
	color:#3c3e40;
	font-weight:normal;
	text-align:left;
}
table.nospacing {
	border-collapse:collapse;
}
/*.tblHead{padding-left:5px;padding-right:5px;border:1px solid #e0e0e0;background-color:#f2f2f2;color:#3c3e40}
.tblContent			{padding-left:5px;padding-right:5px;border:1px solid #e0e0e0;}
*/
tr.OK td {background-color:#e0f3e6;}
tr.notOK td {background-color:#f9e0e0;}
.tblContentRed		{padding-left:5px;padding-right:5px;border:1px solid #cc0000;color:red}
.tblContentGreen	{padding-left:5px;padding-right:5px;border:1px solid #009933;}
.tblContentYellow	{padding-left:5px;padding-right:5px;border:1px solid #ccad00;background-color:#fff9da;}
/* tables */
.maintbl {
	width:100%;
}
.maintbl + .maintbl {
	margin-top: 15px;
}
.autowidth {
	width: auto;
}
.maintbl td, .maintbl th {
	padding: 3px 5px;
	font-weight:normal;
	empty-cells:show;
	border:1px solid #e0e0e0;
}
.longwords {
	word-break:break-all;
}
.maintbl th {
	text-align:left;
}
.maintbl > tbody > tr > th {/* like .tblHead */
	width: 30%;
}
.maintbl tfoot td {
	border:none;
}
td.fieldPadded {
	padding-top:10px;
	padding-bottom:10px;
}
