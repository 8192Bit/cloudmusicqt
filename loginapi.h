#ifndef LOGINAPI_H
#define LOGINAPI_H

#include <QObject>

class QNetworkReply;
class QDeclarativeView;
class QNetworkAccessManager;

namespace QJson { class Parser; }

class LoginApi : public QObject
{
    Q_OBJECT

public:
    explicit LoginApi(QObject *parent = 0);
    ~LoginApi();

    Q_INVOKABLE int checkQrCodeStatus(QString key);

signals:
    void returnResult(int result);

private:
    Q_INVOKABLE void checkNAM();

    QDeclarativeView* caller;
    QNetworkAccessManager* manager;
    QJson::Parser* mParser;

};
#endif // LOGINAPI_H
