# Architecture

## Explanation
balenaSound bases on balenaCloud and its features. balenaCloud gives the OS/Code updates and a API for interacting out of the container.

## Containers
Every service runs in a seperate docker container. Since it runs on docker every os can be used. This allows us to use lots of projects made for Linux. 

## The projects used

Our project bases on lots of projects (All made for Linux):

* Bluez (Bluetooth): http://www.bluez.org/
* Raspotify (Spotify): https://github.com/dtcooper/raspotify
* Librespot (Base for raspotify): https://github.com/librespot-org/librespot
* shairport-sync (Airplay): https://github.com/mikebrady/shairport-sync
* Snapcast (Multiroom): https://github.com/badaix/snapcast
