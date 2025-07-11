﻿#ifndef QMLAPI_H
#define QMLAPI_H

#include <QObject>
#include <QVariant>

#ifdef Q_OS_SYMBIAN
#include <eikcmobs.h>
#include <eikenv.h>
#ifdef PIGLER_API
#include <QPiglerAPI.h>
#endif
#endif

#include "typespatch.h"

namespace QJson { class Parser; }

#ifdef Q_OS_SYMBIAN
class QmlApi : public QObject, public MEikCommandObserver
#else
class QmlApi : public QObject
#endif
{
    Q_OBJECT
public:
    explicit QmlApi(QObject *parent = 0);
    ~QmlApi();

    Q_INVOKABLE QString getCookieToken();

    Q_INVOKABLE QString getUserId();
    Q_INVOKABLE void saveUserId(const QString& id);
    Q_INVOKABLE void logout();

    Q_INVOKABLE int getVolume();
    Q_INVOKABLE void saveVolume(const int& volume);

    Q_INVOKABLE QString getPlayMode();
    Q_INVOKABLE void savePlayMode(const QString& playMode);

    Q_INVOKABLE void takeScreenShot();

    Q_INVOKABLE void showNotification(const QString& title, const QString& text,
                                      const int& commandId = 0);

    Q_INVOKABLE QVariant jsonParse(const QString& text);

    Q_INVOKABLE bool compareVariant(const QVariant& left, const QVariant& right);

    Q_INVOKABLE QString getNetEaseImageUrl(const QString& imgId);

    Q_INVOKABLE bool isFileExists(const QString& fileName);
    Q_INVOKABLE bool removeFile(const QString& fileName);

    Q_INVOKABLE QString cleanPath(const QString& path);
    Q_INVOKABLE QString getHomePath() const;

    Q_INVOKABLE QString selectFolder(const QString& title, const QString& defaultDir);


    // For Symbian OS only
    Q_INVOKABLE bool showAccessPointTip();
    Q_INVOKABLE void clearAccessPointTip();
    Q_INVOKABLE void launchSettingApp();

    // by Karin
    Q_INVOKABLE void CopyToClipboard(const QString &text);


    Q_INVOKABLE QString generateSvgQrCode(QString string);

    Q_INVOKABLE QString getChineseWeekday();

    Q_INVOKABLE bool isPiglerAPIAvailable();


#ifdef Q_OS_SYMBIAN
    void ProcessCommandL(TInt aCommandId);

#ifdef PIGLER_API
    Q_INVOKABLE void showStatusPanelNotification(QString text);
    Q_INVOKABLE void hideStatusPanelNotification();
#endif

#endif

signals:
    void processCommand(int commandId);


private:
    QJson::Parser* mParser;
#ifdef PIGLER_API
    QPiglerAPI *api;
    qint32 uid;
#endif
};

#endif // QMLAPI_H
