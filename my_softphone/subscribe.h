#ifndef SUBSCRIBE_H
#define SUBSCRIBE_H
#include <QString>
#include <mybuddy.h>
#include <myaccount.h>
#include <config.h>
class MyAccount;
class Subscribe
{
public:
    Subscribe(MyAccount &acc, QString login, Config &settings);
    ~Subscribe(){delete buddy;}
    QString getLogin(){return login;}
    void notifyAboutSubscribe();

private:
    QString login;

    MyBuddy *buddy;
    Config *settings;
};

#endif // SUBSCRIBE_H
