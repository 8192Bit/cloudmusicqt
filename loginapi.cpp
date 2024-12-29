#include "loginapi.h"

#include <QString>
#include <QVariant>
#include <QEventLoop>
#include <QNetworkReply>
#include <QSystemDeviceInfo>
#include <QNetworkRequest>
#include <QDeclarativeView>
#include <QDeclarativeEngine>
#include <QNetworkAccessManager>

#include "networkaccessmanagerfactory.h"
#include "qjson/json_parser.hh"

static const char* QrStatusCheckUrl = "http://music.163.com/api/login/qrcode/client/login";

LoginApi::LoginApi(QObject *parent) : QObject(parent),
    mParser(new QJson::Parser)
{
}

LoginApi::~LoginApi()
{
    delete mParser;
}

int LoginApi::checkQrCodeStatus(QString key)
{
    //QUrl url(QString(QrStatusCheckUrl));
    //url.addQueryItem("key", key);
    //url.addQueryItem("type", "3");

    //checkNAM();
    manager = new QNetworkAccessManager(this);

    QNetworkCookieJar* cookieJar = NetworkCookieJar::Instance();
    manager->setCookieJar(cookieJar);
    cookieJar->setParent(0);

    QVariant cookies = QVariant::fromValue(cookieJar->cookiesForUrl(QUrl("music.163.com")));

    QNetworkRequest req(QString(QrStatusCheckUrl)+"?key="+key+"&type=3");
    //req.setUrl(url);
    //req.setHeader(QNetworkRequest::CookieHeader, cookies);

    //qDebug() << url.toString();

    //qDebug() << cookies.toString();

    QNetworkReply* rep = manager->get(req);


    QEventLoop loop;
    //Ò°ÂùÍ¬²½
    connect(rep, SIGNAL(finished()), &loop, SLOT(quit()));
    loop.exec();

    manager->deleteLater();

    if(rep->error() != QNetworkReply::NoError)
    {
        rep->deleteLater();
        return 0;
    }
    else
    {
        QVariant httpStatusCode = rep->attribute(QNetworkRequest::HttpStatusCodeAttribute);
        if(httpStatusCode.toInt() == 200)
        {
            QByteArray result = rep->readAll();
            QVariantMap json = mParser->parse(result).toMap();
            int code = json["code"].toInt();
            if(code == 803)
            {
                //save cookie to the jar
                //QVariant cookie = rep->header(QNetworkRequest::SetCookieHeader);
                //QList<QNetworkCookie> receivedCookies = qvariant_cast<QList<QNetworkCookie> >(cookie);
                //jar->insertCookie();

            }
            rep->deleteLater();
            return code;
        }
        else
        {
            rep->deleteLater();
            return httpStatusCode.toInt();
        }
    }
}

void LoginApi::checkNAM()
{
    if (!manager)
        manager = caller->engine()->networkAccessManager();
}
