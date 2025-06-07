#include "qmlapi.h"

#include <QDateTime>
#include <QApplication>
#include <QPixmap>
#include <QDesktopServices>
#include <QFile>
#include <QFileDialog>
#include <QDebug>

#include <QClipboard>

#ifdef Q_OS_SYMBIAN
#ifndef Q_OS_S60V5
#include <akndiscreetpopup.h>
#endif
#include <avkon.hrh>
#include <gslauncher.h>
#include <gsfwviewuids.h>
#endif

#include "networkaccessmanagerfactory.h"
#include "userconfig.h"
#include "musicfetcher.h"

#include "qjson/json_parser.hh"

#include "qrcodegen/qrcodegen.h"

QmlApi::QmlApi(QObject *parent) : QObject(parent),
    mParser(new QJson::Parser)
{
}

QmlApi::~QmlApi()
{
    delete mParser;
}

QString QmlApi::getCookieToken()
{
    QList<QNetworkCookie> cookies = NetworkCookieJar::Instance()->cookiesForUrl(QUrl("http://music.163.com"));
    foreach (const QNetworkCookie& cookie, cookies) {
        if (cookie.name() == "MUSIC_U" && cookie.expirationDate() > QDateTime::currentDateTime()) {
            return cookie.value();
        }
    }
    return QString();
}

QString QmlApi::getUserId()
{
    return UserConfig::Instance()->getSetting(UserConfig::KeyUserId).toString();
}

void QmlApi::saveUserId(const QString &id)
{
    UserConfig::Instance()->setSetting(UserConfig::KeyUserId, id);
}

void QmlApi::logout()
{
    saveUserId(QString());
    NetworkCookieJar::Instance()->clearCookies();
}

int QmlApi::getVolume()
{
    return qBound(0, UserConfig::Instance()->getSetting(UserConfig::KeyVolume, 30).toInt(), 100);
}

void QmlApi::saveVolume(const int &volume)
{
    UserConfig::Instance()->setSetting(UserConfig::KeyVolume, qBound(0, volume, 100));
}

QString QmlApi::getPlayMode()
{
    return UserConfig::Instance()->getSetting(UserConfig::KeyPlayMode, "Normal").toString();
}

void QmlApi::savePlayMode(const QString &playMode)
{
    UserConfig::Instance()->setSetting(UserConfig::KeyPlayMode, playMode);
}

void QmlApi::takeScreenShot()
{
    QPixmap p = QPixmap::grabWidget(QApplication::activeWindow());

    QString fileName = QString("%1/%2_%3.png")
            .arg(QDesktopServices::storageLocation(QDesktopServices::PicturesLocation),
                 qApp->applicationName(),
                 QDateTime::currentDateTime().toString("yyyy_MM_dd_hh_mm_ss"));

    p.save(fileName);
}

void QmlApi::showNotification(const QString &title, const QString &text, const int &commandId)
{
#ifdef Q_OS_SYMBIAN
#ifndef Q_OS_S60V5
    TPtrC16 sTitle(static_cast<const TUint16 *>(title.utf16()), title.length());
    TPtrC16 sText(static_cast<const TUint16 *>(text.utf16()), text.length());
    TUid uid = TUid::Uid(0x2006DFF5);
    TRAP_IGNORE(CAknDiscreetPopup::ShowGlobalPopupL(
                    sTitle,
                    sText,
                    KAknsIIDNone,
                    KNullDesC,
                    0,
                    0,
                    KAknDiscreetPopupDurationLong,
                    commandId,
                    this,
                    uid ));
#endif
#else
    qDebug() << "showNotification:" << title << text << commandId;
#endif
}

static const uint MaxAccurateNumberInQML = 65535;

