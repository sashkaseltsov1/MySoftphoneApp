#include "myaccount.h"

QString MyAccount::splitUri(QString uri)
{
    QString login = uri;
    QStringList splitLst = login.split(":");
    login=splitLst.at(1);
    splitLst.clear();
    splitLst = login.split("@");
    login=splitLst.at(0);
    return login;
}

MyAccount::~MyAccount()
{
    sendAccState("Offline");


    for(auto entity:friendsLst)
    {
        delete entity;
    }
    friendsLst.clear();
    for(auto entity:subscribesLst)
    {
        delete entity;
    }
    subscribesLst.clear();
    for(auto entity:subscribersLst)
    {
        delete entity;
    }
    subscribersLst.clear();

    shutdown();
    qDebug() << "*** Account is being deleted: No of calls="
              << calls.size();
}

void MyAccount::removeCall(MyCall *call)
{
    calls.removeOne(call);
    for(auto entity:friendsLst)
    {
        if(entity->getLogin()==call->getCalliedLogin())
        {
            int index = friendsLst.indexOf(entity);
            entity->setCallingState(callStates::CS_NO_CALLS);
            emit changeIFriendInQml(entity->getLogin(), entity->getName(), entity->getCallingState(),index );

            if(entity->getStatus()==0)
                emit showInfoInQml(entity->getLogin()+" не в сети");
            else
                emit showInfoInQml("Вызов завершен");
            break;
        }
    }
    emit removeIncomingCall(call->getCalliedLogin());
    delete call;
    if(calls.size()==0) emit close();
}

void MyAccount::RemoveConference(Conference *conf)
{
    int index = conferences.indexOf(conf);
    QString confName = conf->getConfName();
    QString confCreator = conf->getConfCreator();
    conferences.removeOne(conf);
    delete conf;
    emit removeConference(index, confName, confCreator);
    if(conferences.size()==0) emit close();
}



void MyAccount::confirmedCall(MyCall *call)
{
    for(auto entity:friendsLst)
    {
        if(entity->getLogin()==call->getCalliedLogin())
        {
            int index = friendsLst.indexOf(entity);
            entity->setCallingState(callStates::CS_IN_CALL);
            emit changeIFriendInQml(entity->getLogin(), entity->getName(), entity->getCallingState(),index );
            break;
        }
    }
}



void MyAccount::initEntities()
{
    SqlQueries database(settings->getDbIp(),settings->getDbName(),
                        settings->getDbUserName(),settings->getDbPwd());
    QVector<QString > friends = database.getFriendsList(login);
    QVector<QString > subscribes = database.getSubscribesList(login);
    QVector<QString > subscribers = database.getSubscribersList(login);
    name = database.getName(login);
    for (auto entity: friends)
    {
        Friend *fr = new Friend(*this, entity, *settings, database.getName(entity), database.getStatus(entity));
        friendsLst.append(fr);
    }
    for (auto entity: subscribes)
    {
        Subscribe *sub = new Subscribe(*this, entity, *settings);
        subscribesLst.append(sub);
    }
    for (auto entity: subscribers)
    {
        Subscriber *subr = new Subscriber(*this, entity, *settings);
        subscribersLst.append(subr);
    }
    qDebug()<<"***Entities is loaded!***"<<friends.size();
}

void MyAccount::sendAccState(QString status)
{
    for(auto entity:friendsLst)
    {
        entity->sendMyStatus(status);
    }
    qDebug()<<"***Status state sended!***";
}

void MyAccount::changeFriendStatus(QString login, QString status)
{

    for(auto entity:friendsLst)
    {
        if(entity->getLogin()==login)
        {
            if(status=="Online")
            {
                entity->setOnlineStatus();
                status="green";
            }
            else
            {
                entity->setOfflineStatus();
                status="red";
            }
            int index = friendsLst.indexOf(entity);
            entityChangeStatusInQml(index, status);
        }
    }
}

