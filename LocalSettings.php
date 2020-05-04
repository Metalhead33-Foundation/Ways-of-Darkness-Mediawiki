<?php
# This file was automatically generated by the MediaWiki 1.30.0
# installer. If you make manual changes, please keep track in case you
# need to recreate them later.
#
# See includes/DefaultSettings.php for all configurable settings
# and their default values, but don't forget to make changes in _this_
# file, not there.
#
# Further documentation for configuration settings may be found at:
# https://www.mediawiki.org/wiki/Manual:Configuration_settings

# Protect against web entry
if ( !defined( 'MEDIAWIKI' ) ) {
	exit;
}

## Uncomment this to disable output compression
# $wgDisableOutputCompression = true;

$wgSitename = "Ways of Darkness";
$wgMetaNamespace = "Ways_of_Darkness";

## The URL base path to the directory containing the wiki;
## defaults for all runtime URL paths are based off of this.
## For more information on customizing the URLs
## (like /w/index.php/Page_title to /wiki/Page_title) please see:
## https://www.mediawiki.org/wiki/Manual:Short_URL
$wgFileExtensions = array( 'png', 'gif', 'jpg', 'jpeg', 'txt', 'obj', 'json',
    'xls', 'mpp', 'pdf', 'ppt', 'tiff', 'ogg', 'svg', 'svgz',
    'woff', 'eot', 'woff2', 'ico', 'json'
);
$wgScriptPath = "";
$wgArticlePath = "/$1";
$wgUserPathInfo = true;
$wgScriptExtension = ".php";

## The protocol and server name to use in fully-qualified URLs
$wgServer = $_ENV['MW_SITE'];

## The URL path to static resources (images, scripts, etc.)
$wgResourceBasePath = $wgScriptPath;

## The URL path to the logo.  Make sure you change this from the default,
## or else you'll overwrite your logo when you upgrade!
# $wgLogo = "$wgResourceBasePath/resources/assets/wiki.png";
$wgLogo = "$wgScriptPath/images/1/1c/WoD_logo.png";
$wgFavicon = "$wgScriptPath/images/6/64/Favicon.ico";

## UPO means: this is also a user preference option

$wgEnableEmail = true;
$wgEnableUserEmail = true; # UPO

$wgEmergencyContact = "info@ways-of-darkness.sonck.nl";
$wgPasswordSender = "info@ways-of-darkness.sonck.nl";

$wgEnotifUserTalk = false; # UPO
$wgEnotifWatchlist = false; # UPO
$wgEmailAuthentication = true;

## Database settings
require('/vault/secrets/db-creds.php');

## Shared memory settings
$wgMainCacheType = CACHE_ACCEL;
$wgMemCachedServers = [];

## To enable image uploads, make sure the 'images' directory
## is writable, then set this to true:
$wgEnableUploads = true;
$wgUseImageMagick = true;
$wgImageMagickConvertCommand = "/usr/bin/convert";

# InstantCommons allows wiki to use images from https://commons.wikimedia.org
$wgUseInstantCommons = false;

# Periodically send a pingback to https://www.mediawiki.org/ with basic data
# about this MediaWiki instance. The Wikimedia Foundation shares this data
# with MediaWiki developers to help guide future development efforts.
$wgPingback = true;

## If you use ImageMagick (or any other shell command) on a
## Linux server, this will need to be set to the name of an
## available UTF-8 locale
$wgShellLocale = "en_US.utf8";

## Set $wgCacheDirectory to a writable directory on the web server
## to make your wiki go slightly faster. The directory should not
## be publically accessible from the web.
#$wgCacheDirectory = "$IP/cache";

# Site language code, should be one of the list in ./languages/data/Names.php
$wgLanguageCode = "en";

$wgSecretKey = $_ENV["MW_SECRETKEY"];

# Changing this will log out all existing sessions.
$wgAuthenticationTokenVersion = "1";

# Site upgrade key. Must be set to a string (default provided) to turn on the
# web installer while LocalSettings.php is in place
$wgUpgradeKey = $_ENV["MW_UPGRADEKEY"];

## For attaching licensing metadata to pages, and displaying an
## appropriate copyright notice / icon. GNU Free Documentation
## License and Creative Commons licenses are supported so far.
$wgRightsPage = ""; # Set to the title of a wiki page that describes your license/copyright
$wgRightsUrl = "";
$wgRightsText = "";
$wgRightsIcon = "";

# Path to the GNU diff3 utility. Used for conflict resolution.
$wgDiff3 = "/usr/bin/diff3";

# The following permissions were set based on your choice in the installer
$wgGroupPermissions['*']['createaccount'] = false;
$wgGroupPermissions['*']['edit'] = false;

