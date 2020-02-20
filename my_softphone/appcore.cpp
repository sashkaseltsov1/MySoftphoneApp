#include "appcore.h"
AppCore::AppCore(QObject *parent) : QObject(parent)
{
    if(!QFile::exists("settings.conf"))
        settings.initDefaultCfg();
}

AppCore::~AppCore()
{
}

void AppCore::removeAllCalls()
{
    if(acc->calls.size()==0 & acc->conferences.size()==0)
    {
        emit close();
    }
    else
    {
        for(auto call:acc->calls)
        {
                pj::CallOpParam prm;
                call->hangup(prm);
        }
        for(auto conference:acc->conferences)
        {
            pj::CallOpParam prm;
            conference->hangUp();
        }
    }
}

void AppCore::closeApp()
{


    delete acc_cfg;
    delete acc;

    ep.libDestroy();
}

void AppCore::addNewAcc(QString name, QString login, QString pwd, QString cpwd)
{  
    SqlQueries database(settings.getDbIp(),settings.getDbName(),
                        settings.getDbUserName(),settings.getDbPwd());
   QString result = database.AddNewUser(name,login,pwd,cpwd);
   emit newAccInfo(result);
}





void AppCore::startPjsuaLib(QString login,QString pwd)
{
    QVector<QString> stunSrvList=settings.getStunSrvList();
    QString codec=settings.getCodec();
    bool turnState = settings.getTurnState().toInt();
    QString turnUserName=settings.getTurnUserName();
    QString turnPwd=settings.getTurnPwd();
    QString turnSrv=settings.getTurnSrv();
    QString sipAddr=settings.getIp();
    QString sipPort=settings.getSipPort();
    // Init library

    ep.libCreate();

    ep_cfg.logConfig.level = 4;
    ep_cfg.medConfig.clockRate=48000;
    ep_cfg.medConfig.noVad=1;
    ep_cfg.medConfig.ecTailLen=0;
    for(auto srvName:stunSrvList)
        ep_cfg.uaConfig.stunServer.push_back(srvName.toStdString());

    ep.libInit( ep_cfg );
    ep.codecSetPriority(codec.toStdString(),255);

    // Transport
    tcfg.port = 0;
    ep.transportCreate(PJSIP_TRANSPORT_UDP, tcfg);

    // Start library
    ep.libStart();
    qDebug()<<"*** PJSUA2 STARTED ***";
    createAcc(login, pwd, turnUserName, turnPwd, turnSrv, sipAddr, sipPort, turnState);
}

void AppCore::stopPjsuaLib()
{

    ep.libDestroy();
    delete acc_cfg;
    delete acc;
    emit pjsuaLibDestroyed();
}

