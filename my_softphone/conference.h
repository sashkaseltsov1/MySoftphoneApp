#ifndef CONFERENCE_H
#define CONFERENCE_H

#include <pjsua2.hpp>
#include <QObject>
#include <QVector>
#include <QDebug>
#include <myaccount.h>
#include <conferencecall.h>
#include <config.h>
class MyAccount;
class ConferenceCall;
class Conference : public QObject
{
    Q_OBJECT
public:
    explicit Conference(MyAccount &acc, QString confName,QString confCreator, Config &settings, QObject *parent = nullptr);
    QVector<ConferenceCall*> conferenceCalls;
    QVector<QString> activeParties;
    QVector<QString> calledParties;
    void makeConference(QVector <QString> parties);
    void makeNewConferenceCall(QString party);
    void createIncomingConferenceCall(QString party, int callId);
    void removeConferenceCall(ConferenceCall *call);
    void confirmConferenceCall(ConferenceCall *call);
    void connectingConferenceCall(ConferenceCall *call);
    void appendMessage(QString login, QString dateTime, QString msg);
    void incomingMsg(QString sender, QString msg, QString dateTime, QString login);
    void sendMsg(QString msg, QString sender);
    void updateConference();
    QVector<qreal> getSpeakersVolume();
    void hangUp();
    QString getConfName(){return confName;}
    QString getConfCreator(){return confCreator;}
    QVector<QString > msgBodies;
    QVector<QString > msgDateTimes;
    QVector<QString > msgSenders;
signals:
private:
    QString confCreator;
    QString confName;
    QString subConfName;
    MyAccount *acc;
    Config *settings;
public slots:
};

#endif // CONFERENCE_H
