#!/bin/bash

WIKI_RELEASE=1_34

# Get extensions.... somewhere.
# Extension list: BlockAndNuke, VoteNY, SocialProfile, SocialProfile/UserWelcome, WikiTextLoggedInOut, BlogPage, CategoryTree, CharInsert, Comments, Cite, CiteThisPage, WikiEditor, CodeEditor, CodeMirror, ConfirmEdit, DisqusTag, EmbedVideo, Gadgets, Widgets, ImageMap, InputBox, Interwiki, Math, Nuke, ParserFunctions, PdfHandler, Poem, Renameuser, SyntaxHighlight_GeSHi, Scribunto, SimpleMathJax, Tabber, UploadWizard, UserMerge, ConfirmAccount, UniversalLanguageSelector, NativeSvgHandler, ReplaceText, LinkSuggest, YouTube

mkdir -p addons
pushd addons

MW_EXTENSIONS="BlockAndNuke VoteNY SocialProfile WikiTextLoggedInOut BlogPage CategoryTree CharInsert Comments Cite CiteThisPage WikiEditor CodeEditor CodeMirror ConfirmEdit DisqusTag Gadgets Widgets ImageMap InputBox Interwiki Math Nuke ParserFunctions PdfHandler Poem Renameuser SyntaxHighlight_GeSHi Scribunto Tabber UploadWizard UserMerge ConfirmAccount UniversalLanguageSelector ReplaceText LinkSuggest YouTube JsonConfig Graph ImportArticles DeleteBatch PhpTags PhpTagsFunctions PhpTagsWiki"

mkdir -p extensions;
pushd extensions;
echo "Downloading extensions!"
for MW in ${MW_EXTENSIONS}
do
    echo "Downloading ${MW}"
    [ -e ${MW} ] || git clone https://github.com/wikimedia/mediawiki-extensions-${MW}.git ${MW} -b REL${WIKI_RELEASE}
done
[ -e NativeSvgHandler ] || git clone https://github.com/wikimedia/mediawiki-extensions-NativeSvgHandler.git NativeSvgHandler
[ -e EmbedVideo ] || git clone https://gitlab.com/hydrawiki/extensions/EmbedVideo.git ; \
[ -e SimpleMathJax ] || git clone https://github.com/jmnote/SimpleMathJax.git ; \
[ -e 3DAlloy ] || git clone https://github.com/dolfinus/3DAlloy
popd ;

MW_SKINS="Vector Timeless Metrolook"

mkdir -p skins;
pushd skins;
echo "Downloading skins!"
for MW in ${MW_SKINS}
do
    [ -e ${MW} ] || git clone https://github.com/wikimedia/mediawiki-skins-${MW}.git ${MW} -b REL${WIKI_RELEASE}; \
done
[ -e Tweeki ] || git clone https://github.com/thaider/Tweeki.git ; \
[ -e foreground ] || git clone https://github.com/jthingelstad/foreground.git ; \
[ -e chameleon ] || git clone https://github.com/cmln/chameleon.git ; \
[ -e pivot ] || git clone https://github.com/Hutchy68/pivot.git ;
popd ;

popd