void AppCore::createAcc(QString login,
                        QString pwd,
                        QString turnUserName,
                        QString turnPwd,
                        QString turnSrv,
                        QString sipAddr,
                        QString sipPort,
                        bool turnState)
{
    acc_cfg=new pj::AccountConfig;
    acc_cfg->natConfig.iceEnabled=1;

    acc_cfg->natConfig.turnEnabled=turnState;
    acc_cfg->natConfig.turnUserName=turnUserName.toStdString();
    acc_cfg->natConfig.turnPassword=turnPwd.toStdString();
    acc_cfg->natConfig.turnServer=turnSrv.toStdString();
    acc_cfg->regConfig.timeoutSec=3600;
    acc_cfg->regConfig.retryIntervalSec=0;
    acc_cfg->mwiConfig.enabled=0;
    acc_cfg->idUri = "sip:"+login.toStdString()+"@"+sipAddr.toStdString()+":"+sipPort.toStdString();
    acc_cfg->regConfig.registrarUri ="sip:"+sipAddr.toStdString()+":"+sipPort.toStdString();
    acc_cfg->sipConfig.authCreds.push_back( pj::AuthCredInfo("digest", "*",login.toStdString(), 0, pwd.toStdString()) );
    acc=new MyAccount(settings, login);
    try {
    acc->create(*acc_cfg);
    } catch (...) {
        qDebug()<<"Adding account failed";
    }
    connect(acc, &MyAccount::regStateInfo, this, &AppCore::loginInfo);
    connect(acc, &MyAccount::entityChangeStatusInQml, this, &AppCore::entityChangeStatusInQml);
    connect(acc, &MyAccount::showNewSubscriberInQml, this, &AppCore::showNewSubscriberInQml);
    connect(acc, &MyAccount::removeSubscriberInQml, this, &AppCore::removeSubscriberInQml);
    connect(acc, &MyAccount::removeFriendInQml, this, &AppCore::removeFriendInQml);
    connect(acc, &MyAccount::showNewFriendInQml, this, &AppCore::showNewFriendInQml);
    connect(acc, &MyAccount::showInfoInQml, this, &AppCore::showInfoInQml);
    connect(acc, &MyAccount::showNewMsgInQml, this, &AppCore::showNewMsgInQml);
    connect(acc, &MyAccount::changeIFriendInQml, this, &AppCore::changeIFriendInQml);
    connect(acc, &MyAccount::incomingCall, this, &AppCore::showIncomingCallInQml);
    connect(acc, &MyAccount::removeIncomingCall, this, &AppCore::removeIncomingCallInQml);
    connect(acc, &MyAccount::defaultVolume, this, &AppCore::defaultVolume);
    connect(acc, &MyAccount::close, this, &AppCore::close);
    connect(acc, &MyAccount::changeIConference, this, &AppCore::changeIConference);
    connect(acc, &MyAccount::removeConference, this, &AppCore::removeConference);
    connect(acc, &MyAccount::incomingConference, this, &AppCore::showIncomingConferenceInQml);
    connect(acc, &MyAccount::showNewConferenceMsgInQml, this, &AppCore::showNewConferenceMsgInQml);
}

void AppCore::makeCall(QString login)
{
    if(getCallSize()==0 & getConferenceSize()==0)
    {
        acc->makeCall(login);
    }
}

void AppCore::makeConference(QVector<QString> parties, QString confName)
{
    acc->makeConference(parties, confName);
}

void AppCore::hangUpCall(QString login)
{
    for(auto call:acc->calls)
    {
        QString remoteUri="sip:"+login+"@"+settings.getIp()+":"+settings.getSipPort();
        QString remoteUri2="<sip:"+login+"@"+settings.getIp()+">";
        if(call->getInfo().remoteUri.c_str()==remoteUri.toStdString() | call->getInfo().remoteUri.c_str()==remoteUri2.toStdString())
        {
            pj::CallOpParam prm;
            call->hangup(prm);
        }
    }
}

void AppCore::getSettings()
{
    QVector <QString> stunServers=settings.getStunSrvList();
    QVector <QString> otherSettings=settings.getOtherSettings();
    emit settingsInfo(stunServers, otherSettings);
}

void AppCore::editSettings(QVector<QString> stunSrvList, QVector<QString> otherSettings)
{
    settings.updateStunSrvList(stunSrvList);
    settings.updateOtherSettings(otherSettings);
}



QString AppCore::getName()
{  
    return acc->getName();
}

QString AppCore::getLogin()
{
    return acc->getLogin();
}

void AppCore::getFriendsList()
{
    QVector <QString > loginList;
    QVector <QString > nameList;
    QVector <QString > statusList;
    QVector<bool> msgStateList;
    for(auto entity: acc->friendsLst)
    {
    loginList.append(entity->getLogin());
    nameList.append(entity->getName());
    if(entity->getStatus()>0)
    statusList.append("green"); else statusList.append("red");
    msgStateList.append(entity->getMsgState());
    }
    emit friendsListShowInQml(loginList, nameList, statusList, msgStateList);
}

void AppCore::getFriendListForConference()
{
    QVector <QString > loginList;
    QVector <QString > nameList;
    for(auto entity: acc->friendsLst)
    {
    loginList.append(entity->getLogin());
    nameList.append(entity->getName());
    }
    emit friendListForConferenceShowInQml(loginList, nameList);
}

void AppCore::getSubscribersList()
{

    QVector <QString> subscribers;
    for(auto entity: acc->subscribersLst)
    {
        subscribers.append(entity->getLogin());
    }
    emit subscribersListShowInQml(subscribers);
}

