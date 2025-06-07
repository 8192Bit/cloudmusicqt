#ifndef _TYPES_PATCH_H
#define _TYPES_PATCH_H

#include <qglobal.h>

// by Karin

// always unsigned, otherwise it's negative.
// and qint64, otherwise overflow. 2025
// To future maintainers: If you found something wrong with playlist loading, please change the type into bigger one.

typedef qint64 playlistId_t;
typedef qint64 musicId_t;
typedef qint64 albumId_t;
typedef qint64 articleId_t;
typedef qint64 djId_t;

#endif
