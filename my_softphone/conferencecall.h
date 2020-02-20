#ifndef CONFERENCECALL_H
#define CONFERENCECALL_H

#include <pjsua2.hpp>
#include <QObject>
#include <QVector>
#include <QDebug>
#include <myaccount.h>
class MyAccount;
class Conference;
class ConferenceCall :public QObject, public pj::Call
{
    Q_OBJECT
public:
    ConferenceCall(pj::Account &acc, int call_id = PJSUA_INVALID_ID)
    : Call(acc, call_id)
    {
        myAcc = (MyAccount *)&acc;
    }

    ~ConferenceCall() override;

    void setConference(Conference *conf);
    virtual void onCallState(pj::OnCallStateParam &prm)override;
    virtual void onCallMediaState(pj::OnCallMediaStateParam &prm)override;
    qreal getSpeakerVolume(){return volume;}
    void setSpeakerVolume(qreal value){volume=value;}
    void setCalliedLogin(QString login){calliedLogin=login;}
    QString getCalliedLogin(){return calliedLogin;}
private:
    MyAccount *myAcc;
    QString calliedLogin;
    Conference *conf;
    qreal volume=1;
    pj::AudDevManager * mgr;
public:
    pj::AudioMedia *aud_med;
signals:
public slots:

};

#endif // CONFERENCECALL_H