void AppCore::getConferencesList()
{
    QVector <QString> conferencesList;
    QVector <QString>confCreatorsList;
    for(auto conference:acc->conferences)
    {
        conferencesList.append(conference->getConfName());
        confCreatorsList.append(conference->getConfCreator());
    }
    emit conferencesListShowInQml(conferencesList, confCreatorsList);
}



void AppCore::findFriends(QString param)
{
    SqlQueries database(settings.getDbIp(),settings.getDbName(),
                        settings.getDbUserName(),settings.getDbPwd());
    QVector<QVector <QString>> findFriendsResult = database.findFriends(param);
    for(auto entityVec:findFriendsResult)
    {
        for(auto entity:acc->friendsLst)
        {
            if(entity->getLogin()==entityVec.at(0))
                findFriendsResult.removeOne(entityVec);
        }
        for(auto entity:acc->subscribesLst)
        {
            if(entity->getLogin()==entityVec.at(0))
                findFriendsResult.removeOne(entityVec);
        }
        for(auto entity:acc->subscribersLst)
        {
            if(entity->getLogin()==entityVec.at(0))
                findFriendsResult.removeOne(entityVec);
        }
        if(acc->getLogin()==entityVec.at(0))
            findFriendsResult.removeOne(entityVec);
    }
    QVector<QString> loginList;
    QVector<QString> nameList;

    for(auto entityVec:findFriendsResult)
    {
        loginList.append(entityVec.at(0));
        nameList.append(entityVec.at(1));
    }
    emit findFriendsShowInQml(loginList, nameList);
}

void AppCore::addSubscribe(QString login)
{
    bool p = true;
    for(auto entity:acc->subscribersLst)
    {
        if(entity->getLogin()==login)
        {
            p=false;
            break;
        }
    }
    if(p)
    {
        SqlQueries database(settings.getDbIp(),settings.getDbName(),
                            settings.getDbUserName(),settings.getDbPwd());
        bool state = database.addSubscribe(acc->getLogin(), login);
        if(state)
        {
            Subscribe *sub = new Subscribe(*acc, login, settings);
            acc->subscribesLst.append(sub);
            sub->notifyAboutSubscribe();
            emit showInfo("Заявка отправлена");
        }
    }
}


void AppCore::removeSubscriber(QString login)
{
    for(auto entity: acc->subscribersLst)
    {
        if(entity->getLogin()==login)
        {
            entity->removeSubscriber();
            acc->subscribersLst.removeOne(entity);
            delete entity;
            SqlQueries database(settings.getDbIp(),settings.getDbName(),
                                settings.getDbUserName(),settings.getDbPwd());
            database.removeSubscriber(acc->getLogin(), login);
            break;
        }
    }
}

void AppCore::addToFriendList(QString login)
{
    SqlQueries database(settings.getDbIp(),settings.getDbName(),
                        settings.getDbUserName(),settings.getDbPwd());
    QVector<QString > friendPrm = database.addNewFriend(acc->getLogin(), login);
    for(auto entity:acc->subscribersLst)
    {
        if(entity->getLogin()==login)
        {
            entity->addToFriendList(acc->getName(), "1");
            acc->subscribersLst.removeOne(entity);
            delete entity;
            Friend *friendEntity = new Friend(*acc, login, settings, friendPrm.at(0), friendPrm.at(1).toInt());
            acc->friendsLst.append(friendEntity);
            break;
        }
    }

}

void AppCore::showIFriend(QString login, QString name)
{
    int callingState=callStates::CS_NO_CALLS;
    for(auto entity:acc->friendsLst)
    {
        if(entity->getLogin()==login)
            callingState=entity->getCallingState();
    }
    emit showIFriendInQml(login, name, callingState);
    getMessageList(login);
}

void AppCore::showIConference(QString confName, QString confCreator)
{
    for(auto conference:acc->conferences)
    {
        if(confName==conference->getConfName() & confCreator==conference->getConfCreator())
        {
            emit showIConferenceInQml(confName, confCreator,
                                      QString::number(conference->activeParties.size()),
                                      conference->activeParties,
                                      conference->calledParties,
                                      conference->getSpeakersVolume(),
                                      conference->msgSenders,
                                      conference->msgBodies,
                                      conference->msgDateTimes);
            break;
        }
    }
}