void MyAccount::makeCall(QString login)
{
    for(auto entity:friendsLst)
    {
        if(entity->getLogin()==login)
            entity->setCallingState(callStates::CS_CALLING);
    }
    MyCall *call = new MyCall(*this);
    call->setAccount(this);
    call->setCalliedLogin(login);
    calls.append(call);



    pj::CallOpParam prm(true);


    prm.opt.audioCount = 1;
    prm.opt.videoCount = 0;
    call->makeCall("sip:"+login.toStdString()+"@"+settings->getIp().toStdString()+":"+settings->getSipPort().toStdString(), prm);
}

void MyAccount::makeConference(QVector<QString> parties, QString confName)
{
    Conference *newConf = new Conference(*this, confName, getLogin(), *settings);
    conferences.push_back(newConf);
    newConf->makeConference(parties);
    emit changeIConference(confName, newConf->getConfCreator());
}

void MyAccount::updateConference(QString confName, QString confCreator)
{
    emit changeIConference(confName, confCreator);
}

void MyAccount::onRegState(pj::OnRegStateParam &prm)
{
pj::AccountInfo ai = getInfo();

    qDebug()<< (ai.regIsActive? "*** Register: code=" : "Error: Unregister: code=")<< prm.code ;
    if(ai.regIsActive & !regState)
    {
        regState=true;
        initEntities();
        sendAccState("Online");
        emit regStateInfo(ai.regIsActive);
    }
    if(!ai.regIsActive)
    emit regStateInfo(ai.regIsActive);
}

void MyAccount::onIncomingCall(pj::OnIncomingCallParam &iprm)
{
    QString wholeMsg=iprm.rdata.wholeMsg.c_str();
    if(!wholeMsg.contains("@@"))
    {
        MyCall *call = new MyCall(*this, iprm.callId);
        call->setAccount(this);

        pj::CallInfo ci = call->getInfo();
        QString login = splitUri(ci.remoteUri.c_str());
        call->setCalliedLogin(login);
        qDebug() << "*** Incoming Call: " <<  ci.remoteUri.c_str() << " ["
                  << ci.stateText.c_str() << "]";

        calls.push_back(call);
        emit incomingCall(login);
    }
    else
    {
        QStringList strList = wholeMsg.split("@@");
        QString confName= strList.at(1);
        QString confCreator = strList.at(2);

        Conference *newConf = new Conference(*this, confName, confCreator, *settings);
        conferences.push_back(newConf);

        newConf->createIncomingConferenceCall(confCreator, iprm.callId);
        emit incomingConference(confName, confCreator);
    }


}