$wgInterwikiMagic = true;
$wgNamespacesWithSubpages[NS_MAIN] = true;
$wgNamespacesWithSubpages[NS_TEMPLATE] = true;
// Define constants for my additional namespaces.
define("NS_TROPES", 3000); // This MUST be even.
define("NS_TROPES_TALK", 3001); // This MUST be the following odd integer.
define("NS_QUOTES", 3002);
define("NS_QUOTES_TALK", 3003);
define("NS_MEMES", 3004);
define("NS_MEMES_TALK", 3005);
define("NS_META", 3006);
define("NS_META_TALK", 3007);
define("NS_RPG", 3008);
define("NS_RPG_TALK", 3009);
define("NS_RECAP", 3008);
define("NS_RECAP_TALK", 3009);
// Add namespaces.
$wgExtraNamespaces[NS_TROPES] = "Tropes";
$wgExtraNamespaces[NS_TROPES_TALK] = "Tropes_talk";
$wgNamespacesWithSubpages[NS_TROPES] = true;
$wgContentNamespaces[] = NS_TROPES;
$wgExtraNamespaces[NS_QUOTES] = "Quotes";
$wgExtraNamespaces[NS_QUOTES_TALK] = "Quotes_talk";
$wgNamespacesWithSubpages[NS_QUOTES] = true;
$wgContentNamespaces[] = NS_QUOTES;
$wgExtraNamespaces[NS_MEMES] = "Memes";
$wgExtraNamespaces[NS_MEMES_TALK] = "Memes_talk";
$wgNamespacesWithSubpages[NS_MEMES] = true;
$wgContentNamespaces[] = NS_MEMES;
$wgExtraNamespaces[NS_META] = "Meta";
$wgExtraNamespaces[NS_META_TALK] = "Meta_talk";
$wgNamespacesWithSubpages[NS_META] = true;
$wgContentNamespaces[] = NS_META;
$wgExtraNamespaces[NS_RPG] = "RPG";
$wgExtraNamespaces[NS_RPG_TALK] = "RPG_talk";
$wgNamespacesWithSubpages[NS_RPG] = true;
$wgContentNamespaces[] = NS_RPG;
$wgExtraNamespaces[NS_RECAP] = "Recap";
$wgExtraNamespaces[NS_RECAP_TALK] = "Recap_talk";
$wgNamespacesWithSubpages[NS_RECAP] = true;
$wgContentNamespaces[] = NS_RECAP;

## Default skin: you can change the default skin. Use the internal symbolic
## names, ie 'vector', 'monobook':

# Enabled skins.
# The following skins were automatically enabled:
#wfLoadExtension( 'TemplateStyles' );
#wfLoadExtension( 'TemplateData' );
wfLoadSkin( 'Vector' );
$wgVectorResponsive = true;
$wgDefaultSkin = "Vector";
$wgVectorUseSimpleSearch = true;
$wgVectorUseIconWatch = true;

wfLoadExtension( 'JsonConfig' );
wfLoadExtension( 'Graph' );
wfLoadExtension( 'ImportArticles' );
# End of automatically generated settings.
# Add more configuration options below.
$wgAllowUserJs = true;
wfLoadExtension( 'DeleteBatch' );
$wgGroupPermissions['bureaucrat']['deletebatch'] = false;
$wgGroupPermissions['sysop']['deletebatch'] = true;
$wgGroupPermissions['bureaucrat']['editinterface'] = true;
$wgGroupPermissions['sysop']['editinterface'] = true;
$wgGroupPermissions['bureaucrat']['editsitecss'] = true;
$wgGroupPermissions['sysop']['editsitecss'] = true;
$wgGroupPermissions['bureaucrat']['editsitejs'] = true;
$wgGroupPermissions['sysop']['editsitejs'] = true;
$wgGroupPermissions['bureaucrat']['editsitejson'] = true;
$wgGroupPermissions['sysop']['editsitejson'] = true;
wfLoadExtension( 'BlockAndNuke' );
wfLoadExtension( 'VoteNY' );
require_once "$IP/extensions/SocialProfile/SocialProfile.php";
wfLoadExtension( 'SocialProfile/UserWelcome' );
wfLoadExtension( 'WikiTextLoggedInOut' );
wfLoadExtension( 'BlogPage' );
wfLoadExtension( 'CategoryTree' );
wfLoadExtension( 'CharInsert' );
$wgGroupPermissions['sysop']['checkuser'] = true;
$wgGroupPermissions['sysop']['checkuser-log'] = true;
wfLoadExtension( 'Cite' );
wfLoadExtension( 'CiteThisPage' );
wfLoadExtension( 'WikiEditor' );
wfLoadExtension( 'CodeEditor' );
$wgDefaultUserOptions['usebetatoolbar'] = 1; // user option provided by WikiEditor extension
wfLoadExtension( 'CodeMirror' );
$wgDefaultUserOptions['usecodemirror'] = 1;
wfLoadExtension( 'ConfirmEdit' );
$wgCaptchaClass = 'SimpleCaptcha';
# DISQUS WON'T WORK!
wfLoadExtension( 'DisqusTag' );
$wgDisqusShortname = 'waysofdarkness';
# Echo don't work either!
$wgPageDisqusShortname = "waysofdarkness";
$wgPageDisqusExclude = array("Main Page", ".+:.+");
wfLoadExtension( 'EmbedVideo' );
wfLoadExtension( 'Gadgets' );
require_once "$IP/extensions/Widgets/Widgets.php";
wfLoadExtension( 'ImageMap' );
wfLoadExtension( 'InputBox' );
wfLoadExtension( 'Interwiki' );
$wgGroupPermissions['sysop']['interwiki'] = true;
wfLoadExtension( 'Math' );
$wgDefaultUserOptions['math'] = 'mathml';
$wgMathFullRestbaseURL = 'https://en.wikipedia.org/api/rest_';
$wgMathMathMLUrl = 'https://mathoid-beta.wmflabs.org/';
$wgEmailFrom ="info@ways-of-darkness.sonck.nl";
 $wgSendNewArticleToFriends=false;
