#here is all your app common defination and configration
#you can modify this pri to link qqt_library
#only link QQt, this pri file.

#this link need Qt Creator set default build directory, replace
#%{JS: Util.asciify("/your/local/path/to/build/root/%{CurrentProject:Name}/%{Qt:Version}/%{CurrentKit:FileSystemName}/%{CurrentBuild:Name}")}

#auto link QQt when build source
#auto copy QQt when deploy app

#-------------------------------------------------------------
#user computer path settings
#-------------------------------------------------------------
#qqt source root, QQt's root pro path. subdir and
equals(QMAKE_HOST.os, Darwin) {
    QQT_SOURCE_ROOT = $$PWD/../..
} else: equals(QMAKE_HOST.os, Linux) {
    QQT_SOURCE_ROOT = $$PWD/../..
} else: equals(QMAKE_HOST.os, Windows) {
    QQT_SOURCE_ROOT = $$PWD/../..
}

#qqt build root, build station root
#link_from_build will need this path.
equals(QMAKE_HOST.os, Darwin) {
    QQT_BUILD_ROOT = /Users/abel/Develop/c0-buildstation
} else: equals(QMAKE_HOST.os, Linux) {
    QQT_BUILD_ROOT = /home/abel/Develop/c0-buildstation
} else: equals(QMAKE_HOST.os, Windows) {
    QQT_BUILD_ROOT = C:/Users/Administrator/Develop/c0-build
}


#default sdk root is qqt-source/..
#user can modify this path
#create_qqt_sdk and link_from_sdk will need this.
equals(QMAKE_HOST.os, Darwin) {
    QQT_SDK_ROOT = $${QQT_SOURCE_ROOT}/..
} else: equals(QMAKE_HOST.os, Linux) {
    QQT_SDK_ROOT = $${QQT_SOURCE_ROOT}/..
} else: equals(QMAKE_HOST.os, Windows) {
    QQT_SDK_ROOT = $${QQT_SOURCE_ROOT}/..
}

#-------------------------------------------------------------
#include qqt's pri
#-------------------------------------------------------------
#qqt qkit
#all cross platform setting is from here.
include($${QQT_SOURCE_ROOT}/src/qqt_qkit.pri)

#qqt version
include($${QQT_SOURCE_ROOT}/src/qqt_version.pri)

#qqt header
include($${QQT_SOURCE_ROOT}/src/qqt_header.pri)

#-------------------------------------------------------------
#link qqt settings: use source or link library?
#-------------------------------------------------------------
#if you dont modify Qt Creator default build directory, you may need mod this path variable.
#link operation all will need this variable
QQT_STD_DIR = QQt/$${QT_VERSION}/$${SYSNAME}/$${BUILD}
#link from build need this, if you havent mod QQt.pro, this can only be two value, qqt's: [src]/$DESTDIR
QQT_DST_DIR = src/bin

#if you want to build qqt source open this annotation
#CONFIG += LINK_QQT_SOURCE
contains (CONFIG, LINK_QQT_SOURCE) {
    #if you want to build src but not link QQt lib in your project
    #if you don't want to modify Qt Creator's default build directory, this maybe a choice.
    include($${QQT_SOURCE_ROOT}/src/qqt_source.pri)
} else {
    #if you want to link QQt library
    #qqt will install sdk to sdk path you set, then link it, or link from build station
    #qqt also can install sdk to qt library path, then to do that.
    #need QQT_BUILD_ROOT
    #need QKIT_PRIVATE from qqt_qkit.pri
    #you can open one or more macro to make sdk or link from build.

    #link from sdk is default setting
    CONFIG += link_from_sdk
    #CONFIG += link_from_build
    #CONFIG += link_from_qt_lib_path

    #especially some occations need some sure macro.
    contains(QKIT_PRIVATE, iOS|iOSSimulator) {
        #mac ios .framework .a 里面的快捷方式必须使用里面的相对路径，不能使用绝对路径
        #但是qtcreator生成framework的时候用了绝对路径，所以导致拷贝后链接失败，库不可用。
        #qqt_install.pri 里面解决了framework的拷贝问题，但是对于ios里.a的没做，而.a被拷贝了竟然也不能用！
        #在build的地方link就可以了
        CONFIG += link_from_build
    }
    contains(CONFIG, link_from_build) {
        #include from source header, default is this, and set in header pri
        #...
    }

    include($${QQT_SOURCE_ROOT}/src/qqt_library.pri)
}
