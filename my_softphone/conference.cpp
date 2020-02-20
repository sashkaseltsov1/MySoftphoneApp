#include "conference.h"

Conference::Conference(MyAccount &acc, QString confName, QString confCreator, Config &settings, QObject *parent) : QObject(parent)
{
    this->acc=&acc;
    this->confName=confName;
    this->confCreator=confCreator;
    this->settings=&settings;
}

void Conference::makeConference(QVector<QString> parties)
{
    for(auto party:parties)
    {

        ConferenceCall *call = new ConferenceCall(*acc);
        call->setConference(this);
        call->setCalliedLogin(party);
        conferenceCalls.append(call);
        pj::CallOpParam prm(true);
        pj::SipHeader sipHeader;
        sipHeader.hName="Subject";
        sipHeader.hValue="Conference/@@"+confName.toStdString()+"@@"+confCreator.toStdString()+"@@";
        pj::SipHeaderVector sipHeaderVector;
        sipHeaderVector.push_back(sipHeader);
        pj::SipTxOption sipTxOption;
        sipTxOption.headers=sipHeaderVector;
        prm.txOption=sipTxOption;
        prm.opt.audioCount = 1;
        prm.opt.videoCount = 0;
        call->makeCall("sip:"+party.toStdString()+"@"+settings->getIp().toStdString()+":"+settings->getSipPort().toStdString(), prm);
    }
}

void Conference::makeNewConferenceCall(QString party)
{
    ConferenceCall *call = new ConferenceCall(*acc);
    call->setConference(this);
    call->setCalliedLogin(party);
    conferenceCalls.append(call);
    pj::CallOpParam prm(true);
    pj::SipHeader sipHeader;
    sipHeader.hName="Subject";
    sipHeader.hValue="Conference/@@"+confName.toStdString()+"@@"+confCreator.toStdString()+"@@";
    pj::SipHeaderVector sipHeaderVector;
    sipHeaderVector.push_back(sipHeader);
    pj::SipTxOption sipTxOption;
    sipTxOption.headers=sipHeaderVector;
    prm.txOption=sipTxOption;
    prm.opt.audioCount = 1;
    prm.opt.videoCount = 0;
    call->makeCall("sip:"+party.toStdString()+"@"+settings->getIp().toStdString()+":"+settings->getSipPort().toStdString(), prm);
}

void Conference::createIncomingConferenceCall(QString party, int callId)
{
    ConferenceCall *call = new ConferenceCall(*acc, callId);
    call->setConference(this);
    call->setCalliedLogin(party);
    conferenceCalls.append(call);
    pj::CallOpParam prm(true);
    pj::SipHeader sipHeader;
    sipHeader.hName="Subject";
    sipHeader.hValue="Conference/@@"+confName.toStdString()+"@@"+confCreator.toStdString()+"@@";
    pj::SipHeaderVector sipHeaderVector;
    sipHeaderVector.push_back(sipHeader);
    pj::SipTxOption sipTxOption;
    sipTxOption.headers=sipHeaderVector;
    prm.txOption=sipTxOption;
    prm.opt.audioCount = 1;
    prm.opt.videoCount = 0;
}

void Conference::removeConferenceCall(ConferenceCall *call)
{
    qDebug()<<"REMOVED***"<<call->getCalliedLogin();
    for(auto confCall:conferenceCalls)
    {
        if(confCall!=call)
        {
            if(confCall->getInfo().state==pjsip_inv_state::PJSIP_INV_STATE_CONFIRMED)
            {
                for(auto entity:acc->friendsLst)
                {
                    if(entity->getLogin()==confCall->getCalliedLogin())
                    {
                        entity->notifyAboutRemovedParty(confName, confCreator, call->getCalliedLogin());
                        break;
                    }
                }
            }
        }
    }
    calledParties.removeOne(call->getCalliedLogin());
    activeParties.removeOne(call->getCalliedLogin());
    conferenceCalls.removeOne(call);
    delete call;
    if(conferenceCalls.size()==0)
    {
        acc->RemoveConference(this);
    }
    else
    acc->updateConference(confName, confCreator);

}

void Conference::confirmConferenceCall(ConferenceCall *call)
{
    calledParties.removeOne(call->getCalliedLogin());
    activeParties.append(call->getCalliedLogin());
    for(auto confCall:conferenceCalls)
    {
        if(confCall!=call)
        {
            if(confCall->getInfo().state==pjsip_inv_state::PJSIP_INV_STATE_CONFIRMED)
            {
                confCall->aud_med->startTransmit(*call->aud_med);
                call->aud_med->startTransmit(*confCall->aud_med);
                for(auto entity:acc->friendsLst)
                {
                    if(entity->getLogin()==confCall->getCalliedLogin())
                    {
                        entity->notifyAboutNewParty(confName, confCreator, call->getCalliedLogin());
                    }
                    if(entity->getLogin()==call->getCalliedLogin())
                    {
                        entity->notifyAboutNewParty(confName, confCreator, confCall->getCalliedLogin());
                    }
                }
            }
        }
    }
    acc->updateConference(confName, confCreator);
}

void Conference::connectingConferenceCall(ConferenceCall *call)
{
    calledParties.append(call->getCalliedLogin());
    acc->updateConference(confName, confCreator);
}

void Conference::appendMessage(QString login, QString dateTime, QString msg)
{
    msgSenders.append(login);
    msgDateTimes.append(dateTime);
    msgBodies.append(msg);
}

void Conference::incomingMsg(QString sender, QString msg, QString dateTime, QString login)
{
    acc->showInfoInQml("Конференция: новое сообщение");
    appendMessage(sender, dateTime, msg);
    if(login!=confCreator)
    {
        for(auto call:conferenceCalls)
        {
            if((call->getInfo().state==pjsip_inv_state::PJSIP_INV_STATE_CONFIRMED) & call->getCalliedLogin()!=sender)
            {
                for(auto entity:acc->friendsLst)
                {
                    if(entity->getLogin()==call->getCalliedLogin())
                    {
                        entity->sendConfMsg(confName, confCreator, msg, sender);
                        break;
                    }
                }
            }
        }
    }
}

void Conference::sendMsg(QString msg, QString sender)
{
    for(auto call:conferenceCalls)
    {
        if(call->getInfo().state==pjsip_inv_state::PJSIP_INV_STATE_CONFIRMED)
        {
            for(auto entity:acc->friendsLst)
            {
                if(entity->getLogin()==call->getCalliedLogin())
                {
                    entity->sendConfMsg(confName, confCreator, msg, sender);
                    break;
                }
            }
        }
    }
}

void Conference::updateConference()
{
    acc->updateConference(confName, confCreator);
}

QVector<qreal> Conference::getSpeakersVolume()
{
    QVector<qreal> volumePrms;
    for(auto call:conferenceCalls)
    {
        volumePrms.append(call->getSpeakerVolume());
    }
    return volumePrms;
}

void Conference::hangUp()
{
    for(auto call:conferenceCalls)
    {
        pj::CallOpParam prm;
        call->hangup(prm);
    }
}


