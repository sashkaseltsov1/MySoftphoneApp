#include "friend.h"

Friend::Friend(MyAccount &acc, QString login, Config &settings, QString name, int status)
{
    this->login = login;
    this->name = name;
    this->status = status;
    this->settings=&settings;
    pj::BuddyConfig cfg;
    cfg.uri="sip:"+login.toStdString()+"@"+settings.getIp().toStdString()+":"+settings.getSipPort().toStdString();
    buddy = new MyBuddy;
    buddy->create(acc, cfg);
}

void Friend::setOnlineStatus()
{
    status=1;
}

void Friend::setOfflineStatus()
{
    status=0;

}

void Friend::sendMsg(QString msg)
{
    pj::SendInstantMessageParam prm;
    prm.content="defMsg:"+msg.toStdString();
    buddy->sendInstantMessage(prm);
}

void Friend::sendConfMsg(QString confName, QString confCreator, QString msg, QString sender)
{
    pj::SendInstantMessageParam prm;
    prm.content="defCon:"+confName.toStdString()+"@"+confCreator.toStdString()+"@"+sender.toStdString()+"@"+msg.toStdString();
    buddy->sendInstantMessage(prm);
}

void Friend::sendMyStatus(QString status)
{
    pj::SendInstantMessageParam prm;
    prm.content="sysMsg:FRIEND_STATUS@"+status.toStdString();
    buddy->sendInstantMessage(prm);
}

void Friend::notifyAboutRemove()
{
    pj::SendInstantMessageParam prm;
    prm.content="sysMsg:FRIEND@Remove";
    buddy->sendInstantMessage(prm);
}

void Friend::notifyAboutNewParty(QString confName, QString confCreator, QString parties)
{
    pj::SendInstantMessageParam prm;
    prm.content="sysCon:ADD@"+confName.toStdString()+"@"+confCreator.toStdString()+"@"+parties.toStdString();
    buddy->sendInstantMessage(prm);
}

void Friend::notifyAboutRemovedParty(QString confName, QString confCreator, QString parties)
{
    pj::SendInstantMessageParam prm;
    prm.content="sysCon:REMOVE@"+confName.toStdString()+"@"+confCreator.toStdString()+"@"+parties.toStdString();
    buddy->sendInstantMessage(prm);
}

void Friend::appendMessage(QString login, QString dateTime, QString msg)
{
    msgSenders.append(login);
    msgDateTimes.append(dateTime);
    msgBodies.append(msg);
}
