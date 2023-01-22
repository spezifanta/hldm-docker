
![Half-Life](/media/banner.jpg)

# Half-Life Deathmatch Server as Docker image

Probably the fastest and easiest way to set up an old-school Half-Life Deathmatch Dedicated Server (HLDS).
You don't need to know anything about Linux or HLDS to start a server. You just need Docker and this image.

## Quick Start

Start a new server by running:
```
docker run -it --rm -d -p27015:27015 -p27015:27015/udp spezifanta/hldm
```

Change the player slot size, map or `rcon_password` by running:
```
docker run -it --rm -d --name hldm -p27015:27015 -p27015:27015/udp spezifanta/hldm +map crossfire +maxplayers 12 +rcon_password SECRET_PASSWORD
```

> **Note:** Any [server config command](http://sr-team.clan.su/K_stat/hlcommandsfull.html) can be passed by using `+`. But it has to follow after the image name `spezifanta/hldm`.


The following default maps are available:
 - boot_camp
 - bounce
 - crossfire
 - datacore
 - frenzy
 - gasworks
 - lambda_bunker
 - rapidcore
 - snark_pit
 - stalkyard
 - subtransit
 - undertow


## Advanced

In order to use custom content like maps or server config file, create a directory named `deploy` and a subdirectory `copy-gamedir` and place your files there.
For an example of a custom `server.cfg` run:

```
mkdir -p deploy/copy-gamedir && echo 'echo "Executing custom server.cfg"' > deploy/copy-gamedir/server.cfg
```

Add your settings to the `server.cfg` and mount the directory as volume by running:

```
docker run -it --rm -d -p27015:27015 -p27015:27015/udp -v ${PWD}/deploy:/deploy spezifanta/hldm
```

You should see `Executing custom server.cfg` in the server log when starting the server.

You can add more content by creating the following directories under `deploy`:

 - `install-assets`: You can put archive files here to be extracted into the root game directory (`valve`).
 - `install-maps`: Put archive files or BSP, RES files here to be deployed into the `maps` subdirectory.
 - `copy-gamedir`: The entire directory structure will be copied verbatim into the root game directory.

The following archive formats are supported: `zip`, `7z`, `rar`, `tar`, `gzip`, `bzip2`, `xz`, `zstd`, `arj`. To remove content, you can simply remove the files from `deploy` and then recreate your container.


## About this Docker image

This image uses the latest version of [Half-life](https://store.steampowered.com/app/70/HalfLife), which can be installed via [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD)
and patched versions of:

 - [Metamod v1.20](http://metamod.org/)
 - [Stripper2 v1.0.0](http://hpb-bot.bots-united.com/stripper2.html)

 Patches: https://github.com/spezifanta/metamod-p


## But why?

### Speed

Setting up a new HLDS from scratch can be a bit tedious because since a few years now SteamCMD will fail to download all the files on the first try.
The general workaround is just by retrying. And retrying, and retrying, and... :gun:. A more promising workaround is replacing certain files and forcing a redownload. But even this can fail sometimes.
Anyway, just searching for the download link of SteamCMD takes longer than just copying & pasting the Docker `run` command from above (yes, this assumes you have Docker installed. But why haven't you already?).

Also, there are a couple of server commands, which need tweaking, and plugins, that need to be installed and configured.


So this image saves a lot of time.


### Sustainability

Half-Life is more than 20 years old now. Many major community pages and tutorials are offline. I am not saying, that Half-Life will die, but the sites with the step by step instructions, workarounds and plugins might not be around for ever.
Furthermore not everybody, who likes playing Half-Life and wants to set up a server, is a Linux geek. You don't need to know anything about Linux or HLDS to start a server by using this image.
That's why I build this image.

I want HLDM to live forever!


### Other reasons

- In most cases, you have to wrap `hlds_run` anyway by using something like `screen`, `tmux`, `wmux` or `systemd`, because the server will exit as soon as you close your terminal. So why not add Docker to that list.
- Decoupling. To set up a HLDS you need to install 32bit libraries. On a 64bit system, this is somewhat less than perfect. On a company PC, you might need extra permissions to do so. With Docker on the other hand... I hope you get my point ;).
- Scalability.


## License

MIT

## Test Server

Connect to `steamcalculator.com:27015` to give it a try.

<a href="https://www.youtube.com/watch?v=y15dfBZSx9Q" target="_blank">
<img src="/media/github-video.jpg" alt="HLDM Docker"/>
</a>
