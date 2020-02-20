#include "subscriber.h"

Subscriber::Subscriber(MyAccount &acc, QString login, Config &settings)
{
    this->login = login;
    this->settings=&settings;
    pj::BuddyConfig cfg;
    cfg.uri="sip:"+login.toStdString()+"@"+settings.getIp().toStdString()+":"+settings.getSipPort().toStdString();
    buddy = new MyBuddy;
    buddy->create(acc, cfg);
}

void Subscriber::addToFriendList(QString name, QString status)
{
    pj::SendInstantMessageParam prm;
    prm.content="sysMsg:SUBSCRIBE@Accept."+name.toStdString()+"."+status.toStdString();
    buddy->sendInstantMessage(prm);
}

void Subscriber::removeSubscriber()
{
    pj::SendInstantMessageParam prm;
    prm.content="sysMsg:SUBSCRIBE@Decline";
    buddy->sendInstantMessage(prm);
}