$wgGroupPermissions['sysop']['moderation'] = true; # Allow sysops to use Special:Moderation
$wgGroupPermissions['sysop']['skip-moderation'] = true; # Allow sysops to skip moderation
$wgGroupPermissions['bot']['skip-moderation'] = true; # Allow bots to skip moderation
$wgLogRestrictions["newusers"] = 'moderation';
wfLoadExtension( 'Nuke' );
wfLoadExtension( 'ParserFunctions' );
wfLoadExtension( 'PdfHandler' );
wfLoadExtension( 'Poem' );
wfLoadExtension( 'Renameuser' );
$wgGroupPermissions['sysop']['renameuser'] = true;
wfLoadExtension( 'SyntaxHighlight_GeSHi' );
wfLoadExtension( 'Scribunto' );
$wgScribuntoDefaultEngine = 'luasandbox';
#$wgScribuntoEngineConf['luastandalone']['luaPath'] = '/usr/bin/luajit'
$wgScribuntoUseGeSHi = true;
$wgScribuntoUseCodeEditor = true;
wfLoadExtension( 'SimpleMathJax' );
wfLoadExtension( 'Tabber' );
wfLoadExtension( 'UploadWizard' );
// Needed to make UploadWizard work in IE, see https://phabricator.wikimedia.org/T41877
 $wgApiFrameOptions = 'SAMEORIGIN';
wfLoadExtension( 'UserMerge' );
// By default nobody can use this function, enable for bureaucrat?
$wgGroupPermissions['sysop']['confirmaccount'] = true;
$wgGroupPermissions['sysop']['usermerge'] = true;
$wgGroupPermissions['bureaucrat']['usermerge'] = true;

//
// optional: default is array( 'sysop' )
 $wgUserMergeProtectedGroups = array( 'groupname' );
require_once "$IP/extensions/ConfirmAccount/ConfirmAccount.php";
$wgConfirmAccountContact = $_ENV["MW_CONFIRMACCOUNT"];
$wgShowExceptionDetails = true;
$wgShowDBErrorBacktrace = true;
wfLoadExtension( 'UniversalLanguageSelector' );
// Other stuff
$wgPFEnableStringFunctions = true;
$wgUseInstantCommons = true;
$wgUseTidy=true;
wfLoadExtension('NativeSvgHandler');
$wgDefaultUserOptions['wikieditor-preview'] = 1;
$wgDefaultUserOptions['wikieditor-publish'] = 1;
$wgAllowDisplayTitle = true;
$wgRestrictDisplayTitle = false;
$wgGroupPermissions['*']['edit'] = false;
$wgGroupPermissions['*']['createpage'] = false;
$wgShowIPinHeader = false;

$wgGroupPermissions['masseditregexeditor']['masseditregex'] = true;
$wgGroupPermissions['sysop']['masseditregex'] = true;
wfLoadExtension( 'ReplaceText' );
$wgGroupPermissions['bureaucrat']['replacetext'] = true;
$wgGroupPermissions['sysop']['replacetext'] = true;
$wgEmailFrom="info@ways-of-darkness.sonck.nl";
wfLoadExtension( 'LinkSuggest' );
wfLoadExtension( 'YouTube' );
wfLoadExtension( 'CommonsMetadata' );
wfLoadExtension( 'MultimediaViewer' );

# For compatibility with CloudFlare
$wgShowIPinHeader=false;
$wgDisableCounters=true;

$wgGroupPermissions['*']['upload'] = false;
$wgGroupPermissions['bureaucrat']['upload'] = true;
$wgGroupPermissions['sysop']['upload'] = true;
