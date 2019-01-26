#ifndef _KARIN_PATCH_H
#define _KARIN_PATCH_H

#define NL_GET_MUSIC_URL "http://music.163.com/song/media/outer/url?id=%1.%2"

#ifndef _NL_VER
#define _NL_VER "0.9.6harmattan2019r1"
#endif

#define NL_PATCH

// always unsigned, otherwise it's negative.
typedef uint playlistId_t;
typedef uint musicId_t;
typedef uint albumId_t;
typedef uint articleId_t;
typedef uint djId_t;

#endif
