#ifndef MYACCOUNT_H
#define MYACCOUNT_H

#include <QObject>
#include <pjsua2.hpp>
#include <mycall.h>
#include <conference.h>
#include <sqlqueries.h>
#include <QDebug>
#include <QVector>
#include <subscriber.h>
#include <subscribe.h>
#include <friend.h>
class Friend;
class Subscriber;
class Subscribe;
class MyCall;
class Conference;
namespace callStates
{
    enum callSt
    {
        CS_NO_CALLS,
        CS_CALLING,
        CS_IN_CALL,
        CS_DISCONNECTED
    };
}
class MyAccount : public QObject, public pj::Account
{
    Q_OBJECT
signals:
    void entityChangeStatusInQml(int index, QString status);
    void showNewSubscriberInQml(QString login);
    void removeSubscriberInQml(int index);
    void removeFriendInQml(int index);
    void showNewFriendInQml(QString friendLogin, QString name, QString status);
    void showInfoInQml(QString infoStr);
    void showNewMsgInQml(QString login, QString msg, QString dateTime, int index=-1);
    void showNewConferenceMsgInQml(QString sender, QString msg, QString dateTime, QString conName, QString confCreator);
    void changeIFriendInQml(QString login, QString name, int callingState, int index);
    void changeIConference(QString confName, QString confCreator);
    void showCallStateInQml(int state);
    void incomingCall(QString login);
    void incomingConference(QString confName, QString confCreator);
    void removeIncomingCall(QString login);
    void removeConference(int confIndex, QString confName, QString confCreator);
    void defaultVolume();
    void regStateInfo(bool regState);
    void close();
public:
    QVector <Subscriber *> subscribersLst;
    QVector <Subscribe *> subscribesLst;
    QVector <Friend *> friendsLst;
    QVector <MyCall*> calls;
    QVector <Conference *> conferences;

    QString getLogin(){return login;}
    QString getName(){return name;}
    QString splitUri(QString uri);
    void setDefaultVolume(){emit defaultVolume();}
    MyAccount(Config &cfg, QString login){settings = &cfg;this->login=login;}
    ~MyAccount() override;
    void removeCall(MyCall *call);
    void RemoveConference(Conference *conf);
    void confirmedCall(MyCall * call);
    void initEntities();

    void sendAccState(QString status);
    void changeFriendStatus(QString login, QString status);
    void makeCall(QString login);
    void makeConference(QVector<QString>parties, QString confName);
    void updateConference(QString confName, QString confCreator);
    virtual void onRegState(pj::OnRegStateParam &prm) override;
    virtual void onIncomingCall(pj::OnIncomingCallParam &iprm) override;
    virtual void onInstantMessage(pj::OnInstantMessageParam &prm) override;
    virtual void onInstantMessageStatus(pj::OnInstantMessageStatusParam &prm) override;
    virtual void onIncomingSubscribe(pj::OnIncomingSubscribeParam &prm) override;



public slots:
private:
    Config *settings;
    QString login;
    QString name;
    bool regState=false;

};

#endif // MYACCOUNT_H
