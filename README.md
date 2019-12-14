# LSK_Prototype
Japanese "LSK" prototype for DLIFLC - Older iOS7 app in Obj-C

"Language Survival Kits" are a set of ~4000 audio files with native-language text and transliterations, designed to be used by U.S. gov't personnel overseas.
There are several "modules" based on specific topics, with English and target-language audio for each phrase.
Each kit is recorded and produced by the Defense Language Institute Foreign Language Center in Monterey, CA. 

This was a personal project from when I first started iOS development and programming in general, and was working as a multimedia specialist for DLIFLC. 
This was based on a web-based Flash product in use at the time.
I also recorded, edited, and processed the Japanese-language audio (spoken by native speakers), and assisted with production and proofing of the text. 

I built the app from scratch in Obj-C. It's not "production" code by any means, but it still compiles and runs.

It uses DLIFLC's (public domain) text and mp3 audio files, which I trimmed and shrank with ffmpeg for a smaller overall package size. 
It uses the AVAudioPlayer and AVAudioSession to play back audio. 
The UI was designed solely for iPhone, targeting iOS7, and uses AutoLayout, which was fairly new at the time.

All the phrase data and file info is stored in XML files, a legacy from the Flash days. 
I had planned to convert it to use CoreData, among other things.
I instead moved on to other work tasks, got married, moved to 4 different states, and began pursuing a 2nd BS in Computer Science, which I intend to complete by ~Sept 2021.
