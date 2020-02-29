#!/bin/bash

WIKI_RELEASE=1_34

# Get extensions.... somewhere.
# Extension list: BlockAndNuke, VoteNY, SocialProfile, SocialProfile/UserWelcome, WikiTextLoggedInOut, BlogPage, CategoryTree, CharInsert, Comments, Cite, CiteThisPage, WikiEditor, CodeEditor, CodeMirror, ConfirmEdit, DisqusTag, EmbedVideo, Gadgets, Widgets, ImageMap, InputBox, Interwiki, Math, Nuke, ParserFunctions, PdfHandler, Poem, Renameuser, SyntaxHighlight_GeSHi, Scribunto, SimpleMathJax, Tabber, UploadWizard, UserMerge, ConfirmAccount, UniversalLanguageSelector, NativeSvgHandler, ReplaceText, LinkSuggest, YouTube

MW_EXTENSIONS="BlockAndNuke VoteNY SocialProfile WikiTextLoggedInOut BlogPage CategoryTree CharInsert Comments Cite CiteThisPage WikiEditor CodeEditor CodeMirror ConfirmEdit DisqusTag Gadgets Widgets ImageMap InputBox Interwiki Math Nuke ParserFunctions PdfHandler Poem Renameuser SyntaxHighlight_GeSHi Scribunto Tabber UploadWizard UserMerge ConfirmAccount UniversalLanguageSelector ReplaceText LinkSuggest YouTube JsonConfig Graph ImportArticles DeleteBatch PhpTags PhpTagsFunctions PhpTagsWiki"

MW_SKINS="Vector Timeless Metrolook"

mkdir -p addons  || exit 1
pushd addons  || exit 1

mkdir -p extensions  || exit 1
pushd extensions  || exit 1
echo "Downloading extensions!"
for MW in ${MW_EXTENSIONS}
do
    echo "Downloading ${MW}"
    [ -e ${MW} ] || git clone --recursive https://github.com/wikimedia/mediawiki-extensions-${MW}.git ${MW} -b REL${WIKI_RELEASE} || exit 1
done
[ -e NativeSvgHandler ] || git clone --recursive https://github.com/wikimedia/mediawiki-extensions-NativeSvgHandler.git NativeSvgHandler || exit 1
[ -e EmbedVideo ] || git clone --recursive https://gitlab.com/hydrawiki/extensions/EmbedVideo.git || exit 1
[ -e SimpleMathJax ] || git clone --recursive https://github.com/jmnote/SimpleMathJax.git || exit 1
[ -e 3DAlloy ] || git clone --recursive https://github.com/dolfinus/3DAlloy || exit 1
pushd Widgets || exit 1
composer update --no-dev || exit 1
popd
popd

mkdir -p skins  || exit 1
pushd skins  || exit 1
echo "Downloading skins!"
for MW in ${MW_SKINS}
do
    [ -e ${MW} ] || git clone --recursive https://github.com/wikimedia/mediawiki-skins-${MW}.git ${MW} -b REL${WIKI_RELEASE} || exit 1
done
[ -e Tweeki ] || git clone --recursive https://github.com/thaider/Tweeki.git || exit 1
[ -e foreground ] || git  clone --recursive https://github.com/jthingelstad/foreground.git || exit 1
[ -e chameleon ] || git  clone --recursive https://github.com/cmln/chameleon.git || exit 1
[ -e pivot ] || git clone --recursive https://github.com/Hutchy68/pivot.git || exit 1
popd

popd
