#ifndef SQLQUERIES_H
#define SQLQUERIES_H

#include <QtSql>

#include <QVariant>
#include <QDebug>
class SqlQueries
{
public:
    SqlQueries(QString dbSrvIp,
               QString dbName,
               QString dbUserName,
               QString dbPwd);
    ~SqlQueries(){QSqlDatabase::removeDatabase("SqlConnect");}
    QString AddNewUser(QString name, QString login, QString pwd, QString cpwd);
    QString getName(QString login);
    int getStatus(QString login);
    QVector <QString> getFriendsList(QString login);
    QVector <QString> getSubscribersList(QString login);
    QVector <QString> getSubscribesList(QString login);
    QVector<QVector <QString>> findFriends(QString param);
    bool addSubscribe(QString login, QString subLogin);
    void removeSubscribe(QString login, QString subLogin);
    void removeSubscriber(QString login, QString subLogin);
    void removeFriend(QString login, QString friendLogin);
    QVector <QString> addNewFriend(QString login, QString friendLogin);
private:
};

#endif // SQLQUERIES_H
