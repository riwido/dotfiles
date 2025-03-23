#!/usr/bin/env python

import argparse
import pathlib
import re
import sys

from mutagen.id3 import ID3
from mutagen.id3 import TALB
from mutagen.id3 import TIT2
from mutagen.id3 import TPE1
from mutagen.id3 import TPE2
from mutagen.id3 import TPOS
from mutagen.id3 import TRCK
from mutagen.id3 import ID3NoHeaderError
from mutagen.mp4 import MP4
from mutagen.mp4 import MP4StreamInfoError

MP4_ALB = "©alb"
MP4_TIT = "©nam"
MP4_ART = "©ART"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("action", choices=actions)
    parser.add_argument("-d", "--directory")
    parser.add_argument("-f", "--file")
    parser.add_argument("-a", "--artist")
    parser.add_argument("-t", "--title")
    parser.add_argument("-l", "--album")
    parser.add_argument("-c", "--commit", action="store_true")
    args = parser.parse_args()
    sys.exit(bool(actions[args.action](args)))


def sub(string):
    if not string:
        return ""
    string = re.sub(r"[^-_\w ]", "", str(string))
    string = string.replace(" ", "_")
    return string


def get_info(args):
    if not args.directory:
        print("Requires directory")
    songs = pathlib.Path(args.directory).rglob("*.[mM][pP]3")
    for song in songs:
        try:
            mp3 = ID3(song)
            artist = mp3.get("TPE1")
            albumartist = mp3.get("TPE2")
            album = mp3.get("TALB")
            title = mp3.get("TIT2")
            print(f"{song}")
            print(f"{album}")
            print(f"{albumartist}")
            print(f"{artist} {title}")
            print()
        except ID3NoHeaderError:
            print(f"No tag: {song}\n")


def one_artist(args):
    if not args.directory:
        print("Requires directory")
        return 1
    if not args.artist:
        print("Requires artist")
        return 1
    songs = pathlib.Path(args.directory).glob("*.[mM][pP]3")
    print(f"new artist name: {args.artist}")
    for song in songs:
        mp3 = ID3(song)
        old = mp3.get("TPE1")
        print(f"old artist: {old}")
        print(mp3.values())
        if args.commit:
            mp3["TPE1"] = TPE1(encoding=0, text=[args.artist])
            mp3["TPE2"] = TPE1(encoding=0, text=[args.artist])
            mp3.save()
            song.rename(song.parent / new)


def fix_various_m4a(args):
    if not args.directory:
        print("Requires directory")
        return 1
    if not args.artist:
        print("Requires artist")
        return 1
    songs = pathlib.Path(args.directory).glob("*.[mM]4[aA]")
    print(f"new artist name: {args.artist}")
    for song in songs:
        try:
            mp4 = MP4(song)
        except MP4StreamInfoError:
            print("Not mp4 file?  Don't know what to do. continuing")
            continue
        artists = []
        albums = []
        titles = []

        for key, value in mp4.items():
            if re.match(r".(?:alb|nam|art)", key, flags=re.I):
                print(f"{key}: {value}")
                if "art" in key.lower():
                    artists.extend(mp4[key])
                    if args.commit:
                        mp4[key] = [args.artist]
                if "alb" in key.lower():
                    albums.extend(mp4[key])
                if "nam" in key.lower():
                    titles.extend(mp4[key])
        if args.commit:
            mp4.save()
        print(f"{','.join(artists)} {','.join(albums)} {','.join(titles)}")
        continue

        # artist = mp3.get('TPE1')
        # album = mp3.get('TALB')
        # title = mp3.get('TIT2')
        # track = str(mp3.get('TRCK')).split('/')[0]
        # prefix = ""
        # if track.isdigit():
        #     prefix = f"{int(track):02d}_"
        # for key, value in mp3.items():
        #     pass
        #     # print(key, value)
        # new = f'{prefix}{sub(artist)}_-_{sub(title)}.mp3'
        # print(f"old: {song.name}")
        # print(f"new: {new}")
        # print("")
        # if args.commit:
        #     mp3['TPE1'] = TPE1(encoding=0, text=[args.artist])
        #     mp3.save()
        #     song.rename(song.parent / new)


