#ifndef MYCALL_H
#define MYCALL_H

#include <pjsua2.hpp>
#include <QObject>
#include <QVector>
#include <QDebug>
#include <myaccount.h>
class MyAccount;

class MyCall :public QObject, public pj::Call
{
    Q_OBJECT
public:
    MyCall(pj::Account &acc, int call_id = PJSUA_INVALID_ID)
    : Call(acc, call_id)
    {
        myAcc = &acc;
       // myAcc = (MyAccount *)&acc;
    }

    ~MyCall() override;

    void setAccount(MyAccount *acc);
    virtual void onCallState(pj::OnCallStateParam &prm)override;
    virtual void onCallMediaState(pj::OnCallMediaStateParam &prm)override;
    virtual void onCreateMediaTransport(pj::OnCreateMediaTransportParam &prm) override;
    virtual void onCallTransferRequest(pj::OnCallTransferRequestParam &prm)override;
    virtual void onCallReplaced(pj::OnCallReplacedParam &prm)override;
    void setCalliedLogin(QString login){calliedLogin=login;}
    QString getCalliedLogin(){return calliedLogin;}

private:
    pj::Account *myAcc;
    //MyAccount *myAcc;
    MyAccount *acc;
    pj::AudDevManager * mgr;
    QString calliedLogin;
public:
    pj::AudioMedia *aud_med;
signals:
public slots:

};

#endif // MYCALL_H