void AppCore::removeFriend(QString friendLogin)
{
    bool state =true;
    for(auto call:acc->calls)
    {
        if(call->getCalliedLogin()==friendLogin)
        {
             state=false;
             break;
        }
    }
    for(auto conf:acc->conferences)
    {
        for(auto call:conf->conferenceCalls)
        {
            if(call->getCalliedLogin()==friendLogin)
            {
                state=false;
                break;
            }
        }
    }
    if(state)
    {
        for(auto entity: acc->friendsLst)
        {
            if(entity->getLogin()==friendLogin)
            {
                for(auto call:acc->calls)
                {
                    if(call->getCalliedLogin()==friendLogin)
                        hangUpCall(friendLogin);
                }
                entity->notifyAboutRemove();
                int index = acc->friendsLst.indexOf(entity);
                acc->friendsLst.remove(index);
                delete entity;
                SqlQueries database(settings.getDbIp(),settings.getDbName(),
                                    settings.getDbUserName(),settings.getDbPwd());
                database.removeFriend(acc->getLogin(), friendLogin);
                emit removeFriendInQml(index);
                emit showInfo("Друг удален");
                break;
            }
        }
    }
    else
    {
        emit showInfo("У вас есть активные звонки с этим другом");
    }

}

void AppCore::sendMsg(QString login, QString msg)
{
    QString temp = msg;
    temp.replace("\n", "");
    if(temp!="")
    {
        msg=msg.replace("\n","<br>");
        qDebug()<<msg;
        for(auto entity:acc->friendsLst)
        {
            if(entity->getLogin()==login)
            {
                QDateTime dateTime(QDate::currentDate(), QTime::currentTime());
                entity->appendMessage("Вы", dateTime.toString(), msg);
                entity->sendMsg(msg);
                emit showNewMsgInQml("Вы", msg, dateTime.toString());
            }
        }
    }
}

void AppCore::sendConferenceMsg(QString confName, QString confCreator, QString msg)
{
    QString temp = msg;
    temp.replace("\n", "");
    if(temp!="")
    {
        msg=msg.replace("\n","<br>");
        for(auto conference:acc->conferences)
        {
            if(conference->getConfName()==confName & conference->getConfCreator()==confCreator)
            {
                QDateTime dateTime(QDate::currentDate(), QTime::currentTime());
                conference->appendMessage("Вы", dateTime.toString(), msg);
                conference->sendMsg(msg, acc->getLogin());
                emit showNewConferenceMsgInQml("Вы", msg, dateTime.toString(), confName, confCreator);
                break;
            }
        }
    }
}

void AppCore::getMessageList(QString login)
{
    for(auto entity:acc->friendsLst)
    {
        if(entity->getLogin()==login)
        {
            emit showAllMessages(entity->msgSenders, entity->msgBodies, entity->msgDateTimes);
        }
    }
}

void AppCore::changeMsgState(int index, bool msgState)
{
    acc->friendsLst[index]->setMsgState(msgState);
}

void AppCore::answerCall(QString login, bool state)
{
    for(auto call:acc->calls)
    {
        if(call->getCalliedLogin()==login)
        {
            if(!state)
            {
                pj::CallOpParam prm;
                prm.statusCode=pjsip_status_code::PJSIP_SC_DECLINE;
                call->answer(prm);
            }
            else
            {
                for(auto call2:acc->calls)
                {
                    if(call2->getInfo().state==pjsip_inv_state::PJSIP_INV_STATE_CONFIRMED)
                    {
                        pj::CallOpParam param;
                        call2->hangup(param);
                    }
                }
                for(auto conf:acc->conferences)
                {
                    conf->hangUp();
                }
                pj::CallOpParam prm;
                prm.statusCode=pjsip_status_code::PJSIP_SC_OK;
                call->answer(prm);
            }
            break;
        }
    }
}

