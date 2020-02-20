#ifndef SUBSCRIBER_H
#define SUBSCRIBER_H
#include <QString>
#include <mybuddy.h>
#include <myaccount.h>
#include <config.h>
class MyAccount;
class Subscriber
{
public:
    Subscriber(MyAccount &acc, QString login, Config &settings);
    ~Subscriber(){delete buddy;}
    QString getLogin(){return login;}

    void addToFriendList(QString name, QString status);
    void removeSubscriber();
private:
    QString login;

    MyBuddy *buddy;
    Config *settings;
};

#endif // SUBSCRIBER_H
