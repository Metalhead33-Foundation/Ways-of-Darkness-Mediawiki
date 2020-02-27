Ways of Darkness Wiki
=====================
![build status](https://bamboo.touhou.fm/plugins/servlet/wittified/build-status/WOD-MW)
![production status](https://bamboo.touhou.fm/plugins/servlet/wittified/deploy-status/39485441)

This project builds the mediawiki docker for [Ways of Darkness](https://ways-of-darkness.sonck.nl/)

## How to build

```bash
git clone https://bitbucket.touhou.fm/scm/wod/mediawiki.git
cd mediawiki
./fetch-git.sh
docker build -t wiki
```

## Running
The docker expects a few environment variables to be set:

| Variable | Description | Example |
| ------------- | ------------------- | --- |
| POSTGRES_HOST | Database host | localhost |
| POSTGRES_PORT | Database port | 5432 |
| POSTGRES_USER | Database user | mediawiki |
| POSTGRES_NAME | Database name | mediawiki |
| POSTGRES_PASSWORD | Database password | H4ckM319 |
| MW_SITE | MediaWiki root URL | https://www.ways-of-darkness.com |
| MW_SECRETKEY | MediaWiki $wgSecretKey | anlksdnlkaieoj09255qjgaavn309qv |
| MW_UPGRADEKEY | MediaWiki $wgUpgradeKey | qf9009q0329rj |
| MW_CONFIRMACCOUNT | Email address receiving account approval requests | hr@example.com |