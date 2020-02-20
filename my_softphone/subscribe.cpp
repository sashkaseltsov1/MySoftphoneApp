#include "subscribe.h"

Subscribe::Subscribe(MyAccount &acc, QString login, Config &settings)
{
    this->login = login;
    this->settings=&settings;
    pj::BuddyConfig cfg;
    cfg.uri="sip:"+login.toStdString()+"@"+settings.getIp().toStdString()+":"+settings.getSipPort().toStdString();
    buddy = new MyBuddy;
    buddy->create(acc, cfg);
}

void Subscribe::notifyAboutSubscribe()
{
    pj::SendInstantMessageParam prm;
    prm.content="sysMsg:SUBSCRIBER@Add";
    buddy->sendInstantMessage(prm);
}

