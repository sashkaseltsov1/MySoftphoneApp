#ifndef MYBUDDY_H
#define MYBUDDY_H

#include <QObject>
#include <pjsua2.hpp>
#include <QDebug>

class MyBuddy :  public pj::Buddy
{

public:
    MyBuddy() {}
    ~MyBuddy()override {}

    virtual void onBuddyState() override;




};

#endif // MYBUDDY_H