def fix_various(args):
    if not args.directory:
        print("Requires directory")
        return 1
    if not args.artist:
        print("Requires artist")
        return 1
    songs = pathlib.Path(args.directory).glob("*.[mM][pP]3")
    print(f"new artist name: {args.artist}")
    for song in songs:
        mp3 = ID3(song)
        artist = mp3.get("TPE1")
        album = mp3.get("TALB")
        title = mp3.get("TIT2")
        track = str(mp3.get("TRCK")).split("/")[0]
        prefix = ""
        if track.isdigit():
            prefix = f"{int(track):02d}_"
        for key, value in mp3.items():
            pass
            # print(key, value)
        new = f"{prefix}{sub(artist)}_-_{sub(title)}.mp3"
        print(f"old: {song.name}")
        print(f"new: {new}")
        print("")
        if args.commit:
            mp3["TPE1"] = TPE1(encoding=0, text=[args.artist])
            mp3.save()
            song.rename(song.parent / new)


def fix_one_song_mp4(args):
    try:
        mp4 = MP4(args.file)
    except MP4StreamInfoError:
        print("Not mp4 file?  Don't know what to do. bye")
        return 1
    if args.commit:
        mp4.pop("soal", None)
        mp4.pop("soar", None)
        mp4.pop("sonm", None)
        mp4.save()
    album_added = False
    for key, value in mp4.items():
        if re.match(r".(?:alb|nam|art)", key, flags=re.I):
            print(f"{key}: {value}")
            if "art" in key.lower() and args.commit and args.artist:
                mp4[key] = [args.artist]
            if "alb" in key.lower() and args.commit and args.album:
                mp4[key] = [args.album]
                album_added = True
            if "nam" in key.lower() and args.commit and args.title:
                mp4[key] = [args.title]
            if args.commit:
                mp4.save()
    if args.album and args.commit and not album_added:
        mp4[MP4_ALB] = args.album
        mp4.save()


def fix_one_song(args):
    if not args.file:
        print("Requires file")
        return 1
    if args.file.lower().endswith(".m4a"):
        return fix_one_song_mp4(args)
    try:
        mp3 = ID3(args.file)
    except ID3NoHeaderError:
        if not args.file.endswith(".mp3"):
            print(f"{args.file} not mp3\n")
            return
        tags = ID3()
        tags.save(args.file)
        mp3 = ID3(args.file)
    print(f"title: {mp3.get('TIT2')}")
    print(f"album: {mp3.get('TALB')}")
    print(f"artist: {mp3.get('TPE1')}")
    print(f"albumartist: {mp3.get('TPE2')}")
    save = False
    if args.title:
        if args.commit:
            save = True
            print(f"new title: {args.title}")
            mp3["TIT2"] = TIT2(encoding=0, text=[args.title])
    if args.album:
        if args.commit:
            save = True
            print(f"new album: {args.album}")
            mp3["TALB"] = TALB(encoding=0, text=[args.album])
    if args.artist:
        if args.commit:
            save = True
            print(f"new artist: {args.artist}")
            mp3.pop("TPE2", None)
            mp3["TPE1"] = TPE1(encoding=0, text=[args.artist])
            mp3["TPE2"] = TPE2(encoding=0, text=[args.artist])
    if args.commit and save:
        print(f"saving")
        mp3.save()


def rip_apple_bs(args):
    if not args.file:
        print("requires file")
        return 1
    if not args.file.endswith(".m4a"):
        print("works with m4a files only")
        return 1
    m = MP4(args.file)
    name = m.get("ownr")
    email = m.get("apID")
    if email:
        print(args.file, name, email)
    if args.commit:
        m.pop("ownr", None)
        m.pop("apID", None)
        m.pop("sfID", None)
        m.pop("plID", None)
        m.pop("cnID", None)
        m.pop("atID", None)
        m.save()


def renumber(args):
    if not args.directory:
        print("requires directory")
        return 1
    songs = list(pathlib.Path(args.directory).glob("*.[mM][4pP][3aA]"))
    songs.sort(key=lambda f: str(f).lower())
    total = len(songs)
    for track, file in enumerate(songs, start=1):
        print(track, file)
        if str(file).lower().endswith("m4a"):
            m = MP4(file)
            m["trkn"] = [(track, total)]
            m["disk"] = [(1, 1)]
            m.pop("cgen", None)
            if args.commit:
                m.pop("soal", None)
                m.pop("soar", None)
                m.pop("sonm", None)
                m.save()
        else:
            m = ID3(file)
            m["TRCK"] = TRCK(encoding=0, text=[f"{track}/{total}"])
            m["TPOS"] = TPOS(encoding=0, text=["1/1"])
            m.pop("TCMP", 0)
            if args.commit:
                m.pop("TSOA", None)
                m.save()


actions = {
    "one_artist": one_artist,
    "various": fix_various,
    "various4": fix_various_m4a,
    "get_info": get_info,
    "one": fix_one_song,
    "apple": rip_apple_bs,
    "num": renumber,
}

if __name__ == "__main__":
    main()
