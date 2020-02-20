#ifndef APPCORE_H
#define APPCORE_H

#include <QObject>
#include <sqlqueries.h>
#include <pjsua2.hpp>
#include <myaccount.h>
#include <mybuddy.h>
#include <QFile>
#include <QVector>
#include <config.h>
#include <QQmlPropertyMap>

class AppCore : public QObject
{
    Q_OBJECT
public:

    explicit AppCore(QObject *parent = nullptr);
    ~AppCore();

signals:
    void loginInfo(bool regState);
    void newAccInfo(QString str);
    void settingsInfo(QVector <QString> srv, QVector <QString> otherSettings);
    void pjsuaLibDestroyed();
    void defaultVolume();
    void close();
    void friendsListShowInQml(QVector <QString > loginList,
                              QVector <QString > nameList,
                              QVector <QString > statusList,
                              QVector <bool> msgStateList);
    void friendListForConferenceShowInQml(QVector <QString > loginList, QVector <QString > nameList);
    void subscribersListShowInQml(QVector <QString> subscribersList);
    void conferencesListShowInQml(QVector<QString> conferencesList, QVector<QString> confCreatorsList);
    void entityChangeStatusInQml(int index, QString status);
    void findFriendsShowInQml(QVector<QString> loginList, QVector<QString> nameList);
    void showNewSubscriberInQml(QString subLogin);
    void showNewFriendInQml(QString friendLogin, QString friendName, QString friendStatus);
    void removeSubscriberInQml(int subIndex);
    void removeFriendInQml(int friendIndex);
    void showInfoInQml(QString infoStr);
    void setDefaultVolumeForConferenceInQml();
    void showIFriendInQml(QString login, QString name, int callingState);
    void showIConferenceInQml(QString confName, QString confCreator,
                              QString activePartiesSize, QVector<QString> activeParties,
                              QVector<QString> calledParties, QVector<qreal> volumePrms,
                              QVector<QString>senders, QVector<QString>messages,
                              QVector<QString>dateTimes);
    void changeIFriendInQml(QString login, QString name, int callingState, int friendIndex);
    void changeIConference(QString confName, QString confCreator);
    void showNewMsgInQml(QString sender, QString msg, QString dateTime, int friendIndex=-1);
    void showNewConferenceMsgInQml(QString sender, QString msg, QString dateTime, QString conName, QString confCreator);
    void showAllMessages(QVector<QString>senders, QVector<QString>messages, QVector<QString>dateTimes);
    void showCallStateInQml(int state);
    void showIncomingCallInQml(QString login);
    void showIncomingConferenceInQml(QString confName, QString confCreator);
    void showValidPartiesInQml(QVector <QString> parties);
    void removeIncomingCallInQml(QString login);
    void removeConference(int confIndex, QString confName, QString confCreator);
public slots:
    void removeAllCalls();
    void closeApp();
    void addNewAcc(QString name, QString login, QString pwd, QString cpwd);
    void startPjsuaLib(QString login,QString pwd);
    void stopPjsuaLib();
    void createAcc(QString login,
                   QString pwd,
                   QString turnUserName,
                   QString turnPwd,
                   QString turnSrv,
                   QString sipAddr,
                   QString sipPort,
                   bool turnState);
    void makeCall(QString login);
    void makeConference(QVector<QString> parties, QString confName);
    void hangUpCall(QString login);
    void getSettings();
    int getCallSize(){return acc->calls.size();}
    int getConferenceSize(){return acc->conferences.size();}
    void editSettings(QVector <QString> stunSrvList, QVector <QString> otherSettings);
    QString getName();
    QString getLogin();
    void getFriendsList();
    void getFriendListForConference();
    void getSubscribersList();
    void getConferencesList();
    void findFriends(QString param);
    void addSubscribe(QString login);
    void removeSubscriber(QString login);
    void addToFriendList(QString login);
    void showInfo(QString info){emit showInfoInQml(info);}
    void showIFriend(QString login, QString name);
    void showIConference(QString confName, QString confCreator);
    void removeFriend(QString friendLogin);
    void sendMsg(QString login, QString msg);
    void sendConferenceMsg(QString confName, QString confCreator, QString msg);
    void getMessageList(QString login);
    void changeMsgState(int index, bool msgState);
    void answerCall(QString login, bool state);
    void answerConference(QString confName, QString confCreator, bool state);
    void setSpeakerVolume(QString login, float value);
    void setConferenceCallSpeakerVolume(QString confName, QString confCreator, QString party, float value);
    void setConferenceCallMicVolume(QString confName, QString confCreator, float value);
    void setConferenceCallSpeakerVolumeForDefaultParty(QString confName, QString confCreator, float value);
    void setDefaultVolumeForConference(){emit setDefaultVolumeForConferenceInQml();}
    void setMicVolume(QString login, float value);
    void hangUpConference(QString confName, QString confCreator);
    void hangUpConferenceCall(QString confName, QString confCreator, QString calledParty);
    void addNewPartyInConference(QString confName, QString confCreator, QString partyName);
    void getValidParties(QString confName, QString confCreator);
private:
    Config settings;
    MyAccount *acc;
    pj::Endpoint ep;
    pj::EpConfig ep_cfg;
    pj::TransportConfig tcfg;
    pj::AccountConfig *acc_cfg;
    pj::AudioMedia *am;

};

#endif // APPCORE_H
