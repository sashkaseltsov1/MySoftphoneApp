#include "mybuddy.h"



void MyBuddy::onBuddyState()
{
    pj::BuddyInfo bi = getInfo();
        qDebug() << "Buddy================================ " << bi.uri.c_str() << " is " << bi.subStateName.c_str();

}


