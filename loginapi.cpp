#include "loginapi.h"

#include <QString>
#include <QVariant>
#include <QEventLoop>
#include <QtDeclarative>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QDeclarativeView>
#include <QDeclarativeEngine>
#include <QNetworkAccessManager>

#include "networkaccessmanagerfactory.h"
#include "qjson/json_parser.hh"

static const char* QrStatusCheckUrl = "http://music.163.com/api/login/qrcode/client/login";

LoginApi::LoginApi(QObject *parent) : QObject(parent),
    manager(0), mParser(new QJson::Parser)
{
}

LoginApi::~LoginApi()
{
    delete mParser;
}

void LoginApi::classBegin()
{
    manager = qmlEngine(this)->networkAccessManager();
}

void LoginApi::componentComplete() {

}

void LoginApi::checkQrCodeStatus(QString key)
{
    checkNAM();

    QNetworkCookieJar* cookieJar = NetworkCookieJar::Instance();
    manager->setCookieJar(cookieJar);
    cookieJar->setParent(0);

    QNetworkRequest req(QString(QrStatusCheckUrl)+"?key="+key+"&type=3");
    QNetworkReply* rep = manager->get(req);

    connect(rep, SIGNAL(finished()), this, SLOT(onFinished()));

}

void LoginApi::onFinished() {

    QNetworkReply* rep = (QNetworkReply*) sender();

    rep->deleteLater();

    if(rep->error() != QNetworkReply::NoError)
    {
        emit failed(rep->errorString());
    }
    else
    {
        QVariant httpStatusCode = rep->attribute(QNetworkRequest::HttpStatusCodeAttribute);
        if(httpStatusCode.toInt() == 200)
        {
            QVariantMap json = mParser->parse(rep->readAll()).toMap();
            emit result(json["code"].toInt());
        }
        else
        {
            emit failed("HTTP " + QString::number(httpStatusCode.toInt()));
        }
    }
}

void LoginApi::checkNAM()
{
    if (!manager)
        manager = caller->engine()->networkAccessManager();
}
