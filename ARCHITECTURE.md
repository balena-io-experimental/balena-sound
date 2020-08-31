# Architecture

 Community contributions have been a staple of this open source project since it's inception. However, as balenaSound grew in features it also did in terms of complexity. It's currently a multi-container application with 4 core services and as many plugin services. This documentation section aims to provide an overview of how balenaSound is architectured with the intention of lowering the barrienr to entry for folks out there wanting to contribute. If you are interested in contributing and after reading this guide you still have questions please [reach out](docs/support#contact-us) and we'll gladly help you out.


## Overview

![](https://raw.githubusercontent.com/balenalabs/balena-sound/master/docs/images/arch-overview.png)

balenaSound services can be divided in three groups:
- Sound core: `sound-supervisor` and `audio`. 
- Multiroom: `multiroom-server` and `multiroom-client`
- Plugins: `spotify`, `airplay`, `bluetooth`, `upnp`


### Sound core

This is the heart of balenaSound, it contains the most important services: `sound-supervisor` and `audio`. 

**audio**
The `audio` block is a balena block that provides an easy way to work with audio applications in containerized environments such as balenaOS. You can read more about it [here](https://github.com/balenablocks/audio). In a nutshell, the `audio` block is the main "audio router". It connects to all audio sources and sinks and handles audio routing, which will change depending on the mode of operation (multi-room vs standalone), the output interface selected (onboard audio, HDMI, DAC, USB soundcard), etc. The `audio` block allows you to build complex audio applications such as balenaSound without having to deep dive into ALSA or PulseAudio configuration. One of the key features for balenaSound is that it allows us to define input and output audio layers and then do all the complex audio routing without knowing/caring about where the audio is being generated or where it should go to. The `audio routing` section belows covers this process in detail.


**sound-supervisor**
The `sound-supervisor` as it's name suggests, is the service that orchestrates all the others. It's not really involved in the audio routing but it does a few key things that enable the other services to be simpler. Here are some of the most important features of the `sound-supervisor`:
- **Multiroom events**: through the use of the [cotejs](https://github.com/dashersw/cote) library and interfacing with the `audio` block, the `sound-supervisor` ensures that all devices on the same local network agree on which is the `master` device. To achieve this, `sound-supervisor` services on different devices exchange event messages constantly.
- **API**: it creates a REST API on port 3000. The API allows other services to access current balenaSound configuration. This allows us to update configuration dynamically and have services react to it accordingly. As a general rule of thumb, if we are interested in service's configuration being able to be dynamically updated, they should rely on configuration reported by `sound-supervisor` and not on environment variables. At this moment, all services support this behaviour but their configuration is mostly static, you set it at startup via environment variables and that's it. However, there are *experimental* endpoints in the API to update configuration values and all services already support it. There's even a *secret* UI that allows for some configuration changes at runtime, it's located at `http://<DEVICE_IP>:3000/secret`.

### Multi-room

Multi-room services provide multiroom capabilities to balenaSound.

**multiroom-server**
This service runs a [Snapcast](https://github.com/badaix/snapcast) server which is responsible for broadcasting (and keeping it in sync) audio from the `audio` service into Snapcast clients. Clients can be running on the same device or on separate devices.

**multiroom-client**
Runs the client version of Snapcast. It needs to connect to a Snapcast server (can be a separate device) to receive audio packets. It will then forward the audio back into the `audio` service.

### Plugins

Plugins are the audio sources that generate the audio to be streamed/played. Refer to the plugins section below for pointers on how to add new plugins.

## Audio routing

Audio routing is the most cruicial part of balenaSound, it also changes significantly depending on what the current configuration is, with the biggest change being the mode of operation (multiroom vs standalone). The `audio` block is the key service we should be looking at, so let's zoom in. 

**Note**: audio routing relies mainly on routing PulseAudio sinks. [Here](https://gavv.github.io/articles/pulseaudio-under-the-hood/) is an awesome resource on PulseAudio in case you are not familiar with it.

### Input and output layers

One of the advantages of using the `audio` block is that, since it's based on PulseAudio, we can use all the audio processing tools and tricks that are widely available, in this particular case `virtual sinks`. PulseAudio clients can send audio to sinks; usually audio soundcards have a sink that represents them, so sending audio to the audio-jack sink will result in that audio coming out of the audio jack. Virtual sinks are virtual nodes that can be used to route audio in and out of them. 

For balenaSound we use two virtual sinks in order to simplify how audio is being routed:
- balena-sound.input
- balena-sound.output

Creation and configuration scripts for these virtual sinks are located at `core/audio/balena-sound.pa` and `core/audio/start.sh`

**balena-sound.input**
`balena-sound.input` acts as an input audio multiplexer/mixer. It's the default sink on balenaSound, so all plugins that send audio to the `audio` block will send it to this sink by default. This allows us to route audio internally without worring where it came from: any audio generated by a plugin will pass through the `balena-sound.input` sink, so controlling where it sends its audio we are effectively controlling all plugins at the same time. 

**balena-sound.output**
`balena-sound.output` on the other hand is the output audio multiplexer/mixer. This one is pretty useful in scenarios where there are multiple soundcards available (onboard, DAC, USB, etc). `balena-sound.output` is always wired to whatever the desired soundcard sink is. So even if we dynamically change the output selection, sending audio to `balena-sound.output` will always result in audio going to the current selection. Again, this is useful to route audio internally without worrying about user selection at runtime.


### Multiroom
![](https://raw.githubusercontent.com/balenalabs/balena-sound/master/docs/images/arch-multiroom.png)



### Standalone
![](https://raw.githubusercontent.com/balenalabs/balena-sound/master/docs/images/arch-standalone.png)

## Plugins


```
# Audio block setup
ENV PULSE_SERVER=tcp:localhost:4317
RUN curl -sL https://raw.githubusercontent.com/balena-io-playground/audio-primitive/master/scripts/alsa-bridge/debian-setup.sh | sh
```