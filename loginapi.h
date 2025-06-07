#ifndef LOGINAPI_H
#define LOGINAPI_H

#include <QObject>
#include <QDeclarativeParserStatus>

class QNetworkReply;
class QDeclarativeView;
class QNetworkAccessManager;

namespace QJson { class Parser; }

class LoginApi : public QObject, public QDeclarativeParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QDeclarativeParserStatus)

public:
    explicit LoginApi(QObject *parent = 0);
    ~LoginApi();

    void classBegin();
    void componentComplete();

    Q_INVOKABLE void checkQrCodeStatus(QString key);

signals:
    void result(int code);
    void failed(QString error);

private:
    Q_INVOKABLE void checkNAM();

    QDeclarativeView* caller;
    QNetworkAccessManager* manager;
    QJson::Parser* mParser;

private slots:
    void onFinished();

};
#endif // LOGINAPI_H