void MyAccount::onInstantMessage(pj::OnInstantMessageParam &prm)
{
    QString login = splitUri(prm.fromUri.c_str());
    QString msg = prm.msgBody.c_str();

    //simple parser
    if(msg.left(16)=="DELAYED DELIVERY")
    {
        QStringList splitLst = msg.split("\r\n");
        splitLst.removeFirst();
        msg=splitLst.join("\r\n");
        if(msg.left(7)=="sysMsg:" | msg.left(7)=="sysCon:")
        {
            msg.prepend("*");
        }
    }

    if(msg.left(7)=="defMsg:")
    {
        msg.remove(0, 7);
        for(auto entity:friendsLst)
        {
            if(entity->getLogin()==login)
            {
                int index = friendsLst.indexOf(entity);
                QDateTime dateTime(QDate::currentDate(), QTime::currentTime());
                entity->appendMessage(login, dateTime.toString(), msg);
                emit showNewMsgInQml(login, msg, dateTime.toString(), index);
            }
        }

    }
    else
    if(msg.left(7)=="sysCon:")
    {
        QString sysConfMsg = msg.remove(0,7);
        QStringList splitConfList = sysConfMsg.split("@");
        if(splitConfList.at(0)=="ADD")
        {
            for(auto conference:conferences)
            {
                if(conference->getConfName()==splitConfList.at(1) & conference->getConfCreator()==splitConfList.at(2))
                {
                    conference->activeParties.append(splitConfList.at(3));
                    conference->calledParties.removeOne(splitConfList.at(3));
                    conference->updateConference();
                    break;
                }
            }
        }
        if(splitConfList.at(0)=="REMOVE")
        {
            for(auto conference:conferences)
            {
                if(conference->getConfName()==splitConfList.at(1) & conference->getConfCreator()==splitConfList.at(2))
                {
                    conference->activeParties.removeOne(splitConfList.at(3));
                    conference->calledParties.removeOne(splitConfList.at(3));
                    conference->updateConference();
                    break;
                }
            }
        }
    }
    else
    if(msg.left(7)=="defCon:")
    {
        QString defConfMsg = msg.remove(0,7);
        QStringList splitConfList = defConfMsg.split("@");
        QString confName = splitConfList.at(0);
        QString confCreator = splitConfList.at(1);
        QString sender = splitConfList.at(2);
        QString msg = defConfMsg.remove(0, confName.size()+confCreator.size()+sender.size()+3);
        for(auto conference:conferences)
        {
            if(conference->getConfName()==confName & conference->getConfCreator()==confCreator)
            {
                QDateTime dateTime(QDate::currentDate(), QTime::currentTime());
                conference->incomingMsg(sender, msg, dateTime.toString(), login);
                emit showNewConferenceMsgInQml(sender, msg, dateTime.toString(), confName, confCreator);
                break;
            }
        }

    }
    else
    if(msg.left(7)=="sysMsg:")
    {
        msg.remove(0,7);
        QStringList splitLst = msg.split("@");
        QString param = splitLst.at(0);
        QString paramState = splitLst.at(1);
        if(param=="FRIEND_STATUS")
        {
            changeFriendStatus(login, paramState);
        }
        if (param=="SUBSCRIBER")
        {
            if(paramState=="Add")
            {
                Subscriber *sub = new Subscriber(*this, login, *settings);
                subscribersLst.append(sub);
                emit showNewSubscriberInQml(login);
                emit showInfoInQml(login+" хочет добавить вас в друзья");
            }
        }
        if(param=="FRIEND")
        {
            if(paramState=="Remove")
            {
                for(auto entity:friendsLst)
                {
                    if(entity->getLogin()==login)
                    {
                        int index = friendsLst.indexOf(entity);
                        friendsLst.remove(index);
                        delete entity;
                        emit showInfoInQml(login +" удалил вас из друзей");
                        emit removeFriendInQml(index);
                        break;
                    }
                }
            }
        }
        if (param=="SUBSCRIBE")
        {
            if(paramState.left(6)=="Accept")
            {

                QStringList tempLst = paramState.split(".");
                tempLst.removeAt(0);
                for(auto entity:subscribesLst)
                {
                    if(entity->getLogin()==login)
                    {
                        subscribesLst.removeOne(entity);
                        delete entity;
                        Friend *friendEntity = new Friend(*this, login, *settings, tempLst.at(0), tempLst.at(1).toInt());
                        friendsLst.append(friendEntity);
                        if(tempLst.at(1).toInt()>0) tempLst[1]="green"; else tempLst[1]="red";
                        emit showNewFriendInQml(login, tempLst.at(0), tempLst.at(1));
                        emit showInfoInQml(login+" теперь ваш друг");
                        break;
                    }
                }
            }
            if(paramState=="Decline")
            {
                for(auto entity:subscribesLst)
                {
                    if(entity->getLogin()==login)
                    {
                        subscribesLst.removeOne(entity);
                        delete entity;
                        emit showInfoInQml(login+" отклонил заявку");
                        break;
                    }
                }
            }
        }

    }
}

void MyAccount::onInstantMessageStatus(pj::OnInstantMessageStatusParam &prm)
{
    prm.code=pjsip_status_code::PJSIP_SC_OK;
    qDebug()<<"MSG succes!";
}

void MyAccount::onIncomingSubscribe(pj::OnIncomingSubscribeParam &prm)
{
    prm.code=pjsip_status_code::PJSIP_SC_REQUEST_TERMINATED;
}