void AppCore::answerConference(QString confName, QString confCreator, bool state)
{
    for(auto conference:acc->conferences)
    {
        if(conference->getConfName()==confName & conference->getConfCreator()==confCreator)
        {
            if(state)
            {
                for(auto call:acc->calls)
                {
                        pj::CallOpParam param;
                        call->hangup(param);
                }
                for(auto conf:acc->conferences)
                {
                    if(conf!=conference)
                        conf->hangUp();
                }
                pj::CallOpParam prm;
                prm.statusCode=pjsip_status_code::PJSIP_SC_OK;
                conference->conferenceCalls[0]->answer(prm);
            }
            else
            {
                pj::CallOpParam prm;
                prm.statusCode=pjsip_status_code::PJSIP_SC_DECLINE;
                conference->conferenceCalls[0]->answer(prm);
            }
            break;
        }
    }
}

void AppCore::setSpeakerVolume(QString login, float value)
{
    for(auto call:acc->calls)
    {
        if(call->getCalliedLogin()==login)
        {
            call->aud_med->adjustTxLevel(value);
            break;
        }
    }
}

void AppCore::setConferenceCallSpeakerVolume(QString confName, QString confCreator, QString party, float value)
{
    for(auto conference:acc->conferences)
    {
        if(conference->getConfName()==confName & conference->getConfCreator()==confCreator)
        {
            for(auto call: conference->conferenceCalls)
            {
                if(call->getCalliedLogin()==party)
                {
                    call->aud_med->adjustTxLevel(value);
                    call->setSpeakerVolume(static_cast<qreal>(value));
                    break;
                }
            }
            break;
        }
    }
}

void AppCore::setConferenceCallMicVolume(QString confName, QString confCreator, float value)
{
    for(auto conference:acc->conferences)
    {
        if(conference->getConfName()==confName & conference->getConfCreator()==confCreator)
        {
            for(auto call:conference->conferenceCalls)
            {
                call->aud_med->adjustRxLevel(value);
            }
            break;
        }
    }
}

void AppCore::setConferenceCallSpeakerVolumeForDefaultParty(QString confName, QString confCreator, float value)
{
    for(auto conf:acc->conferences)
    {
        if(confName==conf->getConfName() & confCreator==conf->getConfCreator())
        {
            conf->conferenceCalls[0]->aud_med->adjustTxLevel(value);
            break;
        }
    }
}

void AppCore::setMicVolume(QString login, float value)
{
    for(auto call:acc->calls)
    {
        if(call->getCalliedLogin()==login)
        {
            call->aud_med->adjustRxLevel(value);
            break;
        }
    }
}

void AppCore::hangUpConference(QString confName, QString confCreator)
{
    for(auto conference:acc->conferences)
    {
        if(conference->getConfName()==confName & conference->getConfCreator()==confCreator)
        {
            conference->hangUp();
            break;
        }
    }
}

void AppCore::hangUpConferenceCall(QString confName, QString confCreator, QString calledParty)
{
    if(confCreator==getLogin())
    {
        for(auto conference:acc->conferences)
        {
            if(conference->getConfName()==confName & conference->getConfCreator()==confCreator)
            {
                for(auto call:conference->conferenceCalls)
                {
                    if(call->getCalliedLogin()==calledParty)
                    {
                        pj::CallOpParam prm;
                        call->hangup(prm);
                        break;
                    }
                }
                break;
            }
        }
    }
}

void AppCore::addNewPartyInConference(QString confName, QString confCreator, QString partyName)
{
    for(auto conference:acc->conferences)
    {
        if(confName==conference->getConfName() & confCreator==conference->getConfCreator())
        {
            conference->makeNewConferenceCall(partyName);
            break;
        }
    }
}

void AppCore::getValidParties(QString confName, QString confCreator)
{
    QVector< QString> parties;
    for(auto conference:acc->conferences)
    {
        if(confName==conference->getConfName() & confCreator==conference->getConfCreator())
        {
            for(auto entity: acc->friendsLst)
            {
                bool state=true;
                for(auto call: conference->conferenceCalls)
                {
                    if(call->getCalliedLogin()==entity->getLogin())
                    {
                        state=false;
                        break;
                    }
                }
                if(state)
                parties.append(entity->getLogin());
            }
            emit showValidPartiesInQml(parties);
            break;
        }
    }
}
