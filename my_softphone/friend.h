#ifndef FRIEND_H
#define FRIEND_H
#include <QString>
#include <mybuddy.h>
#include <myaccount.h>
#include <config.h>
class MyAccount;
class Friend
{
public:
    Friend(MyAccount &acc, QString login, Config &settings, QString name, int status);
    ~Friend(){delete buddy;}
    QString getLogin(){return login;}
    QString getName(){return name;}
    int getStatus(){return status;}
    bool getMsgState(){return msgState;}
    void setMsgState(bool prm){msgState=prm;}
    int getCallingState(){return callingState;}
    void setCallingState(int state){callingState=state;}
    void setOnlineStatus();
    void setOfflineStatus();
    void sendMsg(QString msg);
    void sendConfMsg(QString confName, QString confCreator, QString msg, QString sender);
    void sendMyStatus(QString status);
    void notifyAboutRemove();
    void notifyAboutNewParty(QString confName, QString confCreator, QString parties);
    void notifyAboutRemovedParty(QString confName, QString confCreator, QString parties);
    void appendMessage(QString login, QString dateTime, QString msg);
    QVector<QString > msgBodies;
    QVector<QString > msgDateTimes;
    QVector<QString > msgSenders;
private:
    int callingState=0;
    bool msgState=false;
    QString login;
    QString name;
    int status;
    MyBuddy *buddy;
    Config *settings;
};

#endif // FRIEND_H