static QVariant fixVariant(const QVariant& variant)
{
    QVariant result(variant);
    if (result.type() == QVariant::ULongLong) {
        quint64 value = result.toULongLong();
        if (value > MaxAccurateNumberInQML)
            result.convert(QVariant::String);
        else
            result.convert(QVariant::Int);
    }
    else if (result.type() == QVariant::Map) {
        QVariantMap map = result.toMap();
        for (QVariantMap::iterator i = map.begin(); i != map.end(); i++) {
            i.value() = fixVariant(i.value());
        }
        result = map;
    }
    else if (result.type() == QVariant::List) {
        QVariantList list = result.toList();
        for (QVariantList::iterator i = list.begin(); i != list.end(); i++) {
            *i = fixVariant(*i);
        }
        result = list;
    }
    return result;
}

QVariant QmlApi::jsonParse(const QString &text)
{
    return fixVariant(mParser->parse(text.toUtf8()));
}

bool QmlApi::compareVariant(const QVariant &left, const QVariant &right)
{
    return left == right;
}

QString QmlApi::getNetEaseImageUrl(const QString &imgId)
{
    return MusicInfo::getPictureUrl(imgId.toAscii());
}

bool QmlApi::isFileExists(const QString &fileName)
{
    return QFile::exists(fileName);
}

bool QmlApi::removeFile(const QString &fileName)
{
    return QFile::remove(fileName);
}

QString QmlApi::cleanPath(const QString &path)
{
    return QDir::cleanPath(path);
}

QString QmlApi::getHomePath() const
{
    return QDesktopServices::storageLocation(QDesktopServices::HomeLocation);
}

QString QmlApi::selectFolder(const QString &title, const QString &defaultDir)
{
    return QFileDialog::getExistingDirectory(0, title, defaultDir);
}

bool QmlApi::showAccessPointTip()
{
    return UserConfig::Instance()->getSetting(UserConfig::KeyShowAccessPointTip, true).toBool();
}

void QmlApi::clearAccessPointTip()
{
    UserConfig::Instance()->setSetting(UserConfig::KeyShowAccessPointTip, false);
}

void QmlApi::launchSettingApp()
{
#ifdef Q_OS_SYMBIAN
    CGSLauncher* l = CGSLauncher::NewLC();
    l->LaunchGSViewL ( KGSAppsPluginUid, TUid::Uid(0), KNullDesC8 );
    CleanupStack::PopAndDestroy(l);
#endif
}

#ifdef Q_OS_SYMBIAN
void QmlApi::ProcessCommandL(TInt aCommandId)
{
    emit processCommand(aCommandId);
}
#endif


//karin 
//other
void QmlApi::CopyToClipboard(const QString &text)
{
	QApplication::clipboard()->setText(text);
}

QString QmlApi::generateSvgQrCode(QString string)
{
    const int border = 4;
    const QString lightColor = "#FFFFFF";
    const QString darkColor = "#000000";

    uint8_t qr0[qrcodegen_BUFFER_LEN_MAX];
    uint8_t tempBuffer[qrcodegen_BUFFER_LEN_MAX];

    const char* source = string.toLatin1().data();
    bool ok = qrcodegen_encodeText(source,
        tempBuffer, qr0, qrcodegen_Ecc_MEDIUM,
        qrcodegen_VERSION_MIN, qrcodegen_VERSION_MAX,
        qrcodegen_Mask_AUTO, true);
    if (!ok)
    {
        return "";
    }

    QString temp = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><!DOCTYPE svg PUBLIC \"-//W3C//DTD SVG 1.1//EN\" \"http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd\"><svg xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\" viewBox=\"0 0 %1 %1\" stroke=\"none\"><rect width=\"100%\" height=\"100%\" fill=\"%2\"/><path d=\"%3\" fill=\"%4\"/></svg>";

    QString part = "";
    int size = qrcodegen_getSize(qr0);
    for (int y = 0; y < size; y++)
    {
        for (int x = 0; x < size; x++)
        {
            if(qrcodegen_getModule(qr0, x, y))
            {
                part.append(QString("M%1,%2h1v1h-1z ").arg(QString::number(x + border)).arg(QString::number(y + border)));
            }
        }
    }

    return "data:image/svg+xml;utf8," + temp.arg(QString::number(size + border * 2), lightColor, part, darkColor);
}

